const std = @import("std");
const Build = std.Build;
const builtin = @import("builtin");
const build_zon = @import("build.zig.zon");

comptime {
    checkVersion();
}

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const no_bin = b.option(bool, "no-bin", "skip emitting binary for incremental compilation checks") orelse false;
    const strip = b.option(bool, "strip", "Strip debug information") orelse false;
    const lto = b.option(bool, "lto", "Enable link time optimization") orelse false;
    const llvm = b.option(bool, "llvm", "Use the llvm codegen backend") orelse false;
    const lld = b.option(bool, "lld", "Use the llvm's lld linker") orelse false;
    const linkage = b.option(std.builtin.LinkMode, "linkage", "Choose linkage of zvips") orelse .static;

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

    const mod = b.addModule("zvips", .{
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .sanitize_c = true,
        .stack_check = true,
        .strip = strip,
    });
    mod.addImport("vips", vips.module("vips8"));
    mod.addImport("glib", vips.module("glib2"));
    mod.addImport("gobject", vips.module("gobject2"));

    const zvips = b.addLibrary(.{
        .name = "zvips",
        .linkage = linkage,
        .root_module = mod,
        .use_lld = lld,
        .use_llvm = llvm,
        .max_rss = std.fmt.parseIntSizeSuffix("100MiB", 10) catch unreachable,
    });
    zvips.pie = llvm;
    zvips.want_lto = lto;

    if (no_bin) {
        const vips_path = zvips.getEmittedBin();
        b.addNamedLazyPath("zvips", vips_path);
    } else {
        b.installArtifact(zvips);
    }
}

fn codeGen(b: *Build, gobject: *Build.Dependency) Build.LazyPath {
    const translate_gir = gobject.artifact("translate-gir");

    const run_translate_gir = b.addRunArtifact(translate_gir);

    const output = run_translate_gir.addPrefixedOutputDirectoryArg("--output-dir=", "bindings");
    run_translate_gir.addPrefixedDirectoryArg("--gir-dir=", .{ .cwd_relative = "/usr/share/gir-1.0/" });
    run_translate_gir.addPrefixedDirectoryArg("--gir-dir=", b.path("gir/"));
    run_translate_gir.addPrefixedDirectoryArg("--gir-fixes-dir=", gobject.path("gir-fixes"));
    run_translate_gir.addPrefixedDirectoryArg("--gir-fixes-dir=", b.path("gir-fixes"));
    run_translate_gir.addPrefixedDirectoryArg("--bindings-dir=", gobject.path("binding-overrides"));
    run_translate_gir.addPrefixedDirectoryArg("--extensions-dir=", gobject.path("extensions"));
    run_translate_gir.addArgs(&.{"Vips-8.0"});

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
