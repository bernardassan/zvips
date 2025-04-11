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

    const gobject = b.dependency("gobject", .{
        .target = target,
        .optimize = optimize,
        // .@"gir-files-path" = @as([]const u8, "gir/"),
        // .@"gir-files-path" = @as([]const u8, "gir/"),
        .modules = @as([]const []const u8, &.{
            // "GLib-2.0",
            // "GObject-2.0",
            // "Gio-2.0",
            "Vips-8.0",
        }),
    });

    // const translate_gir = gobject.artifact("translate-gir");
    // const codegen = b.addRunArtifact(translate_gir);
    // const output = codegen.addPrefixedOutputDirectoryArg("--output-dir=", "bindings");
    // codegen.addPrefixedDirectoryArg("--gir-fixes-dir=", gobject.path("gir-fixes"));
    // codegen.addPrefixedDirectoryArg("--gir-dir=", std.Build.LazyPath{ .cwd_relative = "/usr/share/gir-1.0/" });
    // codegen.addPrefixedDirectoryArg("--gir-dir=", b.path("gir/"));
    // codegen.addPrefixedDirectoryArg("--bindings-dir=", gobject.path("binding-overrides"));
    // codegen.addPrefixedDirectoryArg("--extensions-dir=", gobject.path("extensions"));
    // codegen.addArgs(&.{"Vips-8.0"});
    // // This is needed to tell Zig that the command run can be cached despite
    // // having output files.
    // codegen.expectExitCode(0);

    const dep_codegen = gobject.builder.top_level_steps.get("codegen").?;
    const my_codegen = b.step("codegen", "Do codegent");

    my_codegen.dependOn(&dep_codegen.step);

    // b.installDirectory(.{
    //     .source_dir = output,
    //     .install_dir = .prefix,
    //     .install_subdir = "bindings",
    // });

    // const vips = b.dependency("libvips", .{
    //     .target = target,
    //     .optimize = optimize,
    // });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .strip = strip,
    });
    // exe_mod.addImport("vips", vips.module("vips8"));

    const exe = b.addExecutable(.{
        .name = "libvips",
        .root_module = exe_mod,
        .use_lld = false,
        .use_llvm = false,
    });
    exe.want_lto = lto;

    const exe_check = b.addExecutable(.{
        .name = "check",
        .root_module = exe_mod,
        .use_lld = false,
        .use_llvm = false,
    });
    const check = b.step("check", "Check if foo compiles");
    check.dependOn(&exe_check.step);

    // For use with incremental compilation checks
    // zig build -Dno-bin -fincremental --watch
    if (no_bin) {
        b.getInstallStep().dependOn(&exe.step);
    } else {
        b.installArtifact(exe);
    }

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
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
