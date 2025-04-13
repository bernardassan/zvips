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
        .@"gir-files-path" = @as([]const u8, "/usr/share/gir-1.0/"),
        .modules = @as([]const []const u8, &.{
            "Vips-8.0",
        }),
    });

    const translate_gir = gobject.artifact("translate-gir");
    const run_translate_gir = b.addRunArtifact(translate_gir);
    const output = run_translate_gir.addPrefixedOutputDirectoryArg("--output-dir=", "bindings");
    run_translate_gir.addPrefixedDirectoryArg("--gir-dir=", std.Build.LazyPath{ .cwd_relative = "/usr/share/gir-1.0/" });
    run_translate_gir.addPrefixedDirectoryArg("--gir-dir=", b.path("gir/"));
    run_translate_gir.addPrefixedDirectoryArg("--gir-fixes-dir=", gobject.path("gir-fixes"));
    run_translate_gir.addPrefixedDirectoryArg("--bindings-dir=", gobject.path("binding-overrides"));
    // run_translate_gir.addPrefixedDirectoryArg("--bindings-dir=", b.path("binding-overrides"));
    run_translate_gir.addPrefixedDirectoryArg("--extensions-dir=", gobject.path("extensions"));
    run_translate_gir.addPrefixedDirectoryArg("--abi-test-output-dir=", gobject.path("test/abi"));
    run_translate_gir.addArgs(&.{"Vips-8.0"});
    // This is needed to tell Zig that the command run can be cached despite
    // having output files.
    run_translate_gir.expectExitCode(0);

    const codegen = b.step("codegen", "Do codegent");
    const install_bindings = b.addInstallDirectory(.{
        .install_dir = .{ .custom = "../" },
        .install_subdir = "bindings",
        .source_dir = output,
    });
    codegen.dependOn(&install_bindings.step);

    const vips = b.dependency("libvips", .{
        .target = target,
        .optimize = optimize,
    });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .strip = strip,
    });
    exe_mod.addImport("vips", vips.module("vips8"));

    const exe = b.addExecutable(.{
        .name = "libvips",
        .root_module = exe_mod,
        .use_lld = false,
        .use_llvm = false,
    });
    exe.want_lto = lto;
    // exe.linkSystemLibrary("vips");

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
