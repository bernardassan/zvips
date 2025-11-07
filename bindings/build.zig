const std = @import("std");

/// A library accessible through the generated bindings.
///
/// While the generated bindings are typically used through modules
/// (e.g. `gobject.module("glib-2.0")`), there are cases where it is
/// useful to have additional information about the libraries exposed
/// to the build script. For example, if any files in the root module
/// of the application want to import a library's C headers directly,
/// it will be necessary to link the library directly to the root module
/// using `Library.linkTo` so the include paths will be available.
pub const Library = struct {
    /// System libraries to be linked using pkg-config.
    system_libraries: []const []const u8,

    /// Links `lib` to `module`.
    pub fn linkTo(lib: Library, module: *std.Build.Module) void {
        module.link_libc = true;
        for (lib.system_libraries) |system_lib| {
            module.linkSystemLibrary(system_lib, .{ .use_pkg_config = .force });
        }
    }
};

/// Returns a `std.Build.Module` created by compiling the GResources file at `path`.
///
/// This requires the `glib-compile-resources` system command to be available.
pub fn addCompileResources(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    path: std.Build.LazyPath,
) *std.Build.Module {
    const compile_resources, const module = addCompileResourcesInternal(b, target, path);
    compile_resources.addArg("--sourcedir");
    compile_resources.addDirectoryArg(path.dirname());
    compile_resources.addArg("--dependency-file");
    _ = compile_resources.addDepFileOutputArg("gresources-deps");

    return module;
}

fn addCompileResourcesInternal(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    path: std.Build.LazyPath,
) struct { *std.Build.Step.Run, *std.Build.Module } {
    const compile_resources = b.addSystemCommand(&.{ "glib-compile-resources", "--generate-source" });
    compile_resources.addArg("--target");
    const gresources_c = compile_resources.addOutputFileArg("gresources.c");
    compile_resources.addFileArg(path);

    const module = b.createModule(.{ .target = target });
    module.addCSourceFile(.{ .file = gresources_c });
    @This().libraries.gio2.linkTo(module);
    return .{ compile_resources, module };
}

/// Returns a builder for a compiled GResource bundle.
///
/// Calling `CompileResources.build` on the returned builder requires the
/// `glib-compile-resources` system command to be installed.
pub fn buildCompileResources(gobject_dependency: *std.Build.Dependency) CompileResources {
    return .{ .b = gobject_dependency.builder };
}

/// A builder for a compiled GResource bundle.
pub const CompileResources = struct {
    b: *std.Build,
    groups: std.ArrayListUnmanaged(*Group) = .{},

    var build_gresources_xml_exe: ?*std.Build.Step.Compile = null;

    /// Builds the GResource bundle as a module. The module must be imported
    /// into the compilation for the resources to be loaded.
    pub fn build(cr: CompileResources, target: std.Build.ResolvedTarget) *std.Build.Module {
        const run = cr.b.addRunArtifact(build_gresources_xml_exe orelse exe: {
            const exe = cr.b.addExecutable(.{
                .name = "build-gresources-xml",
                .root_module = cr.b.createModule(.{
                    .root_source_file = cr.b.path("build/build_gresources_xml.zig"),
                    .target = cr.b.graph.host,
                    .optimize = .Debug,
                }),
            });
            build_gresources_xml_exe = exe;
            break :exe exe;
        });

        for (cr.groups.items) |group| {
            run.addArg(cr.b.fmt("--prefix={s}", .{group.prefix}));
            for (group.files.items) |file| {
                run.addArg(cr.b.fmt("--alias={s}", .{file.name}));
                if (file.options.compressed) {
                    run.addArg("--compressed");
                }
                for (file.options.preprocess) |preprocessor| {
                    run.addArg(cr.b.fmt("--preprocess={s}", .{preprocessor.name()}));
                }
                run.addPrefixedFileArg("--path=", file.path);
            }
        }
        const xml = run.addPrefixedOutputFileArg("--output=", "gresources.xml");

        _, const module = addCompileResourcesInternal(cr.b, target, xml);
        return module;
    }

    /// Adds a group of resources showing a common prefix.
    pub fn addGroup(cr: *CompileResources, prefix: []const u8) *Group {
        const group = cr.b.allocator.create(Group) catch @panic("OOM");
        group.* = .{ .owner = cr, .prefix = prefix };
        cr.groups.append(cr.b.allocator, group) catch @panic("OOM");
        return group;
    }

    pub const Group = struct {
        owner: *CompileResources,
        prefix: []const u8,
        files: std.ArrayListUnmanaged(File) = .{},

        /// Adds the file at `path` as a resource named `name` (within the
        /// prefix of the containing group).
        pub fn addFile(g: *Group, name: []const u8, path: std.Build.LazyPath, options: File.Options) void {
            g.files.append(g.owner.b.allocator, .{
                .name = name,
                .path = path,
                .options = options,
            }) catch @panic("OOM");
        }
    };

    pub const File = struct {
        name: []const u8,
        path: std.Build.LazyPath,
        options: Options = .{},

        pub const Options = struct {
            compressed: bool = false,
            preprocess: []const Preprocessor = &.{},
        };

        pub const Preprocessor = union(enum) {
            xml_stripblanks,
            json_stripblanks,
            other: []const u8,

            pub fn name(p: Preprocessor) []const u8 {
                return switch (p) {
                    .xml_stripblanks => "xml-stripblanks",
                    .json_stripblanks => "json-stripblanks",
                    .other => |s| s,
                };
            }
        };
    };
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const docs_step = b.step("docs", "Generate documentation");
    const test_step = b.step("test", "Run tests");

    const compat = b.createModule(.{
        .root_source_file = b.path("src/compat/compat.zig"),
        .target = target,
        .optimize = optimize,
    });

    const vips8 = b.addModule("vips8", .{
        .root_source_file = b.path(b.pathJoin(&.{ "src", "vips8", "vips8" ++ ".zig" })),
        .target = target,
        .optimize = optimize,
    });
    libraries.vips8.linkTo(vips8);
    vips8.addImport("compat", compat);

    const vips8_test = b.addTest(.{
        .root_module = vips8,
    });
    test_step.dependOn(&b.addRunArtifact(vips8_test).step);

    const gio2 = b.addModule("gio2", .{
        .root_source_file = b.path(b.pathJoin(&.{ "src", "gio2", "gio2" ++ ".zig" })),
        .target = target,
        .optimize = optimize,
    });
    libraries.gio2.linkTo(gio2);
    gio2.addImport("compat", compat);

    const gio2_test = b.addTest(.{
        .root_module = gio2,
    });
    test_step.dependOn(&b.addRunArtifact(gio2_test).step);

    const gobject2 = b.addModule("gobject2", .{
        .root_source_file = b.path(b.pathJoin(&.{ "src", "gobject2", "gobject2" ++ ".zig" })),
        .target = target,
        .optimize = optimize,
    });
    libraries.gobject2.linkTo(gobject2);
    gobject2.addImport("compat", compat);

    const gobject2_test = b.addTest(.{
        .root_module = gobject2,
    });
    test_step.dependOn(&b.addRunArtifact(gobject2_test).step);

    const glib2 = b.addModule("glib2", .{
        .root_source_file = b.path(b.pathJoin(&.{ "src", "glib2", "glib2" ++ ".zig" })),
        .target = target,
        .optimize = optimize,
    });
    libraries.glib2.linkTo(glib2);
    glib2.addImport("compat", compat);

    const glib2_test_mod = b.createModule(.{
        .root_source_file = b.path("src/glib2/glib2.zig"),
        .target = target,
        .optimize = optimize,
    });
    libraries.glib2.linkTo(glib2_test_mod);
    libraries.gobject2.linkTo(glib2_test_mod);
    // Some deprecated thread functions require linking gthread-2.0
    glib2_test_mod.linkSystemLibrary("gthread-2.0", .{ .use_pkg_config = .force });
    glib2_test_mod.addImport("compat", compat);
    glib2_test_mod.addImport("glib2", glib2_test_mod);

    const glib2_test = b.addTest(.{
        .root_module = glib2_test_mod,
    });
    test_step.dependOn(&b.addRunArtifact(glib2_test).step);

    const gmodule2 = b.addModule("gmodule2", .{
        .root_source_file = b.path(b.pathJoin(&.{ "src", "gmodule2", "gmodule2" ++ ".zig" })),
        .target = target,
        .optimize = optimize,
    });
    libraries.gmodule2.linkTo(gmodule2);
    gmodule2.addImport("compat", compat);

    const gmodule2_test = b.addTest(.{
        .root_module = gmodule2,
    });
    test_step.dependOn(&b.addRunArtifact(gmodule2_test).step);

    vips8.addImport("gio2", gio2);
    vips8.addImport("gobject2", gobject2);
    vips8.addImport("glib2", glib2);
    vips8.addImport("gmodule2", gmodule2);
    vips8.addImport("vips8", vips8);
    gio2.addImport("gobject2", gobject2);
    gio2.addImport("glib2", glib2);
    gio2.addImport("gmodule2", gmodule2);
    gio2.addImport("gio2", gio2);
    gobject2.addImport("glib2", glib2);
    gobject2.addImport("gobject2", gobject2);
    glib2.addImport("glib2", glib2);
    gmodule2.addImport("glib2", glib2);
    gmodule2.addImport("gmodule2", gmodule2);
    const docs_mod = b.createModule(.{
        .root_source_file = b.path("src/root/root.zig"),
        .target = target,
        .optimize = .Debug,
    });
    const docs_obj = b.addObject(.{
        .name = "docs",
        .root_module = docs_mod,
    });
    const install_docs = b.addInstallDirectory(.{
        .source_dir = docs_obj.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&install_docs.step);
    docs_mod.addImport("vips8", vips8);
    docs_mod.addImport("gio2", gio2);
    docs_mod.addImport("gobject2", gobject2);
    docs_mod.addImport("glib2", glib2);
    docs_mod.addImport("gmodule2", gmodule2);
}

pub const libraries = struct {
    pub const vips8: Library = .{
        .system_libraries = &.{ "vips", "vips" },
    };

    pub const gio2: Library = .{
        .system_libraries = &.{"gio-2.0"},
    };

    pub const gobject2: Library = .{
        .system_libraries = &.{"gobject-2.0"},
    };

    pub const glib2: Library = .{
        .system_libraries = &.{"glib-2.0"},
    };

    pub const gmodule2: Library = .{
        .system_libraries = &.{"gmodule-2.0"},
    };
};
