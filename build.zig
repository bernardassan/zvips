const std = @import("std");
const builtin = @import("builtin");

const build_zon = @import("build.zig.zon");

comptime {
    checkVersion();
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const strip = b.option(bool, "strip", "Strip debug information") orelse false;
    const lto = b.option(bool, "lto", "Enable link time optimization") orelse false;
    const llvm = b.option(bool, "llvm", "Use the llvm codegen backend") orelse false;
    const lld = b.option(bool, "lld", "Use the llvm's lld linker") orelse false;
    const linkage = b.option(std.builtin.LinkMode, "linkage", "Choose linkage of zivips") orelse .static;

    const gobject = b.dependency("gobject", .{
        .target = target,
        .optimize = optimize,
    });

    const vips = b.dependency("libvips", .{
        .target = target,
        .optimize = optimize,
    });

    const output = codeGen(b, gobject);

    const codegen = b.step("codegen", "Do codegen");
    const install_bindings = b.addInstallDirectory(.{
        .install_dir = .{ .custom = "../" },
        .install_subdir = "bindings",
        .source_dir = output,
    });
    codegen.dependOn(&install_bindings.step);

    const lib_mod = b.addModule("zivips", .{
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .sanitize_c = true,
        .stack_check = true,
        .strip = strip,
    });
    lib_mod.addImport("vips", vips.module("vips8"));
    lib_mod.addImport("glib", vips.module("glib2"));

    const libzivips = b.addLibrary(.{
        .name = "zivips",
        .linkage = linkage,
        .root_module = lib_mod,
        .use_lld = lld,
        .use_llvm = llvm,
    });
    libzivips.pie = llvm;
    libzivips.want_lto = lto;

    b.installArtifact(libzivips);
}

fn codeGen(b: *std.Build, gobject: *std.Build.Dependency) std.Build.LazyPath {
    const translate_gir = gobject.artifact("translate-gir");

    const run_translate_gir = b.addRunArtifact(translate_gir);

    const output = run_translate_gir.addPrefixedOutputDirectoryArg("--output-dir=", "bindings");
    run_translate_gir.addPrefixedDirectoryArg("--gir-dir=", std.Build.LazyPath{ .cwd_relative = "/usr/share/gir-1.0/" });
    run_translate_gir.addPrefixedDirectoryArg("--gir-dir=", b.path("gir/"));
    run_translate_gir.addPrefixedDirectoryArg("--gir-fixes-dir=", gobject.path("gir-fixes"));
    run_translate_gir.addPrefixedDirectoryArg("--gir-fixes-dir=", b.path("gir-fixes"));
    run_translate_gir.addPrefixedDirectoryArg("--bindings-dir=", gobject.path("binding-overrides"));
    run_translate_gir.addPrefixedDirectoryArg("--extensions-dir=", gobject.path("extensions"));
    run_translate_gir.addArgs(&.{"Vips-8.0"});
    // This is needed to tell Zig that the command run can be cached despite
    // having output files.
    run_translate_gir.expectExitCode(0);

    return output;
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
