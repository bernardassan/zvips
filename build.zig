const std = @import("std");
const builtin = @import("builtin");

const build_zon = @import("build.zig.zon");

comptime {
    checkVersion();
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const no_bin = b.option(bool, "no-bin", "skip emitting binary for incremental compilation checks") orelse false;
    const strip = b.option(bool, "strip", "Strip debug information") orelse false;
    const lto = b.option(bool, "lto", "Enable link time optimization") orelse false;
    const linkage = b.option(std.builtin.LinkMode, "linkage", "Link mode for Lmdb") orelse .static;

    const vips = b.dependency("libvips", .{
        .target = target,
        .optimize = optimize,
    });
    const expat = b.dependency("libepat", .{
        .target = target,
        .optimize = optimize,
    });
    const glib = b.dependency("glib", .{
        .target = target,
        .optimize = optimize,
    });
    const max_flags = 30;
    var cflags: std.ArrayList([]const u8) = .initCapacity(b.allocator, max_flags);
    cflags.appendSliceAssumeCapacity(&.{
        "-Werror=pointer-arith",
        "-lm",
        "-std=c23",
        "-pthread",
        //Disable runtime Glib dynamic module loading
        "-Dmodules=disabled",
    });

    switch (optimize) {
        .Debug => {
            cflags.appendAssumeCapacity("-DDEBUG_LEAK");
        },
        .ReleaseSafe => {},
        else => {
            cflags.appendSliceAssumeCapacity(&.{
                "-DG_DISABLE_CAST_CHECKS",
                "-DG_DISABLE_CHECKS",
                "-DG_DISABLE_ASSERT",
            });
        },
    }
    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .strip = strip,
        .sanitize_c = true,
    });
    // lib_mod.addConfigHeader()

    const libvips = b.addLibrary(.{
        .linkage = linkage,
        .name = "libvips",
        .root_module = lib_mod,
        .use_lld = false,
        .use_llvm = false,
    });
    libvips.want_lto = lto;

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("libvips", lib_mod);

    // For use with incremental compilation checks
    // zig build -Dno-bin -fincremental --watch
    if (no_bin) {
        b.getInstallStep().dependOn(&libvips.step);
    } else {
        b.installArtifact(libvips);
    }

    const exe = b.addExecutable(.{
        .name = "libvips",
        .root_module = exe_mod,
    });

    // For use with incremental compilation checks
    // zig build -Dno-bin -fincremental --watch
    if (no_bin) {
        b.getInstallStep().dependOn(&exe.step);
    } else {
        b.installArtifact(exe);
    }

    const check = b.addExecutable(.{
        .name = "check",
        .root_module = exe_mod,
    });
    check.linkLibrary(libvips);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}

// ensures the currently in-use zig version is at least the minimum required
fn checkVersion() void {
    const supported_version = std.SemanticVersion.parse(build_zon.minimum_zig_version) catch unreachable;

    const current_version = builtin.zig_version;
    const order = current_version.order(supported_version);
    if (order == .lt) {
        @compileError(std.fmt.comptimePrint("Update your zig toolchain to >= {s}", .{build_zon.minimum_zig_version}));
    }
}
