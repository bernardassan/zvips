const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const no_bin = b.option(bool, "no-bin", "skip emitting binary for incremental compilation checks") orelse false;

    const llvm = false;
    const lld = false;
    const strip = false;
    const lto = false;

    const zivips = b.dependency("zivips", .{
        .target = target,
        .optimize = optimize,
        .linkage = .static,
        .lto = lto,
        .strip = strip,
        .llvm = llvm,
        .lld = lld,
    });

    const libzivips = zivips.artifact("zivips");

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
    });
    exe_mod.addImport("zivips", zivips.module("zivips"));

    const exe = b.addExecutable(.{
        .name = "basic",
        .root_module = exe_mod,
        .use_llvm = llvm,
        .use_lld = lld,
    });
    exe.want_lto = lto;
    exe.pie = llvm;
    exe.linkLibrary(libzivips);

    const exe_check = b.addExecutable(.{
        .name = "check",
        .root_module = exe_mod,
        .use_llvm = llvm,
        .use_lld = lld,
    });
    exe_check.linkLibrary(libzivips);

    const check = b.step("check", "Check if foo compiles");
    check.dependOn(&exe_check.step);

    // For use with incremental compilation checks
    // zig build -Dno-bin -fincremental --watch
    if (no_bin) {
        b.getInstallStep().dependOn(&exe.step);
    } else {
        b.installArtifact(exe);
        b.installArtifact(libzivips);
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
