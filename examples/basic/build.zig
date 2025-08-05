const std = @import("std");
const Build = std.Build;

const Lib = union(enum) {
    compile: *Build.Step.Compile,
    lazy: Build.LazyPath,
};

// zig build run -Dno-bin -fincremental --watch -freference-trace=6 -- ../assets/image.avif
pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const no_bin = b.option(bool, "no-bin", "skip emitting binary for incremental compilation checks") orelse switch (optimize) {
        .Debug => true,
        else => false,
    };

    // https://github.com/ziglang/zig/issues/24280
    const llvm = true;
    const lld = false;
    const strip = false;
    const lto = lld;

    const zvips = b.dependency("zvips", .{
        .target = target,
        .optimize = optimize,
        .linkage = .static,
        .lto = lto,
        .strip = strip,
        .llvm = llvm,
        .lld = lld,
        .@"no-bin" = no_bin,
    });

    const libzvips: Lib = lib: {
        if (no_bin) {
            break :lib .{ .lazy = zvips.namedLazyPath("zvips") };
        } else {
            break :lib .{ .compile = zvips.artifact("zvips") };
        }
    };

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
    });
    switch (libzvips) {
        .lazy => |lazy| {
            exe_mod.addObjectFile(lazy);
        },
        .compile => |compile| {
            exe_mod.linkLibrary(compile);
        },
    }
    exe_mod.addImport("zvips", zvips.module("zvips"));

    const exe = b.addExecutable(.{
        .name = "basic",
        .root_module = exe_mod,
        .use_llvm = llvm,
        .use_lld = lld,
    });
    exe.want_lto = lto;
    exe.pie = llvm;

    const exe_check = b.addExecutable(.{
        .name = "basic",
        .root_module = exe_mod,
        .use_llvm = llvm,
        .use_lld = lld,
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
