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
    const codegen = b.option(bool, "codegen", "regenerate the libvips bindings") orelse false;

    const fmt = b.step("fmt", "Modify source files in place to have conforming formatting");
    const docs = b.step("docs", "Build and install the library documentation");

    const vips = b.dependency("libvips", .{
        .target = target,
        .optimize = optimize,
    });

    const mod = b.addModule("zvips", .{
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .sanitize_c = .full,
        .stack_check = true,
        .strip = strip,
    });
    mod.addImport("vips8", vips.module("vips8"));
    mod.addImport("glib2", vips.module("glib2"));
    mod.addImport("gobject2", vips.module("gobject2"));

    const zvips = b.addLibrary(.{
        .name = "zvips",
        .linkage = linkage,
        .root_module = mod,
        .use_lld = lld,
        .use_llvm = llvm,
        .max_rss = if (isWsl()) rss("97MiB") else rss("40MiB"),
    });
    zvips.pie = llvm;
    zvips.want_lto = lto;

    const fmt_dirs: []const []const u8 = &.{ "bindings", "lib", "examples" };
    fmt.dependOn(&b.addFmt(.{ .paths = fmt_dirs }).step);

    const autodoc = b.addObject(.{
        .name = "zvips",
        .root_module = mod,
        .optimize = .Debug,
        .max_rss = if (isWsl()) rss("95MiB") else rss("40MiB"),
        .use_lld = lld,
        .use_llvm = llvm,
    });
    autodoc.pie = llvm;
    autodoc.want_lto = lto;

    const install_docs = b.addInstallDirectory(.{
        .source_dir = autodoc.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs.dependOn(&install_docs.step);

    if (no_bin) {
        const vips_path = zvips.getEmittedBin();
        b.addNamedLazyPath("zvips", vips_path);
    } else {
        b.installArtifact(zvips);
    }

    if (codegen) {
        if (b.lazyDependency("zig-gobject", .{
            .target = target,
            .optimize = optimize,
        })) |gobject_introspection| {
            const output = codeGen(b, gobject_introspection);

            const install_bindings = b.addInstallDirectory(.{
                .install_dir = .{ .custom = "../" },
                .install_subdir = "bindings",
                .source_dir = output,
            });
            install_bindings.step.name = "install generated bindings to bindings/";
            b.getInstallStep().dependOn(&install_bindings.step);
        }
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

fn isWsl() bool {
    if (builtin.os.tag != .linux) return false;
    const uname = std.posix.uname();
    if (std.mem.endsWith(u8, uname.release[0..], "WSL2") or
        std.mem.indexOf(u8, uname.release[0..], "microsoft") != null) return true;
    return false;
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

fn rss(size: []const u8) usize {
    return std.fmt.parseIntSizeSuffix(size, 10) catch unreachable;
}
