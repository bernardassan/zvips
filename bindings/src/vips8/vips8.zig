pub const ext = @import("ext.zig");
const vips = @This();

const std = @import("std");
const compat = @import("compat");
const gobject = @import("gobject2");
const glib = @import("glib2");
pub const ArgumentTable = glib.HashTable;

/// A picture element. Cast this to whatever the associated VipsBandFormat says
/// to get the value.
pub const Pel = u8;

pub const Foreign = extern struct {
    pub const Parent = vips.Operation;
    pub const Implements = [_]type{};
    pub const Class = vips.ForeignClass;
    f_parent_object: vips.Operation,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Searches for an operation you could use to load `filename`. Any trailing
    /// options on `filename` are stripped and ignored.
    ///
    /// See also: `vips.Foreign.findLoadBuffer`, `vips.Image.newFromFile`.
    extern fn vips_foreign_find_load(p_filename: [*:0]const u8) [*:0]const u8;
    pub const findLoad = vips_foreign_find_load;

    /// Searches for an operation you could use to load a memory buffer. To see the
    /// range of buffer loaders supported by your vips, try something like:
    ///
    ///     vips -l | grep load_buffer
    ///
    /// See also: `vips.Image.newFromBuffer`.
    extern fn vips_foreign_find_load_buffer(p_data: [*]u8, p_size: usize) [*:0]const u8;
    pub const findLoadBuffer = vips_foreign_find_load_buffer;

    /// Searches for an operation you could use to load a source. To see the
    /// range of source loaders supported by your vips, try something like:
    ///
    ///     vips -l | grep load_source
    ///
    /// See also: `vips.Image.newFromSource`.
    extern fn vips_foreign_find_load_source(p_source: *vips.Source) [*:0]const u8;
    pub const findLoadSource = vips_foreign_find_load_source;

    /// Searches for an operation you could use to write to `filename`.
    /// Any trailing options on `filename` are stripped and ignored.
    ///
    /// See also: `vips.Foreign.findSaveBuffer`, `vips.Image.writeToFile`.
    extern fn vips_foreign_find_save(p_filename: [*:0]const u8) ?[*:0]const u8;
    pub const findSave = vips_foreign_find_save;

    /// Searches for an operation you could use to write to a buffer in `suffix`
    /// format.
    ///
    /// See also: `vips.Image.writeToBuffer`.
    extern fn vips_foreign_find_save_buffer(p_suffix: [*:0]const u8) ?[*:0]const u8;
    pub const findSaveBuffer = vips_foreign_find_save_buffer;

    /// Searches for an operation you could use to write to a target in `suffix`
    /// format.
    ///
    /// See also: `vips.Image.writeToBuffer`.
    extern fn vips_foreign_find_save_target(p_suffix: [*:0]const u8) ?[*:0]const u8;
    pub const findSaveTarget = vips_foreign_find_save_target;

    /// Get a `NULL`-terminated array listing all the supported suffixes.
    ///
    /// This is not the same as all the supported file types, since libvips
    /// detects image format for load by testing the first few bytes.
    ///
    /// Use `vips.Foreign.findLoad` to detect type for a specific file.
    ///
    /// Free the return result with `glib.strfreev`.
    extern fn vips_foreign_get_suffixes() [*][*:0]u8;
    pub const getSuffixes = vips_foreign_get_suffixes;

    /// Return `TRUE` if `filename` can be loaded by `loader`. `loader` is something
    /// like "tiffload" or "VipsForeignLoadTiff".
    extern fn vips_foreign_is_a(p_loader: [*:0]const u8, p_filename: [*:0]const u8) c_int;
    pub const isA = vips_foreign_is_a;

    /// Return `TRUE` if `data` can be loaded by `loader`. `loader` is something
    /// like "tiffload_buffer" or "VipsForeignLoadTiffBuffer".
    extern fn vips_foreign_is_a_buffer(p_loader: [*:0]const u8, p_data: [*]u8, p_size: usize) c_int;
    pub const isABuffer = vips_foreign_is_a_buffer;

    /// Return `TRUE` if `source` can be loaded by `loader`. `loader` is something
    /// like "tiffload_source" or "VipsForeignLoadTiffSource".
    extern fn vips_foreign_is_a_source(p_loader: [*:0]const u8, p_source: *vips.Source) c_int;
    pub const isASource = vips_foreign_is_a_source;

    /// Apply a function to every `vips.ForeignClass` that VIPS knows about. Foreigns
    /// are presented to the function in priority order.
    ///
    /// Like all VIPS map functions, if `fn` returns `NULL`, iteration continues. If
    /// it returns non-`NULL`, iteration terminates and that value is returned. The
    /// map function returns `NULL` if all calls return `NULL`.
    ///
    /// See also: `vips_slist_map`.
    extern fn vips_foreign_map(p_base: [*:0]const u8, p_fn: vips.SListMap2Fn, p_a: ?*anyopaque, p_b: ?*anyopaque) ?*anyopaque;
    pub const map = vips_foreign_map;

    extern fn vips_foreign_get_type() usize;
    pub const getGObjectType = vips_foreign_get_type;

    extern fn g_object_ref(p_self: *vips.Foreign) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.Foreign) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Foreign, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ForeignLoad = extern struct {
    pub const Parent = vips.Foreign;
    pub const Implements = [_]type{};
    pub const Class = vips.ForeignLoadClass;
    f_parent_object: vips.Foreign,
    f_memory: c_int,
    f_access: vips.Access,
    f_flags: vips.ForeignFlags,
    f_fail_on: vips.FailOn,
    f_fail: c_int,
    f_sequential: c_int,
    f_out: ?*vips.Image,
    f_real: ?*vips.Image,
    f_nocache: c_int,
    f_disc: c_int,
    f_error: c_int,
    f_revalidate: c_int,

    pub const virtual_methods = struct {
        pub const get_flags = struct {
            pub fn call(p_class: anytype, p_load: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) vips.ForeignFlags {
                return gobject.ext.as(ForeignLoad.Class, p_class).f_get_flags.?(gobject.ext.as(ForeignLoad, p_load));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_load: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) vips.ForeignFlags) void {
                gobject.ext.as(ForeignLoad.Class, p_class).f_get_flags = @ptrCast(p_implementation);
            }
        };

        pub const header = struct {
            pub fn call(p_class: anytype, p_load: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) c_int {
                return gobject.ext.as(ForeignLoad.Class, p_class).f_header.?(gobject.ext.as(ForeignLoad, p_load));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_load: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) c_int) void {
                gobject.ext.as(ForeignLoad.Class, p_class).f_header = @ptrCast(p_implementation);
            }
        };

        pub const load = struct {
            pub fn call(p_class: anytype, p_load: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) c_int {
                return gobject.ext.as(ForeignLoad.Class, p_class).f_load.?(gobject.ext.as(ForeignLoad, p_load));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_load: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) c_int) void {
                gobject.ext.as(ForeignLoad.Class, p_class).f_load = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const access = struct {
            pub const name = "access";

            pub const Type = vips.Access;
        };

        pub const disc = struct {
            pub const name = "disc";

            pub const Type = c_int;
        };

        pub const fail = struct {
            pub const name = "fail";

            pub const Type = c_int;
        };

        pub const fail_on = struct {
            pub const name = "fail-on";

            pub const Type = vips.FailOn;
        };

        pub const flags = struct {
            pub const name = "flags";

            pub const Type = vips.ForeignFlags;
        };

        pub const memory = struct {
            pub const name = "memory";

            pub const Type = c_int;
        };

        pub const out = struct {
            pub const name = "out";

            pub const Type = ?*vips.Image;
        };

        pub const revalidate = struct {
            pub const name = "revalidate";

            pub const Type = c_int;
        };

        pub const sequential = struct {
            pub const name = "sequential";

            pub const Type = c_int;
        };
    };

    pub const signals = struct {};

    extern fn vips_foreign_load_get_type() usize;
    pub const getGObjectType = vips_foreign_load_get_type;

    extern fn g_object_ref(p_self: *vips.ForeignLoad) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.ForeignLoad) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ForeignLoad, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ForeignSave = extern struct {
    pub const Parent = vips.Foreign;
    pub const Implements = [_]type{};
    pub const Class = vips.ForeignSaveClass;
    f_parent_object: vips.Foreign,
    f_strip: c_int,
    f_keep: vips.ForeignKeep,
    f_profile: ?[*:0]u8,
    f_background: ?*vips.ArrayDouble,
    f_page_height: c_int,
    f_in: ?*vips.Image,
    f_ready: ?*vips.Image,

    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const background = struct {
            pub const name = "background";

            pub const Type = ?*vips.ArrayDouble;
        };

        pub const in = struct {
            pub const name = "in";

            pub const Type = ?*vips.Image;
        };

        pub const keep = struct {
            pub const name = "keep";

            pub const Type = vips.ForeignKeep;
        };

        pub const page_height = struct {
            pub const name = "page-height";

            pub const Type = c_int;
        };

        pub const profile = struct {
            pub const name = "profile";

            pub const Type = ?[*:0]u8;
        };

        pub const strip = struct {
            pub const name = "strip";

            pub const Type = c_int;
        };
    };

    pub const signals = struct {};

    extern fn vips_foreign_save_get_type() usize;
    pub const getGObjectType = vips_foreign_save_get_type;

    extern fn g_object_ref(p_self: *vips.ForeignSave) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.ForeignSave) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ForeignSave, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An image. These can represent an image on disc, a memory buffer, an image
/// in the process of being written to disc or a partially evaluated image
/// in memory.
pub const Image = extern struct {
    pub const Parent = vips.Object;
    pub const Implements = [_]type{};
    pub const Class = vips.ImageClass;
    f_parent_instance: vips.Object,
    f_Xsize: c_int,
    f_Ysize: c_int,
    f_Bands: c_int,
    f_BandFmt: vips.BandFormat,
    f_Coding: vips.Coding,
    f_Type: vips.Interpretation,
    f_Xres: f64,
    f_Yres: f64,
    f_Xoffset: c_int,
    f_Yoffset: c_int,
    f_Length: c_int,
    f_Compression: c_short,
    f_Level: c_short,
    f_Bbits: c_int,
    f_time: ?*vips.Progress,
    f_Hist: ?[*:0]u8,
    f_filename: ?[*:0]u8,
    f_data: ?*vips.Pel,
    f_kill: c_int,
    f_Xres_float: f32,
    f_Yres_float: f32,
    f_mode: ?[*:0]u8,
    f_dtype: vips.ImageType,
    f_fd: c_int,
    f_baseaddr: ?*anyopaque,
    f_length: usize,
    f_magic: u32,
    f_start_fn: ?vips.StartFn,
    f_generate_fn: ?vips.GenerateFn,
    f_stop_fn: ?vips.StopFn,
    f_client1: ?*anyopaque,
    f_client2: ?*anyopaque,
    f_sslock: ?*glib.Mutex,
    f_regions: ?*glib.SList,
    f_dhint: vips.DemandStyle,
    f_meta: ?*glib.HashTable,
    f_meta_traverse: ?*glib.SList,
    f_sizeof_header: i64,
    f_windows: ?*glib.SList,
    f_upstream: ?*glib.SList,
    f_downstream: ?*glib.SList,
    f_serial: c_int,
    f_history_list: ?*glib.SList,
    f_progress_signal: ?*vips.Image,
    f_file_length: i64,
    f_hint_set: c_int,
    f_delete_on_close: c_int,
    f_delete_on_close_filename: ?[*:0]u8,

    pub const virtual_methods = struct {
        pub const eval = struct {
            pub fn call(p_class: anytype, p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_progress: *vips.Progress, p_data: ?*anyopaque) void {
                return gobject.ext.as(Image.Class, p_class).f_eval.?(gobject.ext.as(Image, p_image), p_progress, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_progress: *vips.Progress, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Image.Class, p_class).f_eval = @ptrCast(p_implementation);
            }
        };

        pub const invalidate = struct {
            pub fn call(p_class: anytype, p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_data: ?*anyopaque) void {
                return gobject.ext.as(Image.Class, p_class).f_invalidate.?(gobject.ext.as(Image, p_image), p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Image.Class, p_class).f_invalidate = @ptrCast(p_implementation);
            }
        };

        pub const minimise = struct {
            pub fn call(p_class: anytype, p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_data: ?*anyopaque) void {
                return gobject.ext.as(Image.Class, p_class).f_minimise.?(gobject.ext.as(Image, p_image), p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Image.Class, p_class).f_minimise = @ptrCast(p_implementation);
            }
        };

        pub const posteval = struct {
            pub fn call(p_class: anytype, p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_progress: *vips.Progress, p_data: ?*anyopaque) void {
                return gobject.ext.as(Image.Class, p_class).f_posteval.?(gobject.ext.as(Image, p_image), p_progress, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_progress: *vips.Progress, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Image.Class, p_class).f_posteval = @ptrCast(p_implementation);
            }
        };

        pub const preeval = struct {
            pub fn call(p_class: anytype, p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_progress: *vips.Progress, p_data: ?*anyopaque) void {
                return gobject.ext.as(Image.Class, p_class).f_preeval.?(gobject.ext.as(Image, p_image), p_progress, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_progress: *vips.Progress, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Image.Class, p_class).f_preeval = @ptrCast(p_implementation);
            }
        };

        pub const written = struct {
            pub fn call(p_class: anytype, p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_result: *c_int, p_data: ?*anyopaque) void {
                return gobject.ext.as(Image.Class, p_class).f_written.?(gobject.ext.as(Image, p_image), p_result, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_image: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_result: *c_int, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Image.Class, p_class).f_written = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const bands = struct {
            pub const name = "bands";

            pub const Type = c_int;
        };

        pub const coding = struct {
            pub const name = "coding";

            pub const Type = vips.Coding;
        };

        pub const demand = struct {
            pub const name = "demand";

            pub const Type = vips.DemandStyle;
        };

        pub const filename = struct {
            pub const name = "filename";

            pub const Type = ?[*:0]u8;
        };

        pub const foreign_buffer = struct {
            pub const name = "foreign-buffer";

            pub const Type = ?*anyopaque;
        };

        pub const format = struct {
            pub const name = "format";

            pub const Type = vips.BandFormat;
        };

        pub const height = struct {
            pub const name = "height";

            pub const Type = c_int;
        };

        pub const interpretation = struct {
            pub const name = "interpretation";

            pub const Type = vips.Interpretation;
        };

        pub const kill = struct {
            pub const name = "kill";

            pub const Type = c_int;
        };

        pub const mode = struct {
            pub const name = "mode";

            pub const Type = ?[*:0]u8;
        };

        pub const sizeof_header = struct {
            pub const name = "sizeof-header";

            pub const Type = u64;
        };

        pub const width = struct {
            pub const name = "width";

            pub const Type = c_int;
        };

        pub const xoffset = struct {
            pub const name = "xoffset";

            pub const Type = c_int;
        };

        pub const xres = struct {
            pub const name = "xres";

            pub const Type = f64;
        };

        pub const yoffset = struct {
            pub const name = "yoffset";

            pub const Type = c_int;
        };

        pub const yres = struct {
            pub const name = "yres";

            pub const Type = f64;
        };
    };

    pub const signals = struct {
        /// The ::eval signal is emitted once per work unit (typically a 128 x
        /// 128 area of pixels) during image computation.
        ///
        /// You can use this signal to update user-interfaces with progress
        /// feedback. Beware of updating too frequently: you will usually
        /// need some throttling mechanism.
        ///
        /// Use `vips.Image.setProgress` to turn on progress reporting for an
        /// image.
        pub const eval = struct {
            pub const name = "eval";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_progress: **vips.Progress, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Image, p_instance))),
                    gobject.signalLookup("eval", Image.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::invalidate signal is emitted when an image or one of it's
        /// upstream data sources has been destructively modified. See
        /// `vips.Image.invalidateAll`.
        pub const invalidate = struct {
            pub const name = "invalidate";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Image, p_instance))),
                    gobject.signalLookup("invalidate", Image.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::minimise signal is emitted when an image has been asked to
        /// minimise memory usage. All non-essential caches are dropped.
        /// See `vips.Image.minimiseAll`.
        pub const minimise = struct {
            pub const name = "minimise";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Image, p_instance))),
                    gobject.signalLookup("minimise", Image.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::posteval signal is emitted once at the end of the computation
        /// of `image`. It's a good place to shut down evaluation feedback.
        ///
        /// Use `vips.Image.setProgress` to turn on progress reporting for an
        /// image.
        pub const posteval = struct {
            pub const name = "posteval";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_progress: **vips.Progress, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Image, p_instance))),
                    gobject.signalLookup("posteval", Image.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::preeval signal is emitted once before computation of `image`
        /// starts. It's a good place to set up evaluation feedback.
        ///
        /// Use `vips.Image.setProgress` to turn on progress reporting for an
        /// image.
        pub const preeval = struct {
            pub const name = "preeval";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_progress: **vips.Progress, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Image, p_instance))),
                    gobject.signalLookup("preeval", Image.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::written signal is emitted just after an image has been
        /// written to. It is
        /// used by vips to implement things like write to foreign file
        /// formats.
        pub const written = struct {
            pub const name = "written";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_result: *c_int, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Image, p_instance))),
                    gobject.signalLookup("written", Image.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    extern fn vips_image_get_format_max(p_format: vips.BandFormat) f64;
    pub const getFormatMax = vips_image_get_format_max;

    /// A renamed `vips.Image.newMatrixFromArray`. Some gobject bindings do not
    /// like more than one _new method.
    extern fn vips_image_matrix_from_array(p_width: c_int, p_height: c_int, p_array: [*]const f64, p_size: c_int) *vips.Image;
    pub const matrixFromArray = vips_image_matrix_from_array;

    /// A renamed `vips.Image.newMemory` ... Some gobject binding systems do not
    /// like more than one `_new` method.
    ///
    /// See also: `vips.Image.newMemory`.
    extern fn vips_image_memory() *vips.Image;
    pub const memory = vips_image_memory;

    /// `vips.Image.new` creates a new, empty `vips.Image`.
    /// If you write to one of these images, vips will just attach some callbacks,
    /// no pixels will be generated.
    ///
    /// Write pixels to an image with `vips_image_generate` or
    /// `vips.Image.writeLine`. Write a whole image to another image with
    /// `vips.Image.write`.
    extern fn vips_image_new() *vips.Image;
    pub const new = vips_image_new;

    /// Loads an image from the formatted area of memory `buf`, `len` using the
    /// loader recommended by `vips.Foreign.findLoadBuffer`.
    /// To load an unformatted area of memory, use
    /// `vips.Image.newFromMemory`.
    ///
    /// VIPS does not take
    /// responsibility for the area of memory, it's up to you to make sure it's
    /// freed when the image is closed. See for example `vips.Object.signals.close`.
    ///
    /// Load options may be given in `option_string` as "[name=value,...]" or given as
    /// a NULL-terminated list of name-value pairs at the end of the arguments.
    /// Options given in the function call override options given in the filename.
    ///
    /// See also: `vips.Image.writeToBuffer`.
    extern fn vips_image_new_from_buffer(p_buf: [*]u8, p_len: usize, p_option_string: [*:0]const u8, ...) *vips.Image;
    pub const newFromBuffer = vips_image_new_from_buffer;

    /// Optional arguments:
    ///
    /// * `access`: hint `vips.Access` mode to loader
    /// * `memory`: force load via memory
    ///
    /// `vips.Image.newFromFile` opens `name` for reading. It can load files
    /// in many image formats, including VIPS, TIFF, PNG, JPEG, FITS, Matlab,
    /// OpenEXR, CSV, WebP, Radiance, RAW, PPM and others.
    ///
    /// Load options may be appended to `filename` as "[name=value,...]" or given as
    /// a NULL-terminated list of name-value pairs at the end of the arguments.
    /// Options given in the function call override options given in the filename.
    /// Many loaders add extra options, see `vips.jpegload`, for example.
    ///
    /// `vips.Image.newFromFile` always returns immediately with the header
    /// fields filled in. No pixels are actually read until you first access them.
    ///
    /// `access` lets you set a `vips.Access` hint giving the expected access pattern
    /// for this file.
    /// `VIPS_ACCESS_RANDOM` means you can fetch pixels randomly from the image.
    /// This is the default mode. `VIPS_ACCESS_SEQUENTIAL` means you will read the
    /// whole image exactly once, top-to-bottom. In this mode, vips can avoid
    /// converting the whole image in one go, for a large memory saving. You are
    /// allowed to make small non-local references, so area operations like
    /// convolution will work.
    ///
    /// In `VIPS_ACCESS_RANDOM` mode, small images are decompressed to memory and
    /// then processed from there. Large images are decompressed to temporary
    /// random-access files on disc and then processed from there.
    ///
    /// Set `memory` to `TRUE` to force loading via memory. The default is to load
    /// large random access images via temporary disc files. See
    /// `vips.Image.newTempFile` for an
    /// explanation of how VIPS selects a location for the temporary file.
    ///
    /// The disc threshold can be set with the "--vips-disc-threshold"
    /// command-line argument, or the `VIPS_DISC_THRESHOLD` environment variable.
    /// The value is a simple integer, but can take a unit postfix of "k",
    /// "m" or "g" to indicate kilobytes, megabytes or gigabytes.
    /// The default threshold is 100 MB.
    ///
    /// For example:
    ///
    /// ```
    /// VipsImage *image = vips_image_new_from_file("fred.tif",
    ///     "page", 12,
    ///     NULL);
    /// ```
    ///
    /// Will open "fred.tif", reading page 12.
    ///
    /// ```
    /// VipsImage *image = vips_image_new_from_file("fred.jpg[shrink=2]",
    ///     NULL);
    /// ```
    ///
    /// Will open "fred.jpg", downsampling by a factor of two.
    ///
    /// Use `vips.Foreign.findLoad` or `vips.Foreign.isA` to see what format a
    /// file is in and therefore what options are available. If you need more
    /// control over the loading process, you can call loaders directly, see
    /// `vips.jpegload`, for example.
    ///
    /// See also: `vips.Foreign.findLoad`, `vips.Foreign.isA`,
    /// `vips.Image.writeToFile`.
    extern fn vips_image_new_from_file(p_name: [*:0]const u8, ...) ?*vips.Image;
    pub const newFromFile = vips_image_new_from_file;

    /// Opens the named file for simultaneous reading and writing. This will only
    /// work for VIPS files in a format native to your machine. It is only for
    /// paintbox-type applications.
    ///
    /// See also: `vips.Image.drawCircle`.
    extern fn vips_image_new_from_file_RW(p_filename: [*:0]const u8) *vips.Image;
    pub const newFromFileRW = vips_image_new_from_file_RW;

    /// This function maps the named file and returns a `vips.Image` you can use to
    /// read it.
    ///
    /// It returns an 8-bit image with `bands` bands. If the image is not 8-bit, use
    /// `vips.Image.copy` to transform the descriptor after loading it.
    ///
    /// See also: `vips.Image.copy`, `vips.rawload`, `vips.Image.newFromFile`.
    extern fn vips_image_new_from_file_raw(p_filename: [*:0]const u8, p_xsize: c_int, p_ysize: c_int, p_bands: c_int, p_offset: u64) *vips.Image;
    pub const newFromFileRaw = vips_image_new_from_file_raw;

    /// Creates a new image with width, height, format, interpretation, resolution
    /// and offset taken from `image`, but with number of bands taken from `n` and the
    /// value of each band element set from `c`.
    ///
    /// See also: `vips.Image.newFromImage1`
    extern fn vips_image_new_from_image(p_image: *vips.Image, p_c: [*]const f64, p_n: c_int) *vips.Image;
    pub const newFromImage = vips_image_new_from_image;

    /// Creates a new image with width, height, format, interpretation, resolution
    /// and offset taken from `image`, but with one band and each pixel having the
    /// value `c`.
    ///
    /// See also: `vips.Image.newFromImage`
    extern fn vips_image_new_from_image1(p_image: *vips.Image, p_c: f64) *vips.Image;
    pub const newFromImage1 = vips_image_new_from_image1;

    /// This function wraps a `vips.Image` around a memory area. The memory area
    /// must be a simple array, for example RGBRGBRGB, left-to-right,
    /// top-to-bottom. Use `vips.Image.newFromBuffer` to load an area of memory
    /// containing an image in a format.
    ///
    /// VIPS does not take
    /// responsibility for the area of memory, it's up to you to make sure it's
    /// freed when the image is closed. See for example `vips.Object.signals.close`.
    ///
    /// Because VIPS is "borrowing" `data` from the caller, this function is
    /// extremely dangerous. Unless you are very careful, you will get crashes or
    /// memory corruption. Use `vips.Image.newFromMemoryCopy` instead if you are
    /// at all unsure.
    ///
    /// Use `vips.Image.copy` to set other image properties.
    ///
    /// See also: `vips.Image.new`, `vips.Image.writeToMemory`,
    /// `vips.Image.newFromMemoryCopy`.
    extern fn vips_image_new_from_memory(p_data: [*]u8, p_size: usize, p_width: c_int, p_height: c_int, p_bands: c_int, p_format: vips.BandFormat) *vips.Image;
    pub const newFromMemory = vips_image_new_from_memory;

    /// Like `vips.Image.newFromMemory`, but VIPS will make a copy of the memory
    /// area. This means more memory use and an extra copy operation, but is much
    /// simpler and safer.
    ///
    /// See also: `vips.Image.newFromMemory`.
    extern fn vips_image_new_from_memory_copy(p_data: [*]u8, p_size: usize, p_width: c_int, p_height: c_int, p_bands: c_int, p_format: vips.BandFormat) *vips.Image;
    pub const newFromMemoryCopy = vips_image_new_from_memory_copy;

    /// Loads an image from the formatted source `input`,
    /// loader recommended by `vips.Foreign.findLoadSource`.
    ///
    /// Load options may be given in `option_string` as "[name=value,...]" or given as
    /// a NULL-terminated list of name-value pairs at the end of the arguments.
    /// Options given in the function call override options given in the string.
    ///
    /// See also: `vips.Image.writeToTarget`.
    extern fn vips_image_new_from_source(p_source: *vips.Source, p_option_string: [*:0]const u8, ...) *vips.Image;
    pub const newFromSource = vips_image_new_from_source;

    /// This convenience function makes an image which is a matrix: a one-band
    /// `VIPS_FORMAT_DOUBLE` image held in memory.
    ///
    /// Use `VIPS_IMAGE_ADDR`, or `VIPS_MATRIX` to address pixels in the image.
    ///
    /// Use `vips.Image.setDouble` to set "scale" and "offset", if required.
    ///
    /// See also: `vips.Image.newMatrixv`
    extern fn vips_image_new_matrix(p_width: c_int, p_height: c_int) *vips.Image;
    pub const newMatrix = vips_image_new_matrix;

    /// A binding-friendly version of `vips.Image.newMatrixv`.
    extern fn vips_image_new_matrix_from_array(p_width: c_int, p_height: c_int, p_array: [*]const f64, p_size: c_int) *vips.Image;
    pub const newMatrixFromArray = vips_image_new_matrix_from_array;

    /// As `vips.Image.newMatrix`, but initialise the matrix from the argument
    /// list. After `height` should be `width` * `height` double constants which are
    /// used to set the matrix elements.
    ///
    /// See also: `vips.Image.newMatrix`
    extern fn vips_image_new_matrixv(p_width: c_int, p_height: c_int, ...) *vips.Image;
    pub const newMatrixv = vips_image_new_matrixv;

    /// `vips.Image.newMemory` creates a new `vips.Image` which, when written to, will
    /// create a memory image.
    ///
    /// See also: `vips.Image.new`.
    extern fn vips_image_new_memory() *vips.Image;
    pub const newMemory = vips_image_new_memory;

    /// Make a `vips.Image` which, when written to, will create a temporary file on
    /// disc. The file will be automatically deleted when the image is destroyed.
    /// `format` is something like "&percnt;s.v" for a vips file.
    ///
    /// The file is created in the temporary directory. This is set with the
    /// environment variable TMPDIR. If this is not set, then on Unix systems, vips
    /// will default to /tmp. On Windows, vips uses `GetTempPath` to find the
    /// temporary directory.
    ///
    /// See also: `vips.Image.new`.
    extern fn vips_image_new_temp_file(p_format: [*:0]const u8) *vips.Image;
    pub const newTempFile = vips_image_new_temp_file;

    /// Turn LCh to CMC.
    ///
    /// See also: `vips.Image.LCh2CMC`.
    extern fn vips_CMC2LCh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const CMC2LCh = vips_CMC2LCh;

    /// Turn CMYK to XYZ. If the image has an embedded ICC profile this will be
    /// used for the conversion. If there is no embedded profile, a generic
    /// fallback profile will be used.
    ///
    /// Conversion is to D65 XYZ with relative intent. If you need more control
    /// over the process, use `vips.Image.iccImport` instead.
    extern fn vips_CMYK2XYZ(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const CMYK2XYZ = vips_CMYK2XYZ;

    /// Convert HSV to sRGB.
    ///
    /// HSV is a crude polar coordinate system for RGB images. It is provided for
    /// compatibility with other image processing systems. See `vips.Image.Lab2LCh` for a
    /// much better colour space.
    ///
    /// See also: `vips.Image.sRGB2HSV`.
    extern fn vips_HSV2sRGB(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const HSV2sRGB = vips_HSV2sRGB;

    /// Turn LCh to CMC.
    ///
    /// The CMC colourspace is described in "Uniform Colour Space Based on the
    /// CMC(l:c) Colour-difference Formula", M R Luo and B Rigg, Journal of the
    /// Society of Dyers and Colourists, vol 102, 1986. Distances in this
    /// colourspace approximate, within 10% or so, differences in the CMC(l:c)
    /// colour difference formula.
    ///
    /// This operation generates CMC(1:1). For CMC(2:1), halve Lucs and double
    /// Cucs.
    ///
    /// See also: `vips.Image.CMC2LCh`.
    extern fn vips_LCh2CMC(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LCh2CMC = vips_LCh2CMC;

    /// Turn LCh to Lab.
    extern fn vips_LCh2Lab(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LCh2Lab = vips_LCh2Lab;

    /// Turn Lab to LCh.
    extern fn vips_Lab2LCh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const Lab2LCh = vips_Lab2LCh;

    /// Convert a Lab three-band float image to LabQ (`VIPS_CODING_LABQ`).
    ///
    /// See also: `vips.Image.LabQ2Lab`.
    extern fn vips_Lab2LabQ(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const Lab2LabQ = vips_Lab2LabQ;

    /// Turn Lab to LabS, signed 16-bit int fixed point.
    ///
    /// See also: `vips.Image.LabQ2Lab`.
    extern fn vips_Lab2LabS(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const Lab2LabS = vips_Lab2LabS;

    /// Optional arguments:
    ///
    /// * `temp`: `vips.ArrayDouble`, colour temperature
    ///
    /// Turn Lab to XYZ. The colour temperature defaults to D65, but can be
    /// specified with `temp`.
    extern fn vips_Lab2XYZ(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const Lab2XYZ = vips_Lab2XYZ;

    /// Unpack a LabQ (`VIPS_CODING_LABQ`) image to a three-band float image.
    ///
    /// See also: `vips.Image.LabQ2Lab`, `vips.Image.LabQ2LabS`, `vips.Image.rad2float`.
    extern fn vips_LabQ2Lab(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LabQ2Lab = vips_LabQ2Lab;

    /// Unpack a LabQ (`VIPS_CODING_LABQ`) image to a three-band short image.
    ///
    /// See also: `vips.Image.LabS2LabQ`, `vips.Image.LabQ2LabS`, `vips.Image.rad2float`.
    extern fn vips_LabQ2LabS(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LabQ2LabS = vips_LabQ2LabS;

    /// Unpack a LabQ (`VIPS_CODING_LABQ`) image to a three-band short image.
    ///
    /// See also: `vips.Image.LabS2LabQ`, `vips.Image.LabQ2sRGB`, `vips.Image.rad2float`.
    extern fn vips_LabQ2sRGB(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LabQ2sRGB = vips_LabQ2sRGB;

    /// Convert a LabS three-band signed short image to a three-band float image.
    ///
    /// See also: `vips.Image.LabS2Lab`.
    extern fn vips_LabS2Lab(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LabS2Lab = vips_LabS2Lab;

    /// Convert a LabS three-band signed short image to LabQ
    ///
    /// See also: `vips.Image.LabQ2LabS`.
    extern fn vips_LabS2LabQ(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const LabS2LabQ = vips_LabS2LabQ;

    /// Turn XYZ to CMYK.
    ///
    /// Conversion is from D65 XYZ with relative intent. If you need more control
    /// over the process, use `vips.Image.iccExport` instead.
    extern fn vips_XYZ2CMYK(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const XYZ2CMYK = vips_XYZ2CMYK;

    /// Optional arguments:
    ///
    /// * `temp`: `vips.ArrayDouble`, colour temperature
    ///
    /// Turn XYZ to Lab, optionally specifying the colour temperature. `temp`
    /// defaults to D65.
    extern fn vips_XYZ2Lab(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const XYZ2Lab = vips_XYZ2Lab;

    /// Turn XYZ to Yxy.
    extern fn vips_XYZ2Yxy(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const XYZ2Yxy = vips_XYZ2Yxy;

    /// Turn XYZ to scRGB.
    extern fn vips_XYZ2scRGB(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const XYZ2scRGB = vips_XYZ2scRGB;

    /// Turn XYZ to Yxy.
    extern fn vips_Yxy2XYZ(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const Yxy2XYZ = vips_Yxy2XYZ;

    /// This operation finds the absolute value of an image. It does a copy for
    /// unsigned integer types, negate for negative values in
    /// signed integer types, <function>fabs(3)</function> for
    /// float types, and calculates modulus for complex
    /// types.
    ///
    /// See also: `vips.Image.sign`.
    extern fn vips_abs(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const abs = vips_abs;

    /// Perform `VIPS_OPERATION_MATH_ACOS` on an image. See `vips.Image.math`.
    extern fn vips_acos(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const acos = vips_acos;

    /// Perform `VIPS_OPERATION_MATH_ACOSH` on an image. See `vips.Image.math`.
    extern fn vips_acosh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const acosh = vips_acosh;

    /// Append an alpha channel.
    ///
    /// See also: `vips.Image.hasalpha`.
    extern fn vips_addalpha(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const addalpha = vips_addalpha;

    /// Optional arguments:
    ///
    /// * `interpolate`: `vips.Interpolate`, interpolate pixels with this
    /// * `oarea`: `vips.ArrayInt`, output rectangle
    /// * `idx`: `gdouble`, input horizontal offset
    /// * `idy`: `gdouble`, input vertical offset
    /// * `odx`: `gdouble`, output horizontal offset
    /// * `ody`: `gdouble`, output vertical offset
    /// * `extend`: `vips.Extend` how to generate new pixels
    /// * `background`: `vips.ArrayDouble` colour for new pixels
    /// * `premultiplied`: `gboolean`, images are already premultiplied
    ///
    /// This operator performs an affine transform on an image using `interpolate`.
    ///
    /// The transform is:
    ///
    /// ```
    ///   X = `a` * (x + `idx`) + `b` * (y + `idy`) + `odx`
    ///   Y = `c` * (x + `idx`) + `d` * (y + `idy`) + `doy`
    ///
    ///   where:
    ///     x and y are the coordinates in input image.
    ///     X and Y are the coordinates in output image.
    ///     (0,0) is the upper left corner.
    /// ```
    ///
    /// The section of the output space defined by `oarea` is written to
    /// `out`. `oarea` is a four-element int array of left, top, width, height.
    /// By default `oarea` is just large enough to cover the whole of the
    /// transformed input image.
    ///
    /// By default, new pixels are filled with `background`. This defaults to
    /// zero (black). You can set other extend types with `extend`. `VIPS_EXTEND_COPY`
    /// is better for image upsizing.
    ///
    /// `interpolate` defaults to bilinear.
    ///
    /// `idx`, `idy`, `odx`, `ody` default to zero.
    ///
    /// Image are normally treated as unpremultiplied, so this operation can be used
    /// directly on PNG images. If your images have been through `vips.Image.premultiply`,
    /// set `premultiplied`.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.shrink`, `vips.Image.resize`, `vips.Interpolate`.
    extern fn vips_affine(p_in: *Image, p_out: **vips.Image, p_a: f64, p_b: f64, p_c: f64, p_d: f64, ...) c_int;
    pub const affine = vips_affine;

    /// Perform `VIPS_OPERATION_BOOLEAN_AND` on an image and an array of constants.
    /// See `vips.Image.booleanConst`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst1`.
    extern fn vips_andimage_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const andimageConst = vips_andimage_const;

    /// Perform `VIPS_OPERATION_BOOLEAN_AND` on an image and a constant.
    /// See `vips.Image.booleanConst1`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst`.
    extern fn vips_andimage_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const andimageConst1 = vips_andimage_const1;

    /// Perform `VIPS_OPERATION_MATH_ASIN` on an image. See `vips.Image.math`.
    extern fn vips_asin(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const asin = vips_asin;

    /// Perform `VIPS_OPERATION_MATH_ASINH` on an image. See `vips.Image.math`.
    extern fn vips_asinh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const asinh = vips_asinh;

    /// Perform `VIPS_OPERATION_MATH_ATAN` on an image. See `vips.Image.math`.
    extern fn vips_atan(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const atan = vips_atan;

    /// Perform `VIPS_OPERATION_MATH2_ATAN2` on an image and a constant. See
    /// `vips.Image.math2Const`.
    extern fn vips_atan2_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const atan2Const = vips_atan2_const;

    /// Perform `VIPS_OPERATION_MATH2_ATAN2` on an image and a constant. See
    /// `vips.Image.math2Const`.
    extern fn vips_atan2_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const atan2Const1 = vips_atan2_const1;

    /// Perform `VIPS_OPERATION_MATH_ATANH` on an image. See `vips.Image.math`.
    extern fn vips_atanh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const atanh = vips_atanh;

    /// Optional arguments:
    ///
    /// * `angle`: output `vips.Angle` the image was rotated by
    /// * `flip`: output `gboolean` whether the image was flipped
    ///
    /// Look at the image metadata and rotate and flip the image to make it
    /// upright. The `VIPS_META_ORIENTATION` tag is removed from `out` to prevent
    /// accidental double rotation.
    ///
    /// Read `angle` to find the amount the image was rotated by. Read `flip` to
    /// see if the image was also flipped.
    extern fn vips_autorot(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const autorot = vips_autorot;

    /// Remove the orientation tag on `image`. Also remove any exif orientation tags.
    /// You must `vips.Image.copy` the image before calling this function since it
    /// modifies metadata.
    extern fn vips_autorot_remove_angle(p_image: *Image) void;
    pub const autorotRemoveAngle = vips_autorot_remove_angle;

    /// This operation finds the average value in an image. It operates on all
    /// bands of the input image: use `vips.Image.stats` if you need to calculate an
    /// average for each band. For complex images, return the average modulus.
    ///
    /// See also: `vips.Image.stats`, `vips.Image.bandmean`, `vips.Image.deviate`, `vips.Image.rank`
    extern fn vips_avg(p_in: *Image, p_out: *f64, ...) c_int;
    pub const avg = vips_avg;

    /// Perform `VIPS_OPERATION_BOOLEAN_AND` on an image. See
    /// `vips.Image.bandbool`.
    extern fn vips_bandand(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const bandand = vips_bandand;

    /// Perform various boolean operations across the bands of an image. For
    /// example, a three-band uchar image operated on with
    /// `VIPS_OPERATION_BOOLEAN_AND` will produce a one-band uchar image where each
    /// pixel is the bitwise and of the band elements of the corresponding pixel in
    /// the input image.
    ///
    /// The output image is the same format as the input image for integer
    /// types. Float types are cast to int before processing. Complex types are not
    /// supported.
    ///
    /// The output image always has one band.
    ///
    /// This operation is useful in conjunction with `vips.relational`. You can use
    /// it to see if all image bands match exactly.
    ///
    /// See also: `vips.Image.booleanConst`.
    extern fn vips_bandbool(p_in: *Image, p_out: **vips.Image, p_boolean: vips.OperationBoolean, ...) c_int;
    pub const bandbool = vips_bandbool;

    /// Perform `VIPS_OPERATION_BOOLEAN_EOR` on an image. See
    /// `vips.Image.bandbool`.
    extern fn vips_bandeor(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const bandeor = vips_bandeor;

    /// Optional arguments:
    ///
    /// * `factor`: fold by this factor
    ///
    /// Fold up an image horizontally: width is collapsed into bands.
    /// Use `factor` to set how much to fold by: `factor` 3, for example, will make
    /// the output image three times narrower than the input, and with three times
    /// as many bands. By default the whole of the input width is folded up.
    ///
    /// See also: `vips.csvload`, `vips.Image.bandunfold`.
    extern fn vips_bandfold(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const bandfold = vips_bandfold;

    /// Append a set of constant bands to an image.
    ///
    /// See also: `vips.bandjoin`.
    extern fn vips_bandjoin_const(p_in: *Image, p_out: **vips.Image, p_c: [*]f64, p_n: c_int, ...) c_int;
    pub const bandjoinConst = vips_bandjoin_const;

    /// Append a single constant band to an image.
    extern fn vips_bandjoin_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const bandjoinConst1 = vips_bandjoin_const1;

    /// This operation writes a one-band image where each pixel is the average of
    /// the bands for that pixel in the input image. The output band format is
    /// the same as the input band format. Integer types use round-to-nearest
    /// averaging.
    ///
    /// See also: `vips.add`, `vips.Image.avg`, `vips.Image.recomb`
    extern fn vips_bandmean(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const bandmean = vips_bandmean;

    /// Perform `VIPS_OPERATION_BOOLEAN_OR` on an image. See
    /// `vips.Image.bandbool`.
    extern fn vips_bandor(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const bandor = vips_bandor;

    /// Optional arguments:
    ///
    /// * `factor`: unfold by this factor
    ///
    /// Unfold image bands into x axis.
    /// Use `factor` to set how much to unfold by: `factor` 3, for example, will make
    /// the output image three times wider than the input, and with one third
    /// as many bands. By default, all bands are unfolded.
    ///
    /// See also: `vips.csvload`, `vips.Image.bandfold`.
    extern fn vips_bandunfold(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const bandunfold = vips_bandunfold;

    /// Perform various boolean operations on an image against an array of
    /// constants.
    ///
    /// The output type is always uchar, with 0 for FALSE and 255 for TRUE.
    ///
    /// If the array of constants has just one element, that constant is used for
    /// all image bands. If the array has more than one element and they have
    /// the same number of elements as there are bands in the image, then
    /// one array element is used for each band. If the arrays have more than one
    /// element and the image only has a single band, the result is a many-band
    /// image where each band corresponds to one array element.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst1`.
    extern fn vips_boolean_const(p_in: *Image, p_out: **vips.Image, p_boolean: vips.OperationBoolean, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const booleanConst = vips_boolean_const;

    /// Perform various boolean operations on an image with a single constant. See
    /// `vips.Image.booleanConst`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst`.
    extern fn vips_boolean_const1(p_in: *Image, p_out: **vips.Image, p_boolean: vips.OperationBoolean, p_c: f64, ...) c_int;
    pub const booleanConst1 = vips_boolean_const1;

    /// This operation builds a lookup table from a set of points. Intermediate
    /// values are generated by piecewise linear interpolation. The lookup table is
    /// always of type `VIPS_FORMAT_DOUBLE`, use `vips.Image.cast` to change it to the
    /// type you need.
    ///
    /// For example, consider this 2 x 2 matrix of (x, y) coordinates:
    ///
    ///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
    ///     <tbody>
    ///       <row>
    ///         <entry>0</entry>
    ///         <entry>0</entry>
    ///       </row>
    ///       <row>
    ///         <entry>255</entry>
    ///         <entry>100</entry>
    ///       </row>
    ///     </tbody>
    ///   </tgroup>
    ///
    /// We then generate a 1 x 256 element LUT like this:
    ///
    ///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
    ///     <thead>
    ///       <row>
    ///         <entry>Index</entry>
    ///         <entry>Value</entry>
    ///       </row>
    ///     </thead>
    ///     <tbody>
    ///       <row>
    ///         <entry>0</entry>
    ///         <entry>0</entry>
    ///       </row>
    ///       <row>
    ///         <entry>1</entry>
    ///         <entry>0.4</entry>
    ///       </row>
    ///       <row>
    ///         <entry>etc.</entry>
    ///         <entry>0.4</entry>
    ///       </row>
    ///       <row>
    ///         <entry>255</entry>
    ///         <entry>100</entry>
    ///       </row>
    ///     </tbody>
    ///   </tgroup>
    ///
    /// This is then written as the output image, with the left column giving the
    /// index in the image to place the value.
    ///
    /// The (x, y) points don't need to be sorted: we do that. You can have
    /// several Ys, each becomes a band in the output LUT. You don't need to
    /// start at zero, any integer will do, including negatives.
    ///
    /// See also: `vips.identity`, `vips.Image.invertlut`, `vips.Image.cast`, `vips.Image.maplut`.
    extern fn vips_buildlut(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const buildlut = vips_buildlut;

    /// Swap the byte order in an image.
    ///
    /// See also: `vips.rawload`.
    extern fn vips_byteswap(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const byteswap = vips_byteswap;

    /// Optional arguments:
    ///
    /// * `sigma`: `gdouble`, sigma for gaussian blur
    /// * `precision`: `vips.Precision`, calculation accuracy
    ///
    /// Find edges by Canny's method: The maximum of the derivative of the gradient
    /// in the direction of the gradient. Output is float, except for uchar input,
    /// where output is uchar, and double input, where output is double. Non-complex
    /// images only.
    ///
    /// Use `sigma` to control the scale over which gradient is measured. 1.4 is
    /// usually a good value.
    ///
    /// Use `precision` to set the precision of edge detection. For uchar images,
    /// setting this to `VIPS_PRECISION_INTEGER` will make edge detection much
    /// faster, but sacrifice some sensitivity.
    ///
    /// You will probably need to process the output further to eliminate weak
    /// edges.
    ///
    /// See also: `vips.Image.sobel`.
    extern fn vips_canny(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const canny = vips_canny;

    /// Use values in `index` to select pixels from `cases`.
    ///
    /// `index` must have one band. `cases` can have up to 256 elements. Values in
    /// `index` greater than or equal to `n` use the final image in `cases`. The
    /// images in `cases` must have either one band or the same number of bands.
    /// The output image is the same size as `index`. Images in `cases` are
    /// expanded to the smallest common format and number of bands.
    ///
    /// Combine this with `vips.@"switch"` to make something like a case statement or
    /// a multi-way `vips.ifthenelse`.
    ///
    /// See also: `vips.Image.maplut`, `vips.@"switch"`, `vips.ifthenelse`.
    extern fn vips_case(p_index: *Image, p_cases: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, ...) c_int;
    pub const case = vips_case;

    /// Optional arguments:
    ///
    /// * `shift`: `gboolean`, integer values are shifted
    ///
    /// Convert `in` to `format`. You can convert between any pair of formats.
    /// Floats are truncated (not rounded). Out of range values are clipped.
    ///
    /// Casting from complex to real returns the real part.
    ///
    /// If `shift` is `TRUE`, integer values are shifted up and down. For example,
    /// casting from unsigned 8 bit to unsigned 16 bit would
    /// shift every value left by 8 bits. The bottom bit is copied into the new
    /// bits, so 255 would become 65535.
    ///
    /// See also: `vips.Image.scale`, `vips.complexform`, `vips.Image.real`, `vips.Image.imag`,
    /// `vips.Image.castUchar`, `vips.Image.msb`.
    extern fn vips_cast(p_in: *Image, p_out: **vips.Image, p_format: vips.BandFormat, ...) c_int;
    pub const cast = vips_cast;

    /// Convert `in` to `VIPS_FORMAT_CHAR`. See `vips.Image.cast`.
    extern fn vips_cast_char(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castChar = vips_cast_char;

    /// Convert `in` to `VIPS_FORMAT_COMPLEX`. See `vips.Image.cast`.
    extern fn vips_cast_complex(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castComplex = vips_cast_complex;

    /// Convert `in` to `VIPS_FORMAT_DOUBLE`. See `vips.Image.cast`.
    extern fn vips_cast_double(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castDouble = vips_cast_double;

    /// Convert `in` to `VIPS_FORMAT_DPCOMPLEX`. See `vips.Image.cast`.
    extern fn vips_cast_dpcomplex(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castDpcomplex = vips_cast_dpcomplex;

    /// Convert `in` to `VIPS_FORMAT_FLOAT`. See `vips.Image.cast`.
    extern fn vips_cast_float(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castFloat = vips_cast_float;

    /// Convert `in` to `VIPS_FORMAT_INT`. See `vips.Image.cast`.
    extern fn vips_cast_int(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castInt = vips_cast_int;

    /// Convert `in` to `VIPS_FORMAT_SHORT`. See `vips.Image.cast`.
    extern fn vips_cast_short(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castShort = vips_cast_short;

    /// Convert `in` to `VIPS_FORMAT_UCHAR`. See `vips.Image.cast`.
    extern fn vips_cast_uchar(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castUchar = vips_cast_uchar;

    /// Convert `in` to `VIPS_FORMAT_UINT`. See `vips.Image.cast`.
    extern fn vips_cast_uint(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castUint = vips_cast_uint;

    /// Convert `in` to `VIPS_FORMAT_USHORT`. See `vips.Image.cast`.
    extern fn vips_cast_ushort(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const castUshort = vips_cast_ushort;

    /// Round to an integral value with `VIPS_OPERATION_ROUND_CEIL`. See
    /// `vips.Image.round`.
    extern fn vips_ceil(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const ceil = vips_ceil;

    /// Optional arguments:
    ///
    /// * `min`: `gdouble`, minimum value
    /// * `max`: `gdouble`, maximum value
    ///
    /// This operation clamps pixel values to a range, by default 0 - 1.
    ///
    /// Use `min` and `max` to change the range.
    ///
    /// See also: `vips.Image.sign`, `vips.Image.abs`, `vips.sdf`.
    extern fn vips_clamp(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const clamp = vips_clamp;

    /// Optional arguments:
    ///
    /// * `source_space`: input colour space
    ///
    /// This operation looks at the interpretation field of `in` (or uses
    /// `source_space`, if set) and runs
    /// a set of colourspace conversion functions to move it to `space`.
    ///
    /// For example, given an image tagged as `VIPS_INTERPRETATION_YXY`, running
    /// `vips.Image.colourspace` with `space` set to `VIPS_INTERPRETATION_LAB` will
    /// convert with `vips.Image.Yxy2XYZ` and `vips.Image.XYZ2Lab`.
    ///
    /// See also: `vips.Image.colourspaceIssupported`,
    /// `vips.Image.guessInterpretation`.
    extern fn vips_colourspace(p_in: *Image, p_out: **vips.Image, p_space: vips.Interpretation, ...) c_int;
    pub const colourspace = vips_colourspace;

    /// Test if `image` is in a colourspace that `vips.Image.colourspace` can process.
    extern fn vips_colourspace_issupported(p_image: *const Image) c_int;
    pub const colourspaceIssupported = vips_colourspace_issupported;

    /// Optional arguments:
    ///
    /// * `times`: `gint`, how many times to rotate and convolve
    /// * `angle`: `vips.Angle45`, rotate mask by this much between colvolutions
    /// * `combine`: `vips.Combine`, combine results like this
    /// * `precision`: `vips.Precision`, precision for blur, default float
    /// * `layers`: `gint`, number of layers for approximation
    /// * `cluster`: `gint`, cluster lines closer than this distance
    ///
    /// This convolves `in` with `mask` `times` times, rotating `mask` by `angle`
    /// each time. By default, it comvolves twice, rotating by 90 degrees, taking
    /// the maximum result.
    ///
    /// See also: `vips.Image.conv`.
    extern fn vips_compass(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const compass = vips_compass;

    /// Perform various operations on complex images.
    ///
    /// Angles are expressed in degrees. The output type is complex unless the
    /// input is double or dpcomplex, in which case the output is dpcomplex.
    extern fn vips_complex(p_in: *Image, p_out: **vips.Image, p_cmplx: vips.OperationComplex, ...) c_int;
    pub const complex = vips_complex;

    /// Get components of complex images.
    ///
    /// The output type is the same as the input type, except `VIPS_FORMAT_COMPLEX`
    /// becomes `VIPS_FORMAT_FLOAT` and `VIPS_FORMAT_DPCOMPLEX` becomes
    /// `VIPS_FORMAT_DOUBLE`.
    extern fn vips_complexget(p_in: *Image, p_out: **vips.Image, p_get: vips.OperationComplexget, ...) c_int;
    pub const complexget = vips_complexget;

    /// Optional arguments:
    ///
    /// * `compositing_space`: `vips.Interpretation` to composite in
    /// * `premultiplied`: `gboolean`, images are already premultiplied
    /// * `x`: `gint`, position of overlay
    /// * `y`: `gint`, position of overlay
    ///
    /// Composite `overlay` on top of `base` with `mode`. See `vips.composite`.
    extern fn vips_composite2(p_base: *Image, p_overlay: *vips.Image, p_out: **vips.Image, p_mode: vips.BlendMode, ...) c_int;
    pub const composite2 = vips_composite2;

    /// Perform `VIPS_OPERATION_COMPLEX_CONJ` on an image. See `vips.Image.complex`.
    extern fn vips_conj(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const conj = vips_conj;

    /// Optional arguments:
    ///
    /// * `precision`: `vips.Precision`, calculation accuracy
    /// * `layers`: `gint`, number of layers for approximation
    /// * `cluster`: `gint`, cluster lines closer than this distance
    ///
    /// Convolution.
    ///
    /// Perform a convolution of `in` with `mask`.
    /// Each output pixel is calculated as:
    ///
    /// ```
    /// sigma[i]{pixel[i] * mask[i]} / scale + offset
    /// ```
    ///
    /// where scale and offset are part of `mask`.
    ///
    /// By default, `precision` is
    /// `VIPS_PRECISION_FLOAT`. The output image
    /// is always `VIPS_FORMAT_FLOAT` unless `in` is `VIPS_FORMAT_DOUBLE`, in which case
    /// `out` is also `VIPS_FORMAT_DOUBLE`.
    ///
    /// If `precision` is `VIPS_PRECISION_INTEGER`, then
    /// elements of `mask` are converted to
    /// integers before convolution, using `rint`,
    /// and the output image
    /// always has the same `vips.BandFormat` as the input image.
    ///
    /// For `VIPS_FORMAT_UCHAR` images and `VIPS_PRECISION_INTEGER` `precision`,
    /// `vips.Image.conv` uses a fast vector path based on
    /// half-float arithmetic. This can produce slightly different results.
    /// Disable the vector path with `--vips-novector` or `VIPS_NOVECTOR` or
    /// `vips_vector_set_enabled`.
    ///
    /// If `precision` is `VIPS_PRECISION_APPROXIMATE` then, like
    /// `VIPS_PRECISION_INTEGER`, `mask` is converted to int before convolution, and
    /// the output image
    /// always has the same `vips.BandFormat` as the input image.
    ///
    /// Larger values for `layers` give more accurate
    /// results, but are slower. As `layers` approaches the mask radius, the
    /// accuracy will become close to exact convolution and the speed will drop to
    /// match. For many large masks, such as Gaussian, `n_layers` need be only 10% of
    /// this value and accuracy will still be good.
    ///
    /// Smaller values of `cluster` will give more accurate results, but be slower
    /// and use more memory. 10% of the mask radius is a good rule of thumb.
    ///
    /// See also: `vips.Image.convsep`.
    extern fn vips_conv(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const conv = vips_conv;

    /// Optional arguments:
    ///
    /// * `layers`: `gint`, number of layers for approximation
    /// * `cluster`: `gint`, cluster lines closer than this distance
    ///
    /// Perform an approximate integer convolution of `in` with `mask`.
    /// This is a low-level operation, see
    /// `vips.Image.conv` for something more convenient.
    ///
    /// The output image
    /// always has the same `vips.BandFormat` as the input image.
    /// Elements of `mask` are converted to
    /// integers before convolution.
    ///
    /// Larger values for `layers` give more accurate
    /// results, but are slower. As `layers` approaches the mask radius, the
    /// accuracy will become close to exact convolution and the speed will drop to
    /// match. For many large masks, such as Gaussian, `layers` need be only 10% of
    /// this value and accuracy will still be good.
    ///
    /// Smaller values of `cluster` will give more accurate results, but be slower
    /// and use more memory. 10% of the mask radius is a good rule of thumb.
    ///
    /// See also: `vips.Image.conv`.
    extern fn vips_conva(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const conva = vips_conva;

    /// Optional arguments:
    ///
    /// * `layers`: `gint`, number of layers for approximation
    ///
    /// Approximate separable integer convolution. This is a low-level operation, see
    /// `vips.Image.convsep` for something more convenient.
    ///
    /// The image is convolved twice: once with `mask` and then again with `mask`
    /// rotated by 90 degrees.
    /// `mask` must be 1xn or nx1 elements.
    /// Elements of `mask` are converted to
    /// integers before convolution.
    ///
    /// Larger values for `layers` give more accurate
    /// results, but are slower. As `layers` approaches the mask radius, the
    /// accuracy will become close to exact convolution and the speed will drop to
    /// match. For many large masks, such as Gaussian, `layers` need be only 10% of
    /// this value and accuracy will still be good.
    ///
    /// The output image
    /// always has the same `vips.BandFormat` as the input image.
    ///
    /// See also: `vips.Image.convsep`.
    extern fn vips_convasep(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const convasep = vips_convasep;

    /// Convolution. This is a low-level operation, see `vips.Image.conv` for something
    /// more convenient.
    ///
    /// Perform a convolution of `in` with `mask`.
    /// Each output pixel is
    /// calculated as sigma[i]{pixel[i] * mask[i]} / scale + offset, where scale
    /// and offset are part of `mask`.
    ///
    /// The convolution is performed with floating-point arithmetic. The output image
    /// is always `VIPS_FORMAT_FLOAT` unless `in` is `VIPS_FORMAT_DOUBLE`, in which case
    /// `out` is also `VIPS_FORMAT_DOUBLE`.
    ///
    /// See also: `vips.Image.conv`.
    extern fn vips_convf(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const convf = vips_convf;

    /// Integer convolution. This is a low-level operation, see `vips.Image.conv` for
    /// something more convenient.
    ///
    /// `mask` is converted to an integer mask with `rint` of each element, rint of
    /// scale and rint of offset. Each output pixel is then calculated as
    ///
    /// ```
    /// sigma[i]{pixel[i] * mask[i]} / scale + offset
    /// ```
    ///
    /// The output image always has the same `vips.BandFormat` as the input image.
    ///
    /// For `VIPS_FORMAT_UCHAR` images, `vips.Image.convi` uses a fast vector path based on
    /// half-float arithmetic. This can produce slightly different results.
    /// Disable the vector path with `--vips-novector` or `VIPS_NOVECTOR` or
    /// `vips_vector_set_enabled`.
    ///
    /// See also: `vips.Image.conv`.
    extern fn vips_convi(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const convi = vips_convi;

    /// Optional arguments:
    ///
    /// * `precision`: calculation accuracy
    /// * `layers`: number of layers for approximation
    /// * `cluster`: cluster lines closer than this distance
    ///
    /// Perform a separable convolution of `in` with `mask`.
    /// See `vips.Image.conv` for a detailed description.
    ///
    /// The mask must be 1xn or nx1 elements.
    ///
    /// The image is convolved twice: once with `mask` and then again with `mask`
    /// rotated by 90 degrees. This is much faster for certain types of mask
    /// (gaussian blur, for example) than doing a full 2D convolution.
    ///
    /// See also: `vips.Image.conv`, `vips.gaussmat`.
    extern fn vips_convsep(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, ...) c_int;
    pub const convsep = vips_convsep;

    /// Optional arguments:
    ///
    /// * `width`: `gint`, set image width
    /// * `height`: `gint`, set image height
    /// * `bands`: `gint`, set image bands
    /// * `format`: `vips.BandFormat`, set image format
    /// * `coding`: `vips.Coding`, set image coding
    /// * `interpretation`: `vips.Interpretation`, set image interpretation
    /// * `xres`: `gdouble`, set image xres
    /// * `yres`: `gdouble`, set image yres
    /// * `xoffset`: `gint`, set image xoffset
    /// * `yoffset`: `gint`, set image yoffset
    ///
    /// Copy an image, optionally modifying the header. VIPS copies images by
    /// copying pointers, so this operation is instant, even for very large images.
    ///
    /// You can optionally change any or all header fields during the copy. You can
    /// make any change which does not change the size of a pel, so for example
    /// you can turn a 4-band uchar image into a 2-band ushort image, but you
    /// cannot change a 100 x 100 RGB image into a 300 x 100 mono image.
    ///
    /// See also: `vips.Image.byteswap`, `vips.Image.bandfold`, `vips.Image.bandunfold`.
    extern fn vips_copy(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const copy = vips_copy;

    /// A simple convenience function to copy an image to a file, then copy
    /// again to output. If the image is already a file, just copy straight
    /// through.
    ///
    /// The file is allocated with `vips.Image.newTempFile`.
    /// The file is automatically deleted when `out` is closed.
    ///
    /// See also: `vips.Image.copy`, `vips.Image.newTempFile`.
    extern fn vips_copy_file(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const copyFile = vips_copy_file;

    /// This function allocates memory, renders `image` into it, builds a new
    /// image around the memory area, and returns that.
    ///
    /// If the image is already a simple area of memory, it just refs `image` and
    /// returns it.
    ///
    /// Call this before using the draw operations to make sure you have a
    /// memory image that can be modified.
    ///
    /// `vips.Image.copy` adds a null "copy" node to a pipeline. Use that
    /// instead if you want to change metadata and not pixels.
    ///
    /// This operation is thread-safe, unlike `vips.Image.wioInput`.
    ///
    /// If you are sure that `image` is not shared with another thread (perhaps you
    /// have made it yourself), use `vips.Image.wioInput` instead.
    ///
    /// See also: `vips.Image.wioInput`.
    extern fn vips_image_copy_memory(p_image: *Image) *vips.Image;
    pub const copyMemory = vips_image_copy_memory;

    /// Perform `VIPS_OPERATION_MATH_COS` on an image. See `vips.Image.math`.
    extern fn vips_cos(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const cos = vips_cos;

    /// Perform `VIPS_OPERATION_MATH_COSH` on an image. See `vips.Image.math`.
    extern fn vips_cosh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const cosh = vips_cosh;

    /// Function which calculates the number of transitions
    /// between black and white for the horizontal or the vertical
    /// direction of an image.  black<128 , white>=128
    /// The function calculates the number of transitions for all
    /// Xsize or Ysize and returns the mean of the result
    /// Input should be one band, 8-bit.
    ///
    /// See also: `vips.Image.morph`, `vips.Image.conv`.
    extern fn vips_countlines(p_in: *Image, p_nolines: *f64, p_direction: vips.Direction, ...) c_int;
    pub const countlines = vips_countlines;

    /// A synonym for `vips.Image.extractArea`.
    ///
    /// See also: `vips_extract_bands`, `vips.Image.smartcrop`.
    extern fn vips_crop(p_in: *Image, p_out: **vips.Image, p_left: c_int, p_top: c_int, p_width: c_int, p_height: c_int, ...) c_int;
    pub const crop = vips_crop;

    /// Optional arguments:
    ///
    /// * `separator`: separator string
    ///
    /// Writes the pixels in `in` to the `filename` as CSV (comma-separated values).
    /// The image is written
    /// one line of text per scanline. Complex numbers are written as
    /// "(real,imaginary)" and will need extra parsing I guess. Only the first band
    /// is written.
    ///
    /// `separator` gives the string to use to separate numbers in the output.
    /// The default is "\\t" (tab).
    ///
    /// See also: `vips.Image.writeToFile`.
    extern fn vips_csvsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const csvsave = vips_csvsave;

    /// Optional arguments:
    ///
    /// * `separator`: separator string
    ///
    /// As `vips.Image.csvsave`, but save to a target.
    ///
    /// See also: `vips.Image.csvsave`.
    extern fn vips_csvsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const csvsaveTarget = vips_csvsave_target;

    /// A convenience function to unpack to a format that we can compute with.
    /// `out`.coding is always `VIPS_CODING_NONE`.
    ///
    /// This unpacks LABQ to plain LAB. Use `vips.Image.LabQ2LabS` for a bit more speed
    /// if you need it.
    ///
    /// See also: `vips.Image.encode`, `vips.Image.LabQ2Lab`, `vips.Image.rad2float`.
    extern fn vips_image_decode(p_in: *Image, p_out: **vips.Image) c_int;
    pub const decode = vips_image_decode;

    /// We often need to know what an image will decode to without actually
    /// decoding it, for example, in arg checking.
    ///
    /// See also: `vips.Image.decode`.
    extern fn vips_image_decode_predict(p_in: *Image, p_bands: *c_int, p_format: *vips.BandFormat) c_int;
    pub const decodePredict = vips_image_decode_predict;

    /// This operation finds the standard deviation of all pixels in `in`. It
    /// operates on all bands of the input image: use `vips.Image.stats` if you need
    /// to calculate an average for each band.
    ///
    /// Non-complex images only.
    ///
    /// See also: `vips.Image.avg`, `vips.Image.stats`..
    extern fn vips_deviate(p_in: *Image, p_out: *f64, ...) c_int;
    pub const deviate = vips_deviate;

    /// Optional arguments:
    ///
    /// * `fill`: fill the draw_circle
    ///
    /// Draws a circle on `image`. If `fill` is `TRUE` then the circle is filled,
    /// otherwise a 1-pixel-wide perimeter is drawn.
    ///
    /// `ink` is an array of double containing values to draw.
    ///
    /// See also: `vips.Image.drawCircle1`, `vips.Image.drawLine`.
    extern fn vips_draw_circle(p_image: *Image, p_ink: [*]f64, p_n: c_int, p_cx: c_int, p_cy: c_int, p_radius: c_int, ...) c_int;
    pub const drawCircle = vips_draw_circle;

    /// Optional arguments:
    ///
    /// * `fill`: fill the draw_circle
    ///
    /// As `vips.Image.drawCircle`, but just takes a single double for `ink`.
    ///
    /// See also: `vips.Image.drawCircle`.
    extern fn vips_draw_circle1(p_image: *Image, p_ink: f64, p_cx: c_int, p_cy: c_int, p_radius: c_int, ...) c_int;
    pub const drawCircle1 = vips_draw_circle1;

    /// Optional arguments:
    ///
    /// * `test`: test this image
    /// * `equal`: fill while equal to edge
    /// * `left`: output left edge of bounding box of modified area
    /// * `top`: output top edge of bounding box of modified area
    /// * `width`: output width of bounding box of modified area
    /// * `height`: output height of bounding box of modified area
    ///
    /// Flood-fill `image` with `ink`, starting at position `x`, `y`. The filled area is
    /// bounded by pixels that are equal to the ink colour, in other words, it
    /// searches for pixels enclosed by an edge of `ink`.
    ///
    /// If `equal` is set, it instead searches for pixels which are equal to the
    /// start point and fills them with `ink`.
    ///
    /// Normally it will test and set pixels in `image`. If `test` is set, it will
    /// test pixels in `test` and set pixels in `image`. This lets you search an
    /// image (`test`) for continuous areas of pixels without modifying it.
    ///
    /// `left`, `top`, `width`, `height` output the bounding box of the modified
    /// pixels.
    ///
    /// `ink` is an array of double containing values to draw.
    ///
    /// See also: `vips.Image.drawFlood1`.
    extern fn vips_draw_flood(p_image: *Image, p_ink: [*]f64, p_n: c_int, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawFlood = vips_draw_flood;

    /// Optional arguments:
    ///
    /// * `test`: test this image
    /// * `equal`: fill while equal to edge
    /// * `left`: output left edge of bounding box of modified area
    /// * `top`: output top edge of bounding box of modified area
    /// * `width`: output width of bounding box of modified area
    /// * `height`: output height of bounding box of modified area
    ///
    /// As `vips.Image.drawFlood`, but just takes a single double for `ink`.
    ///
    /// See also: `vips.Image.drawFlood`.
    extern fn vips_draw_flood1(p_image: *Image, p_ink: f64, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawFlood1 = vips_draw_flood1;

    /// Optional arguments:
    ///
    /// * `mode`: how to combine pixels
    ///
    /// Draw `sub` on top of `image` at position `x`, `y`. The two images must have the
    /// same Coding. If `sub` has 1 band, the bands will be duplicated to match the
    /// number of bands in `image`. `sub` will be converted to `image`'s format, see
    /// `vips.Image.cast`.
    ///
    /// Use `mode` to set how pixels are combined. If you use
    /// `VIPS_COMBINE_MODE_ADD`, both images muct be uncoded.
    ///
    /// See also: `vips.Image.drawMask`, `vips.Image.insert`.
    extern fn vips_draw_image(p_image: *Image, p_sub: *vips.Image, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawImage = vips_draw_image;

    /// Draws a 1-pixel-wide line on an image.
    ///
    /// `ink` is an array of double containing values to draw.
    ///
    /// See also: `vips.Image.drawLine1`, `vips.Image.drawCircle`, `vips.Image.drawMask`.
    extern fn vips_draw_line(p_image: *Image, p_ink: [*]f64, p_n: c_int, p_x1: c_int, p_y1: c_int, p_x2: c_int, p_y2: c_int, ...) c_int;
    pub const drawLine = vips_draw_line;

    /// As `vips.Image.drawLine`, but just take a single double for `ink`.
    ///
    /// See also: `vips.Image.drawLine`.
    extern fn vips_draw_line1(p_image: *Image, p_ink: f64, p_x1: c_int, p_y1: c_int, p_x2: c_int, p_y2: c_int, ...) c_int;
    pub const drawLine1 = vips_draw_line1;

    /// Draw `mask` on the image. `mask` is a monochrome 8-bit image with 0/255
    /// for transparent or `ink` coloured points. Intermediate values blend the ink
    /// with the pixel. Use with `vips.text` to draw text on an image. Use in a
    /// `vips.Image.drawLine` subclass to draw an object along a line.
    ///
    /// `ink` is an array of double containing values to draw.
    ///
    /// See also: `vips.text`, `vips.Image.drawLine`.
    extern fn vips_draw_mask(p_image: *Image, p_ink: [*]f64, p_n: c_int, p_mask: *vips.Image, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawMask = vips_draw_mask;

    /// As `vips.Image.drawMask`, but just takes a single double for `ink`.
    ///
    /// See also: `vips.Image.drawMask`.
    extern fn vips_draw_mask1(p_image: *Image, p_ink: f64, p_mask: *vips.Image, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawMask1 = vips_draw_mask1;

    /// As `vips.Image.drawRect`, but draw a single pixel at `x`, `y`.
    ///
    /// See also: `vips.Image.drawRect`.
    extern fn vips_draw_point(p_image: *Image, p_ink: [*]f64, p_n: c_int, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawPoint = vips_draw_point;

    /// As `vips.Image.drawPoint`, but just take a single double for `ink`.
    ///
    /// See also: `vips.Image.drawPoint`.
    extern fn vips_draw_point1(p_image: *Image, p_ink: f64, p_x: c_int, p_y: c_int, ...) c_int;
    pub const drawPoint1 = vips_draw_point1;

    /// Optional arguments:
    ///
    /// * `fill`: fill the rect
    ///
    /// Paint pixels within `left`, `top`, `width`, `height` in `image` with `ink`. If
    /// `fill` is zero, just paint a 1-pixel-wide outline.
    ///
    /// See also: `vips.Image.drawCircle`.
    extern fn vips_draw_rect(p_image: *Image, p_ink: [*]f64, p_n: c_int, p_left: c_int, p_top: c_int, p_width: c_int, p_height: c_int, ...) c_int;
    pub const drawRect = vips_draw_rect;

    /// Optional arguments:
    ///
    /// * `fill`: fill the rect
    ///
    /// As `vips.Image.drawRect`, but just take a single double for `ink`.
    ///
    /// See also: `vips.Image.drawRect`.
    extern fn vips_draw_rect1(p_image: *Image, p_ink: f64, p_left: c_int, p_top: c_int, p_width: c_int, p_height: c_int, ...) c_int;
    pub const drawRect1 = vips_draw_rect1;

    /// Smudge a section of `image`. Each pixel in the area `left`, `top`, `width`,
    /// `height` is replaced by the average of the surrounding 3x3 pixels.
    ///
    /// See also: `vips.Image.drawLine`.
    extern fn vips_draw_smudge(p_image: *Image, p_left: c_int, p_top: c_int, p_width: c_int, p_height: c_int, ...) c_int;
    pub const drawSmudge = vips_draw_smudge;

    /// Optional arguments:
    ///
    /// * `basename`: `gchar` base part of name
    /// * `layout`: `vips.ForeignDzLayout` directory layout convention
    /// * `suffix`: `gchar` suffix for tiles
    /// * `overlap`: `gint` set tile overlap
    /// * `tile_size`: `gint` set tile size
    /// * `background`: `vips.ArrayDouble` background colour
    /// * `depth`: `vips.ForeignDzDepth` how deep to make the pyramid
    /// * `centre`: `gboolean` centre the tiles
    /// * `angle`: `vips.Angle` rotate the image by this much
    /// * `container`: `vips.ForeignDzContainer` set container type
    /// * `compression`: `gint` zip deflate compression level
    /// * `region_shrink`: `vips.RegionShrink` how to shrink each 2x2 region
    /// * `skip_blanks`: `gint` skip tiles which are nearly equal to the background
    /// * `id`: `gchar` id for IIIF properties
    /// * `Q`: `gint`, quality factor
    ///
    /// Save an image as a set of tiles at various resolutions. By default dzsave
    /// uses DeepZoom layout -- use `layout` to pick other conventions.
    ///
    /// `vips.Image.dzsave` creates a directory called `name` to hold the tiles. If `name`
    /// ends `.zip`, `vips.Image.dzsave` will create a zip file called `name` to hold the
    /// tiles. You can use `container` to force zip file output.
    ///
    /// Use `basename` to set the name of the image we are creating. The
    /// default value is set from `name`.
    ///
    /// By default, tiles are written as JPEGs. Use `Q` set set the JPEG quality
    /// factor.
    ///
    /// You can set `suffix` to something like `".png[bitdepth=4]"` to write tiles
    /// in another format.
    ///
    /// In Google layout mode, edge tiles are expanded to `tile_size` by `tile_size`
    /// pixels. Normally they are filled with white, but you can set another colour
    /// with `background`. Images are usually placed at the top-left of the tile,
    /// but you can have them centred by turning on `centre`.
    ///
    /// You can set the size and overlap of tiles with `tile_size` and `overlap`.
    /// They default to the correct settings for the selected `layout`. The deepzoom
    /// defaults produce 256x256 jpeg files for centre tiles, the most efficient
    /// size.
    ///
    /// Use `depth` to control how low the pyramid goes. This defaults to the
    /// correct setting for the `layout` you select.
    ///
    /// You can rotate the image during write with the `angle` argument. However,
    /// this will only work for images which support random access, like openslide,
    /// and not for things like JPEG. You'll need to rotate those images
    /// yourself with `vips.Image.rot`. Note that the `autorotate` option to the loader
    /// may do what you need.
    ///
    /// By default, all tiles are stripped since usually you do not want a copy of
    /// all metadata in every tile. Set `keep` if you want to keep metadata.
    ///
    /// If `container` is set to `zip`, you can set a compression level from -1
    /// (use zlib default), 0 (store, compression disabled) to 9 (max compression).
    /// If no value is given, the default is to store files without compression.
    ///
    /// You can use `region_shrink` to control the method for shrinking each 2x2
    /// region. This defaults to using the average of the 4 input pixels but you can
    /// also use the median in cases where you want to preserve the range of values.
    ///
    /// If you set `skip_blanks` to a value greater than or equal to zero, tiles
    /// which are all within that many pixel values to the background are skipped.
    /// This can save a lot of space for some image types. This option defaults to
    /// 5 in Google layout mode, -1 otherwise.
    ///
    /// In IIIF layout, you can set the base of the `id` property in `info.json`
    /// with `id`. The default is `https://example.com/iiif`.
    ///
    /// Use `layout` `VIPS_FOREIGN_DZ_LAYOUT_IIIF3` for IIIF v3 layout.
    ///
    /// See also: `vips.Image.tiffsave`.
    extern fn vips_dzsave(p_in: *Image, p_name: [*:0]const u8, ...) c_int;
    pub const dzsave = vips_dzsave;

    /// Optional arguments:
    ///
    /// * `basename`: `gchar` base part of name
    /// * `layout`: `vips.ForeignDzLayout` directory layout convention
    /// * `suffix`: `gchar` suffix for tiles
    /// * `overlap`: `gint` set tile overlap
    /// * `tile_size`: `gint` set tile size
    /// * `background`: `vips.ArrayDouble` background colour
    /// * `depth`: `vips.ForeignDzDepth` how deep to make the pyramid
    /// * `centre`: `gboolean` centre the tiles
    /// * `angle`: `vips.Angle` rotate the image by this much
    /// * `container`: `vips.ForeignDzContainer` set container type
    /// * `compression`: `gint` zip deflate compression level
    /// * `region_shrink`: `vips.RegionShrink` how to shrink each 2x2 region.
    /// * `skip_blanks`: `gint` skip tiles which are nearly equal to the background
    /// * `id`: `gchar` id for IIIF properties
    /// * `Q`: `gint`, quality factor
    ///
    /// As `vips.Image.dzsave`, but save to a memory buffer.
    ///
    /// Output is always in a zip container. Use `basename` to set the name of the
    /// directory that the zip will create when unzipped.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.dzsave`, `vips.Image.writeToFile`.
    extern fn vips_dzsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const dzsaveBuffer = vips_dzsave_buffer;

    /// Optional arguments:
    ///
    /// * `basename`: `gchar` base part of name
    /// * `layout`: `vips.ForeignDzLayout` directory layout convention
    /// * `suffix`: `gchar` suffix for tiles
    /// * `overlap`: `gint` set tile overlap
    /// * `tile_size`: `gint` set tile size
    /// * `background`: `vips.ArrayDouble` background colour
    /// * `depth`: `vips.ForeignDzDepth` how deep to make the pyramid
    /// * `centre`: `gboolean` centre the tiles
    /// * `angle`: `vips.Angle` rotate the image by this much
    /// * `container`: `vips.ForeignDzContainer` set container type
    /// * `compression`: `gint` zip deflate compression level
    /// * `region_shrink`: `vips.RegionShrink` how to shrink each 2x2 region.
    /// * `skip_blanks`: `gint` skip tiles which are nearly equal to the background
    /// * `id`: `gchar` id for IIIF properties
    /// * `Q`: `gint`, quality factor
    ///
    /// As `vips.Image.dzsave`, but save to a target.
    ///
    /// See also: `vips.Image.dzsave`, `vips.Image.writeToTarget`.
    extern fn vips_dzsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const dzsaveTarget = vips_dzsave_target;

    /// Optional arguments:
    ///
    /// * `extend`: `vips.Extend` to generate the edge pixels (default: black)
    /// * `background`: `vips.ArrayDouble` colour for edge pixels
    ///
    /// The opposite of `vips.Image.extractArea`: embed `in` within an image of size
    /// `width` by `height` at position `x`, `y`.
    ///
    /// `extend`
    /// controls what appears in the new pels, see `vips.Extend`.
    ///
    /// See also: `vips.Image.extractArea`, `vips.Image.insert`.
    extern fn vips_embed(p_in: *Image, p_out: **vips.Image, p_x: c_int, p_y: c_int, p_width: c_int, p_height: c_int, ...) c_int;
    pub const embed = vips_embed;

    /// A convenience function to pack to a coding. The inverse of
    /// `vips.Image.decode`.
    ///
    /// See also: `vips.Image.decode`.
    extern fn vips_image_encode(p_in: *Image, p_out: **vips.Image, p_coding: vips.Coding) c_int;
    pub const encode = vips_image_encode;

    /// Perform `VIPS_OPERATION_BOOLEAN_EOR` on an image and an array of constants.
    /// See `vips.Image.booleanConst`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst1`.
    extern fn vips_eorimage_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const eorimageConst = vips_eorimage_const;

    /// Perform `VIPS_OPERATION_BOOLEAN_EOR` on an image and a constant.
    /// See `vips.Image.booleanConst1`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst`.
    extern fn vips_eorimage_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const eorimageConst1 = vips_eorimage_const1;

    /// Perform `VIPS_OPERATION_RELATIONAL_EQUAL` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_equal_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const equalConst = vips_equal_const;

    /// Perform `VIPS_OPERATION_RELATIONAL_EQUAL` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_equal_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const equalConst1 = vips_equal_const1;

    /// Perform `VIPS_OPERATION_MATH_EXP` on an image. See `vips.Image.math`.
    extern fn vips_exp(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const exp = vips_exp;

    /// Perform `VIPS_OPERATION_MATH_EXP10` on an image. See `vips.Image.math`.
    extern fn vips_exp10(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const exp10 = vips_exp10;

    /// Extract an area from an image. The area must fit within `in`.
    ///
    /// See also: `vips_extract_bands`, `vips.Image.smartcrop`.
    extern fn vips_extract_area(p_in: *Image, p_out: **vips.Image, p_left: c_int, p_top: c_int, p_width: c_int, p_height: c_int, ...) c_int;
    pub const extractArea = vips_extract_area;

    /// Optional arguments:
    ///
    /// * `n`: number of bands to extract
    ///
    /// Extract a band or bands from an image. Extracting out of range is an error.
    ///
    /// See also: `vips.Image.extractArea`.
    extern fn vips_extract_band(p_in: *Image, p_out: **vips.Image, p_band: c_int, ...) c_int;
    pub const extractBand = vips_extract_band;

    /// Force `in` to 1 band, 8-bit, then transform to
    /// a 3-band 8-bit image with a false colour
    /// map. The map is supposed to make small differences in brightness more
    /// obvious.
    ///
    /// See also: `vips.Image.maplut`.
    extern fn vips_falsecolour(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const falsecolour = vips_falsecolour;

    /// Calculate a fast correlation surface.
    ///
    /// `ref` is placed at every position in `in` and the sum of squares of
    /// differences calculated.
    ///
    /// The output
    /// image is the same size as the input. Extra input edge pixels are made by
    /// copying the existing edges outwards.
    ///
    /// If the number of bands differs, one of the images
    /// must have one band. In this case, an n-band image is formed from the
    /// one-band image by joining n copies of the one-band image together, and then
    /// the two n-band images are operated upon.
    ///
    /// The output type is uint if both inputs are integer, float if both are float
    /// or complex, and double if either is double or double complex.
    /// In other words, the output type is just large enough to hold the whole
    /// range of possible values.
    ///
    /// See also: `vips.Image.spcor`.
    extern fn vips_fastcor(p_in: *Image, p_ref: *vips.Image, p_out: **vips.Image, ...) c_int;
    pub const fastcor = vips_fastcor;

    /// Optional arguments:
    ///
    /// * `distance`: output image of distance to nearest non-zero pixel
    ///
    /// Fill outwards from every non-zero pixel in `in`, setting pixels in `distance`
    /// and `value`.
    ///
    /// At the position of zero pixels in `in`, `distance` contains the distance to
    /// the nearest non-zero pixel in `in`, and `value` contains the value of that
    /// pixel.
    ///
    /// `distance` is a one-band float image. `value` has the same number of bands and
    /// format as `in`.
    ///
    /// See also: `vips.Image.histFindIndexed`.
    extern fn vips_fill_nearest(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const fillNearest = vips_fill_nearest;

    /// Optional arguments:
    ///
    /// * `threshold`: `gdouble`, background / object threshold
    /// * `background`: `vips.ArrayDouble`, background colour
    /// * `line_art`: `gboolean`, enable line art mode
    ///
    /// Search `in` for the bounding box of the non-background area.
    ///
    /// Any alpha is flattened out, then the image is median-filtered (unless
    /// `line_art` is set, see below). The absolute difference from `background` is
    /// computed and binarized according to `threshold`. Row and column sums of
    /// the absolute difference are calculated from this binary image and searched
    /// for the first row or column in each direction to obtain the bounding box.
    ///
    /// If the image is entirely background, `vips.Image.findTrim` returns `width` == 0
    /// and `height` == 0.
    ///
    /// `background` defaults to 255, or 65535 for 16-bit images. Set another value,
    /// or use `vips.Image.getpoint` to pick a value from an edge. You'll need to flatten
    /// before `vips.Image.getpoint` to get a correct background value.
    ///
    /// `threshold` defaults to 10.
    ///
    /// The detector is designed for photographic or compressed images where there
    /// is a degree of noise that needs filtering. If your images are synthetic
    /// (eg. rendered from vector art, perhaps), set `line_art` to disable this
    /// filtering.
    ///
    /// The image needs to be at least 3x3 pixels in size.
    ///
    /// See also: `vips.Image.getpoint`, `vips.Image.extractArea`, `vips.Image.smartcrop`.
    extern fn vips_find_trim(p_in: *Image, p_left: *c_int, p_top: *c_int, p_width: *c_int, p_height: *c_int, ...) c_int;
    pub const findTrim = vips_find_trim;

    /// Write a VIPS image to a file in FITS format.
    ///
    /// See also: `vips.Image.writeToFile`.
    extern fn vips_fitssave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const fitssave = vips_fitssave;

    /// Optional arguments:
    ///
    /// * `background`: `vips.ArrayDouble` colour for new pixels
    /// * `max_alpha`: `gdouble`, maximum value for alpha
    ///
    /// Take the last band of `in` as an alpha and use it to blend the
    /// remaining channels with `background`.
    ///
    /// The alpha channel is 0 - `max_alpha`, where `max_alpha` means 100% image
    /// and 0 means 100% background. `background` defaults to zero (black).
    ///
    /// `max_alpha` has the default value 255, or 65535 for images tagged as
    /// `VIPS_INTERPRETATION_RGB16` or
    /// `VIPS_INTERPRETATION_GREY16`.
    ///
    /// Useful for flattening PNG images to RGB.
    ///
    /// Non-complex images only.
    ///
    /// See also: `vips.Image.premultiply`, `vips.pngload`.
    extern fn vips_flatten(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const flatten = vips_flatten;

    /// Flips an image left-right or up-down.
    ///
    /// See also: `vips.Image.rot`.
    extern fn vips_flip(p_in: *Image, p_out: **vips.Image, p_direction: vips.Direction, ...) c_int;
    pub const flip = vips_flip;

    /// Convert a three-band float image to Radiance 32-bit packed format.
    ///
    /// See also: `vips.Image.rad2float`, `VIPS_CODING_RAD`, `vips.Image.LabQ2Lab`.
    extern fn vips_float2rad(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const float2rad = vips_float2rad;

    /// Round to an integral value with `VIPS_OPERATION_ROUND_FLOOR`. See
    /// `vips.Image.round`.
    extern fn vips_floor(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const floor = vips_floor;

    /// Loaders can call this on the image they are making if they see a read error
    /// from the load library. It signals "invalidate" on the load operation and
    /// will cause it to be dropped from cache.
    ///
    /// If we know a file will cause a read error, we don't want to cache the
    /// failing operation, we want to make sure the image will really be opened
    /// again if our caller tries again. For example, a broken file might be
    /// replaced by a working one.
    extern fn vips_foreign_load_invalidate(p_image: *Image) void;
    pub const foreignLoadInvalidate = vips_foreign_load_invalidate;

    /// Free the externally allocated buffer found in the input image. This function
    /// is intended to be used with g_signal_connect.
    extern fn vips_image_free_buffer(p_image: *Image, p_buffer: ?*anyopaque) void;
    pub const freeBuffer = vips_image_free_buffer;

    /// Multiply `in` by `mask` in Fourier space.
    ///
    /// `in` is transformed to Fourier space, multiplied with `mask`, then
    /// transformed back to real space. If `in` is already a complex image, just
    /// multiply then inverse transform.
    ///
    /// See also: `vips.Image.invfft`, `vips.maskIdeal`.
    extern fn vips_freqmult(p_in: *Image, p_mask: *vips.Image, p_out: **vips.Image, ...) c_int;
    pub const freqmult = vips_freqmult;

    /// Transform an image to Fourier space.
    ///
    /// VIPS uses the fftw Fourier Transform library. If this library was not
    /// available when VIPS was configured, these functions will fail.
    ///
    /// See also: `vips.Image.invfft`.
    extern fn vips_fwfft(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const fwfft = vips_fwfft;

    /// Optional arguments:
    ///
    /// * `exponent`: gamma, default 1.0 / 2.4
    ///
    /// Calculate `in` ** (1 / `exponent`), normalising to the maximum range of the
    /// input type. For float types use 1.0 as the maximum.
    ///
    /// See also: `vips.identity`, `vips.Image.powConst1`, `vips.Image.maplut`
    extern fn vips_gamma(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const gamma = vips_gamma;

    /// Optional arguments:
    ///
    /// * `precision`: `vips.Precision`, precision for blur, default int
    /// * `min_ampl`: minimum amplitude, default 0.2
    ///
    /// This operator runs `vips.gaussmat` and `vips.Image.convsep` for you on an image.
    /// Set `min_ampl` smaller to generate a larger, more accurate mask. Set `sigma`
    /// larger to make the blur more blurry.
    ///
    /// See also: `vips.gaussmat`, `vips.Image.convsep`.
    extern fn vips_gaussblur(p_in: *Image, p_out: **vips.Image, p_sigma: f64, ...) c_int;
    pub const gaussblur = vips_gaussblur;

    /// Fill `value_copy` with a copy of the header field. `value_copy` must be zeroed
    /// but uninitialised.
    ///
    /// This will return -1 and add a message to the error buffer if the field
    /// does not exist. Use `vips.Image.getTypeof` to test for the
    /// existence of a field first if you are not certain it will be there.
    ///
    /// For example, to read a double from an image (though of course you would use
    /// `vips.Image.getDouble` in practice):
    ///
    /// ```
    /// GValue value = G_VALUE_INIT;
    /// double d;
    ///
    /// if (vips_image_get(image, name, &value))
    ///     return -1;
    ///
    /// if (G_VALUE_TYPE(&value) != G_TYPE_DOUBLE) {
    ///     vips_error("mydomain",
    ///         _("field \"`s`\" is of type `s`, not double"),
    ///         name,
    ///         g_type_name(G_VALUE_TYPE(&value)));
    ///     g_value_unset(&value);
    ///     return -1;
    /// }
    ///
    /// d = g_value_get_double(&value);
    /// g_value_unset(&value);
    /// ```
    ///
    /// See also: `vips.Image.getTypeof`, `vips.Image.getDouble`.
    extern fn vips_image_get(p_image: *const Image, p_name: [*:0]const u8, p_value_copy: *gobject.Value) c_int;
    pub const get = vips_image_get;

    /// Gets `data` from `image` under the name `name`. A convenience
    /// function over `vips.Image.get`. Use `vips.Image.getTypeof` to test for
    /// the existence of a piece of metadata.
    ///
    /// See also: `vips.Image.setArea`, `vips.Image.get`,
    /// `vips.Image.getTypeof`
    extern fn vips_image_get_area(p_image: *const Image, p_name: [*:0]const u8, p_data: ?*anyopaque) c_int;
    pub const getArea = vips_image_get_area;

    /// Gets `out` from `im` under the name `name`.
    /// The field must be of type
    /// `VIPS_TYPE_ARRAY_INT`.
    ///
    /// Do not free `out`. `out` is valid as long as `image` is valid.
    ///
    /// Use `vips.Image.getTypeof` to test for the
    /// existence of a piece of metadata.
    ///
    /// See also: `vips.Image.get`, `vips.Image.setImage`
    extern fn vips_image_get_array_double(p_image: *Image, p_name: [*:0]const u8, p_out: *[*]f64, p_n: ?*c_int) c_int;
    pub const getArrayDouble = vips_image_get_array_double;

    /// Gets `out` from `im` under the name `name`.
    /// The field must be of type
    /// `VIPS_TYPE_ARRAY_INT`.
    ///
    /// Do not free `out`. `out` is valid as long as `image` is valid.
    ///
    /// Use `vips.Image.getTypeof` to test for the
    /// existence of a piece of metadata.
    ///
    /// See also: `vips.Image.get`, `vips.Image.setImage`
    extern fn vips_image_get_array_int(p_image: *Image, p_name: [*:0]const u8, p_out: *[*]c_int, p_n: ?*c_int) c_int;
    pub const getArrayInt = vips_image_get_array_int;

    /// Returns `name` from `image` in `out`.
    /// This function will read any field, returning it as a printable string.
    /// You need to free the string with `glib.free` when you are done with it.
    ///
    /// This will base64-encode BLOBs, for example. Use `vips_buf_appendgv` to
    /// make a string that's for humans.
    ///
    /// See also: `vips.Image.get`, `vips.Image.getTypeof`, `vips_buf_appendgv`.
    extern fn vips_image_get_as_string(p_image: *const Image, p_name: [*:0]const u8, p_out: *[*:0]u8) c_int;
    pub const getAsString = vips_image_get_as_string;

    extern fn vips_image_get_bands(p_image: *const Image) c_int;
    pub const getBands = vips_image_get_bands;

    /// Gets `data` from `image` under the name `name`, optionally returns its
    /// length in `length`. Use `vips.Image.getTypeof` to test for the existence
    /// of a piece of metadata.
    ///
    /// See also: `vips.Image.get`, `vips.Image.getTypeof`, `vips.Blob.get`,
    extern fn vips_image_get_blob(p_image: *const Image, p_name: [*:0]const u8, p_data: *[*]u8, p_length: *usize) c_int;
    pub const getBlob = vips_image_get_blob;

    extern fn vips_image_get_coding(p_image: *const Image) vips.Coding;
    pub const getCoding = vips_image_get_coding;

    /// Fetch and sanity-check `VIPS_CONCURRENCY`. Default to 1 if not present or
    /// crazy.
    extern fn vips_image_get_concurrency(p_image: *Image, p_default_concurrency: c_int) c_int;
    pub const getConcurrency = vips_image_get_concurrency;

    /// Return a pointer to the image's pixel data, if possible. This can involve
    /// allocating large amounts of memory and performing a long computation. Image
    /// pixels are laid out in band-packed rows.
    ///
    /// Since this function modifies `image`, it is not threadsafe. Only call it on
    /// images which you are sure have not been shared with another thread.
    ///
    /// See also: `vips.Image.wioInput`, `vips.Image.copyMemory`.
    extern fn vips_image_get_data(p_image: *Image) ?*anyopaque;
    pub const getData = vips_image_get_data;

    /// Gets `out` from `im` under the name `name`.
    /// The value will be transformed into
    /// a double, if possible.
    ///
    /// See also: `vips.Image.get`, `vips.Image.getTypeof`
    extern fn vips_image_get_double(p_image: *const Image, p_name: [*:0]const u8, p_out: *f64) c_int;
    pub const getDouble = vips_image_get_double;

    /// Get a `NULL`-terminated array listing all the metadata field names on `image`.
    /// Free the return result with `glib.strfreev`.
    ///
    /// This is handy for language bindings. From C, it's usually more convenient to
    /// use `vips.Image.map`.
    extern fn vips_image_get_fields(p_image: *Image) [*][*:0]u8;
    pub const getFields = vips_image_get_fields;

    extern fn vips_image_get_filename(p_image: *const Image) [*:0]const u8;
    pub const getFilename = vips_image_get_filename;

    extern fn vips_image_get_format(p_image: *const Image) vips.BandFormat;
    pub const getFormat = vips_image_get_format;

    extern fn vips_image_get_height(p_image: *const Image) c_int;
    pub const getHeight = vips_image_get_height;

    /// This function reads the image history as a C string. The string is owned
    /// by VIPS and must not be freed.
    ///
    /// VIPS tracks the history of each image, that is, the sequence of operations
    /// that generated that image. Applications built on VIPS need to call
    /// `vips.Image.historyPrintf` for each action they perform, setting the
    /// command-line equivalent for the action.
    ///
    /// See also: `vips.Image.historyPrintf`.
    extern fn vips_image_get_history(p_image: *Image) [*:0]const u8;
    pub const getHistory = vips_image_get_history;

    /// Gets `out` from `im` under the name `name`.
    /// The field must be of type
    /// `VIPS_TYPE_IMAGE`. You must unref `out` with `gobject.Object.unref`.
    ///
    /// Use `vips.Image.getTypeof` to test for the
    /// existence of a piece of metadata.
    ///
    /// See also: `vips.Image.get`, `vips.Image.setImage`
    extern fn vips_image_get_image(p_image: *const Image, p_name: [*:0]const u8, p_out: **vips.Image) c_int;
    pub const getImage = vips_image_get_image;

    /// Gets `out` from `im` under the name `name`.
    /// The value will be transformed into
    /// an int, if possible.
    ///
    /// See also: `vips.Image.get`, `vips.Image.getTypeof`
    extern fn vips_image_get_int(p_image: *const Image, p_name: [*:0]const u8, p_out: *c_int) c_int;
    pub const getInt = vips_image_get_int;

    /// Return the `vips.Interpretation` set in the image header.
    /// Use `vips.Image.guessInterpretation` if you want a sanity-checked value.
    extern fn vips_image_get_interpretation(p_image: *const Image) vips.Interpretation;
    pub const getInterpretation = vips_image_get_interpretation;

    /// Image modes are things like `"t"`, meaning a memory buffer, and `"p"`
    /// meaning a delayed computation.
    extern fn vips_image_get_mode(p_image: *const Image) [*:0]const u8;
    pub const getMode = vips_image_get_mode;

    /// Fetch and sanity-check `VIPS_META_N_PAGES`. Default to 1 if not present or
    /// crazy.
    ///
    /// This is the number of pages in the image file, not the number of pages that
    /// have been loaded into `image`.
    extern fn vips_image_get_n_pages(p_image: *Image) c_int;
    pub const getNPages = vips_image_get_n_pages;

    /// Fetch and sanity-check `VIPS_META_N_SUBIFDS`. Default to 0 if not present or
    /// crazy.
    extern fn vips_image_get_n_subifds(p_image: *Image) c_int;
    pub const getNSubifds = vips_image_get_n_subifds;

    /// Matrix images can have an optional `offset` field for use by integer
    /// convolution.
    extern fn vips_image_get_offset(p_image: *const Image) f64;
    pub const getOffset = vips_image_get_offset;

    /// Fetch and sanity-check `VIPS_META_ORIENTATION`. Default to 1 (no rotate,
    /// no flip) if not present or crazy.
    extern fn vips_image_get_orientation(p_image: *Image) c_int;
    pub const getOrientation = vips_image_get_orientation;

    /// Return `TRUE` if applying the orientation would swap width and height.
    extern fn vips_image_get_orientation_swap(p_image: *Image) c_int;
    pub const getOrientationSwap = vips_image_get_orientation_swap;

    /// Multi-page images can have a page height. Fetch it, and sanity check it. If
    /// page-height is not set, it defaults to the image height.
    extern fn vips_image_get_page_height(p_image: *Image) c_int;
    pub const getPageHeight = vips_image_get_page_height;

    /// Matrix images can have an optional `scale` field for use by integer
    /// convolution.
    extern fn vips_image_get_scale(p_image: *const Image) f64;
    pub const getScale = vips_image_get_scale;

    /// Gets `out` from `im` under the name `name`.
    /// The field must be of type
    /// G_TYPE_STRING, VIPS_TYPE_REF_STRING.
    ///
    /// Do not free `out`.
    ///
    /// Use `vips.Image.getAsString` to fetch any field as a string.
    ///
    /// See also: `vips.Image.get`, `vips.Image.getTypeof`
    extern fn vips_image_get_string(p_image: *const Image, p_name: [*:0]const u8, p_out: *[*:0]const u8) c_int;
    pub const getString = vips_image_get_string;

    /// Read the `gobject.Type` for a header field. Returns zero if there is no
    /// field of that name.
    ///
    /// See also: `vips.Image.get`.
    extern fn vips_image_get_typeof(p_image: *const Image, p_name: [*:0]const u8) usize;
    pub const getTypeof = vips_image_get_typeof;

    extern fn vips_image_get_width(p_image: *const Image) c_int;
    pub const getWidth = vips_image_get_width;

    extern fn vips_image_get_xoffset(p_image: *const Image) c_int;
    pub const getXoffset = vips_image_get_xoffset;

    extern fn vips_image_get_xres(p_image: *const Image) f64;
    pub const getXres = vips_image_get_xres;

    extern fn vips_image_get_yoffset(p_image: *const Image) c_int;
    pub const getYoffset = vips_image_get_yoffset;

    extern fn vips_image_get_yres(p_image: *const Image) f64;
    pub const getYres = vips_image_get_yres;

    /// Reads a single pixel on an image.
    ///
    /// The pixel values are returned in `vector`, the length of the
    /// array in `n`. You must free the array with `glib.free` when you are done with
    /// it.
    ///
    /// The result array has an element for each band. If `unpack_complex` is set,
    /// pixels in complex images are returned as double-length arrays.
    ///
    /// See also: `vips.Image.drawPoint`.
    extern fn vips_getpoint(p_in: *Image, p_vector: *[*]f64, p_n: *c_int, p_x: c_int, p_y: c_int, ...) c_int;
    pub const getpoint = vips_getpoint;

    /// Optional arguments:
    ///
    /// * `dither`: `gdouble`, quantisation dithering level
    /// * `effort`: `gint`, quantisation CPU effort
    /// * `bitdepth`: `gint`, number of bits per pixel
    /// * `interframe_maxerror`: `gdouble`, maximum inter-frame error for transparency
    /// * `reuse`: `gboolean`, reuse palette from input
    /// * `interlace`: `gboolean`, write an interlaced (progressive) GIF
    /// * `interpalette_maxerror`: `gdouble`, maximum inter-palette error for palette
    ///   reusage
    ///
    /// Write to a file in GIF format.
    ///
    /// Use `dither` to set the degree of Floyd-Steinberg dithering
    /// and `effort` to control the CPU effort (1 is the fastest,
    /// 10 is the slowest, 7 is the default).
    ///
    /// Use `bitdepth` (from 1 to 8, default 8) to control the number
    /// of colours in the palette. The first entry in the palette is
    /// always reserved for transparency. For example, a bitdepth of
    /// 4 will allow the output to contain up to 15 colours.
    ///
    /// Use `interframe_maxerror` to set the threshold below which pixels are
    /// considered equal.
    /// Pixels which don't change from frame to frame can be made transparent,
    /// improving the compression rate. Default 0.
    ///
    /// Use `interpalette_maxerror` to set the threshold below which the
    /// previously generated palette will be reused.
    ///
    /// If `reuse` is TRUE, the GIF will be saved with a single global
    /// palette taken from the metadata in `in`, and no new palette optimisation
    /// will be done.
    ///
    /// If `interlace` is TRUE, the GIF file will be interlaced (progressive GIF).
    /// These files may be better for display over a slow network
    /// connection, but need more memory to encode.
    ///
    /// See also: `vips.Image.newFromFile`.
    extern fn vips_gifsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const gifsave = vips_gifsave;

    /// Optional arguments:
    ///
    /// * `dither`: `gdouble`, quantisation dithering level
    /// * `effort`: `gint`, quantisation CPU effort
    /// * `bitdepth`: `gint`, number of bits per pixel
    /// * `interframe_maxerror`: `gdouble`, maximum inter-frame error for transparency
    /// * `reuse`: `gboolean`, reuse palette from input
    /// * `interlace`: `gboolean`, write an interlaced (progressive) GIF
    /// * `interpalette_maxerror`: `gdouble`, maximum inter-palette error for palette
    ///   reusage
    ///
    /// As `vips.Image.gifsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.gifsave`, `vips.Image.writeToFile`.
    extern fn vips_gifsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const gifsaveBuffer = vips_gifsave_buffer;

    /// Optional arguments:
    ///
    /// * `dither`: `gdouble`, quantisation dithering level
    /// * `effort`: `gint`, quantisation CPU effort
    /// * `bitdepth`: `gint`, number of bits per pixel
    /// * `interframe_maxerror`: `gdouble`, maximum inter-frame error for transparency
    /// * `reuse`: `gboolean`, reuse palette from input
    /// * `interlace`: `gboolean`, write an interlaced (progressive) GIF
    /// * `interpalette_maxerror`: `gdouble`, maximum inter-palette error for palette
    ///   reusage
    ///
    /// As `vips.Image.gifsave`, but save to a target.
    ///
    /// See also: `vips.Image.gifsave`, `vips.Image.writeToTarget`.
    extern fn vips_gifsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const gifsaveTarget = vips_gifsave_target;

    /// Optional arguments:
    ///
    /// * `gamma`: gamma of source images
    /// * `int_output`: `TRUE` for integer image output
    ///
    /// `vips.Image.globalbalance` can be used to remove contrast differences in
    /// an assembled mosaic.
    ///
    /// It reads the History field attached to `in` and builds a list of the source
    /// images that were used to make the mosaic and the position that each ended
    /// up at in the final image.
    ///
    /// It opens each of the source images in turn and extracts all parts which
    /// overlap with any of the other images. It finds the average values in the
    /// overlap areas and uses least-mean-square to find a set of correction
    /// factors which will minimise overlap differences. It uses `gamma` to
    /// gamma-correct the source images before calculating the factors. A value of
    /// 1.0 will stop this.
    ///
    /// Each of the source images is transformed with the appropriate correction
    /// factor, then the mosaic is reassembled. `out` is `VIPS_FORMAT_FLOAT`, but
    /// if `int_output` is set, the output image is the same format as the input
    /// images.
    ///
    /// There are some conditions that must be met before this operation can work:
    /// the source images must all be present under the filenames recorded in the
    /// history on `in`, and the mosaic must have been built using only operations in
    /// this package.
    ///
    /// See also: `vips.Image.remosaic`.
    extern fn vips_globalbalance(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const globalbalance = vips_globalbalance;

    /// Chop a tall thin image up into a set of tiles, lay the tiles out in a grid.
    ///
    /// The input image should be a very tall, thin image containing a list of
    /// smaller images. Volumetric or time-sequence images are often laid out like
    /// this. This image is chopped into a series of tiles, each `tile_height`
    /// pixels high and the width of `in`. The tiles are then rearranged into a grid
    /// `across` tiles across and `down` tiles down in row-major order.
    ///
    /// Supplying `tile_height`, `across` and `down` is not strictly necessary, we
    /// only really need two of these. Requiring three is a double-check that the
    /// image has the expected geometry.
    ///
    /// See also: `vips.Image.embed`, `vips.Image.insert`, `vips.join`.
    extern fn vips_grid(p_in: *Image, p_out: **vips.Image, p_tile_height: c_int, p_across: c_int, p_down: c_int, ...) c_int;
    pub const grid = vips_grid;

    /// Return the `vips.BandFormat` for an image, guessing a sane value if
    /// the set value looks crazy.
    ///
    /// For example, for a float image tagged as rgb16, we'd return ushort.
    extern fn vips_image_guess_format(p_image: *const Image) vips.BandFormat;
    pub const guessFormat = vips_image_guess_format;

    /// Return the `vips.Interpretation` for an image, guessing a sane value if
    /// the set value looks crazy.
    extern fn vips_image_guess_interpretation(p_image: *const Image) vips.Interpretation;
    pub const guessInterpretation = vips_image_guess_interpretation;

    /// Look at an image's interpretation and see if it has extra alpha bands. For
    /// example, a 4-band `VIPS_INTERPRETATION_sRGB` would, but a six-band
    /// `VIPS_INTERPRETATION_MULTIBAND` would not.
    ///
    /// Return `TRUE` if `image` has an alpha channel.
    extern fn vips_image_hasalpha(p_image: *Image) c_int;
    pub const hasalpha = vips_image_hasalpha;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `bitdepth`: `gint`, set write bit depth to 8, 10, or 12 bits
    /// * `lossless`: `gboolean`, enable lossless encoding
    /// * `compression`: `vips.ForeignHeifCompression`, write with this compression
    /// * `effort`: `gint`, encoding effort
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `encoder`: `vips.ForeignHeifEncoder`, select encoder to use
    ///
    /// Write a VIPS image to a file in HEIF format.
    ///
    /// Use `Q` to set the compression factor. Default 50, which seems to be roughly
    /// what the iphone uses. Q 30 gives about the same quality as JPEG Q 75.
    ///
    /// Set `lossless` `TRUE` to switch to lossless compression.
    ///
    /// Use `compression` to set the compression format e.g. HEVC, AVC, AV1 to use. It defaults to AV1
    /// if the target filename ends with ".avif", otherwise HEVC.
    ///
    /// Use `effort` to control the CPU effort spent improving compression.
    /// This is currently only applicable to AV1 encoders. Defaults to 4, 0 is
    /// fastest, 9 is slowest.
    ///
    /// Chroma subsampling is normally automatically disabled for Q >= 90. You can
    /// force the subsampling mode with `subsample_mode`.
    ///
    /// Use `bitdepth` to set the bitdepth of the output file. HEIC supports at
    /// least 8, 10 and 12 bits; other codecs may support more or fewer options.
    ///
    /// Use `encoder` to set the encode library to use, e.g. aom, SVT-AV1, rav1e etc.
    ///
    /// See also: `vips.Image.writeToFile`, `vips.heifload`.
    extern fn vips_heifsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const heifsave = vips_heifsave;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `bitdepth`: `gint`, set write bit depth to 8, 10, or 12 bits
    /// * `lossless`: `gboolean`, enable lossless encoding
    /// * `compression`: `vips.ForeignHeifCompression`, write with this compression
    /// * `effort`: `gint`, encoding effort
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `encoder`: `vips.ForeignHeifEncoder`, select encoder to use
    ///
    /// As `vips.Image.heifsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `obuf`, the length of the buffer in
    /// `olen`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.heifsave`, `vips.Image.writeToFile`.
    extern fn vips_heifsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const heifsaveBuffer = vips_heifsave_buffer;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `bitdepth`: `gint`, set write bit depth to 8, 10, or 12 bits
    /// * `lossless`: `gboolean`, enable lossless encoding
    /// * `compression`: `vips.ForeignHeifCompression`, write with this compression
    /// * `effort`: `gint`, encoding effort
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `encoder`: `vips.ForeignHeifEncoder`, select encoder to use
    ///
    /// As `vips.Image.heifsave`, but save to a target.
    ///
    /// See also: `vips.Image.heifsave`, `vips.Image.writeToTarget`.
    extern fn vips_heifsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const heifsaveTarget = vips_heifsave_target;

    /// Form cumulative histogram.
    ///
    /// See also: `vips.Image.histNorm`.
    extern fn vips_hist_cum(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const histCum = vips_hist_cum;

    /// Estimate image entropy from a histogram. Entropy is calculated as:
    ///
    /// ```
    /// -sum(p * log2(p))
    /// ```
    ///
    /// where p is histogram-value / sum-of-histogram-values.
    extern fn vips_hist_entropy(p_in: *Image, p_out: *f64, ...) c_int;
    pub const histEntropy = vips_hist_entropy;

    /// Optional arguments:
    ///
    /// * `band`: band to equalise
    ///
    /// Histogram-equalise `in`. Equalise using band `bandno`, or if `bandno` is -1,
    /// equalise bands independently. The output format is always the same as the
    /// input format.
    ///
    /// See also:
    extern fn vips_hist_equal(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const histEqual = vips_hist_equal;

    /// Optional arguments:
    ///
    /// * `band`: band to equalise
    ///
    /// Find the histogram of `in`. Find the histogram for band `band` (producing a
    /// one-band histogram), or for all bands (producing an n-band histogram) if
    /// `band` is -1.
    ///
    /// char and uchar images are cast to uchar before histogramming, all other
    /// image types are cast to ushort.
    ///
    /// See also: `vips.Image.histFindNdim`, `vips.Image.histFindIndexed`.
    extern fn vips_hist_find(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const histFind = vips_hist_find;

    /// Optional arguments:
    ///
    /// * `combine`: `vips.Combine`, combine bins like this
    ///
    /// Make a histogram of `in`, but use image `index` to pick the bins. In other
    /// words, element zero in `out` contains the combination of all the pixels in `in`
    /// whose corresponding pixel in `index` is zero.
    ///
    /// char and uchar `index` images are cast to uchar before histogramming, all
    /// other image types are cast to ushort. `index` must have just one band.
    ///
    /// `in` must be non-complex.
    ///
    /// `out` always has the same size and format as `in`.
    ///
    /// Normally, bins are summed, but you can use `combine` to set other combine
    /// modes.
    ///
    /// This operation is useful in conjunction with `vips.Image.labelregions`. You can
    /// use it to find the centre of gravity of blobs in an image, for example.
    ///
    /// See also: `vips.Image.histFind`, `vips.Image.labelregions`.
    extern fn vips_hist_find_indexed(p_in: *Image, p_index: *vips.Image, p_out: **vips.Image, ...) c_int;
    pub const histFindIndexed = vips_hist_find_indexed;

    /// Optional arguments:
    ///
    /// * `bins`: number of bins to make on each axis
    ///
    /// Make a one, two or three dimensional histogram of a 1, 2 or
    /// 3 band image. Divide each axis into `bins` bins .. ie.
    /// output is 1 x bins, bins x bins, or bins x bins x bins bands.
    /// `bins` defaults to 10.
    ///
    /// char and uchar images are cast to uchar before histogramming, all other
    /// image types are cast to ushort.
    ///
    /// See also: `vips.Image.histFind`, `vips.Image.histFindIndexed`.
    extern fn vips_hist_find_ndim(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const histFindNdim = vips_hist_find_ndim;

    /// Test `in` for monotonicity. `out` is set non-zero if `in` is monotonic.
    extern fn vips_hist_ismonotonic(p_in: *Image, p_out: *c_int, ...) c_int;
    pub const histIsmonotonic = vips_hist_ismonotonic;

    /// Optional arguments:
    ///
    /// * `max_slope`: maximum brightening
    ///
    /// Performs local histogram equalisation on `in` using a
    /// window of size `width` by `height` centered on the input pixel.
    ///
    /// The output image is the same size as the input image. The edge pixels are
    /// created by mirroring the input image outwards.
    ///
    /// If `max_slope` is greater than 0, it sets the maximum value for the slope of
    /// the cumulative histogram, that is, the maximum brightening that is
    /// performed. A value of 3 is often used. Local histogram equalization with
    /// contrast limiting is usually called CLAHE.
    ///
    /// See also: `vips.Image.histEqual`.
    extern fn vips_hist_local(p_in: *Image, p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
    pub const histLocal = vips_hist_local;

    /// Adjust `in` to match `ref`. If `in` and `ref` are normalised
    /// cumulative histograms, `out` will be a LUT that adjusts the PDF of the image
    /// from which `in` was made to match the PDF of `ref`'s image.
    ///
    /// See also: `vips.Image.maplut`, `vips.Image.histFind`, `vips.Image.histNorm`,
    /// `vips.Image.histCum`.
    extern fn vips_hist_match(p_in: *Image, p_ref: *vips.Image, p_out: **vips.Image, ...) c_int;
    pub const histMatch = vips_hist_match;

    /// Normalise histogram. The maximum of each band becomes equal to the maximum
    /// index, so for example the max for a uchar image becomes 255.
    /// Normalise each band separately.
    ///
    /// See also: `vips.Image.histCum`.
    extern fn vips_hist_norm(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const histNorm = vips_hist_norm;

    /// Plot a 1 by any or any by 1 image file as a max by any or
    /// any by max image using these rules:
    ///
    /// <emphasis>unsigned char</emphasis> max is always 256
    ///
    /// <emphasis>other unsigned integer types</emphasis> output 0 - maximum
    /// value of `in`.
    ///
    /// <emphasis>signed int types</emphasis> min moved to 0, max moved to max + min.
    ///
    /// <emphasis>float types</emphasis> min moved to 0, max moved to any
    /// (square output)
    extern fn vips_hist_plot(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const histPlot = vips_hist_plot;

    /// Formats the name/argv as a single string and calls
    /// `vips.Image.historyPrintf`. A
    /// convenience function for command-line prorams.
    ///
    /// See also: `vips.Image.getHistory`.
    extern fn vips_image_history_args(p_image: *Image, p_name: [*:0]const u8, p_argc: c_int, p_argv: [*][*:0]u8) c_int;
    pub const historyArgs = vips_image_history_args;

    /// Add a line to the image history. The `format` and arguments are expanded, the
    /// date and time is appended prefixed with a hash character, and the whole
    /// string is appended to the image history and terminated with a newline.
    ///
    /// For example:
    ///
    /// ```
    /// vips_image_history_printf(image, "vips invert `s` `s`",
    ///     in->filename, out->filename);
    /// ```
    ///
    /// Might add the string
    ///
    /// ```
    /// "vips invert /home/john/fred.v /home/john/jim.v # Fri Apr 3 23:30:35 2009\n"
    /// ```
    ///
    /// VIPS operations don't add history lines for you because a single action at
    /// the application level might involve many VIPS operations. History must be
    /// recorded by the application.
    extern fn vips_image_history_printf(p_image: *Image, p_format: [*:0]const u8, ...) c_int;
    pub const historyPrintf = vips_image_history_printf;

    /// Optional arguments:
    ///
    /// * `scale`: scale down dimensions by this much
    /// * `min_radius`: smallest radius to search for
    /// * `max_radius`: largest radius to search for
    ///
    /// Find the circular Hough transform of an image. `in` must be one band, with
    /// non-zero pixels for image edges. `out` is three-band, with the third channel
    /// representing the detected circle radius. The operation scales the number of
    /// votes by circle circumference so circles of differing size are given equal
    /// weight.
    ///
    /// The output pixel at (x, y, band) is the strength of the circle centred on
    /// (x, y) and with radius (band).
    ///
    /// Use `max_radius` and `min_radius` to set the range of radii to search for.
    ///
    /// Use `scale` to set how `in` coordinates are scaled to `out` coordinates. A
    /// `scale` of 3, for example, will make `out` 1/3rd of the width and height of
    /// `in`, and reduce the number of radii tested (and hence the number of bands
    /// int `out`) by a factor of three as well.
    ///
    /// See also: `vips.Image.houghLine`.
    extern fn vips_hough_circle(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const houghCircle = vips_hough_circle;

    /// Optional arguments:
    ///
    /// * `width`: horizontal size of parameter space
    /// * `height`: vertical size of parameter space
    ///
    /// Find the line Hough transform for `in`. `in` must have one band. `out` has one
    /// band, with pixels being the number of votes for that line. The X dimension
    /// of `out` is the line angle in 0 - 180 degrees, the Y dimension is the
    /// distance of the closest part of that line to the origin in the top-left.
    ///
    /// Use `width` `height` to set the size of the parameter space image (`out`),
    /// that is, how accurate the line determination should be.
    ///
    /// See also: `vips.Image.houghCircle`.
    extern fn vips_hough_line(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const houghLine = vips_hough_line;

    /// Transform an image from absolute to relative colorimetry using the
    /// MediaWhitePoint stored in the ICC profile.
    ///
    /// See also: `vips.Image.iccTransform`, `vips.Image.iccImport`.
    extern fn vips_icc_ac2rc(p_in: *Image, p_out: **vips.Image, p_profile_filename: [*:0]const u8) c_int;
    pub const iccAc2rc = vips_icc_ac2rc;

    /// Optional arguments:
    ///
    /// * `pcs`: `vips.PCS`,  use XYZ or LAB PCS
    /// * `intent`: `vips.Intent`, transform with this intent
    /// * `black_point_compensation`: `gboolean`, enable black point compensation
    /// * `output_profile`: `gchararray`, get the output profile from here
    /// * `depth`: `gint`, depth of output image in bits
    ///
    /// Export an image from D65 LAB to device space with an ICC profile.
    /// If `pcs` is
    /// set to `VIPS_PCS_XYZ`, use CIE XYZ PCS instead.
    /// If `output_profile` is not set, use the embedded profile, if any.
    /// If `output_profile` is set, export with that and attach it to the output
    /// image.
    ///
    /// If `black_point_compensation` is set, LCMS black point compensation is
    /// enabled.
    extern fn vips_icc_export(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const iccExport = vips_icc_export;

    /// Optional arguments:
    ///
    /// * `pcs`: `vips.PCS`,  use XYZ or LAB PCS
    /// * `intent`: `vips.Intent`, transform with this intent
    /// * `black_point_compensation`: `gboolean`, enable black point compensation
    /// * `embedded`: `gboolean`, use profile embedded in input image
    /// * `input_profile`: `gchararray`, get the input profile from here
    ///
    /// Import an image from device space to D65 LAB with an ICC profile. If `pcs` is
    /// set to `VIPS_PCS_XYZ`, use CIE XYZ PCS instead.
    ///
    /// The input profile is searched for in three places:
    ///
    ///   1. If `embedded` is set, libvips will try to use any profile in the input
    ///   image metadata. You can test for the presence of an embedded profile
    ///   with `vips.Image.getTypeof` with `VIPS_META_ICC_NAME` as an argument.
    ///   This will return `gobject.Type` 0 if there is no profile.
    ///
    ///   2. Otherwise, if `input_profile` is set, libvips will try to load a
    ///   profile from the named file. This can aslso be the name of one of the
    ///   built-in profiles.
    ///
    ///   3. Otherwise, libvips will try to pick a compatible profile from the set
    ///   of built-in profiles.
    ///
    /// If `black_point_compensation` is set, LCMS black point compensation is
    /// enabled.
    extern fn vips_icc_import(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const iccImport = vips_icc_import;

    /// Optional arguments:
    ///
    /// * `pcs`: `vips.PCS`,  use XYZ or LAB PCS
    /// * `intent`: `vips.Intent`, transform with this intent
    /// * `black_point_compensation`: `gboolean`, enable black point compensation
    /// * `embedded`: `gboolean`, use profile embedded in input image
    /// * `input_profile`: `gchararray`, get the input profile from here
    /// * `depth`: `gint`, depth of output image in bits
    ///
    /// Transform an image with a pair of ICC profiles. The input image is moved to
    /// profile-connection space with the input profile and then to the output
    /// space with the output profile.
    ///
    /// The input profile is searched for in three places:
    ///
    ///   1. If `embedded` is set, libvips will try to use any profile in the input
    ///   image metadata. You can test for the presence of an embedded profile
    ///   with `vips.Image.getTypeof` with `VIPS_META_ICC_NAME` as an argument.
    ///   This will return `gobject.Type` 0 if there is no profile.
    ///
    ///   2. Otherwise, if `input_profile` is set, libvips will try to load a
    ///   profile from the named file. This can aslso be the name of one of the
    ///   built-in profiles.
    ///
    ///   3. Otherwise, libvips will try to pick a compatible profile from the set
    ///   of built-in profiles.
    ///
    /// If `black_point_compensation` is set, LCMS black point compensation is
    /// enabled.
    ///
    /// `depth` defaults to 8, or 16 if `in` is a 16-bit image.
    ///
    /// The output image has the output profile attached to the `VIPS_META_ICC_NAME`
    /// field.
    ///
    /// Use `vips.Image.iccImport` and `vips.Image.iccExport` to do either the first or
    /// second half of this operation in isolation.
    extern fn vips_icc_transform(p_in: *Image, p_out: **vips.Image, p_output_profile: [*:0]const u8, ...) c_int;
    pub const iccTransform = vips_icc_transform;

    /// Perform `VIPS_OPERATION_COMPLEXGET_IMAG` on an image. See `vips.Image.complexget`.
    extern fn vips_imag(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const imag = vips_imag;

    /// A convenience function to set the header fields after creating an image.
    /// Normally you copy the fields from your input images with
    /// `vips_image_pipelinev` and then make
    /// any adjustments you need, but if you are creating an image from scratch,
    /// for example `vips.black` or `vips.jpegload`, you do need to set all the
    /// fields yourself.
    ///
    /// See also: `vips_image_pipelinev`.
    extern fn vips_image_init_fields(p_image: *Image, p_xsize: c_int, p_ysize: c_int, p_bands: c_int, p_format: vips.BandFormat, p_coding: vips.Coding, p_interpretation: vips.Interpretation, p_xres: f64, p_yres: f64) void;
    pub const initFields = vips_image_init_fields;

    /// Gets `image` ready for an in-place operation, such as `vips.Image.drawCircle`.
    /// After calling this function you can both read and write the image with
    /// `VIPS_IMAGE_ADDR`.
    ///
    /// This method is called for you by the base class of the draw operations,
    /// there's no need to call it yourself.
    ///
    /// Since this function modifies `image`, it is not thread-safe. Only call it on
    /// images which you are sure have not been shared with another thread.
    /// All in-place operations are inherently not thread-safe, so you need to take
    /// great care in any case.
    ///
    /// See also: `vips.Image.drawCircle`, `vips.Image.wioInput`.
    extern fn vips_image_inplace(p_image: *Image) c_int;
    pub const inplace = vips_image_inplace;

    /// Optional arguments:
    ///
    /// * `expand`: expand output to hold whole of both images
    /// * `background`: colour for new pixels
    ///
    /// Insert `sub` into `main` at position `x`, `y`.
    ///
    /// Normally `out` shows the whole of `main`. If `expand` is `TRUE` then `out` is
    /// made large enough to hold all of `main` and `sub`.
    /// Any areas of `out` not coming from
    /// either `main` or `sub` are set to `background` (default 0).
    ///
    /// If `sub` overlaps `main`,
    /// `sub` will appear on top of `main`.
    ///
    /// If the number of bands differs, one of the images
    /// must have one band. In this case, an n-band image is formed from the
    /// one-band image by joining n copies of the one-band image together, and then
    /// the two n-band images are operated upon.
    ///
    /// The two input images are cast up to the smallest common type (see table
    /// Smallest common format in
    /// <link linkend="libvips-arithmetic">arithmetic</link>).
    ///
    /// See also: `vips.join`, `vips.Image.embed`, `vips.Image.extractArea`.
    extern fn vips_insert(p_main: *Image, p_sub: *vips.Image, p_out: **vips.Image, p_x: c_int, p_y: c_int, ...) c_int;
    pub const insert = vips_insert;

    /// Invalidate all pixel caches on `image` and any downstream images, that
    /// is, images which depend on this image. Additionally, all operations which
    /// depend upon this image are dropped from the VIPS operation cache.
    ///
    /// You should call this function after
    /// destructively modifying an image with something like `vips.Image.drawCircle`.
    ///
    /// The `vips.Image.signals.invalidate` signal is emitted for all invalidated images.
    ///
    /// See also: `vips.Region.invalidate`.
    extern fn vips_image_invalidate_all(p_image: *Image) void;
    pub const invalidateAll = vips_image_invalidate_all;

    /// For unsigned formats, this operation calculates (max - `in`), eg. (255 -
    /// `in`) for uchar. For signed and float formats, this operation calculates (-1
    /// `in`).
    ///
    /// For complex images, only the real part is inverted. See also `vips.Image.conj`.
    ///
    /// See also: `vips.Image.linear`.
    extern fn vips_invert(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const invert = vips_invert;

    /// Optional arguments:
    ///
    /// * `size`: generate this much
    ///
    /// Given a mask of target values and real values, generate a LUT which
    /// will map reals to targets. Handy for linearising images from
    /// measurements of a colour chart. All values in [0,1]. Piecewise linear
    /// interpolation, extrapolate head and tail to 0 and 1.
    ///
    /// Eg. input like this:
    ///
    ///   <tgroup cols='4' align='left' colsep='1' rowsep='1'>
    ///     <tbody>
    ///       <row>
    ///         <entry>4</entry>
    ///         <entry>3</entry>
    ///       </row>
    ///       <row>
    ///         <entry>0.1</entry>
    ///         <entry>0.2</entry>
    ///         <entry>0.3</entry>
    ///         <entry>0.1</entry>
    ///       </row>
    ///       <row>
    ///         <entry>0.2</entry>
    ///         <entry>0.4</entry>
    ///         <entry>0.4</entry>
    ///         <entry>0.2</entry>
    ///       </row>
    ///       <row>
    ///         <entry>0.7</entry>
    ///         <entry>0.5</entry>
    ///         <entry>0.6</entry>
    ///         <entry>0.3</entry>
    ///       </row>
    ///     </tbody>
    ///   </tgroup>
    ///
    /// Means a patch with 10% reflectance produces an image with 20% in
    /// channel 1, 30% in channel 2, and 10% in channel 3, and so on.
    ///
    /// Inputs don't need to be sorted (we do that). Generate any precision
    /// LUT, default to 256 elements.
    ///
    /// It won't work too well for non-monotonic camera responses
    /// (we should fix this). Interpolation is simple piecewise linear; we ought to
    /// do something better really.
    ///
    /// See also: `vips.Image.buildlut`.
    extern fn vips_invertlut(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const invertlut = vips_invertlut;

    /// Optional arguments:
    ///
    /// * `real`: only output the real part
    ///
    /// Transform an image from Fourier space to real space. The result is complex.
    /// If you are OK with a real result, set `real`, it's quicker.
    ///
    /// VIPS uses the fftw Fourier Transform library. If this library was not
    /// available when VIPS was configured, these functions will fail.
    ///
    /// See also: `vips.Image.fwfft`.
    extern fn vips_invfft(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const invfft = vips_invfft;

    /// Return `TRUE` if `image` is in most-significant-
    /// byte first form. This is the byte order used on the SPARC
    /// architecture and others.
    extern fn vips_image_isMSBfirst(p_image: *Image) c_int;
    pub const isMSBfirst = vips_image_isMSBfirst;

    /// TRUE if any of the images upstream from `image` were opened in sequential
    /// mode. Some operations change behaviour slightly in sequential mode to
    /// optimize memory behaviour.
    extern fn vips_image_is_sequential(p_image: *Image) c_int;
    pub const isSequential = vips_image_is_sequential;

    /// Return `TRUE` if `image` represents a file on disc in some way.
    extern fn vips_image_isfile(p_image: *Image) c_int;
    pub const isfile = vips_image_isfile;

    /// If `image` has been killed (see `vips.Image.setKill`), set an error message,
    /// clear the `vips.Image.kill` flag and return `TRUE`. Otherwise return `FALSE`.
    ///
    /// Handy for loops which need to run sets of threads which can fail.
    ///
    /// See also: `vips.Image.setKill`.
    extern fn vips_image_iskilled(p_image: *Image) c_int;
    pub const iskilled = vips_image_iskilled;

    /// Return `TRUE` if `im` represents a partial image (a delayed calculation).
    extern fn vips_image_ispartial(p_image: *Image) c_int;
    pub const ispartial = vips_image_ispartial;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `tile_width`: `gint` for tile size
    /// * `tile_height`: `gint` for tile size
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    ///
    /// Write a VIPS image to a file in JPEG2000 format.
    /// The saver supports 8, 16 and 32-bit int pixel
    /// values, signed and unsigned. It supports greyscale, RGB, CMYK and
    /// multispectral images.
    ///
    /// Use `Q` to set the compression quality factor. The default value
    /// produces file with approximately the same size as regular JPEG Q 75.
    ///
    /// Set `lossless` to enable lossless compression.
    ///
    /// Use `tile_width` and `tile_height` to set the tile size. The default is 512.
    ///
    /// Chroma subsampling is normally disabled for compatibility. Set
    /// `subsample_mode` to auto to enable chroma subsample for Q < 90. Subsample
    /// mode uses YCC rather than RGB colourspace, and many jpeg2000 decoders do
    /// not support this.
    ///
    /// This operation always writes a pyramid.
    ///
    /// See also: `vips.Image.writeToFile`, `vips.jp2kload`.
    extern fn vips_jp2ksave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const jp2ksave = vips_jp2ksave;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `tile_width`: `gint` for tile size
    /// * `tile_height`: `gint` for tile size
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    ///
    /// As `vips.Image.jp2ksave`, but save to a target.
    ///
    /// See also: `vips.Image.jp2ksave`, `vips.Image.writeToTarget`.
    extern fn vips_jp2ksave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const jp2ksaveBuffer = vips_jp2ksave_buffer;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `tile_width`: `gint` for tile size
    /// * `tile_height`: `gint` for tile size
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    ///
    /// As `vips.Image.jp2ksave`, but save to a target.
    ///
    /// See also: `vips.Image.jp2ksave`, `vips.Image.writeToTarget`.
    extern fn vips_jp2ksave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const jp2ksaveTarget = vips_jp2ksave_target;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `optimize_coding`: `gboolean`, compute optimal Huffman coding tables
    /// * `interlace`: `gboolean`, write an interlaced (progressive) jpeg
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `trellis_quant`: `gboolean`, apply trellis quantisation to each 8x8 block
    /// * `overshoot_deringing`: `gboolean`, overshoot samples with extreme values
    /// * `optimize_scans`: `gboolean`, split DCT coefficients into separate scans
    /// * `quant_table`: `gint`, quantization table index
    /// * `restart_interval`: `gint`, restart interval in mcu
    ///
    /// Write a VIPS image to a file as JPEG.
    ///
    /// Use `Q` to set the JPEG compression factor. Default 75.
    ///
    /// If `optimize_coding` is set, the Huffman tables are optimized. This is
    /// slightly slower and produces slightly smaller files.
    ///
    /// If `interlace` is set, the jpeg files will be interlaced (progressive jpeg,
    /// in jpg parlance). These files may be better for display over a slow network
    /// connection, but need much more memory to encode and decode.
    ///
    /// Chroma subsampling is normally automatically disabled for Q >= 90. You can
    /// force the subsampling mode with `subsample_mode`.
    ///
    /// If `trellis_quant` is set and the version of libjpeg supports it
    /// (e.g. mozjpeg >= 3.0), apply trellis quantisation to each 8x8 block.
    /// Reduces file size but increases compression time.
    ///
    /// If `overshoot_deringing` is set and the version of libjpeg supports it
    /// (e.g. mozjpeg >= 3.0), apply overshooting to samples with extreme values
    /// for example 0 and 255 for 8-bit. Overshooting may reduce ringing artifacts
    /// from compression, in particular in areas where black text appears on a
    /// white background.
    ///
    /// If `optimize_scans` is set and the version of libjpeg supports it
    /// (e.g. mozjpeg >= 3.0), split the spectrum of DCT coefficients into
    /// separate scans. Reduces file size but increases compression time.
    ///
    /// If `quant_table` is set and the version of libjpeg supports it
    /// (e.g. mozjpeg >= 3.0) it selects the quantization table to use:
    ///
    /// * 0 — Tables from JPEG Annex K (vips and libjpeg default)
    /// * 1 — Flat table
    /// * 2 — Table tuned for MSSIM on Kodak image set
    /// * 3 — Table from ImageMagick by N. Robidoux (current mozjpeg default)
    /// * 4 — Table tuned for PSNR-HVS-M on Kodak image set
    /// * 5 — Table from Relevance of Human Vision to JPEG-DCT Compression (1992)
    /// * 6 — Table from DCTune Perceptual Optimization of Compressed Dental
    ///   X-Rays (1997)
    /// * 7 — Table from A Visual Detection Model for DCT Coefficient
    ///   Quantization (1993)
    /// * 8 — Table from An Improved Detection Model for DCT Coefficient
    ///   Quantization (1993)
    ///
    /// Quantization table 0 is the default in vips and libjpeg(-turbo), but it
    /// tends to favor detail over color accuracy, producing colored patches and
    /// stripes as well as heavy banding in flat areas at high compression ratios.
    /// Quantization table 2 is a good candidate to try if the default quantization
    /// table produces banding or color shifts and is well suited for hires images.
    /// Quantization table 3 is the default in mozjpeg and has been tuned to produce
    /// good results at the default quality setting; banding at high compression.
    /// Quantization table 4 is the most accurate at the cost of compression ratio.
    /// Tables 5-7 are based on older research papers, but generally achieve worse
    /// compression ratios and/or quality than 2 or 4.
    ///
    /// For maximum compression with mozjpeg, a useful set of options is `strip,
    /// optimize-coding, interlace, optimize-scans, trellis-quant, quant_table=3`.
    ///
    /// By default, the output stream won't have restart markers.  If a non-zero
    /// restart_interval is specified, a restart marker will be added after each
    /// specified number of MCU blocks.  This makes the stream more recoverable
    /// if there are transmission errors, but also allows for some decoders to read
    /// part of the JPEG without decoding the whole stream.
    ///
    /// The image is automatically converted to RGB, Monochrome or CMYK before
    /// saving.
    ///
    /// EXIF data is constructed from `VIPS_META_EXIF_NAME`, then
    /// modified with any other related tags on the image before being written to
    /// the file. `VIPS_META_RESOLUTION_UNIT` is used to set the EXIF resolution
    /// unit. `VIPS_META_ORIENTATION` is used to set the EXIF orientation tag.
    ///
    /// IPTC as `VIPS_META_IPTC_NAME` and XMP as `VIPS_META_XMP_NAME`
    /// are coded and attached.
    ///
    /// See also: `vips.Image.jpegsaveBuffer`, `vips.Image.writeToFile`.
    extern fn vips_jpegsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const jpegsave = vips_jpegsave;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `optimize_coding`: `gboolean`, compute optimal Huffman coding tables
    /// * `interlace`: `gboolean`, write an interlaced (progressive) jpeg
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `trellis_quant`: `gboolean`, apply trellis quantisation to each 8x8 block
    /// * `overshoot_deringing`: `gboolean`, overshoot samples with extreme values
    /// * `optimize_scans`: `gboolean`, split DCT coefficients into separate scans
    /// * `quant_table`: `gint`, quantization table index
    /// * `restart_interval`: `gint`, restart interval in mcu
    ///
    /// As `vips.Image.jpegsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `obuf`, the length of the buffer in
    /// `olen`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.jpegsave`, `vips.Image.writeToFile`.
    extern fn vips_jpegsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const jpegsaveBuffer = vips_jpegsave_buffer;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `optimize_coding`: `gboolean`, compute optimal Huffman coding tables
    /// * `interlace`: `gboolean`, write an interlaced (progressive) jpeg
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `trellis_quant`: `gboolean`, apply trellis quantisation to each 8x8 block
    /// * `overshoot_deringing`: `gboolean`, overshoot samples with extreme values
    /// * `optimize_scans`: `gboolean`, split DCT coefficients into separate scans
    /// * `quant_table`: `gint`, quantization table index
    /// * `restart_interval`: `gint`, restart interval in mcu
    ///
    /// As `vips.Image.jpegsave`, but save as a mime jpeg on stdout.
    ///
    /// See also: `vips.Image.jpegsave`, `vips.Image.writeToFile`.
    extern fn vips_jpegsave_mime(p_in: *Image, ...) c_int;
    pub const jpegsaveMime = vips_jpegsave_mime;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `optimize_coding`: `gboolean`, compute optimal Huffman coding tables
    /// * `interlace`: `gboolean`, write an interlaced (progressive) jpeg
    /// * `subsample_mode`: `vips.ForeignSubsample`, chroma subsampling mode
    /// * `trellis_quant`: `gboolean`, apply trellis quantisation to each 8x8 block
    /// * `overshoot_deringing`: `gboolean`, overshoot samples with extreme values
    /// * `optimize_scans`: `gboolean`, split DCT coefficients into separate scans
    /// * `quant_table`: `gint`, quantization table index
    /// * `restart_interval`: `gint`, restart interval in mcu
    ///
    /// As `vips.Image.jpegsave`, but save to a target.
    ///
    /// See also: `vips.Image.jpegsave`, `vips.Image.writeToTarget`.
    extern fn vips_jpegsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const jpegsaveTarget = vips_jpegsave_target;

    /// Optional arguments:
    ///
    /// * `tier`: `gint`, decode speed tier
    /// * `distance`: `gdouble`, maximum encoding error
    /// * `effort`: `gint`, encoding effort
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `Q`: `gint`, quality setting
    ///
    /// Write a VIPS image to a file in JPEG-XL format.
    ///
    /// The JPEG-XL loader and saver are experimental features and may change
    /// in future libvips versions.
    ///
    /// `tier` sets the overall decode speed the encoder will target. Minimum is 0
    /// (highest quality), and maximum is 4 (lowest quality). Default is 0.
    ///
    /// `distance` sets the target maximum encoding error. Minimum is 0
    /// (highest quality), and maximum is 15 (lowest quality). Default is 1.0
    /// (visually lossless).
    ///
    /// As a convenience, you can also use `Q` to set `distance`. `Q` uses
    /// approximately the same scale as regular JPEG.
    ///
    /// Set `lossless` to enable lossless compression.
    extern fn vips_jxlsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const jxlsave = vips_jxlsave;

    /// Optional arguments:
    ///
    /// * `tier`: `gint`, decode speed tier
    /// * `distance`: `gdouble`, maximum encoding error
    /// * `effort`: `gint`, encoding effort
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `Q`: `gint`, quality setting
    ///
    /// As `vips.Image.jxlsave`, but save to a memory buffer.
    ///
    /// See also: `vips.Image.jxlsave`, `vips.Image.writeToTarget`.
    extern fn vips_jxlsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const jxlsaveBuffer = vips_jxlsave_buffer;

    /// Optional arguments:
    ///
    /// * `tier`: `gint`, decode speed tier
    /// * `distance`: `gdouble`, maximum encoding error
    /// * `effort`: `gint`, encoding effort
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `Q`: `gint`, quality setting
    ///
    /// As `vips.Image.jxlsave`, but save to a target.
    ///
    /// See also: `vips.Image.jxlsave`, `vips.Image.writeToTarget`.
    extern fn vips_jxlsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const jxlsaveTarget = vips_jxlsave_target;

    /// Optional arguments:
    ///
    /// * `segments`: return number of regions found here
    ///
    /// Repeatedly scans `in` for regions of 4-connected pixels
    /// with the same pixel value. Every time a region is discovered, those
    /// pixels are marked in `mask` with a unique serial number. Once all pixels
    /// have been labelled, the operation returns, setting `segments` to the number
    /// of discrete regions which were detected.
    ///
    /// `mask` is always a 1-band `VIPS_FORMAT_INT` image of the same dimensions as
    /// `in`.
    ///
    /// This operation is useful for, for example, blob counting. You can use the
    /// morphological operators to detect and isolate a series of objects, then use
    /// `vips.Image.labelregions` to number them all.
    ///
    /// Use `vips.Image.histFindIndexed` to (for example) find blob coordinates.
    ///
    /// See also: `vips.Image.histFindIndexed`.
    extern fn vips_labelregions(p_in: *Image, p_mask: **vips.Image, ...) c_int;
    pub const labelregions = vips_labelregions;

    /// Perform `VIPS_OPERATION_RELATIONAL_LESS` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_less_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const lessConst = vips_less_const;

    /// Perform `VIPS_OPERATION_RELATIONAL_LESS` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_less_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const lessConst1 = vips_less_const1;

    /// Perform `VIPS_OPERATION_RELATIONAL_LESSEQ` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_lesseq_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const lesseqConst = vips_lesseq_const;

    /// Perform `VIPS_OPERATION_RELATIONAL_LESSEQ` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_lesseq_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const lesseqConst1 = vips_lesseq_const1;

    /// Optional arguments:
    ///
    /// * `uchar`: output uchar pixels
    ///
    /// Pass an image through a linear transform, ie. (`out` = `in` * `a` + `b`). Output
    /// is float for integer input, double for double input, complex for
    /// complex input and double complex for double complex input. Set `uchar` to
    /// output uchar pixels.
    ///
    /// If the arrays of constants have just one element, that constant is used for
    /// all image bands. If the arrays have more than one element and they have
    /// the same number of elements as there are bands in the image, then
    /// one array element is used for each band. If the arrays have more than one
    /// element and the image only has a single band, the result is a many-band
    /// image where each band corresponds to one array element.
    ///
    /// See also: `vips.Image.linear1`, `vips.add`.
    extern fn vips_linear(p_in: *Image, p_out: **vips.Image, p_a: [*]const f64, p_b: [*]const f64, p_n: c_int, ...) c_int;
    pub const linear = vips_linear;

    /// Optional arguments:
    ///
    /// * `uchar`: output uchar pixels
    ///
    /// Run `vips.Image.linear` with a single constant.
    ///
    /// See also: `vips.Image.linear`.
    extern fn vips_linear1(p_in: *Image, p_out: **vips.Image, p_a: f64, p_b: f64, ...) c_int;
    pub const linear1 = vips_linear1;

    /// Optional arguments:
    ///
    /// * `access`: hint expected access pattern `vips.Access`
    /// * `tile_height`: height of tiles in cache
    /// * `threaded`: allow many threads
    ///
    /// This operation behaves rather like `vips.Image.copy` between images
    /// `in` and `out`, except that it keeps a cache of computed scanlines.
    ///
    /// The number of lines cached is enough for a small amount of non-local
    /// access.
    ///
    /// Each cache tile is made with a single call to
    /// `vips.Region.prepare`.
    ///
    /// When the cache fills, a tile is chosen for reuse. If `access` is
    /// `VIPS_ACCESS_RANDOM`, then the least-recently-used tile is reused. If
    /// `access` is `VIPS_ACCESS_SEQUENTIAL`, then
    /// the top-most tile is reused. `access` defaults to `VIPS_ACCESS_RANDOM`.
    ///
    /// `tile_height` can be used to set the size of the strips that
    /// `vips.Image.linecache` uses. The default is 1 (a single scanline).
    ///
    /// Normally, only a single thread at once is allowed to calculate tiles. If
    /// you set `threaded` to `TRUE`, `vips.Image.linecache` will allow many threads to
    /// calculate tiles at once and share the cache between them.
    ///
    /// See also: `vips_cache`, `vips.Image.tilecache`.
    extern fn vips_linecache(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const linecache = vips_linecache;

    /// Perform `VIPS_OPERATION_MATH_LOG` on an image. See `vips.Image.math`.
    extern fn vips_log(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const log = vips_log;

    /// Perform `VIPS_OPERATION_MATH_LOG10` on an image. See `vips.Image.math`.
    extern fn vips_log10(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const log10 = vips_log10;

    /// Perform `VIPS_OPERATION_BOOLEAN_LSHIFT` on an image and an array of constants.
    /// See `vips.Image.booleanConst`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst1`.
    extern fn vips_lshift_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const lshiftConst = vips_lshift_const;

    /// Perform `VIPS_OPERATION_BOOLEAN_LSHIFT` on an image and a constant.
    /// See `vips.Image.booleanConst1`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst`.
    extern fn vips_lshift_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const lshiftConst1 = vips_lshift_const1;

    /// Optional arguments:
    ///
    /// * `quality`: `gint`, quality factor
    /// * `format`: `gchararray`, format to save as
    /// * `optimize_gif_frames`: `gboolean`, apply GIF frames optimization
    /// * `optimize_gif_transparency`: `gboolean`, apply GIF transparency optimization
    /// * `bitdepth`: `gint`, number of bits per pixel
    ///
    /// Write an image using libMagick.
    ///
    /// Use `quality` to set the quality factor. Default 0.
    ///
    /// Use `format` to explicitly set the save format, for example, "BMP". Otherwise
    /// the format is guessed from the filename suffix.
    ///
    /// If `optimize_gif_frames` is set, GIF frames are cropped to the smallest size
    /// while preserving the results of the GIF animation. This takes some time for
    /// computation but saves some time on encoding and produces smaller files in
    /// some cases.
    ///
    /// If `optimize_gif_transparency` is set, pixels that don't change the image
    /// through animation are made transparent. This takes some time for computation
    /// but saves some time on encoding and produces smaller files in some cases.
    ///
    /// `bitdepth` specifies the number of bits per pixel. The image will be quantized
    /// and dithered if the value is within the valid range (1 to 8).
    ///
    /// See also: `vips.Image.magicksaveBuffer`, `vips.magickload`.
    extern fn vips_magicksave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const magicksave = vips_magicksave;

    /// Optional arguments:
    ///
    /// * `quality`: `gint`, quality factor
    /// * `format`: `gchararray`, format to save as
    /// * `optimize_gif_frames`: `gboolean`, apply GIF frames optimization
    /// * `optimize_gif_transparency`: `gboolean`, apply GIF transparency optimization
    /// * `bitdepth`: `gint`, number of bits per pixel
    ///
    /// As `vips.Image.magicksave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `obuf`, the length of the buffer in
    /// `olen`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.magicksave`, `vips.Image.writeToFile`.
    extern fn vips_magicksave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const magicksaveBuffer = vips_magicksave_buffer;

    /// This function calls `fn` for every header field, including every item of
    /// metadata.
    ///
    /// Like all _map functions, the user function should return `NULL` to continue
    /// iteration, or a non-`NULL` pointer to indicate early termination.
    ///
    /// See also: `vips.Image.getTypeof`, `vips.Image.get`.
    extern fn vips_image_map(p_image: *Image, p_fn: vips.ImageMapFn, p_a: ?*anyopaque) ?*anyopaque;
    pub const map = vips_image_map;

    /// Optional arguments:
    ///
    /// * `interpolate`: interpolate pixels with this
    /// * `extend`: `vips.Extend` how to generate new pixels
    /// * `background`: `vips.ArrayDouble` colour for new pixels
    /// * `premultiplied`: `gboolean`, images are already premultiplied
    ///
    /// This operator resamples `in` using `index` to look up pixels. `out` is
    /// the same size as `index`, with each pixel being fetched from that position in
    /// `in`. That is:
    ///
    /// ```
    /// out[x, y] = in[index[x, y]]
    /// ```
    ///
    /// If `index` has one band, that band must be complex. Otherwise, `index` must
    /// have two bands of any format.
    ///
    /// Coordinates in `index` are in pixels, with (0, 0) being the top-left corner
    /// of `in`, and with y increasing down the image. Use `vips.xyz` to build index
    /// images.
    ///
    /// `interpolate` defaults to bilinear.
    ///
    /// By default, new pixels are filled with `background`. This defaults to
    /// zero (black). You can set other extend types with `extend`. `VIPS_EXTEND_COPY`
    /// is better for image upsizing.
    ///
    /// Image are normally treated as unpremultiplied, so this operation can be used
    /// directly on PNG images. If your images have been through `vips.Image.premultiply`,
    /// set `premultiplied`.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See `vips.Image.maplut` for a 1D equivalent of this operation.
    ///
    /// See also: `vips.xyz`, `vips.Image.affine`, `vips.Image.resize`,
    /// `vips.Image.maplut`, `vips.Interpolate`.
    extern fn vips_mapim(p_in: *Image, p_out: **vips.Image, p_index: *vips.Image, ...) c_int;
    pub const mapim = vips_mapim;

    /// Optional arguments:
    ///
    /// * `band`: apply one-band `lut` to this band of `in`
    ///
    /// Map an image through another image acting as a LUT (Look Up Table).
    /// The lut may have any type and the output image will be that type.
    ///
    /// The input image will be cast to one of the unsigned integer types, that is,
    /// VIPS_FORMAT_UCHAR, VIPS_FORMAT_USHORT or VIPS_FORMAT_UINT.
    ///
    /// If `lut` is too small for the input type (for example, if `in` is
    /// VIPS_FORMAT_UCHAR but `lut` only has 100 elements), the lut is padded out
    /// by copying the last element. Overflows are reported at the end of
    /// computation.
    /// If `lut` is too large, extra values are ignored.
    ///
    /// If `lut` has one band and `band` is -1 (the default), then all bands of `in`
    /// pass through `lut`. If `band` is >= 0, then just that band of `in` passes
    /// through `lut` and other bands are just copied.
    ///
    /// If `lut`
    /// has same number of bands as `in`, then each band is mapped
    /// separately. If `in` has one band, then `lut` may have many bands and
    /// the output will have the same number of bands as `lut`.
    ///
    /// See also: `vips.Image.histFind`, `vips.identity`.
    extern fn vips_maplut(p_in: *Image, p_out: **vips.Image, p_lut: *vips.Image, ...) c_int;
    pub const maplut = vips_maplut;

    /// Perform various functions in -lm, the maths library, on images.
    ///
    /// Angles are expressed in degrees. The output type is float unless the
    /// input is double, in which case the output is double.
    ///
    /// Non-complex images only.
    ///
    /// See also: `vips.math2`.
    extern fn vips_math(p_in: *Image, p_out: **vips.Image, p_math: vips.OperationMath, ...) c_int;
    pub const math = vips_math;

    /// This operation calculates various 2-ary maths operations on an image and
    /// an array of constants and writes the result to `out`.
    /// The image may have any
    /// non-complex format. `out` is float except in the case that `in`
    /// is double, in which case `out` is also double.
    ///
    /// It detects division by zero, setting those pixels to zero in the output.
    /// Beware: it does this silently!
    ///
    /// If the array of constants has just one element, that constant is used for
    /// all image bands. If the array has more than one element and they have
    /// the same number of elements as there are bands in the image, then
    /// one array element is used for each band. If the arrays have more than one
    /// element and the image only has a single band, the result is a many-band
    /// image where each band corresponds to one array element.
    ///
    /// See also: `vips.math2`, `vips.Image.math`.
    extern fn vips_math2_const(p_in: *Image, p_out: **vips.Image, p_math2: vips.OperationMath2, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const math2Const = vips_math2_const;

    /// This operation calculates various 2-ary maths operations on an image and
    /// a constant. See `vips.Image.math2Const`.
    extern fn vips_math2_const1(p_in: *Image, p_out: **vips.Image, p_math2: vips.OperationMath2, p_c: f64, ...) c_int;
    pub const math2Const1 = vips_math2_const1;

    /// This operation calculates the inverse of the matrix represented in `m`.
    /// The scale and offset members of the input matrix are ignored.
    ///
    /// See also: `vips.matrixload`.
    extern fn vips_matrixinvert(p_m: *Image, p_out: **vips.Image, ...) c_int;
    pub const matrixinvert = vips_matrixinvert;

    /// Print `in` to `stdout` in matrix format. See `vips.matrixload` for a
    /// description of the format.
    ///
    /// See also: `vips.matrixload`.
    extern fn vips_matrixprint(p_in: *Image, ...) c_int;
    pub const matrixprint = vips_matrixprint;

    /// Write `in` to `filename` in matrix format. See `vips.matrixload` for a
    /// description of the format.
    ///
    /// See also: `vips.matrixload`.
    extern fn vips_matrixsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const matrixsave = vips_matrixsave;

    /// As `vips.Image.matrixsave`, but save to a target.
    ///
    /// See also: `vips.Image.matrixsave`.
    extern fn vips_matrixsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const matrixsaveTarget = vips_matrixsave_target;

    /// Optional arguments:
    ///
    /// * `x`: horizontal position of maximum
    /// * `y`: vertical position of maximum
    /// * `size`: number of maxima to find
    /// * `out_array`: return array of maximum values
    /// * `x_array`: corresponding horizontal positions
    /// * `y_array`: corresponding vertical positions
    ///
    /// This operation finds the maximum value in an image.
    ///
    /// By default it finds the single largest value. If `size` is set >1, it will
    /// find the `size` largest values. It will stop searching early if has found
    /// enough values.
    /// Equal values will be sorted by y then x.
    ///
    /// It operates on all
    /// bands of the input image: use `vips.Image.stats` if you need to find an
    /// maximum for each band.
    ///
    /// For complex images, this operation finds the maximum modulus.
    ///
    /// You can read out the position of the maximum with `x` and `y`. You can read
    /// out arrays of the values and positions of the top `size` maxima with
    /// `out_array`, `x_array` and `y_array`. These values are returned sorted from
    /// largest to smallest.
    ///
    /// If there are more than `size` maxima, the maxima returned will be a random
    /// selection of the maxima in the image.
    ///
    /// See also: `vips.Image.min`, `vips.Image.stats`.
    extern fn vips_max(p_in: *Image, p_out: *f64, ...) c_int;
    pub const max = vips_max;

    /// Optional arguments:
    ///
    /// * `left`: area of image containing chart
    /// * `top`: area of image containing chart
    /// * `width`: area of image containing chart
    /// * `height`: area of image containing chart
    ///
    /// Analyse a grid of colour patches, producing an array of patch averages.
    /// The mask has a row for each measured patch and a column for each image
    /// band. The operations issues a warning if any patch has a deviation more
    /// than 20% of
    /// the mean. Only the central 50% of each patch is averaged.
    ///
    /// If the chart does not fill the whole image, use the optional `left`, `top`,
    /// `width`, `height` arguments to indicate the
    /// position of the chart.
    ///
    /// See also: `vips.Image.avg`, `vips.Image.deviate`.
    extern fn vips_measure(p_in: *Image, p_out: **vips.Image, p_h: c_int, p_v: c_int, ...) c_int;
    pub const measure = vips_measure;

    /// A convenience function equivalent to:
    ///
    ///  vips_rank(in, out, size, size, (size * size) / 2);
    ///
    /// See also: `vips.Image.rank`.
    extern fn vips_median(p_in: *Image, p_out: **vips.Image, p_size: c_int, ...) c_int;
    pub const median = vips_median;

    /// Optional arguments:
    ///
    /// * `x`: horizontal position of minimum
    /// * `y`: vertical position of minimum
    /// * `size`: number of minima to find
    /// * `out_array`: return array of minimum values
    /// * `x_array`: corresponding horizontal positions
    /// * `y_array`: corresponding vertical positions
    ///
    /// This operation finds the minimum value in an image.
    ///
    /// By default it finds the single smallest value. If `size` is set >1, it will
    /// find the `size` smallest values. It will stop searching early if has found
    /// enough values.
    /// Equal values will be sorted by y then x.
    ///
    /// It operates on all
    /// bands of the input image: use `vips.Image.stats` if you need to find an
    /// minimum for each band.
    ///
    /// For complex images, this operation finds the minimum modulus.
    ///
    /// You can read out the position of the minimum with `x` and `y`. You can read
    /// out arrays of the values and positions of the top `size` minima with
    /// `out_array`, `x_array` and `y_array`.
    /// These values are returned sorted from
    /// smallest to largest.
    ///
    /// If there are more than `size` minima, the minima returned will be a random
    /// selection of the minima in the image.
    ///
    /// See also: `vips.Image.min`, `vips.Image.stats`.
    extern fn vips_min(p_in: *Image, p_out: *f64, ...) c_int;
    pub const min = vips_min;

    /// Minimise memory use on this image and any upstream images, that is, images
    /// which this image depends upon. This function is called automatically at the
    /// end of a computation, but it might be useful to call at other times.
    ///
    /// The `vips.Image.signals.minimise` signal is emitted for all minimised images.
    extern fn vips_image_minimise_all(p_image: *Image) void;
    pub const minimiseAll = vips_image_minimise_all;

    /// Perform `VIPS_OPERATION_RELATIONAL_MORE` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_more_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const moreConst = vips_more_const;

    /// Perform `VIPS_OPERATION_RELATIONAL_MORE` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_more_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const moreConst1 = vips_more_const1;

    /// Perform `VIPS_OPERATION_RELATIONAL_MOREEQ` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_moreeq_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const moreeqConst = vips_moreeq_const;

    /// Perform `VIPS_OPERATION_RELATIONAL_MOREEQ` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_moreeq_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const moreeqConst1 = vips_moreeq_const1;

    /// Performs a morphological operation on `in` using `mask` as a
    /// structuring element.
    ///
    /// The image should have 0 (black) for no object and 255
    /// (non-zero) for an object. Note that this is the reverse of the usual
    /// convention for these operations, but more convenient when combined with the
    /// boolean operators. The output image is the same
    /// size as the input image: edge pxels are made by expanding the input image
    /// as necessary.
    ///
    /// Mask coefficients can be either 0 (for object) or 255 (for background)
    /// or 128 (for do not care).  The origin of the mask is at location
    /// (m.xsize / 2, m.ysize / 2), integer division.  All algorithms have been
    /// based on the book "Fundamentals of Digital Image Processing" by A. Jain,
    /// pp 384-388, Prentice-Hall, 1989.
    ///
    /// For `VIPS_OPERATION_MORPHOLOGY_ERODE`,
    /// the whole mask must match for the output pixel to be
    /// set, that is, the result is the logical AND of the selected input pixels.
    ///
    /// For `VIPS_OPERATION_MORPHOLOGY_DILATE`,
    /// the output pixel is set if any part of the mask
    /// matches, that is, the result is the logical OR of the selected input pixels.
    ///
    /// See the boolean operations `vips.andimage`, `vips.orimage` and
    /// `vips.eorimage`
    /// for analogues of the usual set difference and set union operations.
    ///
    /// Operations are performed using the processor's vector unit,
    /// if possible. Disable this with `--vips-novector` or `VIPS_NOVECTOR` or
    /// `vips_vector_set_enabled`
    extern fn vips_morph(p_in: *Image, p_out: **vips.Image, p_mask: *vips.Image, p_morph: vips.OperationMorphology, ...) c_int;
    pub const morph = vips_morph;

    /// Optional arguments:
    ///
    /// * `band`: `gint`, msb just this band
    ///
    /// Turn any integer image to 8-bit unsigned char by discarding all but the most
    /// significant byte. Signed values are converted to unsigned by adding 128.
    ///
    /// Use `band` to make a one-band 8-bit image.
    ///
    /// This operator also works for LABQ coding.
    ///
    /// See also: `vips.Image.scale`, `vips.Image.cast`.
    extern fn vips_msb(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const msb = vips_msb;

    /// Write a VIPS image to a file in NIFTI format.
    ///
    /// Use the various NIFTI suffixes to pick the nifti save format.
    ///
    /// See also: `vips.Image.writeToFile`, `vips.niftiload`.
    extern fn vips_niftisave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const niftisave = vips_niftisave;

    /// Perform `VIPS_OPERATION_RELATIONAL_NOTEQ` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_notequal_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const notequalConst = vips_notequal_const;

    /// Perform `VIPS_OPERATION_RELATIONAL_NOTEQ` on an image and a constant. See
    /// `vips.Image.relationalConst`.
    extern fn vips_notequal_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const notequalConst1 = vips_notequal_const1;

    /// Perform `VIPS_OPERATION_BOOLEAN_OR` on an image and an array of constants.
    /// See `vips.Image.booleanConst`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst1`.
    extern fn vips_orimage_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const orimageConst = vips_orimage_const;

    /// Perform `VIPS_OPERATION_BOOLEAN_OR` on an image and a constant.
    /// See `vips.Image.booleanConst1`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst`.
    extern fn vips_orimage_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const orimageConst1 = vips_orimage_const1;

    /// `vips.Image.percent` returns (through the `threshold` parameter) the threshold
    /// below which there are `percent` values of `in`. For example:
    ///
    /// ```
    /// $ vips percent k2.jpg 90
    /// 214
    /// ```
    ///
    /// Means that 90% of pixels in `k2.jpg` have a value less than 214.
    ///
    /// The function works for uchar and ushort images only.  It can be used
    /// to threshold the scaled result of a filtering operation.
    ///
    /// See also: `vips.Image.histFind`, `vips.Image.profile`.
    extern fn vips_percent(p_in: *Image, p_percent: f64, p_threshold: *c_int, ...) c_int;
    pub const percent = vips_percent;

    /// Check that an image is readable with `vips.Region.prepare` and friends.
    /// If it isn't, try to transform the image so that `vips.Region.prepare` can
    /// work.
    ///
    /// See also: `vips.Image.pioOutput`, `vips.Region.prepare`.
    extern fn vips_image_pio_input(p_image: *Image) c_int;
    pub const pioInput = vips_image_pio_input;

    /// Check that an image is writeable with `vips_image_generate`. If it isn't,
    /// try to transform the image so that `vips_image_generate` can work.
    ///
    /// See also: `vips.Image.pioInput`.
    extern fn vips_image_pio_output(p_image: *Image) c_int;
    pub const pioOutput = vips_image_pio_output;

    /// Optional arguments:
    ///
    /// * `compression`: `gint`, compression level
    /// * `interlace`: `gboolean`, interlace image
    /// * `filter`: `vips.ForeignPngFilter` row filter flag(s)
    /// * `palette`: `gboolean`, enable quantisation to 8bpp palette
    /// * `Q`: `gint`, quality for 8bpp quantisation
    /// * `dither`: `gdouble`, amount of dithering for 8bpp quantization
    /// * `bitdepth`: `gint`, set write bit depth to 1, 2, 4, 8 or 16
    /// * `effort`: `gint`, quantisation CPU effort
    ///
    /// Write a VIPS image to a file as PNG.
    ///
    /// `compression` means compress with this much effort (0 - 9). Default 6.
    ///
    /// Set `interlace` to `TRUE` to interlace the image with ADAM7
    /// interlacing. Beware
    /// than an interlaced PNG can be up to 7 times slower to write than a
    /// non-interlaced image.
    ///
    /// Use `filter` to specify one or more filters, defaults to none,
    /// see `vips.ForeignPngFilter`.
    ///
    /// The image is automatically converted to RGB, RGBA, Monochrome or Mono +
    /// alpha before saving. Images with more than one byte per band element are
    /// saved as 16-bit PNG, others are saved as 8-bit PNG.
    ///
    /// Set `palette` to `TRUE` to enable palette mode for RGB or RGBA images. A
    /// palette will be computed with enough space for `bitdepth` (1, 2, 4 or 8)
    /// bits. Use `Q` to set the optimisation effort, `dither` to set the degree of
    /// Floyd-Steinberg dithering and `effort` to control the CPU effort
    /// (1 is the fastest, 10 is the slowest, 7 is the default).
    /// This feature requires libvips to be compiled with libimagequant.
    ///
    /// The default `bitdepth` is either 8 or 16 depending on the interpretation.
    /// You can also set `bitdepth` for mono and mono + alpha images, and the image
    /// will be quantized.
    ///
    /// XMP metadata is written to the XMP chunk. PNG comments are written to
    /// separate text chunks.
    ///
    /// See also: `vips.Image.newFromFile`.
    extern fn vips_pngsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const pngsave = vips_pngsave;

    /// Optional arguments:
    ///
    /// * `compression`: `gint`, compression level
    /// * `interlace`: `gboolean`, interlace image
    /// * `filter`: `vips.ForeignPngFilter` row filter flag(s)
    /// * `palette`: `gboolean`, enable quantisation to 8bpp palette
    /// * `Q`: `gint`, quality for 8bpp quantisation
    /// * `dither`: `gdouble`, amount of dithering for 8bpp quantization
    /// * `bitdepth`: `gint`, set write bit depth to 1, 2, 4, 8 or 16
    /// * `effort`: `gint`, quantisation CPU effort
    ///
    /// As `vips.Image.pngsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.pngsave`, `vips.Image.writeToFile`.
    extern fn vips_pngsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const pngsaveBuffer = vips_pngsave_buffer;

    /// Optional arguments:
    ///
    /// * `compression`: compression level
    /// * `interlace`: interlace image
    /// * `filter`: libpng row filter flag(s)
    /// * `palette`: enable quantisation to 8bpp palette
    /// * `Q`: quality for 8bpp quantisation
    /// * `dither`: amount of dithering for 8bpp quantization
    /// * `bitdepth`: `gint`, set write bit depth to 1, 2, 4, 8 or 16
    /// * `effort`: `gint`, quantisation CPU effort
    ///
    /// As `vips.Image.pngsave`, but save to a target.
    ///
    /// See also: `vips.Image.pngsave`, `vips.Image.writeToTarget`.
    extern fn vips_pngsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const pngsaveTarget = vips_pngsave_target;

    /// Perform `VIPS_OPERATION_COMPLEX_POLAR` on an image. See `vips.Image.complex`.
    extern fn vips_polar(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const polar = vips_polar;

    /// Perform `VIPS_OPERATION_MATH2_POW` on an image and a constant. See
    /// `vips.Image.math2Const`.
    extern fn vips_pow_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const powConst = vips_pow_const;

    /// Perform `VIPS_OPERATION_MATH2_POW` on an image and a constant. See
    /// `vips.Image.math2Const`.
    extern fn vips_pow_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const powConst1 = vips_pow_const1;

    /// Optional arguments:
    ///
    /// * `format`: `vips.ForeignPpmFormat`, format to save in
    /// * `ascii`: `gboolean`, save as ASCII rather than binary
    /// * `bitdepth`: `gint`, bitdepth to save at
    ///
    /// Write a VIPS image to a file as PPM. It can write 1, 8, 16 or
    /// 32 bit unsigned integer images, float images, colour or monochrome,
    /// stored as binary or ASCII.
    /// Integer images of more than 8 bits can only be stored in ASCII.
    ///
    /// When writing float (PFM) images the scale factor is set from the
    /// "pfm-scale" metadata.
    ///
    /// Set `ascii` to `TRUE` to write as human-readable ASCII. Normally data is
    /// written in binary.
    ///
    /// Set `bitdepth` to 1 to write a one-bit image.
    ///
    /// `format` defaults to the sub-type for this filename suffix.
    ///
    /// See also: `vips.Image.writeToFile`.
    extern fn vips_ppmsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const ppmsave = vips_ppmsave;

    /// Optional arguments:
    ///
    /// * `format`: `vips.ForeignPpmFormat`, format to save in
    /// * `ascii`: `gboolean`, save as ASCII rather than binary
    /// * `bitdepth`: `gint`, bitdepth to save at
    ///
    /// As `vips.Image.ppmsave`, but save to a target.
    ///
    /// See also: `vips.Image.ppmsave`.
    extern fn vips_ppmsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const ppmsaveTarget = vips_ppmsave_target;

    /// Optional arguments:
    ///
    /// * `max_alpha`: `gdouble`, maximum value for alpha
    ///
    /// Premultiplies any alpha channel.
    /// The final band is taken to be the alpha
    /// and the bands are transformed as:
    ///
    /// ```
    ///   alpha = clip(0, in[in.bands - 1], `max_alpha`);
    ///   norm = alpha / `max_alpha`;
    ///   out = [in[0] * norm, ..., in[in.bands - 1] * norm, alpha];
    /// ```
    ///
    /// So for an N-band image, the first N - 1 bands are multiplied by the clipped
    /// and normalised final band, the final band is clipped.
    /// If there is only a single band,
    /// the image is passed through unaltered.
    ///
    /// The result is
    /// `VIPS_FORMAT_FLOAT` unless the input format is `VIPS_FORMAT_DOUBLE`, in which
    /// case the output is double as well.
    ///
    /// `max_alpha` has the default value 255, or 65535 for images tagged as
    /// `VIPS_INTERPRETATION_RGB16` or
    /// `VIPS_INTERPRETATION_GREY16`.
    ///
    /// Non-complex images only.
    ///
    /// See also: `vips.Image.unpremultiply`, `vips.Image.flatten`.
    extern fn vips_premultiply(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const premultiply = vips_premultiply;

    /// Prewitt edge detector.
    ///
    /// uchar images are computed using a fast, low-precision path. Cast to float
    /// for a high-precision implementation.
    ///
    /// See also: `vips.Image.canny`, `vips.Image.sobel`, `vips.Image.prewitt`, `vips.Image.scharr`.
    extern fn vips_prewitt(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const prewitt = vips_prewitt;

    /// Prints field `name` to stdout as ASCII. Handy for debugging.
    extern fn vips_image_print_field(p_image: *const Image, p_name: [*:0]const u8) void;
    pub const printField = vips_image_print_field;

    /// `vips.Image.profile` searches inward from the edge of `in` and finds the
    /// first non-zero pixel. Pixels in `columns` have the distance from the top edge
    /// to the first non-zero pixel in that column, `rows` has the distance from the
    /// left edge to the first non-zero pixel in that row.
    ///
    /// See also: `vips.Image.project`, `vips.Image.histFind`.
    extern fn vips_profile(p_in: *Image, p_columns: **vips.Image, p_rows: **vips.Image, ...) c_int;
    pub const profile = vips_profile;

    /// Find the horizontal and vertical projections of an image, ie. the sum
    /// of every row of pixels, and the sum of every column of pixels. The output
    /// format is uint, int or double, depending on the input format.
    ///
    /// Non-complex images only.
    ///
    /// See also: `vips.Image.histFind`, `vips.Image.profile`.
    extern fn vips_project(p_in: *Image, p_columns: **vips.Image, p_rows: **vips.Image, ...) c_int;
    pub const project = vips_project;

    /// Optional arguments:
    ///
    /// * `interpolate`: use this interpolator (default bilinear)
    ///
    /// This operation is unfinished and unusable, sorry.
    ///
    /// See also: `vips.Image.affine`.
    extern fn vips_quadratic(p_in: *Image, p_out: **vips.Image, p_coeff: *vips.Image, ...) c_int;
    pub const quadratic = vips_quadratic;

    /// Unpack a RAD (`VIPS_CODING_RAD`) image to a three-band float image.
    ///
    /// See also: `vips.Image.float2rad`, `vips.Image.LabQ2LabS`.
    extern fn vips_rad2float(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const rad2float = vips_rad2float;

    /// Write a VIPS image in Radiance (HDR) format.
    ///
    /// Sections of this reader from Greg Ward and Radiance with kind permission.
    ///
    /// See also: `vips.Image.writeToFile`.
    extern fn vips_radsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const radsave = vips_radsave;

    /// As `vips.Image.radsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.radsave`, `vips.Image.writeToFile`.
    extern fn vips_radsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const radsaveBuffer = vips_radsave_buffer;

    /// As `vips.Image.radsave`, but save to a target.
    ///
    /// See also: `vips.Image.radsave`.
    extern fn vips_radsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const radsaveTarget = vips_radsave_target;

    /// `vips.Image.rank` does rank filtering on an image. A window of size `width` by
    /// `height` is passed over the image. At each position, the pixels inside the
    /// window are sorted into ascending order and the pixel at position `index` is
    /// output. `index` numbers from 0.
    ///
    /// It works for any non-complex image type, with any number of bands.
    /// The input is expanded by copying edge pixels before performing the
    /// operation so that the output image has the same size as the input.
    /// Edge pixels in the output image are therefore only approximate.
    ///
    /// For a median filter with mask size m (3 for 3x3, 5 for 5x5, etc.) use
    ///
    ///  vips_rank(in, out, m, m, m * m / 2);
    ///
    /// The special cases n == 0 and n == m * m - 1 are useful dilate and
    /// expand operators.
    ///
    /// See also: `vips.Image.conv`, `vips.Image.median`, `vips.Image.spcor`.
    extern fn vips_rank(p_in: *Image, p_out: **vips.Image, p_width: c_int, p_height: c_int, p_index: c_int, ...) c_int;
    pub const rank = vips_rank;

    /// Writes the pixels in `in` to the file `filename` with no header or other
    /// metadata.
    ///
    /// See also: `vips.Image.writeToFile`.
    extern fn vips_rawsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const rawsave = vips_rawsave;

    /// As `vips.Image.rawsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.rawsave`, `vips.Image.writeToMemory`, `vips.Image.writeToFile`.
    extern fn vips_rawsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const rawsaveBuffer = vips_rawsave_buffer;

    /// As `vips.Image.rawsave`, but save to a target.
    ///
    /// See also: `vips.Image.rawsave`.
    extern fn vips_rawsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const rawsaveTarget = vips_rawsave_target;

    /// Perform `VIPS_OPERATION_COMPLEXGET_REAL` on an image. See `vips.Image.complexget`.
    extern fn vips_real(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const real = vips_real;

    /// This operation recombines an image's bands. Each pixel in `in` is treated as
    /// an n-element vector, where n is the number of bands in `in`, and multiplied by
    /// the n x m matrix `m` to produce the m-band image `out`.
    ///
    /// `out` is always float, unless `in` is double, in which case `out` is double
    /// too. No complex images allowed.
    ///
    /// It's useful for various sorts of colour space conversions.
    ///
    /// See also: `vips.Image.bandmean`.
    extern fn vips_recomb(p_in: *Image, p_out: **vips.Image, p_m: *vips.Image, ...) c_int;
    pub const recomb = vips_recomb;

    /// Perform `VIPS_OPERATION_COMPLEX_RECT` on an image. See `vips.Image.complex`.
    extern fn vips_rect(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const rect = vips_rect;

    /// Optional arguments:
    ///
    /// * `kernel`: `vips.Kernel` to use to interpolate (default: lanczos3)
    /// * `gap`: reducing gap to use (default: 0.0)
    ///
    /// Reduce `in` by a pair of factors with a pair of 1D kernels. This
    /// will not work well for shrink factors greater than three.
    ///
    /// Set `gap` to speed up reducing by having `vips.Image.shrink` to shrink
    /// with a box filter first. The bigger `gap`, the closer the result
    /// to the fair resampling. The smaller `gap`, the faster resizing.
    /// The default value is 0.0 (no optimization).
    ///
    /// This is a very low-level operation: see `vips.Image.resize` for a more
    /// convenient way to resize images.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.shrink`, `vips.Image.resize`, `vips.Image.affine`.
    extern fn vips_reduce(p_in: *Image, p_out: **vips.Image, p_hshrink: f64, p_vshrink: f64, ...) c_int;
    pub const reduce = vips_reduce;

    /// Optional arguments:
    ///
    /// * `kernel`: `vips.Kernel` to use to interpolate (default: lanczos3)
    /// * `gap`: reducing gap to use (default: 0.0)
    ///
    /// Reduce `in` horizontally by a float factor. The pixels in `out` are
    /// interpolated with a 1D mask generated by `kernel`.
    ///
    /// Set `gap` to speed up reducing by having `vips.Image.shrinkh` to shrink
    /// with a box filter first. The bigger `gap`, the closer the result
    /// to the fair resampling. The smaller `gap`, the faster resizing.
    /// The default value is 0.0 (no optimization).
    ///
    /// This is a very low-level operation: see `vips.Image.resize` for a more
    /// convenient way to resize images.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.shrink`, `vips.Image.resize`, `vips.Image.affine`.
    extern fn vips_reduceh(p_in: *Image, p_out: **vips.Image, p_hshrink: f64, ...) c_int;
    pub const reduceh = vips_reduceh;

    /// Optional arguments:
    ///
    /// * `kernel`: `vips.Kernel` to use to interpolate (default: lanczos3)
    /// * `gap`: reducing gap to use (default: 0.0)
    ///
    /// Reduce `in` vertically by a float factor. The pixels in `out` are
    /// interpolated with a 1D mask generated by `kernel`.
    ///
    /// Set `gap` to speed up reducing by having `vips.Image.shrinkv` to shrink
    /// with a box filter first. The bigger `gap`, the closer the result
    /// to the fair resampling. The smaller `gap`, the faster resizing.
    /// The default value is 0.0 (no optimization).
    ///
    /// This is a very low-level operation: see `vips.Image.resize` for a more
    /// convenient way to resize images.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.shrink`, `vips.Image.resize`, `vips.Image.affine`.
    extern fn vips_reducev(p_in: *Image, p_out: **vips.Image, p_vshrink: f64, ...) c_int;
    pub const reducev = vips_reducev;

    /// Perform various relational operations on an image and an array of
    /// constants.
    ///
    /// The output type is always uchar, with 0 for FALSE and 255 for TRUE.
    ///
    /// If the array of constants has just one element, that constant is used for
    /// all image bands. If the array has more than one element and they have
    /// the same number of elements as there are bands in the image, then
    /// one array element is used for each band. If the arrays have more than one
    /// element and the image only has a single band, the result is a many-band
    /// image where each band corresponds to one array element.
    ///
    /// See also: `vips.boolean`, `vips.relational`.
    extern fn vips_relational_const(p_in: *Image, p_out: **vips.Image, p_relational: vips.OperationRelational, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const relationalConst = vips_relational_const;

    /// Perform various relational operations on an image and a constant. See
    /// `vips.Image.relationalConst`.
    ///
    /// See also: `vips.boolean`, `vips.relational`.
    extern fn vips_relational_const1(p_in: *Image, p_out: **vips.Image, p_relational: vips.OperationRelational, p_c: f64, ...) c_int;
    pub const relationalConst1 = vips_relational_const1;

    /// This operation calculates `in` % `c` (remainder after division by an
    /// array of constants)
    /// and writes the result to `out`.
    /// The image may have any
    /// non-complex format. For float formats, `vips.Image.remainderConst` calculates
    /// `in` - `c` * floor (`in` / `c`).
    ///
    /// If the array of constants has just one element, that constant is used for
    /// all image bands. If the array has more than one element and they have
    /// the same number of elements as there are bands in the image, then
    /// one array element is used for each band. If the arrays have more than one
    /// element and the image only has a single band, the result is a many-band
    /// image where each band corresponds to one array element.
    ///
    /// See also: `vips.remainder`, `vips.divide`, `vips.Image.round`.
    extern fn vips_remainder_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const remainderConst = vips_remainder_const;

    /// This operation calculates `in` % `c` (remainder after division by a
    /// constant)
    /// and writes the result to `out`.
    /// The image may have any
    /// non-complex format. For float formats, `vips.Image.remainderConst` calculates
    /// `in` - `c` * floor (`in` / `c`).
    ///
    /// If the array of constants has just one element, that constant is used for
    /// all image bands. If the array has more than one element and they have
    /// the same number of elements as there are bands in the image, then
    /// one array element is used for each band. If the arrays have more than one
    /// element and the image only has a single band, the result is a many-band
    /// image where each band corresponds to one array element.
    ///
    /// See also: `vips.remainder`, `vips.divide`, `vips.Image.round`.
    extern fn vips_remainder_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const remainderConst1 = vips_remainder_const1;

    /// `vips.Image.remosaic` works rather as `vips.Image.globalbalance`. It takes apart the
    /// mosaiced image `in` and rebuilds it, substituting images.
    ///
    /// Unlike `vips.Image.globalbalance`, images are substituted based on their file‐
    /// names.  The  rightmost  occurrence  of the string `old_str` is swapped
    /// for `new_str`, that file is opened, and that image substituted  for
    /// the old image.
    ///
    /// It's convenient for multispectral images. You can mosaic one band, then
    /// use that mosaic as a template for mosaicing the others automatically.
    ///
    /// See also: `vips.Image.globalbalance`.
    extern fn vips_remosaic(p_in: *Image, p_out: **vips.Image, p_old_str: [*:0]const u8, p_new_str: [*:0]const u8, ...) c_int;
    pub const remosaic = vips_remosaic;

    /// Find and remove an item of metadata. Return `FALSE` if no metadata of that
    /// name was found.
    ///
    /// See also: `vips.Image.set`, `vips.Image.getTypeof`.
    extern fn vips_image_remove(p_image: *Image, p_name: [*:0]const u8) c_int;
    pub const remove = vips_image_remove;

    /// `vips.Image.reorderMarginHint` sets a hint that `image` contains a margin, that
    /// is, that each `vips.Region.prepare` on `image` will request a slightly larger
    /// region from it's inputs. A good value for `margin` is (width * height) for
    /// the window the operation uses.
    ///
    /// This information is used by `vips_image_prepare_many` to attempt to reorder
    /// computations to minimise recomputation.
    ///
    /// See also: `vips_image_prepare_many`.
    extern fn vips_reorder_margin_hint(p_image: *Image, p_margin: c_int) void;
    pub const reorderMarginHint = vips_reorder_margin_hint;

    /// `vips.Image.reorderPrepareMany` runs `vips.Region.prepare` on each region in
    /// `regions`, requesting the pixels in `r`.
    ///
    /// It tries to request the regions in the order which will cause least
    /// recomputation. This can give a large speedup, in some cases.
    ///
    /// See also: `vips.Region.prepare`, `vips.Image.reorderMarginHint`.
    extern fn vips_reorder_prepare_many(p_image: *Image, p_regions: [*]*vips.Region, p_r: *vips.Rect) c_int;
    pub const reorderPrepareMany = vips_reorder_prepare_many;

    /// Repeats an image many times.
    ///
    /// See also: `vips.Image.extractArea`.
    extern fn vips_replicate(p_in: *Image, p_out: **vips.Image, p_across: c_int, p_down: c_int, ...) c_int;
    pub const replicate = vips_replicate;

    /// Optional arguments:
    ///
    /// * `vscale`: `gdouble` vertical scale factor
    /// * `kernel`: `vips.Kernel` to reduce with
    /// * `gap`: reducing gap to use (default: 2.0)
    ///
    /// Resize an image.
    ///
    /// Set `gap` to speed up downsizing by having `vips.Image.shrink` to shrink
    /// with a box filter first. The bigger `gap`, the closer the result
    /// to the fair resampling. The smaller `gap`, the faster resizing.
    /// The default value is 2.0 (very close to fair resampling
    /// while still being faster in many cases).
    ///
    /// `vips.Image.resize` normally uses `VIPS_KERNEL_LANCZOS3` for the final reduce, you
    /// can change this with `kernel`. Downsizing is done with centre convention.
    ///
    /// When upsizing (`scale` > 1), the operation uses `vips.Image.affine` with
    /// a `vips.Interpolate` selected depending on `kernel`. It will use
    /// `VipsInterpolateBicubic` for `VIPS_KERNEL_CUBIC` and above. It adds a
    /// 0.5 pixel displacement to the input pixels to get centre convention scaling.
    ///
    /// `vips.Image.resize` normally maintains the image aspect ratio. If you set
    /// `vscale`, that factor is used for the vertical scale and `scale` for the
    /// horizontal.
    ///
    /// If either axis would drop below 1px in size, the shrink in that dimension
    /// is limited. This breaks the image aspect ratio, but prevents errors due to
    /// fractional pixel sizes.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// This operation does not premultiply alpha. If your image has an alpha
    /// channel, you should use `vips.Image.premultiply` on it first.
    ///
    /// See also: `vips.Image.premultiply`, `vips.Image.shrink`, `vips.Image.reduce`.
    extern fn vips_resize(p_in: *Image, p_out: **vips.Image, p_scale: f64, ...) c_int;
    pub const resize = vips_resize;

    /// Round to an integral value with `VIPS_OPERATION_ROUND_RINT`. See
    /// `vips.Image.round`.
    extern fn vips_rint(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const rint = vips_rint;

    /// Rotate `in` by a multiple of 90 degrees.
    ///
    /// Use `vips.Image.similarity` to rotate by an arbitrary angle. `vips.Image.rot45` is
    /// useful for rotating convolution masks by 45 degrees.
    ///
    /// See also: `vips.Image.flip`, `vips.Image.similarity`, `vips.Image.rot45`.
    extern fn vips_rot(p_in: *Image, p_out: **vips.Image, p_angle: vips.Angle, ...) c_int;
    pub const rot = vips_rot;

    /// Rotate `in` by 180 degrees. A convenience function over `vips.Image.rot`.
    ///
    /// See also: `vips.Image.rot`.
    extern fn vips_rot180(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const rot180 = vips_rot180;

    /// Rotate `in` by 270 degrees clockwise. A convenience function over `vips.Image.rot`.
    ///
    /// See also: `vips.Image.rot`.
    extern fn vips_rot270(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const rot270 = vips_rot270;

    /// Optional arguments:
    ///
    /// * `angle`: `vips.Angle45` rotation angle
    ///
    /// Rotate `in` by a multiple of 45 degrees. Odd-length sides and square images
    /// only.
    ///
    /// This operation is useful for rotating convolution masks. Use
    /// `vips.Image.similarity` to rotate images by arbitrary angles.
    ///
    /// See also: `vips.Image.rot`, `vips.Image.similarity`.
    extern fn vips_rot45(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const rot45 = vips_rot45;

    /// Optional arguments:
    ///
    /// * `interpolate`: `vips.Interpolate`, interpolate pixels with this
    /// * `background`: `vips.ArrayDouble` colour for new pixels
    /// * `idx`: `gdouble`, input horizontal offset
    /// * `idy`: `gdouble`, input vertical offset
    /// * `odx`: `gdouble`, output horizontal offset
    /// * `ody`: `gdouble`, output vertical offset
    ///
    /// This operator calls `vips.Image.affine` for you, calculating the matrix for the
    /// affine transform from `scale` and `angle`. Other parameters are passed on to
    /// `vips.Image.affine` unaltered.
    ///
    /// See also: `vips.Image.affine`, `vips.Interpolate`.
    extern fn vips_rotate(p_in: *Image, p_out: **vips.Image, p_angle: f64, ...) c_int;
    pub const rotate = vips_rotate;

    /// Round to an integral value.
    ///
    /// Copy for integer types, round float and
    /// complex types.
    ///
    /// The format of `out` is always the same as `in`, so you may wish to cast to an
    /// integer format afterwards.
    ///
    /// See also: `vips.Image.cast`
    extern fn vips_round(p_in: *Image, p_out: **vips.Image, p_round: vips.OperationRound, ...) c_int;
    pub const round = vips_round;

    /// Perform `VIPS_OPERATION_BOOLEAN_LSHIFT` on an image and an array of constants.
    /// See `vips.Image.booleanConst`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst1`.
    extern fn vips_rshift_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const rshiftConst = vips_rshift_const;

    /// Perform `VIPS_OPERATION_BOOLEAN_RSHIFT` on an image and a constant.
    /// See `vips.Image.booleanConst1`.
    ///
    /// See also: `vips.boolean`, `vips.Image.booleanConst`.
    extern fn vips_rshift_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const rshiftConst1 = vips_rshift_const1;

    /// Convert to HSV.
    ///
    /// HSV is a crude polar coordinate system for RGB images. It is provided for
    /// compatibility with other image processing systems. See `vips.Image.Lab2LCh` for a
    /// much better colour space.
    ///
    /// See also: `vips.Image.HSV2sRGB`, `vips.Image.Lab2LCh`.
    extern fn vips_sRGB2HSV(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sRGB2HSV = vips_sRGB2HSV;

    /// Convert an sRGB image to scRGB. The input image can be 8 or 16-bit.
    ///
    /// If the input image is tagged as `VIPS_INTERPRETATION_RGB16`, any extra
    /// channels after RGB are divided by 256. Thus, scRGB alpha is
    /// always 0 - 255.99.
    ///
    /// See also: `vips.Image.scRGB2XYZ`, `vips.Image.scRGB2sRGB`, `vips.Image.rad2float`.
    extern fn vips_sRGB2scRGB(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sRGB2scRGB = vips_sRGB2scRGB;

    /// Optional arguments:
    ///
    /// * `depth`: depth of output image in bits
    ///
    /// Convert an scRGB image to greyscale. Set `depth` to 16 to get 16-bit output.
    ///
    /// If `depth` is 16, any extra channels after RGB are
    /// multiplied by 256.
    ///
    /// See also: `vips.Image.LabS2LabQ`, `vips.Image.sRGB2scRGB`, `vips.Image.rad2float`.
    extern fn vips_scRGB2BW(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const scRGB2BW = vips_scRGB2BW;

    /// Turn XYZ to scRGB.
    extern fn vips_scRGB2XYZ(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const scRGB2XYZ = vips_scRGB2XYZ;

    /// Optional arguments:
    ///
    /// * `depth`: depth of output image in bits
    ///
    /// Convert an scRGB image to sRGB. Set `depth` to 16 to get 16-bit output.
    ///
    /// If `depth` is 16, any extra channels after RGB are
    /// multiplied by 256.
    ///
    /// See also: `vips.Image.LabS2LabQ`, `vips.Image.sRGB2scRGB`, `vips.Image.rad2float`.
    extern fn vips_scRGB2sRGB(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const scRGB2sRGB = vips_scRGB2sRGB;

    /// Optional arguments:
    ///
    /// * `log`: log scale pixels
    /// * `exp`: exponent for log scale
    ///
    /// Search the image for the maximum and minimum value, then return the image
    /// as unsigned 8-bit, scaled so that the maximum value is 255 and the
    /// minimum is zero.
    ///
    /// If `log` is set, transform with log10(1.0 + pow(x, `exp`)) + .5,
    /// then scale so max == 255. By default, `exp` is 0.25.
    ///
    /// See also: `vips.Image.cast`.
    extern fn vips_scale(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const scale = vips_scale;

    /// Scharr edge detector.
    ///
    /// uchar images are computed using a fast, low-precision path. Cast to float
    /// for a high-precision implementation.
    ///
    /// See also: `vips.Image.canny`, `vips.Image.sobel`, `vips.Image.prewitt`, `vips.Image.scharr`.
    extern fn vips_scharr(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const scharr = vips_scharr;

    /// Optional arguments:
    ///
    /// * `tile_height`: height of cache strips
    ///
    /// This operation behaves rather like `vips.Image.copy` between images
    /// `in` and `out`, except that it checks that pixels on `in` are only requested
    /// top-to-bottom. This operation is useful for loading file formats which are
    /// strictly top-to-bottom, like PNG.
    ///
    /// `tile_height` can be used to set the size of the tiles that
    /// `vips.Image.sequential` uses. The default value is 1.
    ///
    /// See also: `vips_cache`, `vips.Image.linecache`, `vips.Image.tilecache`.
    extern fn vips_sequential(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sequential = vips_sequential;

    /// Set a piece of metadata on `image`. Any old metadata with that name is
    /// destroyed. The `gobject.Value` is copied into the image, so you need to unset the
    /// value when you're done with it.
    ///
    /// For example, to set an integer on an image (though you would use the
    /// convenience function `vips.Image.setInt` in practice), you would do:
    ///
    /// ```
    /// GValue value = G_VALUE_INIT;
    ///
    /// g_value_init(&value, G_TYPE_INT);
    /// g_value_set_int(&value, 42);
    /// vips_image_set(image, name, &value);
    /// g_value_unset(&value);
    /// ```
    ///
    /// See also: `vips.Image.get`.
    extern fn vips_image_set(p_image: *Image, p_name: [*:0]const u8, p_value: *gobject.Value) void;
    pub const set = vips_image_set;

    /// Attaches `data` as a metadata item on `image` under the name `name`. When
    /// VIPS no longer needs the metadata, it will be freed with `free_fn`.
    ///
    /// See also: `vips.Image.getDouble`, `vips.Image.set`
    extern fn vips_image_set_area(p_image: *Image, p_name: [*:0]const u8, p_free_fn: ?vips.CallbackFn, p_data: ?*anyopaque) void;
    pub const setArea = vips_image_set_area;

    /// Attaches `array` as a metadata item on `image` as `name`.
    /// A convenience function over `vips.Image.set`.
    ///
    /// See also: `vips.Image.getImage`, `vips.Image.set`.
    extern fn vips_image_set_array_double(p_image: *Image, p_name: [*:0]const u8, p_array: ?[*]const f64, p_n: c_int) void;
    pub const setArrayDouble = vips_image_set_array_double;

    /// Attaches `array` as a metadata item on `image` as `name`.
    /// A convenience function over `vips.Image.set`.
    ///
    /// See also: `vips.Image.getImage`, `vips.Image.set`.
    extern fn vips_image_set_array_int(p_image: *Image, p_name: [*:0]const u8, p_array: ?[*]const c_int, p_n: c_int) void;
    pub const setArrayInt = vips_image_set_array_int;

    /// Attaches `data` as a metadata item on `image` under the name `name`.
    ///
    /// See also: `vips.Image.getBlob`, `vips.Image.set`.
    extern fn vips_image_set_blob(p_image: *Image, p_name: [*:0]const u8, p_free_fn: ?vips.CallbackFn, p_data: [*]u8, p_length: usize) void;
    pub const setBlob = vips_image_set_blob;

    /// Attaches `data` as a metadata item on `image` under the name `name`, taking
    /// a copy of the memory area.
    ///
    /// See also: `vips.Image.getBlob`, `vips.Image.set`.
    extern fn vips_image_set_blob_copy(p_image: *Image, p_name: [*:0]const u8, p_data: [*]u8, p_length: usize) void;
    pub const setBlobCopy = vips_image_set_blob_copy;

    /// Sets the delete_on_close flag for the image. If this flag is set, when
    /// `image` is finalized, the filename held in `image`->filename at the time of
    /// this call is deleted.
    ///
    /// This function is clearly extremely dangerous, use with great caution.
    ///
    /// See also: `vips.Image.newTempFile`.
    extern fn vips_image_set_delete_on_close(p_image: *Image, p_delete_on_close: c_int) void;
    pub const setDeleteOnClose = vips_image_set_delete_on_close;

    /// Attaches `d` as a metadata item on `image` as `name`. A
    /// convenience
    /// function over `vips.Image.set`.
    ///
    /// See also: `vips.Image.getDouble`, `vips.Image.set`
    extern fn vips_image_set_double(p_image: *Image, p_name: [*:0]const u8, p_d: f64) void;
    pub const setDouble = vips_image_set_double;

    /// Attaches `im` as a metadata item on `image` as `name`.
    /// A convenience function over `vips.Image.set`.
    ///
    /// See also: `vips.Image.getImage`, `vips.Image.set`.
    extern fn vips_image_set_image(p_image: *Image, p_name: [*:0]const u8, p_im: *vips.Image) void;
    pub const setImage = vips_image_set_image;

    /// Attaches `i` as a metadata item on `image` under the name `name`. A
    /// convenience
    /// function over `vips.Image.set`.
    ///
    /// See also: `vips.Image.getInt`, `vips.Image.set`
    extern fn vips_image_set_int(p_image: *Image, p_name: [*:0]const u8, p_i: c_int) void;
    pub const setInt = vips_image_set_int;

    /// Set the `vips.Image.kill` flag on an image. Handy for stopping sets of
    /// threads.
    ///
    /// See also: `vips.Image.iskilled`.
    extern fn vips_image_set_kill(p_image: *Image, p_kill: c_int) void;
    pub const setKill = vips_image_set_kill;

    /// vips signals evaluation progress via the `vips.Image.signals.preeval`,
    /// `vips.Image.signals.eval` and `vips.Image.signals.posteval`
    /// signals. Progress is signalled on the most-downstream image for which
    /// `vips.Image.setProgress` was called.
    extern fn vips_image_set_progress(p_image: *Image, p_progress: c_int) void;
    pub const setProgress = vips_image_set_progress;

    /// Attaches `str` as a metadata item on `image` as `name`.
    /// A convenience
    /// function over `vips.Image.set` using `VIPS_TYPE_REF_STRING`.
    ///
    /// See also: `vips.Image.getDouble`, `vips.Image.set`.
    extern fn vips_image_set_string(p_image: *Image, p_name: [*:0]const u8, p_str: [*:0]const u8) void;
    pub const setString = vips_image_set_string;

    /// Optional arguments:
    ///
    /// * `sigma`: sigma of gaussian
    /// * `x1`: flat/jaggy threshold
    /// * `y2`: maximum amount of brightening
    /// * `y3`: maximum amount of darkening
    /// * `m1`: slope for flat areas
    /// * `m2`: slope for jaggy areas
    ///
    /// Selectively sharpen the L channel of a LAB image. The input image is
    /// transformed to `VIPS_INTERPRETATION_LABS`.
    ///
    /// The operation performs a gaussian blur and subtracts from `in` to generate a
    /// high-frequency signal. This signal is passed through a lookup table formed
    /// from the five parameters and added back to `in`.
    ///
    /// The lookup table is formed like this:
    ///
    /// ```
    /// .                     ^
    /// .                  y2 |- - - - - -----------
    /// .                     |         /
    /// .                     |        / slope m2
    /// .                     |    .../
    /// .             -x1     | ...   |
    /// . -------------------...---------------------->
    /// .             |   ... |      x1
    /// .             |... slope m1
    /// .             /       |
    /// .            / m2     |
    /// .           /         |
    /// .          /          |
    /// .         /           |
    /// .        /            |
    /// . ______/ _ _ _ _ _ _ | -y3
    /// .                     |
    /// ```
    ///
    /// For screen output, we suggest the following settings (the defaults):
    ///
    /// ```
    ///   sigma == 0.5
    ///   x1 == 2
    ///   y2 == 10         (don't brighten by more than 10 L*)
    ///   y3 == 20         (can darken by up to 20 L*)
    ///   m1 == 0          (no sharpening in flat areas)
    ///   m2 == 3          (some sharpening in jaggy areas)
    /// ```
    ///
    /// If you want more or less sharpening, we suggest you just change the
    /// m2 parameter.
    ///
    /// The `sigma` parameter changes the width of the fringe and can be
    /// adjusted according to the output printing resolution. As an approximate
    /// guideline, use 0.5 for 4 pixels/mm (display resolution),
    /// 1.0 for 12 pixels/mm and 1.5 for 16 pixels/mm (300 dpi == 12
    /// pixels/mm). These figures refer to the image raster, not the half-tone
    /// resolution.
    ///
    /// See also: `vips.Image.conv`.
    extern fn vips_sharpen(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sharpen = vips_sharpen;

    /// Optional arguments:
    ///
    /// * `ceil`: round-up output dimensions
    ///
    /// Shrink `in` by a pair of factors with a simple box filter. For non-integer
    /// factors, `vips.Image.shrink` will first shrink by the integer part with a box
    /// filter, then use `vips.Image.reduce` to shrink by the
    /// remaining fractional part.
    ///
    /// This is a very low-level operation: see `vips.Image.resize` for a more
    /// convenient way to resize images.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.resize`, `vips.Image.reduce`.
    extern fn vips_shrink(p_in: *Image, p_out: **vips.Image, p_hshrink: f64, p_vshrink: f64, ...) c_int;
    pub const shrink = vips_shrink;

    /// Optional arguments:
    ///
    /// * `ceil`: round-up output dimensions
    ///
    /// Shrink `in` horizontally by an integer factor. Each pixel in the output is
    /// the average of the corresponding line of `hshrink` pixels in the input.
    ///
    /// This is a very low-level operation: see `vips.Image.resize` for a more
    /// convenient way to resize images.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.shrinkv`, `vips.Image.shrink`, `vips.Image.resize`, `vips.Image.affine`.
    extern fn vips_shrinkh(p_in: *Image, p_out: **vips.Image, p_hshrink: c_int, ...) c_int;
    pub const shrinkh = vips_shrinkh;

    /// Optional arguments:
    ///
    /// * `ceil`: round-up output dimensions
    ///
    /// Shrink `in` vertically by an integer factor. Each pixel in the output is
    /// the average of the corresponding column of `vshrink` pixels in the input.
    ///
    /// This is a very low-level operation: see `vips.Image.resize` for a more
    /// convenient way to resize images.
    ///
    /// This operation does not change xres or yres. The image resolution needs to
    /// be updated by the application.
    ///
    /// See also: `vips.Image.shrinkh`, `vips.Image.shrink`, `vips.Image.resize`, `vips.Image.affine`.
    extern fn vips_shrinkv(p_in: *Image, p_out: **vips.Image, p_vshrink: c_int, ...) c_int;
    pub const shrinkv = vips_shrinkv;

    /// Finds the unit vector in the direction of the pixel value. For non-complex
    /// images, it returns a signed char image with values -1, 0, and 1 for negative,
    /// zero and positive pixels. For complex images, it returns a
    /// complex normalised to length 1.
    ///
    /// See also: `vips.Image.abs`.
    extern fn vips_sign(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sign = vips_sign;

    /// Optional arguments:
    ///
    /// * `scale`: `gdouble`, scale by this factor
    /// * `angle`: `gdouble`, rotate by this many degrees clockwise
    /// * `interpolate`: `vips.Interpolate`, interpolate pixels with this
    /// * `background`: `vips.ArrayDouble` colour for new pixels
    /// * `idx`: `gdouble`, input horizontal offset
    /// * `idy`: `gdouble`, input vertical offset
    /// * `odx`: `gdouble`, output horizontal offset
    /// * `ody`: `gdouble`, output vertical offset
    ///
    /// This operator calls `vips.Image.affine` for you, calculating the matrix for the
    /// affine transform from `scale` and `angle`. Other parameters are passed on to
    /// `vips.Image.affine` unaltered.
    ///
    /// See also: `vips.Image.affine`, `vips.Interpolate`.
    extern fn vips_similarity(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const similarity = vips_similarity;

    /// Perform `VIPS_OPERATION_MATH_SIN` on an image. See `vips.Image.math`.
    extern fn vips_sin(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sin = vips_sin;

    /// Perform `VIPS_OPERATION_MATH_SINH` on an image. See `vips.Image.math`.
    extern fn vips_sinh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sinh = vips_sinh;

    /// Optional arguments:
    ///
    /// * `interesting`: `vips.Interesting` to use to find interesting areas (default: `VIPS_INTERESTING_ATTENTION`)
    /// * `premultiplied`: `gboolean`, input image already has premultiplied alpha
    /// * `attention_x`: `gint`, horizontal position of attention centre when using attention based cropping
    /// * `attention_y`: `gint`, vertical position of attention centre when using attention based cropping
    ///
    /// Crop an image down to a specified width and height by removing boring parts.
    ///
    /// Use `interesting` to pick the method vips uses to decide which bits of the
    /// image should be kept.
    ///
    /// You can test xoffset / yoffset on `out` to find the location of the crop
    /// within the input image.
    ///
    /// See also: `vips.Image.extractArea`.
    extern fn vips_smartcrop(p_in: *Image, p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
    pub const smartcrop = vips_smartcrop;

    /// Sobel edge detector.
    ///
    /// uchar images are computed using a fast, low-precision path. Cast to float
    /// for a high-precision implementation.
    ///
    /// See also: `vips.Image.canny`, `vips.Image.sobel`, `vips.Image.prewitt`, `vips.Image.scharr`.
    extern fn vips_sobel(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const sobel = vips_sobel;

    /// Calculate a correlation surface.
    ///
    /// `ref` is placed at every position in `in` and the correlation coefficient
    /// calculated. The output
    /// image is always float.
    ///
    /// The output
    /// image is the same size as the input. Extra input edge pixels are made by
    /// copying the existing edges outwards.
    ///
    /// The correlation coefficient is calculated as:
    ///
    /// ```
    ///          sumij (ref(i,j)-mean(ref))(inkl(i,j)-mean(inkl))
    /// c(k,l) = ------------------------------------------------
    ///          sqrt(sumij (ref(i,j)-mean(ref))^2) *
    ///                      sqrt(sumij (inkl(i,j)-mean(inkl))^2)
    /// ```
    ///
    /// where inkl is the area of `in` centred at position (k,l).
    ///
    /// from Niblack "An Introduction to Digital Image Processing",
    /// Prentice/Hall, pp 138.
    ///
    /// If the number of bands differs, one of the images
    /// must have one band. In this case, an n-band image is formed from the
    /// one-band image by joining n copies of the one-band image together, and then
    /// the two n-band images are operated upon.
    ///
    /// The output image is always float, unless either of the two inputs is
    /// double, in which case the output is also double.
    ///
    /// See also: `vips.Image.fastcor`.
    extern fn vips_spcor(p_in: *Image, p_ref: *vips.Image, p_out: **vips.Image, ...) c_int;
    pub const spcor = vips_spcor;

    /// Make a displayable (ie. 8-bit unsigned int) power spectrum.
    ///
    /// If `in` is non-complex, it is transformed to Fourier space. Then the
    /// absolute value is passed through `vips.Image.scale` in log mode, and `vips.Image.wrap`.
    ///
    /// See also: `vips.Image.fwfft`, `vips.Image.scale`, `vips.Image.wrap`.
    extern fn vips_spectrum(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const spectrum = vips_spectrum;

    /// Find many image statistics in a single pass through the data. `out` is a
    /// one-band `VIPS_FORMAT_DOUBLE` image of at least 10 columns by n + 1
    /// (where n is number of bands in image `in`)
    /// rows. Columns are statistics, and are, in order: minimum, maximum, sum,
    /// sum of squares, mean, standard deviation, x coordinate of minimum, y
    /// coordinate of minimum, x coordinate of maximum, y coordinate of maximum.
    /// Later versions of `vips.Image.stats` may add more columns.
    ///
    /// Row 0 has statistics for all
    /// bands together, row 1 has stats for band 1, and so on.
    ///
    /// If there is more than one maxima or minima, one of them will be chosen at
    /// random.
    ///
    /// See also: `vips.Image.avg`, `vips.Image.min`.
    extern fn vips_stats(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const stats = vips_stats;

    /// Optional arguments:
    ///
    /// * `a`: weight of new mean
    /// * `m0`: target mean
    /// * `b`: weight of new deviation
    /// * `s0`: target deviation
    ///
    /// `vips.Image.stdif` performs statistical differencing according to the formula
    /// given in page 45 of the book "An Introduction to Digital Image
    /// Processing" by Wayne Niblack. This transformation emphasises the way in
    /// which a pel differs statistically from its neighbours. It is useful for
    /// enhancing low-contrast images with lots of detail, such as X-ray plates.
    ///
    /// At point (i,j) the output is given by the equation:
    ///
    /// ```
    /// vout(i,j) = `a` * `m0` + (1 - `a`) * meanv +
    ///       (vin(i,j) - meanv) * (`b` * `s0`) / (`s0` + `b` * stdv)
    /// ```
    ///
    /// Values `a`, `m0`, `b` and `s0` are entered, while meanv and stdv are the values
    /// calculated over a moving window of size `width`, `height` centred on pixel
    /// (i,j). `m0` is the new mean, `a` is the weight given to it. `s0` is the new
    /// standard deviation, `b` is the weight given to it.
    ///
    /// Try:
    ///
    /// ```
    /// vips stdif $VIPSHOME/pics/huysum.v fred.v 0.5 128 0.5 50 11 11
    /// ```
    ///
    /// The operation works on one-band uchar images only, and writes a one-band
    /// uchar image as its result. The output image has the same size as the
    /// input.
    ///
    /// See also: `vips.Image.histLocal`.
    extern fn vips_stdif(p_in: *Image, p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
    pub const stdif = vips_stdif;

    /// Optional arguments:
    ///
    /// * `point`: turn on point sample mode
    ///
    /// Subsample an image by an integer fraction. This is fast, nearest-neighbour
    /// shrink.
    ///
    /// For small horizontal shrinks, this operation will fetch lines of pixels
    /// from `in` and then subsample that line. For large shrinks it will fetch
    /// single pixels.
    ///
    /// If `point` is set, `in` will always be sampled in points. This can be faster
    /// if the previous operations in the pipeline are very slow.
    ///
    /// See also: `vips.Image.affine`, `vips.Image.shrink`, `vips.Image.zoom`.
    extern fn vips_subsample(p_in: *Image, p_out: **vips.Image, p_xfac: c_int, p_yfac: c_int, ...) c_int;
    pub const subsample = vips_subsample;

    /// Perform `VIPS_OPERATION_MATH_TAN` on an image. See `vips.Image.math`.
    extern fn vips_tan(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const tan = vips_tan;

    /// Perform `VIPS_OPERATION_MATH_TANH` on an image. See `vips.Image.math`.
    extern fn vips_tanh(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const tanh = vips_tanh;

    /// Optional arguments:
    ///
    /// * `height`: `gint`, target height in pixels
    /// * `size`: `vips.Size`, upsize, downsize, both or force
    /// * `no_rotate`: `gboolean`, don't rotate upright using orientation tag
    /// * `crop`: `vips.Interesting`, shrink and crop to fill target
    /// * `linear`: `gboolean`, perform shrink in linear light
    /// * `import_profile`: `gchararray`, fallback import ICC profile
    /// * `export_profile`: `gchararray`, export ICC profile
    /// * `intent`: `vips.Intent`, rendering intent
    /// * `fail_on`: `vips.FailOn`, load error types to fail on
    ///
    /// Exactly as `vips.thumbnail`, but read from an existing image.
    ///
    /// This operation
    /// is not able to exploit shrink-on-load features of image load libraries, so
    /// it can be much slower than ``vips.thumbnail`` and produce poorer quality
    /// output. Only use it if you really have to.
    ///
    /// See also: `vips.thumbnail`.
    extern fn vips_thumbnail_image(p_in: *Image, p_out: **vips.Image, p_width: c_int, ...) c_int;
    pub const thumbnailImage = vips_thumbnail_image;

    /// Optional arguments:
    ///
    /// * `compression`: use this `vips.ForeignTiffCompression`
    /// * `Q`: `gint` quality factor
    /// * `predictor`: use this `vips.ForeignTiffPredictor`
    /// * `tile`: `gboolean`, set `TRUE` to write a tiled tiff
    /// * `tile_width`: `gint` for tile size
    /// * `tile_height`: `gint` for tile size
    /// * `pyramid`: `gboolean`, write an image pyramid
    /// * `bitdepth`: `int`, change bit depth to 1,2, or 4 bit
    /// * `miniswhite`: `gboolean`, write 1-bit images as MINISWHITE
    /// * `resunit`: `vips.ForeignTiffResunit` for resolution unit
    /// * `xres`: `gdouble` horizontal resolution in pixels/mm
    /// * `yres`: `gdouble` vertical resolution in pixels/mm
    /// * `bigtiff`: `gboolean`, write a BigTiff file
    /// * `properties`: `gboolean`, set `TRUE` to write an IMAGEDESCRIPTION tag
    /// * `region_shrink`: `vips.RegionShrink` How to shrink each 2x2 region.
    /// * `level`: `gint`, Zstd or Deflate (zlib) compression level
    /// * `lossless`: `gboolean`, WebP lossless mode
    /// * `depth`: `vips.ForeignDzDepth` how deep to make the pyramid
    /// * `subifd`: `gboolean` write pyr layers as sub-ifds
    /// * `premultiply`: `gboolean` write premultiplied alpha
    ///
    /// Write a VIPS image to a file as TIFF.
    ///
    /// If `in` has the `VIPS_META_PAGE_HEIGHT` metadata item, this is assumed to be a
    /// "toilet roll" image. It will be
    /// written as series of pages, each `VIPS_META_PAGE_HEIGHT` pixels high.
    ///
    /// Use `compression` to set the tiff compression. Currently jpeg, packbits,
    /// fax4, lzw, none, deflate, webp and zstd are supported. The default is no
    /// compression.
    /// JPEG compression is a good lossy compressor for photographs, packbits is
    /// good for 1-bit images, and deflate is the best lossless compression TIFF
    /// can do.
    ///
    /// XYZ images are automatically saved as libtiff LOGLUV with SGILOG compression.
    /// Float LAB images are saved as float CIELAB. Set `bitdepth` to save as 8-bit
    /// CIELAB.
    ///
    /// Use `Q` to set the JPEG compression factor. Default 75.
    ///
    /// User `level` to set the ZSTD (1-22) or Deflate (1-9) compression level. Use `lossless` to
    /// set WEBP lossless mode on. Use `Q` to set the WEBP compression level.
    ///
    /// Use `predictor` to set the predictor for lzw, deflate and zstd compression.
    /// It defaults to `VIPS_FOREIGN_TIFF_PREDICTOR_HORIZONTAL`, meaning horizontal
    /// differencing. Please refer to the libtiff
    /// specifications for further discussion of various predictors.
    ///
    /// Set `tile` to TRUE to write a tiled tiff.  By default tiff are written in
    /// strips. Use `tile_width` and `tile_height` to set the tile size. The defaiult
    /// is 128 by 128.
    ///
    /// Set `pyramid` to write the image as a set of images, one per page, of
    /// decreasing size. Use `region_shrink` to set how images will be shrunk: by
    /// default each 2x2 block is just averaged, but you can set MODE or MEDIAN as
    /// well.
    ///
    /// By default, the pyramid stops when the image is small enough to fit in one
    /// tile. Use `depth` to stop when the image fits in one pixel, or to only write
    /// a single layer.
    ///
    /// Set `bitdepth` to save 8-bit uchar images as 1, 2 or 4-bit TIFFs.
    /// In case of depth 1: Values >128 are written as white, values <=128 as black.
    /// Normally vips will write MINISBLACK TIFFs where black is a 0 bit, but if you
    /// set `miniswhite`, it will use 0 for a white bit. Many pre-press applications
    /// only work with images which use this sense. `miniswhite` only affects one-bit
    /// images, it does nothing for greyscale images.
    /// In case of depth 2: The same holds but values < 64 are written as black.
    /// For 64 <= values < 128 they are written as dark grey, for 128 <= values < 192
    /// they are written as light gray and values above are written as white.
    /// In case `miniswhite` is set to true this behavior is inverted.
    /// In case of depth 4: values < 16 are written as black, and so on for the
    /// lighter shades. In case `miniswhite` is set to true this behavior is inverted.
    ///
    /// Use `resunit` to override the default resolution unit.
    /// The default
    /// resolution unit is taken from the header field
    /// `VIPS_META_RESOLUTION_UNIT`. If this field is not set, then
    /// VIPS defaults to cm.
    ///
    /// Use `xres` and `yres` to override the default horizontal and vertical
    /// resolutions. By default these values are taken from the VIPS image header.
    /// libvips resolution is always in pixels per millimetre.
    ///
    /// Set `bigtiff` to attempt to write a bigtiff. Bigtiff is a variant of the TIFF
    /// format that allows more than 4GB in a file.
    ///
    /// Set `properties` to write all vips metadata to the IMAGEDESCRIPTION tag as
    /// xml. If `properties` is not set, the value of `VIPS_META_IMAGEDESCRIPTION` is
    /// used instead.
    ///
    /// The value of `VIPS_META_XMP_NAME` is written to
    /// the XMP tag. `VIPS_META_ORIENTATION` (if set) is used to set the value of
    /// the orientation
    /// tag. `VIPS_META_IPTC` (if set) is used to set the value of the IPTC tag.
    /// `VIPS_META_PHOTOSHOP_NAME` (if set) is used to set the value of the PHOTOSHOP
    /// tag.
    ///
    /// By default, pyramid layers are saved as consecutive pages.
    /// Set `subifd` to save pyramid layers as sub-directories of the main image.
    /// Setting this option can improve compatibility with formats like OME.
    ///
    /// Set `premultiply` to save with premultiplied alpha. Some programs, such as
    /// InDesign, will only work with premultiplied alpha.
    ///
    /// See also: `vips.tiffload`, `vips.Image.writeToFile`.
    extern fn vips_tiffsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const tiffsave = vips_tiffsave;

    /// Optional arguments:
    ///
    /// * `compression`: use this `vips.ForeignTiffCompression`
    /// * `Q`: `gint` quality factor
    /// * `predictor`: use this `vips.ForeignTiffPredictor`
    /// * `tile`: `gboolean`, set `TRUE` to write a tiled tiff
    /// * `tile_width`: `gint` for tile size
    /// * `tile_height`: `gint` for tile size
    /// * `pyramid`: `gboolean`, write an image pyramid
    /// * `bitdepth`: `int`, set write bit depth to 1, 2, 4 or 8
    /// * `miniswhite`: `gboolean`, write 1-bit images as MINISWHITE
    /// * `resunit`: `vips.ForeignTiffResunit` for resolution unit
    /// * `xres`: `gdouble` horizontal resolution in pixels/mm
    /// * `yres`: `gdouble` vertical resolution in pixels/mm
    /// * `bigtiff`: `gboolean`, write a BigTiff file
    /// * `properties`: `gboolean`, set `TRUE` to write an IMAGEDESCRIPTION tag
    /// * `region_shrink`: `vips.RegionShrink` How to shrink each 2x2 region.
    /// * `level`: `gint`, Zstd or Deflate (zlib) compression level
    /// * `lossless`: `gboolean`, WebP lossless mode
    /// * `depth`: `vips.ForeignDzDepth` how deep to make the pyramid
    /// * `subifd`: `gboolean` write pyr layers as sub-ifds
    /// * `premultiply`: `gboolean` write premultiplied alpha
    ///
    /// As `vips.Image.tiffsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.tiffsave`, `vips.Image.writeToFile`.
    extern fn vips_tiffsave_buffer(p_in: *Image, p_buf: [*]*u8, p_len: *usize, ...) c_int;
    pub const tiffsaveBuffer = vips_tiffsave_buffer;

    /// Optional arguments:
    ///
    /// * `compression`: use this `vips.ForeignTiffCompression`
    /// * `Q`: `gint` quality factor
    /// * `predictor`: use this `vips.ForeignTiffPredictor`
    /// * `tile`: `gboolean`, set `TRUE` to write a tiled tiff
    /// * `tile_width`: `gint` for tile size
    /// * `tile_height`: `gint` for tile size
    /// * `pyramid`: `gboolean`, write an image pyramid
    /// * `bitdepth`: `int`, set write bit depth to 1, 2, 4 or 8
    /// * `miniswhite`: `gboolean`, write 1-bit images as MINISWHITE
    /// * `resunit`: `vips.ForeignTiffResunit` for resolution unit
    /// * `xres`: `gdouble` horizontal resolution in pixels/mm
    /// * `yres`: `gdouble` vertical resolution in pixels/mm
    /// * `bigtiff`: `gboolean`, write a BigTiff file
    /// * `properties`: `gboolean`, set `TRUE` to write an IMAGEDESCRIPTION tag
    /// * `region_shrink`: `vips.RegionShrink` How to shrink each 2x2 region.
    /// * `level`: `gint`, Zstd or Deflate (zlib) compression level
    /// * `lossless`: `gboolean`, WebP lossless mode
    /// * `depth`: `vips.ForeignDzDepth` how deep to make the pyramid
    /// * `subifd`: `gboolean` write pyr layers as sub-ifds
    /// * `premultiply`: `gboolean` write premultiplied alpha
    ///
    /// As `vips.Image.tiffsave`, but save to a target.
    ///
    /// See also: `vips.Image.tiffsave`, `vips.Image.writeToTarget`.
    extern fn vips_tiffsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const tiffsaveTarget = vips_tiffsave_target;

    /// Optional arguments:
    ///
    /// * `tile_width`: width of tiles in cache
    /// * `tile_height`: height of tiles in cache
    /// * `max_tiles`: maximum number of tiles to cache
    /// * `access`: hint expected access pattern `vips.Access`
    /// * `threaded`: allow many threads
    /// * `persistent`: don't drop cache at end of computation
    ///
    /// This operation behaves rather like `vips.Image.copy` between images
    /// `in` and `out`, except that it keeps a cache of computed pixels.
    /// This cache is made of up to `max_tiles` tiles (a value of -1
    /// means any number of tiles), and each tile is of size `tile_width`
    /// by `tile_height` pixels.
    ///
    /// Each cache tile is made with a single call to
    /// `vips.Region.prepare`.
    ///
    /// When the cache fills, a tile is chosen for reuse. If `access` is
    /// `VIPS_ACCESS_RANDOM`, then the least-recently-used tile is reused. If
    /// `access` is `VIPS_ACCESS_SEQUENTIAL`
    /// the top-most tile is reused.
    ///
    /// By default, `tile_width` and `tile_height` are 128 pixels, and the operation
    /// will cache up to 1,000 tiles. `access` defaults to `VIPS_ACCESS_RANDOM`.
    ///
    /// Normally, only a single thread at once is allowed to calculate tiles. If
    /// you set `threaded` to `TRUE`, `vips.Image.tilecache` will allow many threads to
    /// calculate tiles at once, and share the cache between them.
    ///
    /// Normally the cache is dropped when computation finishes. Set `persistent` to
    /// `TRUE` to keep the cache between computations.
    ///
    /// See also: `vips_cache`, `vips.Image.linecache`.
    extern fn vips_tilecache(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const tilecache = vips_tilecache;

    /// Optional arguments:
    ///
    /// * `page_height`: `gint`, size of each input page
    ///
    /// Transpose a volumetric image.
    ///
    /// Volumetric images are very tall, thin images, with the metadata item
    /// `VIPS_META_PAGE_HEIGHT` set to the height of each sub-image.
    ///
    /// This operation swaps the two major dimensions, so that page N in the
    /// output contains the Nth scanline, in order, from each input page.
    ///
    /// You can override the `VIPS_META_PAGE_HEIGHT` metadata item with the optional
    /// `page_height` parameter.
    ///
    /// `VIPS_META_PAGE_HEIGHT` in the output image is the number of pages in the
    /// input image.
    ///
    /// See also: `vips.Image.grid`.
    extern fn vips_transpose3d(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const transpose3d = vips_transpose3d;

    /// Optional arguments:
    ///
    /// * `max_alpha`: `gdouble`, maximum value for alpha
    /// * `alpha_band`: `gint`, band containing alpha data
    ///
    /// Unpremultiplies any alpha channel.
    /// Band `alpha_band` (by default the final band) contains the alpha and all
    /// other bands are transformed as:
    ///
    /// ```
    ///   alpha = (int) clip(0, in[in.bands - 1], `max_alpha`);
    ///   norm = (double) alpha / `max_alpha`;
    ///   if (alpha == 0)
    ///       out = [0, ..., 0, alpha];
    ///   else
    ///       out = [in[0] / norm, ..., in[in.bands - 1] / norm, alpha];
    /// ```
    ///
    /// So for an N-band image, the first N - 1 bands are divided by the clipped
    /// and normalised final band, the final band is clipped.
    /// If there is only a single band, the image is passed through unaltered.
    ///
    /// The result is
    /// `VIPS_FORMAT_FLOAT` unless the input format is `VIPS_FORMAT_DOUBLE`, in which
    /// case the output is double as well.
    ///
    /// `max_alpha` has the default value 255, or 65535 for images tagged as
    /// `VIPS_INTERPRETATION_RGB16` or
    /// `VIPS_INTERPRETATION_GREY16`.
    ///
    /// Non-complex images only.
    ///
    /// See also: `vips.Image.premultiply`, `vips.Image.flatten`.
    extern fn vips_unpremultiply(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const unpremultiply = vips_unpremultiply;

    /// Write `in` to `filename` in VIPS format.
    ///
    /// See also: `vips.vipsload`.
    extern fn vips_vipssave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const vipssave = vips_vipssave;

    /// As `vips.Image.vipssave`, but save to a target.
    extern fn vips_vipssave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const vipssaveTarget = vips_vipssave_target;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `preset`: `vips.ForeignWebpPreset`, choose lossy compression preset
    /// * `smart_subsample`: `gboolean`, enables high quality chroma subsampling
    /// * `smart_deblock`: `gboolean`, enables auto-adjusting of the deblocking filter
    /// * `near_lossless`: `gboolean`, preprocess in lossless mode (controlled by Q)
    /// * `alpha_q`: `gint`, set alpha quality in lossless mode
    /// * `effort`: `gint`, level of CPU effort to reduce file size
    /// * `target_size`: `gint`, desired target size in bytes
    /// * `passes`: `gint`, number of entropy-analysis passes
    /// * `min_size`: `gboolean`, minimise size
    /// * `mixed`: `gboolean`, allow both lossy and lossless encoding
    /// * `kmin`: `gint`, minimum number of frames between keyframes
    /// * `kmax`: `gint`, maximum number of frames between keyframes
    ///
    /// Write an image to a file in WebP format.
    ///
    /// By default, images are saved in lossy format, with
    /// `Q` giving the WebP quality factor. It has the range 0 - 100, with the
    /// default 75.
    ///
    /// Use `preset` to hint the image type to the lossy compressor. The default is
    /// `VIPS_FOREIGN_WEBP_PRESET_DEFAULT`.
    ///
    /// Set `smart_subsample` to enable high quality chroma subsampling.
    ///
    /// Set `smart_deblock` to enable auto-adjusting of the deblocking filter. This
    /// can improve image quality, especially on low-contrast edges, but encoding
    /// can take significantly longer.
    ///
    /// Use `alpha_q` to set the quality for the alpha channel in lossy mode. It has
    /// the range 1 - 100, with the default 100.
    ///
    /// Use `effort` to control how much CPU time to spend attempting to
    /// reduce file size. A higher value means more effort and therefore CPU time
    /// should be spent. It has the range 0-6 and a default value of 4.
    ///
    /// Use `target_size` to set the desired target size in bytes.
    ///
    /// Use `passes` to set the number of entropy-analysis passes, by default 1,
    /// unless `target_size` is set, in which case the default is 3. It is not
    /// recommended to set `passes` unless you set `target_size`. Doing so will
    /// result in longer encoding times for no benefit.
    ///
    /// Set `lossless` to use lossless compression, or combine `near_lossless`
    /// with `Q` 80, 60, 40 or 20 to apply increasing amounts of preprocessing
    /// which improves the near-lossless compression ratio by up to 50%.
    ///
    /// For animated webp output, `min_size` will try to optimize for minimum size.
    ///
    /// For animated webp output, `kmax` sets the maximum number of frames between
    /// keyframes. Setting 0 means only keyframes. `kmin` sets the minimum number of
    /// frames between frames. Setting 0 means no keyframes. By default, keyframes
    /// are disabled.
    ///
    /// For animated webp output, `mixed` tries to improve the file size by mixing
    /// both lossy and lossless encoding.
    ///
    /// Use the metadata items `loop` and `delay` to set the number of
    /// loops for the animation and the frame delays.
    ///
    /// See also: `vips.webpload`, `vips.Image.writeToFile`.
    extern fn vips_webpsave(p_in: *Image, p_filename: [*:0]const u8, ...) c_int;
    pub const webpsave = vips_webpsave;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `preset`: `vips.ForeignWebpPreset`, choose lossy compression preset
    /// * `smart_subsample`: `gboolean`, enables high quality chroma subsampling
    /// * `smart_deblock`: `gboolean`, enables auto-adjusting of the deblocking filter
    /// * `near_lossless`: `gboolean`, preprocess in lossless mode (controlled by Q)
    /// * `alpha_q`: `gint`, set alpha quality in lossless mode
    /// * `effort`: `gint`, level of CPU effort to reduce file size
    /// * `target_size`: `gint`, desired target size in bytes
    /// * `passes`: `gint`, number of entropy-analysis passes
    /// * `min_size`: `gboolean`, minimise size
    /// * `mixed`: `gboolean`, allow both lossy and lossless encoding
    /// * `kmin`: `gint`, minimum number of frames between keyframes
    /// * `kmax`: `gint`, maximum number of frames between keyframes
    ///
    /// As `vips.Image.webpsave`, but save to a memory buffer.
    ///
    /// The address of the buffer is returned in `buf`, the length of the buffer in
    /// `len`. You are responsible for freeing the buffer with `glib.free` when you
    /// are done with it.
    ///
    /// See also: `vips.Image.webpsave`.
    extern fn vips_webpsave_buffer(p_in: *Image, p_buf: *[*]u8, p_len: *usize, ...) c_int;
    pub const webpsaveBuffer = vips_webpsave_buffer;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `preset`: `vips.ForeignWebpPreset`, choose lossy compression preset
    /// * `smart_subsample`: `gboolean`, enables high quality chroma subsampling
    /// * `smart_deblock`: `gboolean`, enables auto-adjusting of the deblocking filter
    /// * `near_lossless`: `gboolean`, preprocess in lossless mode (controlled by Q)
    /// * `alpha_q`: `gint`, set alpha quality in lossless mode
    /// * `effort`: `gint`, level of CPU effort to reduce file size
    /// * `target_size`: `gint`, desired target size in bytes
    /// * `passes`: `gint`, number of entropy-analysis passes
    /// * `min_size`: `gboolean`, minimise size
    /// * `mixed`: `gboolean`, allow both lossy and lossless encoding
    /// * `kmin`: `gint`, minimum number of frames between keyframes
    /// * `kmax`: `gint`, maximum number of frames between keyframes
    ///
    /// As `vips.Image.webpsave`, but save as a mime webp on stdout.
    ///
    /// See also: `vips.Image.webpsave`, `vips.Image.writeToFile`.
    extern fn vips_webpsave_mime(p_in: *Image, ...) c_int;
    pub const webpsaveMime = vips_webpsave_mime;

    /// Optional arguments:
    ///
    /// * `Q`: `gint`, quality factor
    /// * `lossless`: `gboolean`, enables lossless compression
    /// * `preset`: `vips.ForeignWebpPreset`, choose lossy compression preset
    /// * `smart_subsample`: `gboolean`, enables high quality chroma subsampling
    /// * `smart_deblock`: `gboolean`, enables auto-adjusting of the deblocking filter
    /// * `near_lossless`: `gboolean`, preprocess in lossless mode (controlled by Q)
    /// * `alpha_q`: `gint`, set alpha quality in lossless mode
    /// * `effort`: `gint`, level of CPU effort to reduce file size
    /// * `target_size`: `gint`, desired target size in bytes
    /// * `passes`: `gint`, number of entropy-analysis passes
    /// * `min_size`: `gboolean`, minimise size
    /// * `mixed`: `gboolean`, allow both lossy and lossless encoding
    /// * `kmin`: `gint`, minimum number of frames between keyframes
    /// * `kmax`: `gint`, maximum number of frames between keyframes
    ///
    /// As `vips.Image.webpsave`, but save to a target.
    ///
    /// See also: `vips.Image.webpsave`.
    extern fn vips_webpsave_target(p_in: *Image, p_target: *vips.Target, ...) c_int;
    pub const webpsaveTarget = vips_webpsave_target;

    /// Check that an image is readable via the `VIPS_IMAGE_ADDR` macro, that is,
    /// that the entire image is in memory and all pixels can be read with
    /// `VIPS_IMAGE_ADDR`.  If it
    /// isn't, try to transform it so that `VIPS_IMAGE_ADDR` can work.
    ///
    /// Since this function modifies `image`, it is not thread-safe. Only call it on
    /// images which you are sure have not been shared with another thread. If the
    /// image might have been shared, use the less efficient
    /// `vips.Image.copyMemory` instead.
    ///
    /// See also: `vips.Image.copyMemory`, `vips.Image.pioInput`,
    /// `vips.Image.inplace`, `VIPS_IMAGE_ADDR`.
    extern fn vips_image_wio_input(p_image: *Image) c_int;
    pub const wioInput = vips_image_wio_input;

    /// Perform `VIPS_OPERATION_MATH2_WOP` on an image and a constant. See
    /// `vips.Image.math2Const`.
    extern fn vips_wop_const(p_in: *Image, p_out: **vips.Image, p_c: [*]const f64, p_n: c_int, ...) c_int;
    pub const wopConst = vips_wop_const;

    /// Perform `VIPS_OPERATION_MATH2_WOP` on an image and a constant. See
    /// `vips.Image.math2Const`.
    extern fn vips_wop_const1(p_in: *Image, p_out: **vips.Image, p_c: f64, ...) c_int;
    pub const wopConst1 = vips_wop_const1;

    /// Optional arguments:
    ///
    /// * `x`: horizontal displacement
    /// * `y`: vertical displacement
    ///
    /// Slice an image up and move the segments about so that the pixel that was
    /// at 0, 0 is now at `x`, `y`. If `x` and `y` are not set, they default to the
    /// centre of the image.
    ///
    /// See also: `vips.Image.embed`, `vips.Image.replicate`.
    extern fn vips_wrap(p_in: *Image, p_out: **vips.Image, ...) c_int;
    pub const wrap = vips_wrap;

    /// Write `image` to `out`. Use `vips.Image.new` and friends to create the
    /// `vips.Image` you want to write to.
    ///
    /// See also: `vips.Image.new`, `vips.Image.copy`, `vips.Image.writeToFile`.
    extern fn vips_image_write(p_image: *Image, p_out: *vips.Image) c_int;
    pub const write = vips_image_write;

    /// Write a line of pixels to an image. This function must be called repeatedly
    /// with `ypos` increasing from 0 to `vips.Image.signals.height` .
    /// `linebuffer` must be `VIPS_IMAGE_SIZEOF_LINE` bytes long.
    ///
    /// See also: `vips_image_generate`.
    extern fn vips_image_write_line(p_image: *Image, p_ypos: c_int, p_linebuffer: *vips.Pel) c_int;
    pub const writeLine = vips_image_write_line;

    /// Call this after setting header fields (width, height, and so on) to
    /// allocate resources ready for writing.
    ///
    /// Normally this function is called for you by `vips_image_generate` or
    /// `vips.Image.writeLine`. You will need to call it yourself if you plan to
    /// write directly to the ->data member of a memory image.
    extern fn vips_image_write_prepare(p_image: *Image) c_int;
    pub const writePrepare = vips_image_write_prepare;

    /// Writes `in` to a memory buffer in a format specified by `suffix`.
    ///
    /// Save options may be appended to `suffix` as "[name=value,...]" or given as
    /// a NULL-terminated list of name-value pairs at the end of the arguments.
    /// Options given in the function call override options given in the filename.
    ///
    /// Currently only TIFF, JPEG and PNG formats are supported.
    ///
    /// You can call the various save operations directly if you wish, see
    /// `vips.Image.jpegsaveBuffer`, for example.
    ///
    /// See also: `vips.Image.writeToMemory`, `vips.Image.newFromBuffer`.
    extern fn vips_image_write_to_buffer(p_in: *Image, p_suffix: [*:0]const u8, p_buf: [*]*u8, p_size: *usize, ...) c_int;
    pub const writeToBuffer = vips_image_write_to_buffer;

    /// Writes `in` to `name` using the saver recommended by
    /// `vips.Foreign.findSave`.
    ///
    /// Save options may be appended to `filename` as "[name=value,...]" or given as
    /// a NULL-terminated list of name-value pairs at the end of the arguments.
    /// Options given in the function call override options given in the filename.
    ///
    /// See also: `vips.Image.newFromFile`.
    extern fn vips_image_write_to_file(p_image: *Image, p_name: [*:0]const u8, ...) c_int;
    pub const writeToFile = vips_image_write_to_file;

    /// Writes `in` to memory as a simple, unformatted C-style array.
    ///
    /// The caller is responsible for freeing this memory with `glib.free`.
    ///
    /// See also: `vips.Image.writeToBuffer`.
    extern fn vips_image_write_to_memory(p_in: *Image, p_size: *usize) [*]u8;
    pub const writeToMemory = vips_image_write_to_memory;

    /// Writes `in` to `output` in format `suffix`.
    ///
    /// Save options may be appended to `suffix` as "[name=value,...]" or given as
    /// a NULL-terminated list of name-value pairs at the end of the arguments.
    /// Options given in the function call override options given in the filename.
    ///
    /// You can call the various save operations directly if you wish, see
    /// `vips.Image.jpegsaveTarget`, for example.
    ///
    /// See also: `vips.Image.writeToFile`.
    extern fn vips_image_write_to_target(p_in: *Image, p_suffix: [*:0]const u8, p_target: *vips.Target, ...) c_int;
    pub const writeToTarget = vips_image_write_to_target;

    /// Zoom an image by repeating pixels. This is fast nearest-neighbour
    /// zoom.
    ///
    /// See also: `vips.Image.affine`, `vips.Image.subsample`.
    extern fn vips_zoom(p_in: *Image, p_out: **vips.Image, p_xfac: c_int, p_yfac: c_int, ...) c_int;
    pub const zoom = vips_zoom;

    extern fn vips_image_get_type() usize;
    pub const getGObjectType = vips_image_get_type;

    extern fn g_object_ref(p_self: *vips.Image) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.Image) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Image, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Interpolate = extern struct {
    pub const Parent = vips.Object;
    pub const Implements = [_]type{};
    pub const Class = vips.InterpolateClass;
    f_parent_object: vips.Object,

    pub const virtual_methods = struct {
        /// Look up an interpolators desired window offset.
        pub const get_window_offset = struct {
            pub fn call(p_class: anytype, p_interpolate: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) c_int {
                return gobject.ext.as(Interpolate.Class, p_class).f_get_window_offset.?(gobject.ext.as(Interpolate, p_interpolate));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_interpolate: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) c_int) void {
                gobject.ext.as(Interpolate.Class, p_class).f_get_window_offset = @ptrCast(p_implementation);
            }
        };

        /// Look up an interpolators desired window size.
        pub const get_window_size = struct {
            pub fn call(p_class: anytype, p_interpolate: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) c_int {
                return gobject.ext.as(Interpolate.Class, p_class).f_get_window_size.?(gobject.ext.as(Interpolate, p_interpolate));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_interpolate: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) c_int) void {
                gobject.ext.as(Interpolate.Class, p_class).f_get_window_size = @ptrCast(p_implementation);
            }
        };

        /// the interpolation method
        pub const interpolate = struct {
            pub fn call(p_class: anytype, p_interpolate: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_out: ?*anyopaque, p_in: *vips.Region, p_x: f64, p_y: f64) void {
                return gobject.ext.as(Interpolate.Class, p_class).f_interpolate.?(gobject.ext.as(Interpolate, p_interpolate), p_out, p_in, p_x, p_y);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_interpolate: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_out: ?*anyopaque, p_in: *vips.Region, p_x: f64, p_y: f64) callconv(.c) void) void {
                gobject.ext.as(Interpolate.Class, p_class).f_interpolate = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {};

    /// A convenience function that returns a bilinear interpolator you
    /// don't need to free.
    extern fn vips_interpolate_bilinear_static() *vips.Interpolate;
    pub const bilinearStatic = vips_interpolate_bilinear_static;

    /// A convenience function that returns a nearest-neighbour interpolator you
    /// don't need to free.
    extern fn vips_interpolate_nearest_static() *vips.Interpolate;
    pub const nearestStatic = vips_interpolate_nearest_static;

    /// Look up an interpolator from a nickname and make one. You need to free the
    /// result with `gobject.Object.unref` when you're done with it.
    ///
    /// See also: `vips.typeFind`.
    extern fn vips_interpolate_new(p_nickname: [*:0]const u8) *vips.Interpolate;
    pub const new = vips_interpolate_new;

    /// Look up the `interpolate` method in the class and return it. Use this
    /// instead of `vips.interpolate` to cache method dispatch.
    extern fn vips_interpolate_get_method(p_interpolate: *Interpolate) vips.InterpolateMethod;
    pub const getMethod = vips_interpolate_get_method;

    /// Look up an interpolators desired window offset.
    extern fn vips_interpolate_get_window_offset(p_interpolate: *Interpolate) c_int;
    pub const getWindowOffset = vips_interpolate_get_window_offset;

    /// Look up an interpolators desired window size.
    extern fn vips_interpolate_get_window_size(p_interpolate: *Interpolate) c_int;
    pub const getWindowSize = vips_interpolate_get_window_size;

    extern fn vips_interpolate_get_type() usize;
    pub const getGObjectType = vips_interpolate_get_type;

    extern fn g_object_ref(p_self: *vips.Interpolate) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.Interpolate) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Interpolate, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Object = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = vips.ObjectClass;
    f_parent_instance: gobject.Object,
    f_constructed: c_int,
    f_static_object: c_int,
    f_argument_table: ?*vips.ArgumentTable,
    f_nickname: ?[*:0]u8,
    f_description: ?[*:0]u8,
    f_preclose: c_int,
    f_close: c_int,
    f_postclose: c_int,
    f_local_memory: usize,

    pub const virtual_methods = struct {
        pub const build = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) c_int {
                return gobject.ext.as(Object.Class, p_class).f_build.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) c_int) void {
                gobject.ext.as(Object.Class, p_class).f_build = @ptrCast(p_implementation);
            }
        };

        pub const close = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_close.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_close = @ptrCast(p_implementation);
            }
        };

        /// Dump everything that vips knows about an object to a string.
        pub const dump = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) void {
                return gobject.ext.as(Object.Class, p_class).f_dump.?(gobject.ext.as(Object, p_object), p_buf);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_dump = @ptrCast(p_implementation);
            }
        };

        pub const output_to_arg = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_string: [*:0]const u8) c_int {
                return gobject.ext.as(Object.Class, p_class).f_output_to_arg.?(gobject.ext.as(Object, p_object), p_string);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_string: [*:0]const u8) callconv(.c) c_int) void {
                gobject.ext.as(Object.Class, p_class).f_output_to_arg = @ptrCast(p_implementation);
            }
        };

        pub const postbuild = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_data: ?*anyopaque) c_int {
                return gobject.ext.as(Object.Class, p_class).f_postbuild.?(gobject.ext.as(Object, p_object), p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_data: ?*anyopaque) callconv(.c) c_int) void {
                gobject.ext.as(Object.Class, p_class).f_postbuild = @ptrCast(p_implementation);
            }
        };

        pub const postclose = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_postclose.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_postclose = @ptrCast(p_implementation);
            }
        };

        pub const preclose = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_preclose.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_preclose = @ptrCast(p_implementation);
            }
        };

        pub const rewind = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Object.Class, p_class).f_rewind.?(gobject.ext.as(Object, p_object));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_rewind = @ptrCast(p_implementation);
            }
        };

        pub const sanity = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) void {
                return gobject.ext.as(Object.Class, p_class).f_sanity.?(gobject.ext.as(Object, p_object), p_buf);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_sanity = @ptrCast(p_implementation);
            }
        };

        /// Generate a human-readable summary for an object.
        pub const summary = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) void {
                return gobject.ext.as(Object.Class, p_class).f_summary.?(gobject.ext.as(Object, p_object), p_buf);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_summary = @ptrCast(p_implementation);
            }
        };

        /// The inverse of `vips.Object.newFromString`: turn `object` into eg.
        /// "VipsInterpolateSnohalo1(blur=.333333)".
        pub const to_string = struct {
            pub fn call(p_class: anytype, p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) void {
                return gobject.ext.as(Object.Class, p_class).f_to_string.?(gobject.ext.as(Object, p_object), p_buf);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_object: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_buf: *vips.Buf) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_to_string = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const description = struct {
            pub const name = "description";

            pub const Type = ?[*:0]u8;
        };

        pub const nickname = struct {
            pub const name = "nickname";

            pub const Type = ?[*:0]u8;
        };
    };

    pub const signals = struct {
        /// The ::close signal is emitted once during object close. The object
        /// is dying and may not work.
        pub const close = struct {
            pub const name = "close";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Object, p_instance))),
                    gobject.signalLookup("close", Object.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::postbuild signal is emitted once just after successful object
        /// construction. Return non-zero to cause object construction to fail.
        pub const postbuild = struct {
            pub const name = "postbuild";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) c_int, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Object, p_instance))),
                    gobject.signalLookup("postbuild", Object.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::postclose signal is emitted once after object close. The
        /// object pointer is still valid, but nothing else.
        pub const postclose = struct {
            pub const name = "postclose";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Object, p_instance))),
                    gobject.signalLookup("postclose", Object.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        /// The ::preclose signal is emitted once just before object close
        /// starts. The object is still alive.
        pub const preclose = struct {
            pub const name = "preclose";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Object, p_instance))),
                    gobject.signalLookup("preclose", Object.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    extern fn vips_object_get_property(p_gobject: *gobject.Object, p_property_id: c_uint, p_value: *gobject.Value, p_pspec: *gobject.ParamSpec) void;
    pub const getProperty = vips_object_get_property;

    /// Call a function for all alive objects.
    /// Stop when `fn` returns non-`NULL` and return that value.
    extern fn vips_object_map(p_fn: vips.SListMap2Fn, p_a: ?*anyopaque, p_b: ?*anyopaque) ?*anyopaque;
    pub const map = vips_object_map;

    extern fn vips_object_print_all() void;
    pub const printAll = vips_object_print_all;

    extern fn vips_object_print_summary_class(p_klass: *vips.ObjectClass) void;
    pub const printSummaryClass = vips_object_print_summary_class;

    extern fn vips_object_sanity_all() void;
    pub const sanityAll = vips_object_sanity_all;

    extern fn vips_object_set_property(p_gobject: *gobject.Object, p_property_id: c_uint, p_value: *const gobject.Value, p_pspec: *gobject.ParamSpec) void;
    pub const setProperty = vips_object_set_property;

    /// Generate a human-readable summary for a class.
    extern fn vips_object_summary_class(p_klass: *vips.ObjectClass, p_buf: *vips.Buf) void;
    pub const summaryClass = vips_object_summary_class;

    /// `gobject.Object.new` the object, set any arguments with `set`, call
    /// `vips.Object.build` and return the complete object.
    extern fn vips_object_new(p_type: usize, p_set: vips.ObjectSetArguments, p_a: ?*anyopaque, p_b: ?*anyopaque) *vips.Object;
    pub const new = vips_object_new;

    extern fn vips_object_new_from_string(p_object_class: *vips.ObjectClass, p_p: [*:0]const u8) *vips.Object;
    pub const newFromString = vips_object_new_from_string;

    /// Convenience: has an argument been assigned. Useful for bindings.
    extern fn vips_object_argument_isset(p_object: *Object, p_name: [*:0]const u8) c_int;
    pub const argumentIsset = vips_object_argument_isset;

    extern fn vips_object_argument_needsstring(p_object: *Object, p_name: [*:0]const u8) c_int;
    pub const argumentNeedsstring = vips_object_argument_needsstring;

    extern fn vips_object_build(p_object: *Object) c_int;
    pub const build = vips_object_build;

    /// Dump everything that vips knows about an object to a string.
    extern fn vips_object_dump(p_object: *Object, p_buf: *vips.Buf) void;
    pub const dump = vips_object_dump;

    /// Get all `gobject.ParamSpec` names and `vips.ArgumentFlags` for an object.
    ///
    /// This is handy for language bindings. From C, it's usually more convenient to
    /// use `vips.argumentMap`.
    extern fn vips_object_get_args(p_object: *Object, p_names: ?[*]*[*:0]const u8, p_flags: ?[*]*c_int, p_n_args: ?*c_int) c_int;
    pub const getArgs = vips_object_get_args;

    /// Look up the three things you need to work with a vips argument.
    extern fn vips_object_get_argument(p_object: *Object, p_name: [*:0]const u8, p_pspec: **gobject.ParamSpec, p_argument_class: **vips.ArgumentClass, p_argument_instance: **vips.ArgumentInstance) c_int;
    pub const getArgument = vips_object_get_argument;

    /// Convenience: get the flags for an argument. Useful for bindings.
    extern fn vips_object_get_argument_flags(p_object: *Object, p_name: [*:0]const u8) vips.ArgumentFlags;
    pub const getArgumentFlags = vips_object_get_argument_flags;

    /// Convenience: get the priority for an argument. Useful for bindings.
    extern fn vips_object_get_argument_priority(p_object: *Object, p_name: [*:0]const u8) c_int;
    pub const getArgumentPriority = vips_object_get_argument_priority;

    extern fn vips_object_get_argument_to_string(p_object: *Object, p_name: [*:0]const u8, p_arg: [*:0]const u8) c_int;
    pub const getArgumentToString = vips_object_get_argument_to_string;

    /// Fetch the object description. Useful for language bindings.
    ///
    /// `object`.description is only available after `_build`, which can be too
    /// late. This function fetches from the instance, if possible, but falls back
    /// to the class description if we are too early.
    extern fn vips_object_get_description(p_object: *Object) [*:0]const u8;
    pub const getDescription = vips_object_get_description;

    /// Make an array of NULL VipsObject pointers. When `parent` closes, every
    /// non-NULL pointer in the array will be unreffed and the array will be
    /// freed. Handy for creating a set of temporary images for a function.
    ///
    /// The array is NULL-terminated, ie. contains an extra NULL element at the
    /// end.
    ///
    /// Example:
    ///
    /// ```
    /// VipsObject **t;
    ///
    /// t = vips_object_local_array(parent, 5);
    /// if (vips_add(a, b, &t[0], NULL) ||
    ///     vips_invert(t[0], &t[1], NULL) ||
    ///     vips_add(t[1], t[0], &t[2], NULL) ||
    ///     vips_costra(t[2], out, NULL))
    ///   return -1;
    /// ```
    ///
    /// See also: `vips_object_local`.
    extern fn vips_object_local_array(p_parent: *Object, p_n: c_int) **vips.Object;
    pub const localArray = vips_object_local_array;

    extern fn vips_object_local_cb(p_vobject: *Object, p_gobject: *gobject.Object) void;
    pub const localCb = vips_object_local_cb;

    extern fn vips_object_preclose(p_object: *Object) void;
    pub const preclose = vips_object_preclose;

    extern fn vips_object_print_dump(p_object: *Object) void;
    pub const printDump = vips_object_print_dump;

    extern fn vips_object_print_name(p_object: *Object) void;
    pub const printName = vips_object_print_name;

    extern fn vips_object_print_summary(p_object: *Object) void;
    pub const printSummary = vips_object_print_summary;

    extern fn vips_object_rewind(p_object: *Object) void;
    pub const rewind = vips_object_rewind;

    extern fn vips_object_sanity(p_object: *Object) c_int;
    pub const sanity = vips_object_sanity;

    /// Set a list of vips object arguments. For example:
    ///
    /// ```
    /// vips_object_set(operation,
    ///     "input", in,
    ///     "output", &out,
    ///     NULL);
    /// ```
    ///
    /// Input arguments are given in-line, output arguments are given as pointers
    /// to where the output value should be written.
    ///
    /// See also: `vips.Object.setValist`, `vips.Object.setFromString`.
    extern fn vips_object_set(p_object: *Object, ...) c_int;
    pub const set = vips_object_set;

    extern fn vips_object_set_argument_from_string(p_object: *Object, p_name: [*:0]const u8, p_value: [*:0]const u8) c_int;
    pub const setArgumentFromString = vips_object_set_argument_from_string;

    /// Set object arguments from a string. The string can be something like
    /// "a=12", or "a = 12, b = 13", or "fred". The string can optionally be
    /// enclosed in brackets.
    ///
    /// You'd typically use this between creating the object and building it.
    ///
    /// See also: `vips.Object.set`, `vips.Object.build`,
    /// `vips.cacheOperationBuildp`.
    extern fn vips_object_set_from_string(p_object: *Object, p_string: [*:0]const u8) c_int;
    pub const setFromString = vips_object_set_from_string;

    extern fn vips_object_set_required(p_object: *Object, p_value: [*:0]const u8) c_int;
    pub const setRequired = vips_object_set_required;

    extern fn vips_object_set_static(p_object: *Object, p_static_object: c_int) void;
    pub const setStatic = vips_object_set_static;

    /// See `vips.Object.set`.
    extern fn vips_object_set_valist(p_object: *Object, p_ap: std.builtin.VaList) c_int;
    pub const setValist = vips_object_set_valist;

    /// Generate a human-readable summary for an object.
    extern fn vips_object_summary(p_object: *Object, p_buf: *vips.Buf) void;
    pub const summary = vips_object_summary;

    /// The inverse of `vips.Object.newFromString`: turn `object` into eg.
    /// "VipsInterpolateSnohalo1(blur=.333333)".
    extern fn vips_object_to_string(p_object: *Object, p_buf: *vips.Buf) void;
    pub const toString = vips_object_to_string;

    /// Unref all assigned output objects. Useful for language bindings.
    ///
    /// After an object is built, all output args are owned by the caller. If
    /// something goes wrong before then, we have to unref the outputs that have
    /// been made so far. This function can also be useful for callers when
    /// they've finished processing outputs themselves.
    ///
    /// See also: `vips.cacheOperationBuild`.
    extern fn vips_object_unref_outputs(p_object: *Object) void;
    pub const unrefOutputs = vips_object_unref_outputs;

    extern fn vips_object_get_type() usize;
    pub const getGObjectType = vips_object_get_type;

    extern fn g_object_ref(p_self: *vips.Object) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.Object) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Object, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Operation = extern struct {
    pub const Parent = vips.Object;
    pub const Implements = [_]type{};
    pub const Class = vips.OperationClass;
    f_parent_instance: vips.Object,
    f_hash: c_uint,
    f_found_hash: c_int,
    f_pixels: c_int,

    pub const virtual_methods = struct {
        /// Returns the set of flags for this operation.
        pub const get_flags = struct {
            pub fn call(p_class: anytype, p_operation: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) vips.OperationFlags {
                return gobject.ext.as(Operation.Class, p_class).f_get_flags.?(gobject.ext.as(Operation, p_operation));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_operation: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) vips.OperationFlags) void {
                gobject.ext.as(Operation.Class, p_class).f_get_flags = @ptrCast(p_implementation);
            }
        };

        pub const invalidate = struct {
            pub fn call(p_class: anytype, p_operation: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Operation.Class, p_class).f_invalidate.?(gobject.ext.as(Operation, p_operation));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_operation: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Operation.Class, p_class).f_invalidate = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {
        pub const invalidate = struct {
            pub const name = "invalidate";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Operation, p_instance))),
                    gobject.signalLookup("invalidate", Operation.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Set the block state on all operations in the libvips class hierarchy at
    /// `name` and below.
    ///
    /// For example:
    ///
    /// ```
    /// vips_operation_block_set("VipsForeignLoad", TRUE);
    /// vips_operation_block_set("VipsForeignLoadJpeg", FALSE);
    /// ```
    ///
    /// Will block all load operations, except JPEG.
    ///
    /// Use `vips -l` at the command-line to see the class hierarchy.
    ///
    /// This call does nothing if the named operation is not found.
    ///
    /// See also: `vips.blockUntrustedSet`.
    extern fn vips_operation_block_set(p_name: [*:0]const u8, p_state: c_int) void;
    pub const blockSet = vips_operation_block_set;

    /// Return a new `vips.Operation` with the specified nickname. Useful for
    /// language bindings.
    ///
    /// You'll need to set any arguments and build the operation before you can use
    /// it. See `vips.call` for a higher-level way to make new operations.
    extern fn vips_operation_new(p_name: [*:0]const u8) *vips.Operation;
    pub const new = vips_operation_new;

    extern fn vips_operation_call_valist(p_operation: *Operation, p_ap: std.builtin.VaList) c_int;
    pub const callValist = vips_operation_call_valist;

    /// Returns the set of flags for this operation.
    extern fn vips_operation_get_flags(p_operation: *Operation) vips.OperationFlags;
    pub const getFlags = vips_operation_get_flags;

    extern fn vips_operation_invalidate(p_operation: *Operation) void;
    pub const invalidate = vips_operation_invalidate;

    extern fn vips_operation_get_type() usize;
    pub const getGObjectType = vips_operation_get_type;

    extern fn g_object_ref(p_self: *vips.Operation) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.Operation) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Operation, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A small part of a `vips.Image`. `valid` holds the left/top/width/height of the
/// area of pixels that are available from the region.
///
/// See also: `VIPS_REGION_ADDR`, `vips.Region.new`, `vips.Region.prepare`.
pub const Region = extern struct {
    pub const Parent = vips.Object;
    pub const Implements = [_]type{};
    pub const Class = vips.RegionClass;
    f_parent_object: vips.Object,
    /// the `vips.Image` that this region is defined on
    f_im: ?*vips.Image,
    /// the `vips.Rect` of pixels that this region represents
    f_valid: vips.Rect,
    f_type: c_int,
    f_data: ?*vips.Pel,
    f_bpl: c_int,
    f_seq: ?*anyopaque,
    f_thread: ?*glib.Thread,
    f_window: ?*anyopaque,
    f_buffer: ?*anyopaque,
    f_invalid: c_int,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Create a region. `vips.Region` s start out empty, you need to call
    /// `vips.Region.prepare` to fill them with pixels.
    ///
    /// See also: `vips.Region.prepare`.
    extern fn vips_region_new(p_image: *vips.Image) *vips.Region;
    pub const new = vips_region_new;

    /// Paints 0 into the valid part of `reg`.
    ///
    /// See also: `vips.Region.paint`.
    extern fn vips_region_black(p_reg: *Region) void;
    pub const black = vips_region_black;

    /// The region is transformed so that at least `r` pixels are available as a
    /// memory buffer that can be written to.
    extern fn vips_region_buffer(p_reg: *Region, p_r: *const vips.Rect) c_int;
    pub const buffer = vips_region_buffer;

    /// Copy from one region to another. Copy area `r` from inside `reg` to `dest`,
    /// positioning the area of pixels at `x`, `y`. The two regions must have pixels
    /// which are the same size.
    ///
    /// See also: `vips.Region.paint`.
    extern fn vips_region_copy(p_reg: *Region, p_dest: *vips.Region, p_r: *const vips.Rect, p_x: c_int, p_y: c_int) void;
    pub const copy = vips_region_copy;

    /// Do two regions point to the same piece of image? ie.
    ///
    /// ```
    ///     VIPS_REGION_ADDR(reg1, x, y) == VIPS_REGION_ADDR(reg2, x, y) &&
    ///     *VIPS_REGION_ADDR(reg1, x, y) ==
    ///         *VIPS_REGION_ADDR(reg2, x, y) for all x, y, reg1, reg2.
    /// ```
    extern fn vips_region_equalsregion(p_reg1: *Region, p_reg2: *vips.Region) c_int;
    pub const equalsregion = vips_region_equalsregion;

    /// Generate an area of pixels and return a copy. The result must be freed
    /// with `glib.free`. The requested area must be completely inside the image.
    ///
    /// This is equivalent to `vips.Region.prepare`, followed by a memcpy. It is
    /// convenient for language bindings.
    extern fn vips_region_fetch(p_region: *Region, p_left: c_int, p_top: c_int, p_width: c_int, p_height: c_int, p_len: *usize) *vips.Pel;
    pub const fetch = vips_region_fetch;

    extern fn vips_region_height(p_region: *Region) c_int;
    pub const height = vips_region_height;

    /// The region is transformed so that at least `r` pixels are available to be
    /// read from the image. The image needs to be a memory buffer or represent a
    /// file on disc that has been mapped or can be mapped.
    extern fn vips_region_image(p_reg: *Region, p_r: *const vips.Rect) c_int;
    pub const image = vips_region_image;

    /// Mark a region as containing invalid pixels. Calling this function means
    /// that the next time `vips.Region.prepare` is called, the region will be
    /// recalculated.
    ///
    /// This is faster than calling `vips.Image.invalidateAll`, but obviously only
    /// affects a single region.
    ///
    /// See also: `vips.Image.invalidateAll`, `vips.Region.prepare`.
    extern fn vips_region_invalidate(p_reg: *Region) void;
    pub const invalidate = vips_region_invalidate;

    /// Paints `value` into `reg` covering rectangle `r`.
    /// `r` is clipped against
    /// `reg`->valid.
    ///
    /// For int images, `value` is
    /// passed to `memset`, so it usually needs to be 0 or 255. For float images,
    /// value is cast to a float and copied in to each band element.
    ///
    /// `r` is clipped against
    /// `reg`->valid.
    ///
    /// See also: `vips.Region.black`.
    extern fn vips_region_paint(p_reg: *Region, p_r: *const vips.Rect, p_value: c_int) void;
    pub const paint = vips_region_paint;

    /// Paints `ink` into `reg` covering rectangle `r`. `r` is clipped against
    /// `reg`->valid.
    ///
    /// `ink` should be a byte array of the same size as an image pixel containing
    /// the binary value to write into the pixels.
    ///
    /// See also: `vips.Region.paint`.
    extern fn vips_region_paint_pel(p_reg: *Region, p_r: *const vips.Rect, p_ink: *const vips.Pel) void;
    pub const paintPel = vips_region_paint_pel;

    /// Set the position of a region. This only affects reg->valid, ie. the way
    /// pixels are addressed, not reg->data, the pixels which are addressed. Clip
    /// against the size of the image. Do not allow negative positions, or
    /// positions outside the image.
    extern fn vips_region_position(p_reg: *Region, p_x: c_int, p_y: c_int) c_int;
    pub const position = vips_region_position;

    /// `vips.Region.prepare` fills `reg` with pixels. After calling,
    /// you can address at least the area `r` with `VIPS_REGION_ADDR` and get
    /// valid pixels.
    ///
    /// `vips.Region.prepare` runs in-line, that is, computation is done by
    /// the calling thread, no new threads are involved, and computation
    /// blocks until the pixels are ready.
    ///
    /// Use `vips_sink_screen` to calculate an area of pixels in the
    /// background.
    ///
    /// See also: `vips_sink_screen`, `vips.Region.prepareTo`.
    extern fn vips_region_prepare(p_reg: *Region, p_r: *const vips.Rect) c_int;
    pub const prepare = vips_region_prepare;

    /// Like `vips.Region.prepare`: fill `reg` with the pixels in area `r`.
    ///
    /// Unlike `vips.Region.prepare`, rather than writing the result to `reg`, the
    /// pixels are written into `dest` at offset `x`, `y`.
    ///
    /// Also unlike `vips.Region.prepare`, `dest` is not set up for writing for
    /// you with `vips.Region.buffer`. You can
    /// point `dest` at anything, and pixels really will be written there.
    /// This makes `vips.Region.prepareTo` useful for making the ends of
    /// pipelines.
    ///
    /// See also: `vips.Region.prepare`, `vips_sink_disc`.
    extern fn vips_region_prepare_to(p_reg: *Region, p_dest: *vips.Region, p_r: *const vips.Rect, p_x: c_int, p_y: c_int) c_int;
    pub const prepareTo = vips_region_prepare_to;

    /// Make `VIPS_REGION_ADDR` on `reg` go to `dest` instead.
    ///
    /// `r` is the part of `reg` which you want to be able to address (this
    /// effectively becomes the valid field), (`x`, `y`) is the top LH corner of the
    /// corresponding area in `dest`.
    ///
    /// Performs all clipping necessary to ensure that `reg`->valid is indeed
    /// valid.
    ///
    /// If the region we attach to is moved or destroyed, we can be left with
    /// dangling pointers! If the region we attach to is on another image, the
    /// two images must have the same sizeof(pel).
    extern fn vips_region_region(p_reg: *Region, p_dest: *vips.Region, p_r: *const vips.Rect, p_x: c_int, p_y: c_int) c_int;
    pub const region = vips_region_region;

    /// Write the pixels `target` in `to` from the x2 larger area in `from`.
    /// Non-complex uncoded images and LABQ only. Images with alpha (see
    /// `vips.Image.hasalpha`) shrink with pixels scaled by alpha to avoid fringing.
    ///
    /// This is a compatibility stub that just calls `vips.Region.shrinkMethod`.
    ///
    /// See also: `vips.Region.shrinkMethod`.
    extern fn vips_region_shrink(p_from: *Region, p_to: *vips.Region, p_target: *const vips.Rect) c_int;
    pub const shrink = vips_region_shrink;

    /// Write the pixels `target` in `to` from the x2 larger area in `from`.
    /// Non-complex uncoded images and LABQ only. Images with alpha (see
    /// `vips.Image.hasalpha`) shrink with pixels scaled by alpha to avoid fringing.
    ///
    /// `method` selects the method used to do the 2x2 shrink.
    ///
    /// See also: `vips.Region.copy`.
    extern fn vips_region_shrink_method(p_from: *Region, p_to: *vips.Region, p_target: *const vips.Rect, p_method: vips.RegionShrink) c_int;
    pub const shrinkMethod = vips_region_shrink_method;

    extern fn vips_region_width(p_region: *Region) c_int;
    pub const width = vips_region_width;

    extern fn vips_region_get_type() usize;
    pub const getGObjectType = vips_region_get_type;

    extern fn g_object_ref(p_self: *vips.Region) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *vips.Region) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Region, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Area = extern struct {
    f_data: ?*anyopaque,
    f_length: usize,
    f_n: c_int,
    f_count: c_int,
    f_lock: ?*glib.Mutex,
    f_free_fn: ?vips.CallbackFn,
    f_client: ?*anyopaque,
    f_type: usize,
    f_sizeof_type: usize,

    extern fn vips_area_free_cb(p_mem: ?*anyopaque, p_area: *vips.Area) c_int;
    pub const freeCb = vips_area_free_cb;

    /// A VipsArea wraps a chunk of memory. It adds reference counting and a free
    /// function. It also keeps a count and a `gobject.Type`, so the area can be an array.
    ///
    /// This type is used for things like passing an array of double or an array of
    /// `vips.Object` pointers to operations, and for reference-counted immutable
    /// strings.
    ///
    /// Initial count == 1, so `_unref` after attaching somewhere.
    ///
    /// See also: `vips.Area.unref`.
    extern fn vips_area_new(p_free_fn: ?vips.CallbackFn, p_data: ?*anyopaque) *vips.Area;
    pub const new = vips_area_new;

    /// An area which holds an array of elements of some `gobject.Type`. To set values for
    /// the elements, get the pointer and write.
    ///
    /// See also: `vips.Area.unref`.
    extern fn vips_area_new_array(p_type: usize, p_sizeof_type: usize, p_n: c_int) *vips.Area;
    pub const newArray = vips_area_new_array;

    /// An area which holds an array of `gobject.Object` s. See `vips.Area.newArray`. When
    /// the area is freed, each `gobject.Object` will be unreffed.
    ///
    /// Add an extra NULL element at the end, handy for eg.
    /// `vips_image_pipeline_array` etc.
    ///
    /// See also: `vips.Area.unref`.
    extern fn vips_area_new_array_object(p_n: c_int) *vips.Area;
    pub const newArrayObject = vips_area_new_array_object;

    extern fn vips_area_copy(p_area: *Area) *vips.Area;
    pub const copy = vips_area_copy;

    /// Return the data pointer plus optionally the length in bytes of an area,
    /// the number of elements, the `gobject.Type` of each element and the `sizeof` each
    /// element.
    extern fn vips_area_get_data(p_area: *Area, p_length: ?*usize, p_n: ?*c_int, p_type: ?*usize, p_sizeof_type: ?*usize) ?*anyopaque;
    pub const getData = vips_area_get_data;

    extern fn vips_area_unref(p_area: *Area) void;
    pub const unref = vips_area_unref;

    extern fn vips_area_get_type() usize;
    pub const getGObjectType = vips_area_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Argument = extern struct {
    f_pspec: ?*gobject.ParamSpec,

    /// Allocate a new property id. See `gobject.ObjectClass.installProperty`.
    extern fn vips_argument_get_id() c_int;
    pub const getId = vips_argument_get_id;

    /// Loop over the vips_arguments to an object. Stop when `fn` returns non-`NULL`
    /// and return that value.
    extern fn vips_argument_map(p_object: *vips.Object, p_fn: vips.ArgumentMapFn, p_a: ?*anyopaque, p_b: ?*anyopaque) ?*anyopaque;
    pub const map = vips_argument_map;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ArgumentClass = extern struct {
    f_parent: vips.Argument,
    f_object_class: ?*vips.ObjectClass,
    f_flags: vips.ArgumentFlags,
    f_priority: c_int,
    f_offset: c_uint,

    /// And loop over a class. Same as ^^, but with no VipsArgumentInstance.
    extern fn vips_argument_class_map(p_object_class: *vips.ObjectClass, p_fn: vips.ArgumentClassMapFn, p_a: ?*anyopaque, p_b: ?*anyopaque) ?*anyopaque;
    pub const map = vips_argument_class_map;

    extern fn vips_argument_class_needsstring(p_argument_class: *ArgumentClass) c_int;
    pub const needsstring = vips_argument_class_needsstring;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ArgumentInstance = extern struct {
    f_parent: vips.Argument,
    f_argument_class: ?*vips.ArgumentClass,
    f_object: ?*vips.Object,
    f_assigned: c_int,
    f_close_id: c_ulong,
    f_invalidate_id: c_ulong,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ArrayDouble = extern struct {
    f_area: vips.Area,

    /// Allocate a new array of doubles and copy `array` into it. Free with
    /// `vips.Area.unref`.
    ///
    /// See also: `vips.Area`.
    extern fn vips_array_double_new(p_array: [*]const f64, p_n: c_int) *vips.ArrayDouble;
    pub const new = vips_array_double_new;

    /// Allocate a new array of `n` doubles and copy @... into it. Free with
    /// `vips.Area.unref`.
    ///
    /// See also: `vips.ArrayDouble.new`
    extern fn vips_array_double_newv(p_n: c_int, ...) *vips.ArrayDouble;
    pub const newv = vips_array_double_newv;

    /// Fetch a double array from a `vips.ArrayDouble`. Useful for language bindings.
    extern fn vips_array_double_get(p_array: *ArrayDouble, p_n: *c_int) [*]f64;
    pub const get = vips_array_double_get;

    extern fn vips_array_double_get_type() usize;
    pub const getGObjectType = vips_array_double_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ArrayImage = extern struct {
    f_area: vips.Area,

    /// Make an empty image array.
    /// Handy with `vips_array_image_add` for bindings
    /// which can't handle object array arguments.
    ///
    /// See also: `vips_array_image_add`.
    extern fn vips_array_image_empty() *vips.ArrayImage;
    pub const empty = vips_array_image_empty;

    /// Allocate a new array of images and copy `array` into it. Free with
    /// `vips.Area.unref`.
    ///
    /// The images will all be reffed by this function. They
    /// will be automatically unreffed for you by
    /// `vips.Area.unref`.
    ///
    /// Add an extra NULL element at the end, handy for eg.
    /// `vips_image_pipeline_array` etc.
    ///
    /// See also: `vips.Area`.
    extern fn vips_array_image_new(p_array: [*]*vips.Image, p_n: c_int) *vips.ArrayImage;
    pub const new = vips_array_image_new;

    extern fn vips_array_image_new_from_string(p_string: [*:0]const u8, p_flags: vips.Access) *vips.ArrayImage;
    pub const newFromString = vips_array_image_new_from_string;

    /// Allocate a new array of `n` `vips.Image` and copy @... into it. Free with
    /// `vips.Area.unref`.
    ///
    /// The images will all be reffed by this function. They
    /// will be automatically unreffed for you by
    /// `vips.Area.unref`.
    ///
    /// Add an extra NULL element at the end, handy for eg.
    /// `vips_image_pipeline_array` etc.
    ///
    /// See also: `vips.ArrayImage.new`
    extern fn vips_array_image_newv(p_n: c_int, ...) *vips.ArrayImage;
    pub const newv = vips_array_image_newv;

    /// Make a new `vips.ArrayImage`, one larger than `array`, with `image` appended
    /// to the end.
    /// Handy with `vips.ArrayImage.empty` for bindings
    /// which can't handle object array arguments.
    ///
    /// See also: `vips.ArrayImage.empty`.
    extern fn vips_array_image_append(p_array: *ArrayImage, p_image: *vips.Image) *vips.ArrayImage;
    pub const append = vips_array_image_append;

    /// Fetch an image array from a `vips.ArrayImage`. Useful for language bindings.
    extern fn vips_array_image_get(p_array: *ArrayImage, p_n: *c_int) [*]*vips.Image;
    pub const get = vips_array_image_get;

    extern fn vips_array_image_get_type() usize;
    pub const getGObjectType = vips_array_image_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ArrayInt = extern struct {
    f_area: vips.Area,

    /// Allocate a new array of ints and copy `array` into it. Free with
    /// `vips.Area.unref`.
    ///
    /// See also: `vips.Area`.
    extern fn vips_array_int_new(p_array: [*]const c_int, p_n: c_int) *vips.ArrayInt;
    pub const new = vips_array_int_new;

    /// Allocate a new array of `n` ints and copy @... into it. Free with
    /// `vips.Area.unref`.
    ///
    /// See also: `vips.ArrayInt.new`
    extern fn vips_array_int_newv(p_n: c_int, ...) *vips.ArrayInt;
    pub const newv = vips_array_int_newv;

    /// Fetch an int array from a `vips.ArrayInt`. Useful for language bindings.
    extern fn vips_array_int_get(p_array: *ArrayInt, p_n: *c_int) [*]c_int;
    pub const get = vips_array_int_get;

    extern fn vips_array_int_get_type() usize;
    pub const getGObjectType = vips_array_int_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Blob = extern struct {
    f_area: vips.Area,

    /// Like `vips.Blob.new`, but take a copy of the data. Useful for bindings
    /// which struggle with callbacks.
    ///
    /// See also: `vips.Blob.new`.
    extern fn vips_blob_copy(p_data: [*]u8, p_length: usize) *vips.Blob;
    pub const copy = vips_blob_copy;

    /// Like `vips.Area.new`, but track a length as well. The returned `vips.Blob`
    /// takes ownership of `data` and will free it with `free_fn`. Pass `NULL` for
    /// `free_fn` to not transfer ownership.
    ///
    /// An area of mem with a free func and a length (some sort of binary object,
    /// like an ICC profile).
    ///
    /// See also: `vips.Area.unref`.
    extern fn vips_blob_new(p_free_fn: ?vips.CallbackFn, p_data: [*]u8, p_length: usize) *vips.Blob;
    pub const new = vips_blob_new;

    /// Get the data from a `vips.Blob`.
    ///
    /// See also: `vips.Blob.new`.
    extern fn vips_blob_get(p_blob: *Blob, p_length: *usize) [*]u8;
    pub const get = vips_blob_get;

    /// Any old data is freed and new data attached.
    ///
    /// It's sometimes useful to be able to create blobs as empty and then fill
    /// them later.
    ///
    /// See also: `vips.Blob.new`.
    extern fn vips_blob_set(p_blob: *Blob, p_free_fn: ?vips.CallbackFn, p_data: [*]u8, p_length: usize) void;
    pub const set = vips_blob_set;

    extern fn vips_blob_get_type() usize;
    pub const getGObjectType = vips_blob_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Buf = opaque {
    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ForeignClass = extern struct {
    pub const Instance = vips.Foreign;

    f_parent_class: vips.OperationClass,
    f_priority: c_int,
    f_suffs: ?*[*:0]const u8,

    pub fn as(p_instance: *ForeignClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ForeignLoadClass = extern struct {
    pub const Instance = vips.ForeignLoad;

    f_parent_class: vips.ForeignClass,
    f_is_a: ?*const fn (p_filename: [*:0]const u8) callconv(.c) c_int,
    f_is_a_buffer: ?*const fn (p_data: *anyopaque, p_size: usize) callconv(.c) c_int,
    f_is_a_source: ?*const fn (p_source: *vips.Source) callconv(.c) c_int,
    f_get_flags_filename: ?*const fn (p_filename: [*:0]const u8) callconv(.c) vips.ForeignFlags,
    f_get_flags: ?*const fn (p_load: *vips.ForeignLoad) callconv(.c) vips.ForeignFlags,
    f_header: ?*const fn (p_load: *vips.ForeignLoad) callconv(.c) c_int,
    f_load: ?*const fn (p_load: *vips.ForeignLoad) callconv(.c) c_int,

    pub fn as(p_instance: *ForeignLoadClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ForeignSaveClass = extern struct {
    pub const Instance = vips.ForeignSave;

    f_parent_class: vips.ForeignClass,
    f_saveable: vips.Saveable,
    f_format_table: ?*vips.BandFormat,
    f_coding: ?[*]c_int,

    pub fn as(p_instance: *ForeignSaveClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ImageClass = extern struct {
    pub const Instance = vips.Image;

    f_parent_class: vips.ObjectClass,
    f_preeval: ?*const fn (p_image: *vips.Image, p_progress: *vips.Progress, p_data: ?*anyopaque) callconv(.c) void,
    f_eval: ?*const fn (p_image: *vips.Image, p_progress: *vips.Progress, p_data: ?*anyopaque) callconv(.c) void,
    f_posteval: ?*const fn (p_image: *vips.Image, p_progress: *vips.Progress, p_data: ?*anyopaque) callconv(.c) void,
    f_written: ?*const fn (p_image: *vips.Image, p_result: *c_int, p_data: ?*anyopaque) callconv(.c) void,
    f_invalidate: ?*const fn (p_image: *vips.Image, p_data: ?*anyopaque) callconv(.c) void,
    f_minimise: ?*const fn (p_image: *vips.Image, p_data: ?*anyopaque) callconv(.c) void,

    pub fn as(p_instance: *ImageClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The abstract base class for the various VIPS interpolation functions.
/// Use "vips --list classes" to see all the interpolators available.
///
/// An interpolator consists of a function to perform the interpolation, plus
/// some extra data fields which tell vips how to call the function and what
/// data it needs.
///
/// `window_size` is the size of the window that the interpolator needs. For
/// example, a bicubic interpolator needs to see a window of 4x4 pixels to be
/// able to interpolate a value.
///
/// You can either have a function in `get_window_size` which returns the window
/// that a specific interpolator needs, or you can leave `get_window_size` `NULL`
/// and set a constant value in `window_size`.
///
/// `window_offset` is how much to offset the window up and left of (x, y). For
/// example, a bicubic interpolator will want a `window_offset` of 1.
///
/// You can either have a function in `get_window_offset` which returns the
/// offset that a specific interpolator needs, or you can leave
/// `get_window_offset` `NULL` and set a constant value in `window_offset`.
///
/// You also need to set `nickname` and `description` in `vips.Object`.
///
/// See also: `vips.InterpolateMethod`, `vips.Object`,
/// `vips.Interpolate.bilinearStatic`.
pub const InterpolateClass = extern struct {
    pub const Instance = vips.Interpolate;

    f_parent_class: vips.ObjectClass,
    /// the interpolation method
    f_interpolate: ?vips.InterpolateMethod,
    /// return the size of the window needed by this method
    f_get_window_size: ?*const fn (p_interpolate: *vips.Interpolate) callconv(.c) c_int,
    /// or just set this for a constant window size
    f_window_size: c_int,
    /// return the window offset for this method
    f_get_window_offset: ?*const fn (p_interpolate: *vips.Interpolate) callconv(.c) c_int,
    /// or just set this for a constant window offset
    f_window_offset: c_int,

    pub fn as(p_instance: *InterpolateClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ObjectClass = extern struct {
    pub const Instance = vips.Object;

    f_parent_class: gobject.ObjectClass,
    f_build: ?*const fn (p_object: *vips.Object) callconv(.c) c_int,
    f_postbuild: ?*const fn (p_object: *vips.Object, p_data: ?*anyopaque) callconv(.c) c_int,
    f_summary_class: ?*const fn (p_cls: *anyopaque, p_buf: *vips.Buf) callconv(.c) void,
    f_summary: ?*const fn (p_object: *vips.Object, p_buf: *vips.Buf) callconv(.c) void,
    f_dump: ?*const fn (p_object: *vips.Object, p_buf: *vips.Buf) callconv(.c) void,
    f_sanity: ?*const fn (p_object: *vips.Object, p_buf: *vips.Buf) callconv(.c) void,
    f_rewind: ?*const fn (p_object: *vips.Object) callconv(.c) void,
    f_preclose: ?*const fn (p_object: *vips.Object) callconv(.c) void,
    f_close: ?*const fn (p_object: *vips.Object) callconv(.c) void,
    f_postclose: ?*const fn (p_object: *vips.Object) callconv(.c) void,
    f_new_from_string: ?*const fn (p_string: [*:0]const u8) callconv(.c) *vips.Object,
    f_to_string: ?*const fn (p_object: *vips.Object, p_buf: *vips.Buf) callconv(.c) void,
    f_output_needs_arg: c_int,
    f_output_to_arg: ?*const fn (p_object: *vips.Object, p_string: [*:0]const u8) callconv(.c) c_int,
    f_nickname: ?[*:0]const u8,
    f_description: ?[*:0]const u8,
    f_argument_table: ?*vips.ArgumentTable,
    f_argument_table_traverse: ?*glib.SList,
    f_argument_table_traverse_gtype: usize,
    f_deprecated: c_int,
    f__vips_reserved1: ?*const fn () callconv(.c) void,
    f__vips_reserved2: ?*const fn () callconv(.c) void,
    f__vips_reserved3: ?*const fn () callconv(.c) void,
    f__vips_reserved4: ?*const fn () callconv(.c) void,

    extern fn vips_object_class_install_argument(p_cls: *ObjectClass, p_pspec: *gobject.ParamSpec, p_flags: vips.ArgumentFlags, p_priority: c_int, p_offset: c_uint) void;
    pub const installArgument = vips_object_class_install_argument;

    pub fn as(p_instance: *ObjectClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const OperationClass = extern struct {
    pub const Instance = vips.Operation;

    f_parent_class: vips.ObjectClass,
    f_usage: ?*const fn (p_cls: *anyopaque, p_buf: *vips.Buf) callconv(.c) void,
    f_get_flags: ?*const fn (p_operation: *vips.Operation) callconv(.c) vips.OperationFlags,
    f_flags: vips.OperationFlags,
    f_invalidate: ?*const fn (p_operation: *vips.Operation) callconv(.c) void,

    /// Print a usage message for the operation to stdout.
    extern fn vips_operation_class_print_usage(p_operation_class: *OperationClass) void;
    pub const printUsage = vips_operation_class_print_usage;

    pub fn as(p_instance: *OperationClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure available to eval callbacks giving information on evaluation
/// progress. See `vips.Image.signals.eval`.
pub const Progress = extern struct {
    f_im: ?*vips.Image,
    /// Time we have been running
    f_run: c_int,
    /// Estimated seconds of computation left
    f_eta: c_int,
    /// Number of pels we expect to calculate
    f_tpels: i64,
    /// Number of pels calculated so far
    f_npels: i64,
    /// Percent complete
    f_percent: c_int,
    /// Start time
    f_start: ?*glib.Timer,

    /// If set, vips will print messages about the progress of computation to
    /// stdout. This can also be enabled with the --vips-progress option, or by
    /// setting the environment variable VIPS_PROGRESS.
    extern fn vips_progress_set(p_progress: c_int) void;
    pub const set = vips_progress_set;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A `vips.Rect` is a rectangular area of pixels. This is a struct for
/// performing simple rectangle algebra.
pub const Rect = extern struct {
    /// left edge of rectangle
    f_left: c_int,
    /// top edge of rectangle
    f_top: c_int,
    /// width of rectangle
    f_width: c_int,
    /// height of rectangle
    f_height: c_int,

    /// Duplicate a rect to the heap. You need to free the result with `glib.free`.
    extern fn vips_rect_dup(p_r: *const Rect) *vips.Rect;
    pub const dup = vips_rect_dup;

    /// Is `r1` equal to `r2`?
    extern fn vips_rect_equalsrect(p_r1: *const Rect, p_r2: *const vips.Rect) c_int;
    pub const equalsrect = vips_rect_equalsrect;

    /// Does `r` contain point (`x`, `y`)?
    extern fn vips_rect_includespoint(p_r: *const Rect, p_x: c_int, p_y: c_int) c_int;
    pub const includespoint = vips_rect_includespoint;

    /// Is `r2` a subset of `r1`?
    extern fn vips_rect_includesrect(p_r1: *const Rect, p_r2: *const vips.Rect) c_int;
    pub const includesrect = vips_rect_includesrect;

    /// Fill `out` with the intersection of `r1` and `r2`. `out` can equal `r1` or `r2`.
    extern fn vips_rect_intersectrect(p_r1: *const Rect, p_r2: *const vips.Rect, p_out: *vips.Rect) void;
    pub const intersectrect = vips_rect_intersectrect;

    /// Is `r` empty? ie. zero width or height.
    extern fn vips_rect_isempty(p_r: *const Rect) c_int;
    pub const isempty = vips_rect_isempty;

    /// Enlarge `r` by `n`. +1 means out one pixel.
    extern fn vips_rect_marginadjust(p_r: *Rect, p_n: c_int) void;
    pub const marginadjust = vips_rect_marginadjust;

    /// Make sure width and height are >0 by moving the origin and flipping the
    /// rect.
    extern fn vips_rect_normalise(p_r: *Rect) void;
    pub const normalise = vips_rect_normalise;

    /// Do `r1` and `r2` have a non-empty intersection?
    extern fn vips_rect_overlapsrect(p_r1: *const Rect, p_r2: *const vips.Rect) c_int;
    pub const overlapsrect = vips_rect_overlapsrect;

    /// Fill `out` with the bounding box of `r1` and `r2`. `out` can equal `r1` or `r2`.
    extern fn vips_rect_unionrect(p_r1: *const Rect, p_r2: *const vips.Rect, p_out: *vips.Rect) void;
    pub const unionrect = vips_rect_unionrect;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const RefString = extern struct {
    f_area: vips.Area,

    /// Create a new refstring. These are reference-counted immutable strings, used
    /// to store string data in vips image metadata.
    ///
    /// Strings must be valid utf-8; use blob for binary data.
    ///
    /// See also: `vips.Area.unref`.
    extern fn vips_ref_string_new(p_str: [*:0]const u8) ?*vips.RefString;
    pub const new = vips_ref_string_new;

    /// Get a pointer to the private string inside a refstr. Handy for language
    /// bindings.
    ///
    /// See also: `vips.valueGetRefString`.
    extern fn vips_ref_string_get(p_refstr: *RefString, p_length: ?*usize) [*:0]const u8;
    pub const get = vips_ref_string_get;

    extern fn vips_ref_string_get_type() usize;
    pub const getGObjectType = vips_ref_string_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const RegionClass = extern struct {
    pub const Instance = vips.Region;

    f_parent_class: vips.ObjectClass,

    pub fn as(p_instance: *RegionClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SaveString = extern struct {
    f_s: ?[*:0]u8,

    extern fn vips_save_string_get_type() usize;
    pub const getGObjectType = vips_save_string_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Source = opaque {
    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Target = opaque {
    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Thing = extern struct {
    f_i: c_int,

    extern fn vips_thing_new(p_i: c_int) *vips.Thing;
    pub const new = vips_thing_new;

    extern fn vips_thing_get_type() usize;
    pub const getGObjectType = vips_thing_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The type of access an operation has to supply. See `vips.Image.tilecache`
/// and `vips.Foreign`.
///
/// `VIPS_ACCESS_RANDOM` means requests can come in any order.
///
/// `VIPS_ACCESS_SEQUENTIAL` means requests will be top-to-bottom, but with some
/// amount of buffering behind the read point for small non-local accesses.
pub const Access = enum(c_int) {
    random = 0,
    sequential = 1,
    sequential_unbuffered = 2,
    last = 3,
    _,

    extern fn vips_access_get_type() usize;
    pub const getGObjectType = vips_access_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips.join` and so on.
///
/// Operations like `vips.join` need to be told whether to align images on the
/// low or high coordinate edge, or centre.
///
/// See also: `vips.join`.
pub const Align = enum(c_int) {
    low = 0,
    centre = 1,
    high = 2,
    last = 3,
    _,

    extern fn vips_align_get_type() usize;
    pub const getGObjectType = vips_align_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips.Image.rot` and so on.
///
/// Fixed rotate angles.
///
/// See also: `vips.Image.rot`.
pub const Angle = enum(c_int) {
    d0 = 0,
    d90 = 1,
    d180 = 2,
    d270 = 3,
    last = 4,
    _,

    extern fn vips_angle_get_type() usize;
    pub const getGObjectType = vips_angle_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips.Image.rot45` and so on.
///
/// Fixed rotate angles.
///
/// See also: `vips.Image.rot45`.
pub const Angle45 = enum(c_int) {
    d0 = 0,
    d45 = 1,
    d90 = 2,
    d135 = 3,
    d180 = 4,
    d225 = 5,
    d270 = 6,
    d315 = 7,
    last = 8,
    _,

    extern fn vips_angle45_get_type() usize;
    pub const getGObjectType = vips_angle45_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The format used for each band element.
///
/// Each corresponds to a native C type for the current machine. For example,
/// `VIPS_FORMAT_USHORT` is <type>unsigned short</type>.
pub const BandFormat = enum(c_int) {
    notset = -1,
    uchar = 0,
    char = 1,
    ushort = 2,
    short = 3,
    uint = 4,
    int = 5,
    float = 6,
    complex = 7,
    double = 8,
    dpcomplex = 9,
    last = 10,
    _,

    /// Return `TRUE` if `format` is uchar or schar.
    extern fn vips_band_format_is8bit(p_format: vips.BandFormat) c_int;
    pub const is8bit = vips_band_format_is8bit;

    /// Return `TRUE` if `fmt` is one of the complex types.
    extern fn vips_band_format_iscomplex(p_format: vips.BandFormat) c_int;
    pub const iscomplex = vips_band_format_iscomplex;

    /// Return `TRUE` if `format` is one of the float types.
    extern fn vips_band_format_isfloat(p_format: vips.BandFormat) c_int;
    pub const isfloat = vips_band_format_isfloat;

    /// Return `TRUE` if `format` is one of the integer types.
    extern fn vips_band_format_isint(p_format: vips.BandFormat) c_int;
    pub const isint = vips_band_format_isint;

    /// Return `TRUE` if `format` is one of the unsigned integer types.
    extern fn vips_band_format_isuint(p_format: vips.BandFormat) c_int;
    pub const isuint = vips_band_format_isuint;

    extern fn vips_band_format_get_type() usize;
    pub const getGObjectType = vips_band_format_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The various Porter-Duff and PDF blend modes. See `vips.composite`,
/// for example.
///
/// The Cairo docs have a nice explanation of all the blend modes:
///
/// https://www.cairographics.org/operators
///
/// The non-separable modes are not implemented.
pub const BlendMode = enum(c_int) {
    clear = 0,
    source = 1,
    over = 2,
    in = 3,
    out = 4,
    atop = 5,
    dest = 6,
    dest_over = 7,
    dest_in = 8,
    dest_out = 9,
    dest_atop = 10,
    xor = 11,
    add = 12,
    saturate = 13,
    multiply = 14,
    screen = 15,
    overlay = 16,
    darken = 17,
    lighten = 18,
    colour_dodge = 19,
    colour_burn = 20,
    hard_light = 21,
    soft_light = 22,
    difference = 23,
    exclusion = 24,
    last = 25,
    _,

    extern fn vips_blend_mode_get_type() usize;
    pub const getGObjectType = vips_blend_mode_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How pixels are coded.
///
/// Normally, pixels are uncoded and can be manipulated as you would expect.
/// However some file formats code pixels for compression, and sometimes it's
/// useful to be able to manipulate images in the coded format.
///
/// The gaps in the numbering are historical and must be maintained. Allocate
/// new numbers from the end.
pub const Coding = enum(c_int) {
    @"error" = -1,
    none = 0,
    labq = 2,
    rad = 6,
    last = 7,
    _,

    extern fn vips_coding_get_type() usize;
    pub const getGObjectType = vips_coding_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How to combine values. See `vips.Image.compass`, for example.
pub const Combine = enum(c_int) {
    max = 0,
    sum = 1,
    min = 2,
    last = 3,
    _,

    extern fn vips_combine_get_type() usize;
    pub const getGObjectType = vips_combine_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips.Image.drawImage` and so on.
///
/// Operations like `vips.Image.drawImage` need to be told how to combine images
/// from two sources.
///
/// See also: `vips.join`.
pub const CombineMode = enum(c_int) {
    set = 0,
    add = 1,
    last = 2,
    _,

    extern fn vips_combine_mode_get_type() usize;
    pub const getGObjectType = vips_combine_mode_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A direction on a compass. Used for `vips.gravity`, for example.
pub const CompassDirection = enum(c_int) {
    centre = 0,
    north = 1,
    east = 2,
    south = 3,
    west = 4,
    north_east = 5,
    south_east = 6,
    south_west = 7,
    north_west = 8,
    last = 9,
    _,

    extern fn vips_compass_direction_get_type() usize;
    pub const getGObjectType = vips_compass_direction_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips_image_pipelinev`. Operations can hint
/// the kind of demand geometry they prefer
/// to the VIPS image IO system.
///
/// These demand styles are given below in order of increasing
/// specialisation.  When demanding output from a pipeline,
/// `vips_image_generate`
/// will use the most general style requested by the operations
/// in the pipeline.
///
/// `VIPS_DEMAND_STYLE_SMALLTILE` --- This is the most general demand format.
/// Output is demanded in small (around 100x100 pel) sections. This style works
/// reasonably efficiently, even for bizarre operations like 45 degree rotate.
///
/// `VIPS_DEMAND_STYLE_FATSTRIP` --- This operation would like to output strips
/// the width of the image and as high as possible. This option is suitable
/// for area operations which do not violently transform coordinates, such
/// as `vips.Image.conv`.
///
/// `VIPS_DEMAND_STYLE_THINSTRIP` --- This operation would like to output strips
/// the width of the image and a few pels high. This option is suitable for
/// point-to-point operations, such as those in the arithmetic package.
///
/// `VIPS_DEMAND_STYLE_ANY` --- This image is not being demand-read from a disc
/// file (even indirectly) so any demand style is OK. It's used for things like
/// `vips.black` where the pixels are calculated.
///
/// See also: `vips_image_pipelinev`.
pub const DemandStyle = enum(c_int) {
    @"error" = -1,
    smalltile = 0,
    fatstrip = 1,
    thinstrip = 2,
    any = 3,
    _,

    extern fn vips_demand_style_get_type() usize;
    pub const getGObjectType = vips_demand_style_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips.Image.flip`, `vips.join` and so on.
///
/// Operations like `vips.Image.flip` need to be told whether to flip left-right or
/// top-bottom.
///
/// See also: `vips.Image.flip`, `vips.join`.
pub const Direction = enum(c_int) {
    horizontal = 0,
    vertical = 1,
    last = 2,
    _,

    extern fn vips_direction_get_type() usize;
    pub const getGObjectType = vips_direction_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See `vips.Image.embed`, `vips.Image.conv`, `vips.Image.affine` and so on.
///
/// When the edges of an image are extended, you can specify
/// how you want the extension done.
///
/// `VIPS_EXTEND_BLACK` --- new pixels are black, ie. all bits are zero.
///
/// `VIPS_EXTEND_COPY` --- each new pixel takes the value of the nearest edge
/// pixel
///
/// `VIPS_EXTEND_REPEAT` --- the image is tiled to fill the new area
///
/// `VIPS_EXTEND_MIRROR` --- the image is reflected and tiled to reduce hash
/// edges
///
/// `VIPS_EXTEND_WHITE` --- new pixels are white, ie. all bits are set
///
/// `VIPS_EXTEND_BACKGROUND` --- colour set from the `background` property
///
/// We have to specify the exact value of each enum member since we have to
/// keep these frozen for back compat with vips7.
///
/// See also: `vips.Image.embed`.
pub const Extend = enum(c_int) {
    black = 0,
    copy = 1,
    repeat = 2,
    mirror = 3,
    white = 4,
    background = 5,
    last = 6,
    _,

    extern fn vips_extend_get_type() usize;
    pub const getGObjectType = vips_extend_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How sensitive loaders are to errors, from never stop (very insensitive), to
/// stop on the smallest warning (very sensitive).
///
/// Each one implies the ones before it, so `VIPS_FAIL_ON_ERROR` implies
/// `VIPS_FAIL_ON_TRUNCATED`.
pub const FailOn = enum(c_int) {
    none = 0,
    truncated = 1,
    @"error" = 2,
    warning = 3,
    last = 4,
    _,

    extern fn vips_fail_on_get_type() usize;
    pub const getGObjectType = vips_fail_on_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How many pyramid layers to create.
pub const ForeignDzContainer = enum(c_int) {
    fs = 0,
    zip = 1,
    szi = 2,
    last = 3,
    _,

    extern fn vips_foreign_dz_container_get_type() usize;
    pub const getGObjectType = vips_foreign_dz_container_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How many pyramid layers to create.
pub const ForeignDzDepth = enum(c_int) {
    onepixel = 0,
    onetile = 1,
    one = 2,
    last = 3,
    _,

    extern fn vips_foreign_dz_depth_get_type() usize;
    pub const getGObjectType = vips_foreign_dz_depth_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// What directory layout and metadata standard to use.
pub const ForeignDzLayout = enum(c_int) {
    dz = 0,
    zoomify = 1,
    google = 2,
    iiif = 3,
    iiif3 = 4,
    last = 5,
    _,

    extern fn vips_foreign_dz_layout_get_type() usize;
    pub const getGObjectType = vips_foreign_dz_layout_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The compression format to use inside a HEIF container.
///
/// This is assumed to use the same numbering as `heif_compression_format`.
pub const ForeignHeifCompression = enum(c_int) {
    hevc = 1,
    avc = 2,
    jpeg = 3,
    av1 = 4,
    last = 5,
    _,

    extern fn vips_foreign_heif_compression_get_type() usize;
    pub const getGObjectType = vips_foreign_heif_compression_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The selected encoder to use.
/// If libheif hasn't been compiled with the selected encoder,
/// we will fallback to the default encoder for the compression format.
pub const ForeignHeifEncoder = enum(c_int) {
    auto = 0,
    aom = 1,
    rav1e = 2,
    svt = 3,
    x265 = 4,
    last = 5,
    _,

    extern fn vips_foreign_heif_encoder_get_type() usize;
    pub const getGObjectType = vips_foreign_heif_encoder_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ForeignJpegSubsample = enum(c_int) {
    auto = 0,
    on = 1,
    off = 2,
    last = 3,
    _,

    extern fn vips_foreign_jpeg_subsample_get_type() usize;
    pub const getGObjectType = vips_foreign_jpeg_subsample_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The netpbm file format to save as.
///
/// `VIPS_FOREIGN_PPM_FORMAT_PBM` images are single bit.
///
/// `VIPS_FOREIGN_PPM_FORMAT_PGM` images are 8, 16, or 32-bits, one band.
///
/// `VIPS_FOREIGN_PPM_FORMAT_PPM` images are 8, 16, or 32-bits, three bands.
///
/// `VIPS_FOREIGN_PPM_FORMAT_PFM` images are 32-bit float pixels.
///
/// `VIPS_FOREIGN_PPM_FORMAT_PNM` images are anymap images -- the image format
/// is used to pick the saver.
pub const ForeignPpmFormat = enum(c_int) {
    pbm = 0,
    pgm = 1,
    ppm = 2,
    pfm = 3,
    pnm = 4,
    last = 5,
    _,

    extern fn vips_foreign_ppm_format_get_type() usize;
    pub const getGObjectType = vips_foreign_ppm_format_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Set subsampling mode.
pub const ForeignSubsample = enum(c_int) {
    auto = 0,
    on = 1,
    off = 2,
    last = 3,
    _,

    extern fn vips_foreign_subsample_get_type() usize;
    pub const getGObjectType = vips_foreign_subsample_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The compression types supported by the tiff writer.
///
/// Use `Q` to set the jpeg compression level, default 75.
///
/// Use `predictor` to set the lzw or deflate prediction, default horizontal.
///
/// Use `lossless` to set WEBP lossless compression.
///
/// Use `level` to set webp and zstd compression level.
pub const ForeignTiffCompression = enum(c_int) {
    none = 0,
    jpeg = 1,
    deflate = 2,
    packbits = 3,
    ccittfax4 = 4,
    lzw = 5,
    webp = 6,
    zstd = 7,
    jp2k = 8,
    last = 9,
    _,

    extern fn vips_foreign_tiff_compression_get_type() usize;
    pub const getGObjectType = vips_foreign_tiff_compression_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The predictor can help deflate and lzw compression. The values are fixed by
/// the tiff library.
pub const ForeignTiffPredictor = enum(c_int) {
    none = 1,
    horizontal = 2,
    float = 3,
    last = 4,
    _,

    extern fn vips_foreign_tiff_predictor_get_type() usize;
    pub const getGObjectType = vips_foreign_tiff_predictor_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Use inches or centimeters as the resolution unit for a tiff file.
pub const ForeignTiffResunit = enum(c_int) {
    cm = 0,
    inch = 1,
    last = 2,
    _,

    extern fn vips_foreign_tiff_resunit_get_type() usize;
    pub const getGObjectType = vips_foreign_tiff_resunit_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Tune lossy encoder settings for different image types.
pub const ForeignWebpPreset = enum(c_int) {
    default = 0,
    picture = 1,
    photo = 2,
    drawing = 3,
    icon = 4,
    text = 5,
    last = 6,
    _,

    extern fn vips_foreign_webp_preset_get_type() usize;
    pub const getGObjectType = vips_foreign_webp_preset_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ImageType = enum(c_int) {
    @"error" = -1,
    none = 0,
    setbuf = 1,
    setbuf_foreign = 2,
    openin = 3,
    mmapin = 4,
    mmapinrw = 5,
    openout = 6,
    partial = 7,
    _,

    extern fn vips_image_type_get_type() usize;
    pub const getGObjectType = vips_image_type_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The rendering intent. `VIPS_INTENT_ABSOLUTE` is best for
/// scientific work, `VIPS_INTENT_RELATIVE` is usually best for
/// accurate communication with other imaging libraries.
pub const Intent = enum(c_int) {
    perceptual = 0,
    relative = 1,
    saturation = 2,
    absolute = 3,
    last = 4,
    _,

    extern fn vips_intent_get_type() usize;
    pub const getGObjectType = vips_intent_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Pick the algorithm vips uses to decide image "interestingness". This is used
/// by `vips.Image.smartcrop`, for example, to decide what parts of the image to
/// keep.
///
/// `VIPS_INTERESTING_NONE` and `VIPS_INTERESTING_LOW` mean the same -- the
/// crop is positioned at the top or left. `VIPS_INTERESTING_HIGH` positions at
/// the bottom or right.
///
/// See also: `vips.Image.smartcrop`.
pub const Interesting = enum(c_int) {
    none = 0,
    centre = 1,
    entropy = 2,
    attention = 3,
    low = 4,
    high = 5,
    all = 6,
    last = 7,
    _,

    extern fn vips_interesting_get_type() usize;
    pub const getGObjectType = vips_interesting_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How the values in an image should be interpreted. For example, a
/// three-band float image of type `VIPS_INTERPRETATION_LAB` should have its
/// pixels interpreted as coordinates in CIE Lab space.
///
/// RGB and sRGB are treated in the same way. Use the colourspace functions if
/// you want some other behaviour.
///
/// The gaps in numbering are historical and must be maintained. Allocate
/// new numbers from the end.
pub const Interpretation = enum(c_int) {
    @"error" = -1,
    multiband = 0,
    b_w = 1,
    histogram = 10,
    xyz = 12,
    lab = 13,
    cmyk = 15,
    labq = 16,
    rgb = 17,
    cmc = 18,
    lch = 19,
    labs = 21,
    srgb = 22,
    yxy = 23,
    fourier = 24,
    rgb16 = 25,
    grey16 = 26,
    matrix = 27,
    scrgb = 28,
    hsv = 29,
    last = 30,
    _,

    extern fn vips_interpretation_max_alpha(p_interpretation: vips.Interpretation) f64;
    pub const maxAlpha = vips_interpretation_max_alpha;

    extern fn vips_interpretation_get_type() usize;
    pub const getGObjectType = vips_interpretation_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The resampling kernels vips supports. See `vips.Image.reduce`, for example.
pub const Kernel = enum(c_int) {
    nearest = 0,
    linear = 1,
    cubic = 2,
    mitchell = 3,
    lanczos2 = 4,
    lanczos3 = 5,
    last = 6,
    _,

    extern fn vips_kernel_get_type() usize;
    pub const getGObjectType = vips_kernel_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.boolean`.
pub const OperationBoolean = enum(c_int) {
    @"and" = 0,
    @"or" = 1,
    eor = 2,
    lshift = 3,
    rshift = 4,
    last = 5,
    _,

    extern fn vips_operation_boolean_get_type() usize;
    pub const getGObjectType = vips_operation_boolean_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.Image.complex`.
pub const OperationComplex = enum(c_int) {
    polar = 0,
    rect = 1,
    conj = 2,
    last = 3,
    _,

    extern fn vips_operation_complex_get_type() usize;
    pub const getGObjectType = vips_operation_complex_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.complex2`.
pub const OperationComplex2 = enum(c_int) {
    cross_phase = 0,
    last = 1,
    _,

    extern fn vips_operation_complex2_get_type() usize;
    pub const getGObjectType = vips_operation_complex2_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.Image.complexget`.
pub const OperationComplexget = enum(c_int) {
    real = 0,
    imag = 1,
    last = 2,
    _,

    extern fn vips_operation_complexget_get_type() usize;
    pub const getGObjectType = vips_operation_complexget_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.Image.math`.
pub const OperationMath = enum(c_int) {
    sin = 0,
    cos = 1,
    tan = 2,
    asin = 3,
    acos = 4,
    atan = 5,
    log = 6,
    log10 = 7,
    exp = 8,
    exp10 = 9,
    sinh = 10,
    cosh = 11,
    tanh = 12,
    asinh = 13,
    acosh = 14,
    atanh = 15,
    last = 16,
    _,

    extern fn vips_operation_math_get_type() usize;
    pub const getGObjectType = vips_operation_math_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.Image.math`.
pub const OperationMath2 = enum(c_int) {
    pow = 0,
    wop = 1,
    atan2 = 2,
    last = 3,
    _,

    extern fn vips_operation_math2_get_type() usize;
    pub const getGObjectType = vips_operation_math2_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// More like hit-miss, really.
///
/// See also: `vips.Image.morph`.
pub const OperationMorphology = enum(c_int) {
    erode = 0,
    dilate = 1,
    last = 2,
    _,

    extern fn vips_operation_morphology_get_type() usize;
    pub const getGObjectType = vips_operation_morphology_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.relational`.
pub const OperationRelational = enum(c_int) {
    equal = 0,
    noteq = 1,
    less = 2,
    lesseq = 3,
    more = 4,
    moreeq = 5,
    last = 6,
    _,

    extern fn vips_operation_relational_get_type() usize;
    pub const getGObjectType = vips_operation_relational_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.Image.round`.
pub const OperationRound = enum(c_int) {
    rint = 0,
    ceil = 1,
    floor = 2,
    last = 3,
    _,

    extern fn vips_operation_round_get_type() usize;
    pub const getGObjectType = vips_operation_round_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Pick a Profile Connection Space for `vips.Image.iccImport` and
/// `vips.Image.iccExport`. LAB is usually best, XYZ can be more convenient in some
/// cases.
pub const PCS = enum(c_int) {
    lab = 0,
    xyz = 1,
    last = 2,
    _,

    extern fn vips_pcs_get_type() usize;
    pub const getGObjectType = vips_pcs_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How accurate an operation should be.
pub const Precision = enum(c_int) {
    integer = 0,
    float = 1,
    approximate = 2,
    last = 3,
    _,

    extern fn vips_precision_get_type() usize;
    pub const getGObjectType = vips_precision_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// How to calculate the output pixels when shrinking a 2x2 region.
pub const RegionShrink = enum(c_int) {
    mean = 0,
    median = 1,
    mode = 2,
    max = 3,
    min = 4,
    nearest = 5,
    last = 6,
    _,

    extern fn vips_region_shrink_get_type() usize;
    pub const getGObjectType = vips_region_shrink_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// See also: `vips.ForeignSave`.
pub const Saveable = enum(c_int) {
    mono = 0,
    rgb = 1,
    rgba = 2,
    rgba_only = 3,
    rgb_cmyk = 4,
    any = 5,
    last = 6,
    _,

    extern fn vips_saveable_get_type() usize;
    pub const getGObjectType = vips_saveable_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The SDF to generate,
///
/// See also: `vips.sdf`.
pub const SdfShape = enum(c_int) {
    circle = 0,
    box = 1,
    rounded_box = 2,
    line = 3,
    last = 4,
    _,

    extern fn vips_sdf_shape_get_type() usize;
    pub const getGObjectType = vips_sdf_shape_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Controls whether an operation should upsize, downsize, both up and
/// downsize, or force a size.
///
/// See also: `vips.thumbnail`.
pub const Size = enum(c_int) {
    both = 0,
    up = 1,
    down = 2,
    force = 3,
    last = 4,
    _,

    extern fn vips_size_get_type() usize;
    pub const getGObjectType = vips_size_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Sets the word wrapping style for `vips.text` when used with a maximum
/// width.
///
/// See also: `vips.text`.
pub const TextWrap = enum(c_int) {
    word = 0,
    char = 1,
    word_char = 2,
    none = 3,
    last = 4,
    _,

    extern fn vips_text_wrap_get_type() usize;
    pub const getGObjectType = vips_text_wrap_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Token = enum(c_int) {
    left = 1,
    right = 2,
    string = 3,
    equals = 4,
    comma = 5,
    _,

    extern fn vips_token_get_type() usize;
    pub const getGObjectType = vips_token_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Flags we associate with each object argument.
///
/// Have separate input & output flags. Both set is an error; neither set is OK.
///
/// Input gobjects are automatically reffed, output gobjects automatically ref
/// us. We also automatically watch for "destroy" and unlink.
///
/// `VIPS_ARGUMENT_SET_ALWAYS` is handy for arguments which are set from C. For
/// example, VipsImage::width is a property that gives access to the Xsize
/// member of struct _VipsImage. We default its 'assigned' to TRUE
/// since the field is always set directly by C.
///
/// `VIPS_ARGUMENT_DEPRECATED` arguments are not shown in help text, are not
/// looked for if required, are not checked for "have-been-set". You can
/// deprecate a required argument, but you must obviously add a new required
/// argument if you do.
///
/// Input args with `VIPS_ARGUMENT_MODIFY` will be modified by the operation.
/// This is used for things like the in-place drawing operations.
///
/// `VIPS_ARGUMENT_NON_HASHABLE` stops the argument being used in hash and
/// equality tests. It's useful for arguments like `revalidate` which
/// control the behaviour of the operator cache.
pub const ArgumentFlags = packed struct(c_uint) {
    required: bool = false,
    construct: bool = false,
    set_once: bool = false,
    set_always: bool = false,
    input: bool = false,
    output: bool = false,
    deprecated: bool = false,
    modify: bool = false,
    non_hashable: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: ArgumentFlags = @bitCast(@as(c_uint, 0));
    pub const flags_required: ArgumentFlags = @bitCast(@as(c_uint, 1));
    pub const flags_construct: ArgumentFlags = @bitCast(@as(c_uint, 2));
    pub const flags_set_once: ArgumentFlags = @bitCast(@as(c_uint, 4));
    pub const flags_set_always: ArgumentFlags = @bitCast(@as(c_uint, 8));
    pub const flags_input: ArgumentFlags = @bitCast(@as(c_uint, 16));
    pub const flags_output: ArgumentFlags = @bitCast(@as(c_uint, 32));
    pub const flags_deprecated: ArgumentFlags = @bitCast(@as(c_uint, 64));
    pub const flags_modify: ArgumentFlags = @bitCast(@as(c_uint, 128));
    pub const flags_non_hashable: ArgumentFlags = @bitCast(@as(c_uint, 256));
    extern fn vips_argument_flags_get_type() usize;
    pub const getGObjectType = vips_argument_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Some hints about the image loader.
///
/// `VIPS_FOREIGN_PARTIAL` means that the image can be read directly from the
/// file without needing to be unpacked to a temporary image first.
///
/// `VIPS_FOREIGN_SEQUENTIAL` means that the loader supports lazy reading, but
/// only top-to-bottom (sequential) access. Formats like PNG can read sets of
/// scanlines, for example, but only in order.
///
/// If neither PARTIAL or SEQUENTIAL is set, the loader only supports whole
/// image read. Setting both PARTIAL and SEQUENTIAL is an error.
///
/// `VIPS_FOREIGN_BIGENDIAN` means that image pixels are most-significant byte
/// first. Depending on the native byte order of the host machine, you may
/// need to swap bytes. See `vips.Image.copy`.
pub const ForeignFlags = packed struct(c_uint) {
    partial: bool = false,
    bigendian: bool = false,
    sequential: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: ForeignFlags = @bitCast(@as(c_uint, 0));
    pub const flags_partial: ForeignFlags = @bitCast(@as(c_uint, 1));
    pub const flags_bigendian: ForeignFlags = @bitCast(@as(c_uint, 2));
    pub const flags_sequential: ForeignFlags = @bitCast(@as(c_uint, 4));
    pub const flags_all: ForeignFlags = @bitCast(@as(c_uint, 7));
    extern fn vips_foreign_flags_get_type() usize;
    pub const getGObjectType = vips_foreign_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Which metadata to retain.
pub const ForeignKeep = packed struct(c_uint) {
    exif: bool = false,
    xmp: bool = false,
    iptc: bool = false,
    icc: bool = false,
    other: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: ForeignKeep = @bitCast(@as(c_uint, 0));
    pub const flags_exif: ForeignKeep = @bitCast(@as(c_uint, 1));
    pub const flags_xmp: ForeignKeep = @bitCast(@as(c_uint, 2));
    pub const flags_iptc: ForeignKeep = @bitCast(@as(c_uint, 4));
    pub const flags_icc: ForeignKeep = @bitCast(@as(c_uint, 8));
    pub const flags_other: ForeignKeep = @bitCast(@as(c_uint, 16));
    pub const flags_all: ForeignKeep = @bitCast(@as(c_uint, 31));
    extern fn vips_foreign_keep_get_type() usize;
    pub const getGObjectType = vips_foreign_keep_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// http://www.w3.org/TR/PNG-Filters.html
/// The values mirror those of png.h in libpng.
pub const ForeignPngFilter = packed struct(c_uint) {
    _padding0: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    none: bool = false,
    sub: bool = false,
    up: bool = false,
    avg: bool = false,
    paeth: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: ForeignPngFilter = @bitCast(@as(c_uint, 8));
    pub const flags_sub: ForeignPngFilter = @bitCast(@as(c_uint, 16));
    pub const flags_up: ForeignPngFilter = @bitCast(@as(c_uint, 32));
    pub const flags_avg: ForeignPngFilter = @bitCast(@as(c_uint, 64));
    pub const flags_paeth: ForeignPngFilter = @bitCast(@as(c_uint, 128));
    pub const flags_all: ForeignPngFilter = @bitCast(@as(c_uint, 248));
    extern fn vips_foreign_png_filter_get_type() usize;
    pub const getGObjectType = vips_foreign_png_filter_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Flags we associate with an operation.
///
/// `VIPS_OPERATION_SEQUENTIAL` means that the operation works like `vips.Image.conv`:
/// it can process images top-to-bottom with only small non-local
/// references.
///
/// Every scan-line must be requested, you are not allowed to skip
/// ahead, but as a special case, the very first request can be for a region
/// not at the top of the image. In this case, the first part of the image will
/// be read and discarded
///
/// Every scan-line must be requested, you are not allowed to skip
/// ahead, but as a special case, the very first request can be for a region
/// not at the top of the image. In this case, the first part of the image will
/// be read and discarded
///
/// `VIPS_OPERATION_NOCACHE` means that the operation must not be cached by
/// vips.
///
/// `VIPS_OPERATION_DEPRECATED` means this is an old operation kept in vips for
/// compatibility only and should be hidden from users.
///
/// `VIPS_OPERATION_UNTRUSTED` means the operation depends on external libraries
/// which have not been hardened against attack. It should probably not be used
/// on untrusted input. Use `vips.blockUntrustedSet` to block all
/// untrusted operations.
///
/// `VIPS_OPERATION_BLOCKED` means the operation is prevented from executing. Use
/// `vips.Operation.blockSet` to enable and disable groups of operations.
///
/// `VIPS_OPERATION_REVALIDATE` force the operation to run, updating the cache
/// with the new value. This is used by eg. VipsForeignLoad to implement the
/// "revalidate" argument.
pub const OperationFlags = packed struct(c_uint) {
    sequential: bool = false,
    sequential_unbuffered: bool = false,
    nocache: bool = false,
    deprecated: bool = false,
    untrusted: bool = false,
    blocked: bool = false,
    revalidate: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: OperationFlags = @bitCast(@as(c_uint, 0));
    pub const flags_sequential: OperationFlags = @bitCast(@as(c_uint, 1));
    pub const flags_sequential_unbuffered: OperationFlags = @bitCast(@as(c_uint, 2));
    pub const flags_nocache: OperationFlags = @bitCast(@as(c_uint, 4));
    pub const flags_deprecated: OperationFlags = @bitCast(@as(c_uint, 8));
    pub const flags_untrusted: OperationFlags = @bitCast(@as(c_uint, 16));
    pub const flags_blocked: OperationFlags = @bitCast(@as(c_uint, 32));
    pub const flags_revalidate: OperationFlags = @bitCast(@as(c_uint, 64));
    extern fn vips_operation_flags_get_type() usize;
    pub const getGObjectType = vips_operation_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

extern fn vips_CMC2XYZ(p_in: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const CMC2XYZ = vips_CMC2XYZ;

extern fn vips_Yxy2Lab(p_in: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const Yxy2Lab = vips_Yxy2Lab;

extern fn vips__object_set_member(p_object: *vips.Object, p_pspec: *gobject.ParamSpec, p_member: **gobject.Object, p_argument: *gobject.Object) void;
pub const _objectSetMember = vips__object_set_member;

/// This operation calculates `in1` + `in2` and writes the result to `out`.
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), then the
/// following table is used to determine the output type:
///
/// <table>
///   <title>VipsAdd type promotion</title>
///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
///     <thead>
///       <row>
///         <entry>input type</entry>
///         <entry>output type</entry>
///       </row>
///     </thead>
///     <tbody>
///       <row>
///         <entry>uchar</entry>
///         <entry>ushort</entry>
///       </row>
///       <row>
///         <entry>char</entry>
///         <entry>short</entry>
///       </row>
///       <row>
///         <entry>ushort</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>short</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>uint</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>int</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>float</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>double</entry>
///         <entry>double</entry>
///       </row>
///       <row>
///         <entry>complex</entry>
///         <entry>complex</entry>
///       </row>
///       <row>
///         <entry>double complex</entry>
///         <entry>double complex</entry>
///       </row>
///     </tbody>
///   </tgroup>
/// </table>
///
/// In other words, the output type is just large enough to hold the whole
/// range of possible values.
///
/// See also: `vips.subtract`, `vips.Image.linear`.
extern fn vips_add(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const add = vips_add;

/// Add the standard vips `glib.OptionEntry` to a `glib.OptionGroup`.
///
/// See also: `glib.OptionGroup.new`.
extern fn vips_add_option_entries(p_option_group: *glib.OptionGroup) void;
pub const addOptionEntries = vips_add_option_entries;

/// Load an Analyze 6.0 file. If `filename` is "fred.img", this will look for
/// an image header called "fred.hdr" and pixel data in "fred.img". You can
/// also load "fred" or "fred.hdr".
///
/// Images are
/// loaded lazilly and byte-swapped, if necessary. The Analyze metadata is read
/// and attached.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_analyzeload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const analyzeload = vips_analyzeload;

/// Perform `VIPS_OPERATION_BOOLEAN_AND` on a pair of images. See
/// `vips.boolean`.
extern fn vips_andimage(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const andimage = vips_andimage;

/// Optional arguments:
///
/// * `across`: `gint`, number of images per row
/// * `shim`: `gint`, space between images, in pixels
/// * `background`: `vips.ArrayDouble`, background ink colour
/// * `halign`: `vips.Align`, low, centre or high alignment
/// * `valign`: `vips.Align`, low, centre or high alignment
/// * `hspacing`: `gint`, horizontal distance between images
/// * `vspacing`: `gint`, vertical distance between images
///
/// Lay out the images in `in` in a grid. The grid is `across` images across and
/// however high is necessary to use up all of `in`. Images are set down
/// left-to-right and top-to-bottom. `across` defaults to `n`.
///
/// Each input image is placed with a box of size `hspacing` by `vspacing`
/// pixels and cropped. These default to the largest width and largest height
/// of the input images.
///
/// Space between images is filled with `background`. This defaults to 0
/// (black).
///
/// Images are positioned within their `hspacing` by `vspacing` box at low,
/// centre or high coordinate values, controlled by `halign` and `valign`. These
/// default to left-top.
///
/// Boxes are joined and separated by `shim` pixels. This defaults to 0.
///
/// If the number of bands in the input images differs, all but one of the
/// images must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the n-band images are operated upon.
///
/// The input images are cast up to the smallest common type (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// `vips.Image.colourspace` can be useful for moving the images to a common
/// colourspace for compositing.
///
/// See also: `vips.join`, `vips.Image.insert`, `vips.Image.colourspace`.
extern fn vips_arrayjoin(p_in: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, ...) c_int;
pub const arrayjoin = vips_arrayjoin;

/// Perform `VIPS_OPERATION_MATH2_ATAN2` on a pair of images. See
/// `vips.math2`.
extern fn vips_atan2(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const atan2 = vips_atan2;

/// Join a set of images together, bandwise.
///
/// If the images
/// have n and m bands, then the output image will have n + m
/// bands, with the first n coming from the first image and the last m
/// from the second.
///
/// If the images differ in size, the smaller images are enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// The input images are cast up to the smallest common type (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// See also: `vips.Image.insert`.
extern fn vips_bandjoin(p_in: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, ...) c_int;
pub const bandjoin = vips_bandjoin;

/// Join a pair of images together, bandwise. See `vips.bandjoin`.
extern fn vips_bandjoin2(p_in1: *vips.Image, p_in2: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const bandjoin2 = vips_bandjoin2;

/// Optional arguments:
///
/// * `index`: pick this index from list of sorted values
///
/// Sorts the images `in` band-element-wise, then outputs an
/// image in which each band element is selected from the sorted list by the
/// `index` parameter. For example, if `index`
/// is zero, then each output band element will be the minimum of all the
/// corresponding input band elements.
///
/// By default, `index` is -1, meaning pick the median value.
///
/// It works for any uncoded, non-complex image type. Images are cast up to the
/// smallest common-format.
///
/// Any image can have either 1 band or n bands, where n is the same for all
/// the non-1-band images. Single band images are then effectively copied to
/// make n-band images.
///
/// Smaller input images are expanded by adding black pixels.
///
/// See also: `vips.Image.rank`.
extern fn vips_bandrank(p_in: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, ...) c_int;
pub const bandrank = vips_bandrank;

/// Optional arguments:
///
/// * `bands`: output bands
///
/// Make a black unsigned char image of a specified size.
///
/// See also: `vips.xyz`, `vips.text`, `vips.gaussnoise`.
extern fn vips_black(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const black = vips_black;

/// Set the block state on all untrusted operations.
///
/// ```
/// vips_block_untrusted_set(TRUE);
/// ```
///
/// Will block all untrusted operations from running.
///
/// Use `vips -l` at the command-line to see the class hierarchy and which
/// operations are marked as untrusted.
///
/// Set the environment variable `VIPS_BLOCK_UNTRUSTED` to block all untrusted
/// operations on `vips.init`.
extern fn vips_block_untrusted_set(p_state: c_int) void;
pub const blockUntrustedSet = vips_block_untrusted_set;

/// Perform various boolean operations on pairs of images.
///
/// The output image is the same format as the upcast input images for integer
/// types. Float types are cast to int before processing. Complex types are not
/// supported.
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// See also: `vips.Image.booleanConst`.
extern fn vips_boolean(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, p_boolean: vips.OperationBoolean, ...) c_int;
pub const boolean = vips_boolean;

/// Drop the whole operation cache, handy for leak tracking. Also called
/// automatically on `vips.shutdown`.
extern fn vips_cache_drop_all() void;
pub const cacheDropAll = vips_cache_drop_all;

/// Get the maximum number of operations we keep in cache.
extern fn vips_cache_get_max() c_int;
pub const cacheGetMax = vips_cache_get_max;

/// Get the maximum number of tracked files we allow before we start dropping
/// cached operations. See `vips.trackedGetFiles`.
///
/// libvips only tracks file descriptors it allocates, it can't track ones
/// allocated by external libraries. If you use an operation like
/// `vips.magickload`, most of the descriptors it uses won't be included.
///
/// See also: `vips.trackedGetFiles`.
extern fn vips_cache_get_max_files() c_int;
pub const cacheGetMaxFiles = vips_cache_get_max_files;

/// Get the maximum amount of tracked memory we allow before we start dropping
/// cached operations. See `vips.trackedGetMem`.
///
/// See also: `vips.trackedGetMem`.
extern fn vips_cache_get_max_mem() usize;
pub const cacheGetMaxMem = vips_cache_get_max_mem;

/// Get the current number of operations in cache.
extern fn vips_cache_get_size() c_int;
pub const cacheGetSize = vips_cache_get_size;

/// A binding-friendly version of `vips.cacheOperationBuildp`.
///
/// After calling this, `operation` has the same ref count as when it went in,
/// and the result must be freed with `vips.Object.unrefOutputs` and
/// `gobject.Object.unref`.
extern fn vips_cache_operation_build(p_operation: *vips.Operation) *vips.Operation;
pub const cacheOperationBuild = vips_cache_operation_build;

/// Look up `operation` in the cache. If we get a hit, unref `operation`, ref the
/// old one and return that through the argument pointer.
///
/// If we miss, build and add `operation`.
///
/// Operators that have been tagged as invalid by the `invalidate` signal are
/// removed from cache.
///
/// Operators with the `VIPS_OPERATION_BLOCKED` flag are never executed.
///
/// Operators with the `VIPS_OPERATION_REVALIDATE` flag are always executed and
/// any old cache value is replaced.
///
/// Operators with the `VIPS_OPERATION_NOCACHE` flag are never cached.
extern fn vips_cache_operation_buildp(p_operation: **vips.Operation) c_int;
pub const cacheOperationBuildp = vips_cache_operation_buildp;

/// Print the whole operation cache to stdout. Handy for debugging.
extern fn vips_cache_print() void;
pub const cachePrint = vips_cache_print;

/// Handy for debugging. Print the operation cache to stdout just before exit.
///
/// See also: `vips.cacheSetTrace`.
extern fn vips_cache_set_dump(p_dump: c_int) void;
pub const cacheSetDump = vips_cache_set_dump;

/// Set the maximum number of operations we keep in cache.
extern fn vips_cache_set_max(p_max: c_int) void;
pub const cacheSetMax = vips_cache_set_max;

/// Set the maximum number of tracked files we allow before we start dropping
/// cached operations. See `vips.trackedGetFiles`.
///
/// See also: `vips.trackedGetFiles`.
extern fn vips_cache_set_max_files(p_max_files: c_int) void;
pub const cacheSetMaxFiles = vips_cache_set_max_files;

/// Set the maximum amount of tracked memory we allow before we start dropping
/// cached operations. See `vips.trackedGetMem`.
///
/// libvips only tracks memory it allocates, it can't track memory allocated by
/// external libraries. If you use an operation like `vips.magickload`, most of
/// the memory it uses won't be included.
///
/// See also: `vips.trackedGetMem`.
extern fn vips_cache_set_max_mem(p_max_mem: usize) void;
pub const cacheSetMaxMem = vips_cache_set_max_mem;

/// Handy for debugging. Print operation cache actions to stdout as we run.
///
/// You can set the environment variable `VIPS_TRACE` to turn this option on, or
/// use the command-line flag `--vips-cache-trace`.
///
/// See also: `vips.cacheSetDump`.
extern fn vips_cache_set_trace(p_trace: c_int) void;
pub const cacheSetTrace = vips_cache_set_trace;

/// `vips.call` calls the named operation, passing in required arguments and
/// then setting any optional ones from the remainder of the arguments as a set
/// of name/value pairs.
///
/// For example, `vips.Image.embed` takes six required arguments, `in`, `out`, `x`, `y`,
/// `width`, `height`, and has two optional arguments, `extend` and `background`.
/// You can run it with `vips.call` like this:
///
/// ```
/// VipsImage *in = ...
/// VipsImage *out;
///
/// if (vips_call("embed", in, &out, 10, 10, 100, 100,
///         "extend", VIPS_EXTEND_COPY,
///         NULL))
///     ... error
/// ```
///
/// Normally of course you'd just use the `vips.Image.embed` wrapper function and get
/// type-safety for the required arguments.
///
/// See also: `vips.callSplit`, `vips.callOptions`.
extern fn vips_call(p_operation_name: [*:0]const u8, ...) c_int;
pub const call = vips_call;

extern fn vips_call_argv(p_operation: *vips.Operation, p_argc: c_int, p_argv: *[*:0]u8) c_int;
pub const callArgv = vips_call_argv;

extern fn vips_call_options(p_group: *glib.OptionGroup, p_operation: *vips.Operation) void;
pub const callOptions = vips_call_options;

/// This is the main entry point for the C and C++ varargs APIs. `operation`
/// is executed, supplying `required` and `optional` arguments.
///
/// Beware, this can change `operation` to point at an old, cached one.
extern fn vips_call_required_optional(p_operation: **vips.Operation, p_required: std.builtin.VaList, p_optional: std.builtin.VaList) c_int;
pub const callRequiredOptional = vips_call_required_optional;

extern fn vips_call_split(p_operation_name: [*:0]const u8, p_optional: std.builtin.VaList, ...) c_int;
pub const callSplit = vips_call_split;

extern fn vips_call_split_option_string(p_operation_name: [*:0]const u8, p_option_string: [*:0]const u8, p_optional: std.builtin.VaList, ...) c_int;
pub const callSplitOptionString = vips_call_split_option_string;

/// Check that the image is 8 or 16-bit integer, signed or unsigned.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_8or16(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const check8or16 = vips_check_8or16;

/// `bandno` should be a valid band number (ie. 0 to im->Bands - 1), or can be
/// -1, meaning all bands.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_bandno(p_domain: [*:0]const u8, p_im: *vips.Image, p_bandno: c_int) c_int;
pub const checkBandno = vips_check_bandno;

/// Check that the image has `bands` bands.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_bands(p_domain: [*:0]const u8, p_im: *vips.Image, p_bands: c_int) c_int;
pub const checkBands = vips_check_bands;

/// Check that the image has either one or three bands.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_bands_1or3(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkBands1or3 = vips_check_bands_1or3;

/// Check that the images have the same number of bands, or that one of the
/// images has just 1 band.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_bands_1orn(p_domain: [*:0]const u8, p_im1: *vips.Image, p_im2: *vips.Image) c_int;
pub const checkBands1orn = vips_check_bands_1orn;

/// Check that an image has 1 or `n` bands. Handy for unary operations, cf.
/// `vips.checkBands1orn`.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.checkBands1orn`.
extern fn vips_check_bands_1orn_unary(p_domain: [*:0]const u8, p_im: *vips.Image, p_n: c_int) c_int;
pub const checkBands1ornUnary = vips_check_bands_1orn_unary;

/// Check that the image has at least `bands` bands.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_bands_atleast(p_domain: [*:0]const u8, p_im: *vips.Image, p_bands: c_int) c_int;
pub const checkBandsAtleast = vips_check_bands_atleast;

/// Check that the images have the same number of bands.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_bands_same(p_domain: [*:0]const u8, p_im1: *vips.Image, p_im2: *vips.Image) c_int;
pub const checkBandsSame = vips_check_bands_same;

/// Check that the image has the required `coding`.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_coding(p_domain: [*:0]const u8, p_im: *vips.Image, p_coding: vips.Coding) c_int;
pub const checkCoding = vips_check_coding;

/// Check that the image is uncoded, LABQ coded or RAD coded.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_coding_known(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkCodingKnown = vips_check_coding_known;

/// Check that the image is uncoded or LABQ coded.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_coding_noneorlabq(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkCodingNoneorlabq = vips_check_coding_noneorlabq;

/// Check that the images have the same coding.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_coding_same(p_domain: [*:0]const u8, p_im1: *vips.Image, p_im2: *vips.Image) c_int;
pub const checkCodingSame = vips_check_coding_same;

/// Check that the image is complex.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_complex(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkComplex = vips_check_complex;

/// Check that the image has the specified format.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_format(p_domain: [*:0]const u8, p_im: *vips.Image, p_fmt: vips.BandFormat) c_int;
pub const checkFormat = vips_check_format;

/// Check that the images have the same format.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_format_same(p_domain: [*:0]const u8, p_im1: *vips.Image, p_im2: *vips.Image) c_int;
pub const checkFormatSame = vips_check_format_same;

/// Histogram images must have width or height 1, and must not have more than
/// 65536 elements. Return 0 if the image will pass as a histogram, or -1 and
/// set an error message otherwise.
///
/// See also: `vips.@"error"`.
extern fn vips_check_hist(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkHist = vips_check_hist;

/// Check that the image is in one of the integer formats.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_int(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkInt = vips_check_int;

/// Matrix images must have width and height less than 100000 and have 1 band.
///
/// Return 0 if the image will pass as a matrix, or -1 and set an error
/// message otherwise.
///
/// `out` is set to be `im` cast to double and stored in memory. Use
/// `VIPS_MATRIX` to address values in `out`.
///
/// You must unref `out` when you are done with it.
///
/// See also: `VIPS_MATRIX`, `vips_object_local`
extern fn vips_check_matrix(p_domain: [*:0]const u8, p_im: *vips.Image, p_out: **vips.Image) c_int;
pub const checkMatrix = vips_check_matrix;

/// Check that the image has exactly one band.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_mono(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkMono = vips_check_mono;

/// Check that the image is not complex.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_noncomplex(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkNoncomplex = vips_check_noncomplex;

/// Check that the image is square and that the sides are odd.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_oddsquare(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkOddsquare = vips_check_oddsquare;

/// Check that `prec` image is either float or int.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_precision_intfloat(p_domain: [*:0]const u8, p_precision: vips.Precision) c_int;
pub const checkPrecisionIntfloat = vips_check_precision_intfloat;

/// Separable matrix images must have width or height 1.
/// Return 0 if the image will pass, or -1 and
/// set an error message otherwise.
///
/// See also: `vips.@"error"`.
extern fn vips_check_separable(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkSeparable = vips_check_separable;

/// Check that the images have the same size.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_size_same(p_domain: [*:0]const u8, p_im1: *vips.Image, p_im2: *vips.Image) c_int;
pub const checkSizeSame = vips_check_size_same;

/// Check that the image is has two "components", ie. is a one-band complex or
/// a two-band non-complex.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_twocomponents(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkTwocomponents = vips_check_twocomponents;

/// Check that the image is 8 or 16-bit unsigned integer.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_u8or16(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkU8or16 = vips_check_u8or16;

/// Check that the image is 8 or 16-bit unsigned integer, or float.
/// Otherwise set an error message and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_u8or16orf(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkU8or16orf = vips_check_u8or16orf;

/// Check that the image is in one of the unsigned integer formats.
/// Otherwise set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_uint(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkUint = vips_check_uint;

/// Check that the image is unsigned int or float.
/// Otherwise set an error message and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_uintorf(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkUintorf = vips_check_uintorf;

/// Check that the image is not coded.
/// If not, set an error message
/// and return non-zero.
///
/// See also: `vips.@"error"`.
extern fn vips_check_uncoded(p_domain: [*:0]const u8, p_im: *vips.Image) c_int;
pub const checkUncoded = vips_check_uncoded;

/// Operations with a vector constant need a 1-element vector, or a vector with
/// the same number of elements as there are bands in the image, or a 1-band
/// image and a many-element vector.
///
/// See also: `vips.@"error"`.
extern fn vips_check_vector(p_domain: [*:0]const u8, p_n: c_int, p_im: *vips.Image) c_int;
pub const checkVector = vips_check_vector;

/// Check that `n` == `len`.
///
/// See also: `vips.@"error"`.
extern fn vips_check_vector_length(p_domain: [*:0]const u8, p_n: c_int, p_len: c_int) c_int;
pub const checkVectorLength = vips_check_vector_length;

/// Search below `basename`, return the first class whose name or `nickname`
/// matches.
///
/// See also: `vips.typeFind`
extern fn vips_class_find(p_basename: [*:0]const u8, p_nickname: [*:0]const u8) *const vips.ObjectClass;
pub const classFind = vips_class_find;

/// Loop over all the subclasses of `type`. Non-abstract classes only.
/// Stop when `fn` returns
/// non-`NULL` and return that value.
extern fn vips_class_map_all(p_type: usize, p_fn: vips.ClassMapFn, p_a: ?*anyopaque) ?*anyopaque;
pub const classMapAll = vips_class_map_all;

/// Calculate Ccmc from C.
extern fn vips_col_C2Ccmc(p_C: f32) f32;
pub const colC2Ccmc = vips_col_C2Ccmc;

/// Calculate C from Ccmc using a table.
/// Call `vips.colMakeTablesCMC` at
/// least once before using this function.
extern fn vips_col_Ccmc2C(p_Ccmc: f32) f32;
pub const colCcmc2C = vips_col_Ccmc2C;

/// Calculate ab from Ch, h in degrees.
extern fn vips_col_Ch2ab(p_C: f32, p_h: f32, p_a: *f32, p_b: *f32) void;
pub const colCh2ab = vips_col_Ch2ab;

/// Calculate hcmc from C and h.
extern fn vips_col_Ch2hcmc(p_C: f32, p_h: f32) f32;
pub const colCh2hcmc = vips_col_Ch2hcmc;

/// Calculate h from C and hcmc, using a table.
/// Call `vips.colMakeTablesCMC` at
/// least once before using this function.
extern fn vips_col_Chcmc2h(p_C: f32, p_hcmc: f32) f32;
pub const colChcmc2h = vips_col_Chcmc2h;

/// Calculate Lcmc from L.
extern fn vips_col_L2Lcmc(p_L: f32) f32;
pub const colL2Lcmc = vips_col_L2Lcmc;

/// Calculate XYZ from Lab, D65.
///
/// See also: `vips.Image.Lab2XYZ`.
extern fn vips_col_Lab2XYZ(p_L: f32, p_a: f32, p_b: f32, p_X: *f32, p_Y: *f32, p_Z: *f32) void;
pub const colLab2XYZ = vips_col_Lab2XYZ;

/// Calculate L from Lcmc using a table. Call `vips.colMakeTablesCMC` at
/// least once before using this function.
extern fn vips_col_Lcmc2L(p_Lcmc: f32) f32;
pub const colLcmc2L = vips_col_Lcmc2L;

/// Calculate XYZ from Lab, D65.
///
/// See also: `vips.Image.XYZ2Lab`.
extern fn vips_col_XYZ2Lab(p_X: f32, p_Y: f32, p_Z: f32, p_L: *f32, p_a: *f32, p_b: *f32) void;
pub const colXYZ2Lab = vips_col_XYZ2Lab;

/// Turn XYZ into scRGB.
///
/// See also: `vips.Image.XYZ2scRGB`.
extern fn vips_col_XYZ2scRGB(p_X: f32, p_Y: f32, p_Z: f32, p_R: *f32, p_G: *f32, p_B: *f32) c_int;
pub const colXYZ2scRGB = vips_col_XYZ2scRGB;

extern fn vips_col_ab2Ch(p_a: f32, p_b: f32, p_C: *f32, p_h: *f32) void;
pub const colAb2Ch = vips_col_ab2Ch;

extern fn vips_col_ab2h(p_a: f64, p_b: f64) f64;
pub const colAb2h = vips_col_ab2h;

/// CIEDE2000, from:
///
/// Luo, Cui, Rigg, "The Development of the CIE 2000 Colour-Difference
/// Formula: CIEDE2000", COLOR research and application, pp 340
extern fn vips_col_dE00(p_L1: f32, p_a1: f32, p_b1: f32, p_L2: f32, p_a2: f32, p_b2: f32) f32;
pub const colDE00 = vips_col_dE00;

/// Make the lookup tables for cmc.
extern fn vips_col_make_tables_CMC() void;
pub const colMakeTablesCMC = vips_col_make_tables_CMC;

extern fn vips_col_sRGB2scRGB_16(p_r: c_int, p_g: c_int, p_b: c_int, p_R: *f32, p_G: *f32, p_B: *f32) c_int;
pub const colSRGB2scRGB16 = vips_col_sRGB2scRGB_16;

extern fn vips_col_sRGB2scRGB_16_noclip(p_r: c_int, p_g: c_int, p_b: c_int, p_R: *f32, p_G: *f32, p_B: *f32) c_int;
pub const colSRGB2scRGB16Noclip = vips_col_sRGB2scRGB_16_noclip;

extern fn vips_col_sRGB2scRGB_8(p_r: c_int, p_g: c_int, p_b: c_int, p_R: *f32, p_G: *f32, p_B: *f32) c_int;
pub const colSRGB2scRGB8 = vips_col_sRGB2scRGB_8;

extern fn vips_col_sRGB2scRGB_8_noclip(p_r: c_int, p_g: c_int, p_b: c_int, p_R: *f32, p_G: *f32, p_B: *f32) c_int;
pub const colSRGB2scRGB8Noclip = vips_col_sRGB2scRGB_8_noclip;

extern fn vips_col_scRGB2BW_16(p_R: f32, p_G: f32, p_B: f32, p_g: *c_int, p_og: *c_int) c_int;
pub const colScRGB2BW16 = vips_col_scRGB2BW_16;

extern fn vips_col_scRGB2BW_8(p_R: f32, p_G: f32, p_B: f32, p_g: *c_int, p_og: *c_int) c_int;
pub const colScRGB2BW8 = vips_col_scRGB2BW_8;

/// Turn scRGB into XYZ.
///
/// See also: `vips.Image.scRGB2XYZ`.
extern fn vips_col_scRGB2XYZ(p_R: f32, p_G: f32, p_B: f32, p_X: *f32, p_Y: *f32, p_Z: *f32) c_int;
pub const colScRGB2XYZ = vips_col_scRGB2XYZ;

extern fn vips_col_scRGB2sRGB_16(p_R: f32, p_G: f32, p_B: f32, p_r: *c_int, p_g: *c_int, p_b: *c_int, p_og: *c_int) c_int;
pub const colScRGB2sRGB16 = vips_col_scRGB2sRGB_16;

extern fn vips_col_scRGB2sRGB_8(p_R: f32, p_G: f32, p_B: f32, p_r: *c_int, p_g: *c_int, p_b: *c_int, p_og: *c_int) c_int;
pub const colScRGB2sRGB8 = vips_col_scRGB2sRGB_8;

/// Perform various binary operations on complex images.
///
/// Angles are expressed in degrees. The output type is complex unless the
/// input is double or dpcomplex, in which case the output is dpcomplex.
extern fn vips_complex2(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, p_cmplx: vips.OperationComplex2, ...) c_int;
pub const complex2 = vips_complex2;

/// Compose two real images to make a complex image. If either `left` or `right`
/// are `VIPS_FORMAT_DOUBLE`, `out` is `VIPS_FORMAT_DPCOMPLEX`. Otherwise `out`
/// is `VIPS_FORMAT_COMPLEX`. `left` becomes the real component of `out` and
/// `right` the imaginary.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// See also: `vips.Image.complexget`.
extern fn vips_complexform(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const complexform = vips_complexform;

/// Optional arguments:
///
/// * `compositing_space`: `vips.Interpretation` to composite in
/// * `premultiplied`: `gboolean`, images are already premultiplied
/// * `x`: `vips.ArrayInt`, array of (`n` - 1) x coordinates
/// * `y`: `vips.ArrayInt`, array of (`n` - 1) y coordinates
///
/// Composite an array of images together.
///
/// Images are placed in a stack, with `in`[0] at the bottom and `in`[`n` - 1] at
/// the top. Pixels are blended together working from the bottom upwards, with
/// the blend mode at each step being set by the corresponding `vips.BlendMode`
/// in `mode`.
///
/// Images are transformed to a compositing space before processing. This is
/// `VIPS_INTERPRETATION_sRGB`, `VIPS_INTERPRETATION_B_W`,
/// `VIPS_INTERPRETATION_RGB16`, or `VIPS_INTERPRETATION_GREY16`
/// by default, depending on
/// how many bands and bits the input images have. You can select any other
/// space, such as `VIPS_INTERPRETATION_LAB` or `VIPS_INTERPRETATION_scRGB`.
///
/// The output image is in the compositing space. It will always be
/// `VIPS_FORMAT_FLOAT` unless one of the inputs is `VIPS_FORMAT_DOUBLE`, in
/// which case the output will be double as well.
///
/// Complex images are not supported.
///
/// The output image will always have an alpha band. A solid alpha is
/// added to any input missing an alpha.
///
/// The images do not need to match in size or format. The output image is
/// always the size of `in`[0], with other images being
/// positioned with the `x` and `y` parameters and clipped
/// against that rectangle.
///
/// Image are normally treated as unpremultiplied, so this operation can be used
/// directly on PNG images. If your images have been through `vips.Image.premultiply`,
/// set `premultiplied`.
///
/// See also: `vips.Image.insert`.
extern fn vips_composite(p_in: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, p_mode: *c_int, ...) c_int;
pub const composite = vips_composite;

/// Returns the number of worker threads that vips should use when running a
/// `VipsThreadPool`.
///
/// vips gets this values from these sources in turn:
///
/// If `vips.concurrencySet` has been called, this value is used. The special
/// value 0 means "default". You can also use the command-line argument
/// "--vips-concurrency" to set this value.
///
/// If `vips.concurrencySet` has not been called and no command-line argument
/// was used, vips uses the value of the environment variable VIPS_CONCURRENCY,
///
/// If VIPS_CONCURRENCY has not been set, vips finds the number of hardware
/// threads that the host machine can run in parallel and uses that value.
///
/// The final value is clipped to the range 1 - 1024.
///
/// See also: `vips.concurrencyGet`.
extern fn vips_concurrency_get() c_int;
pub const concurrencyGet = vips_concurrency_get;

/// Sets the number of worker threads that vips should use when running a
/// `VipsThreadPool`.
///
/// The special value 0 means "default". In this case, the number of threads
/// is set by the environment variable VIPS_CONCURRENCY, or if that is not
/// set, the number of threads available on the host machine.
///
/// See also: `vips.concurrencyGet`.
extern fn vips_concurrency_set(p_concurrency: c_int) void;
pub const concurrencySet = vips_concurrency_set;

/// Perform `VIPS_OPERATION_COMPLEX2_CROSS_PHASE` on an image.
/// See `vips.complex2`.
extern fn vips_cross_phase(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const crossPhase = vips_cross_phase;

/// Optional arguments:
///
/// * `skip`: skip this many lines at start of file
/// * `lines`: read this many lines from file
/// * `whitespace`: set of whitespace characters
/// * `separator`: set of separator characters
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Load a CSV (comma-separated values) file. The output image is always 1
/// band (monochrome), `VIPS_FORMAT_DOUBLE`. Use `vips.Image.bandfold` to turn
/// RGBRGBRGB mono images into colour images.
///
/// Items in lines can be either floating point numbers in the C locale, or
/// strings enclosed in double-quotes ("), or empty.
/// You can use a backslash (\) within the quotes to escape special characters,
/// such as quote marks.
///
/// `skip` sets the number of lines to skip at the start of the file.
/// Default zero.
///
/// `lines` sets the number of lines to read from the file. Default -1,
/// meaning read all lines to end of file.
///
/// `whitespace` sets the skippable whitespace characters.
/// Default <emphasis>space</emphasis>.
/// Whitespace characters are always run together.
///
/// `separator` sets the characters that separate fields.
/// Default ;,<emphasis>tab</emphasis>. Separators are never run together.
///
/// Use `fail_on` to set the type of error that will cause load to fail. By
/// default, loaders are permissive, that is, `VIPS_FAIL_ON_NONE`.
///
/// See also: `vips.Image.newFromFile`, `vips.Image.bandfold`.
extern fn vips_csvload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const csvload = vips_csvload;

/// Optional arguments:
///
/// * `skip`: skip this many lines at start of file
/// * `lines`: read this many lines from file
/// * `whitespace`: set of whitespace characters
/// * `separator`: set of separator characters
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Exactly as `vips.csvload`, but read from a source.
///
/// See also: `vips.csvload`.
extern fn vips_csvload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const csvloadSource = vips_csvload_source;

/// Calculate dE 00.
extern fn vips_dE00(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const dE00 = vips_dE00;

/// Calculate dE 76.
extern fn vips_dE76(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const dE76 = vips_dE76;

/// Calculate dE CMC. The input images are transformed to CMC colour space and
/// the euclidean distance between corresponding pixels calculated.
///
/// To calculate a colour difference with values for (l:c) other than (1:1),
/// transform the two source images to CMC yourself, scale the channels
/// appropriately, and call this function.
///
/// See also: `vips.Image.colourspace`
extern fn vips_dECMC(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const dECMC = vips_dECMC;

/// This operation calculates `in1` / `in2` and writes the result to `out`. If any
/// pixels in `in2` are zero, the corresponding pixel in `out` is also zero.
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), then the
/// following table is used to determine the output type:
///
/// <table>
///   <title>`vips.divide` type promotion</title>
///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
///     <thead>
///       <row>
///         <entry>input type</entry>
///         <entry>output type</entry>
///       </row>
///     </thead>
///     <tbody>
///       <row>
///         <entry>uchar</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>char</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>ushort</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>short</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>uint</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>int</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>float</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>double</entry>
///         <entry>double</entry>
///       </row>
///       <row>
///         <entry>complex</entry>
///         <entry>complex</entry>
///       </row>
///       <row>
///         <entry>double complex</entry>
///         <entry>double complex</entry>
///       </row>
///     </tbody>
///   </tgroup>
/// </table>
///
/// In other words, the output type is just large enough to hold the whole
/// range of possible values.
///
/// See also: `vips.multiply`, `vips.Image.linear`, `vips.pow`.
extern fn vips_divide(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const divide = vips_divide;

/// Perform `VIPS_OPERATION_BOOLEAN_EOR` on a pair of images. See
/// `vips.boolean`.
extern fn vips_eorimage(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const eorimage = vips_eorimage;

/// Perform `VIPS_OPERATION_RELATIONAL_EQUAL` on a pair of images. See
/// `vips.relational`.
extern fn vips_equal(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const equal = vips_equal;

/// Format the string in the style of `printf` and append to the error buffer.
///
/// See also: `vips.errorSystem`, `vips.verror`.
extern fn vips_error(p_domain: [*:0]const u8, p_fmt: [*:0]const u8, ...) void;
pub const @"error" = vips_error;

/// Get a pointer to the start of the error buffer as a C string.
/// The string is owned by the error system and must not be freed.
///
/// See also: `vips.errorClear`.
extern fn vips_error_buffer() [*:0]const u8;
pub const errorBuffer = vips_error_buffer;

/// Return a copy of the vips error buffer, and clear it.
extern fn vips_error_buffer_copy() [*:0]u8;
pub const errorBufferCopy = vips_error_buffer_copy;

/// Clear and reset the error buffer. This is typically called after presenting
/// an error to the user.
///
/// See also: `vips.errorBuffer`.
extern fn vips_error_clear() void;
pub const errorClear = vips_error_clear;

/// Sends a formatted error message to stderr, then sends the contents of the
/// error buffer, if any, then shuts down vips and terminates the program with
/// an error code.
///
/// `fmt` may be `NULL`, in which case only the error buffer is printed before
/// exiting.
///
/// See also: `vips.@"error"`.
extern fn vips_error_exit(p_fmt: [*:0]const u8, ...) void;
pub const errorExit = vips_error_exit;

/// Stop errors being logged. Use `vips.errorThaw` to unfreeze. You can
/// nest freeze/thaw pairs.
extern fn vips_error_freeze() void;
pub const errorFreeze = vips_error_freeze;

/// This function sets the glib error pointer from the vips error buffer and
/// clears it. It's handy for returning errors to glib functions from vips.
///
/// See `vips.gError` for the inverse operation.
///
/// See also: `glib.setError`, `vips.gError`.
extern fn vips_error_g(p_error: ?*?*glib.Error) void;
pub const errorG = vips_error_g;

/// Format the string in the style of `printf` and append to the error buffer.
/// Then create and append a localised message based on the system error code,
/// usually the value of errno.
///
/// See also: `vips.verrorSystem`.
extern fn vips_error_system(p_err: c_int, p_domain: [*:0]const u8, p_fmt: [*:0]const u8, ...) void;
pub const errorSystem = vips_error_system;

/// Re-enable error logging.
extern fn vips_error_thaw() void;
pub const errorThaw = vips_error_thaw;

/// Optional arguments:
///
/// * `factor`: `gdouble`, maximum spatial frequency
/// * `uchar`: `gboolean`, output a uchar image
///
/// Create a test pattern with increasing spatial frequency in X and
/// amplitude in Y. `factor` should be between 0 and 1 and determines the
/// maximum spatial frequency.
///
/// Set `uchar` to output a uchar image.
///
/// See also: `vips.zone`.
extern fn vips_eye(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const eye = vips_eye;

/// Given a vips filename like "fred.jpg[Q=90]", return a new string of
/// just the filename part, "fred.jpg" in this case.
///
/// Useful for language bindings.
///
/// See also: `vips.filenameGetOptions`.
extern fn vips_filename_get_filename(p_vips_filename: [*:0]const u8) [*:0]u8;
pub const filenameGetFilename = vips_filename_get_filename;

/// Given a vips filename like "fred.jpg[Q=90]", return a new string of
/// just the options part, "[Q=90]" in this case.
///
/// Useful for language bindings.
///
/// See also: `vips.filenameGetFilename`.
extern fn vips_filename_get_options(p_vips_filename: [*:0]const u8) [*:0]u8;
pub const filenameGetOptions = vips_filename_get_options;

/// Read a FITS image file into a VIPS image.
///
/// This operation can read images with up to three dimensions. Any higher
/// dimensions must be empty.
///
/// It can read 8, 16 and 32-bit integer images, signed and unsigned, float and
/// double.
///
/// FITS metadata is attached with the "fits-" prefix.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_fitsload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const fitsload = vips_fitsload;

/// Return the flags for `filename` using `loader`.
/// `loader` is something like "tiffload" or "VipsForeignLoadTiff".
extern fn vips_foreign_flags(p_loader: [*:0]const u8, p_filename: [*:0]const u8) vips.ForeignFlags;
pub const foreignFlags = vips_foreign_flags;

extern fn vips_format_sizeof(p_format: vips.BandFormat) u64;
pub const formatSizeof = vips_format_sizeof;

/// A fast but dangerous version of `vips.formatSizeof`. You must have
/// previously range-checked `format` or you'll crash.
extern fn vips_format_sizeof_unsafe(p_format: vips.BandFormat) u64;
pub const formatSizeofUnsafe = vips_format_sizeof_unsafe;

/// Generate an image of size `width` by `height` and fractal dimension
/// `fractal_dimension`. The dimension should be between 2 and 3.
///
/// See also: `vips.gaussnoise`, `vips.maskFractal`.
extern fn vips_fractsurf(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_fractal_dimension: f64, ...) c_int;
pub const fractsurf = vips_fractsurf;

/// This function adds the `glib.Error` to the vips error buffer and clears it. It's
/// the opposite of `vips.errorG`.
///
/// See also: `vips.errorG`.
extern fn vips_g_error(p_error: ?*?*glib.Error) void;
pub const gError = vips_g_error;

/// Optional arguments:
///
/// * `separable`: generate a separable gaussian
/// * `precision`: `vips.Precision` for `out`
///
/// Creates a circularly symmetric Gaussian image of radius
/// `sigma`.  The size of the mask is determined by the variable `min_ampl`;
/// if for instance the value .1 is entered this means that the produced mask
/// is clipped at values less than 10 percent of the maximum amplitude.
///
/// The program uses the following equation:
///
///   H(r) = exp(-(r * r) / (2 * `sigma` * `sigma`))
///
/// The generated image has odd size and its maximum value is normalised to
/// 1.0, unless `precision` is `VIPS_PRECISION_INTEGER`.
///
/// If `separable` is set, only the centre horizontal is generated. This is
/// useful for separable convolutions.
///
/// If `precision` is `VIPS_PRECISION_INTEGER`, an integer gaussian is generated.
/// This is useful for integer convolutions.
///
/// "scale" is set to the sum of all the mask elements.
///
/// See also: `vips.logmat`, `vips.Image.conv`.
extern fn vips_gaussmat(p_out: **vips.Image, p_sigma: f64, p_min_ampl: f64, ...) c_int;
pub const gaussmat = vips_gaussmat;

/// Optional arguments:
///
/// * `mean`: mean of generated pixels
/// * `sigma`: standard deviation of generated pixels
///
/// Make a one band float image of gaussian noise with the specified
/// distribution. The noise distribution is created by averaging 12 random
/// numbers with the appropriate weights.
///
/// See also: `vips.black`, `vips.xyz`, `vips.text`.
extern fn vips_gaussnoise(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const gaussnoise = vips_gaussnoise;

/// See also: `VIPS_INIT`.
extern fn vips_get_argv0() [*:0]const u8;
pub const getArgv0 = vips_get_argv0;

/// Return the number of bytes at which we flip between open via memory and
/// open via disc. This defaults to 100mb, but can be changed with the
/// VIPS_DISC_THRESHOLD environment variable or the --vips-disc-threshold
/// command-line flag. See `vips.Image.newFromFile`.
extern fn vips_get_disc_threshold() u64;
pub const getDiscThreshold = vips_get_disc_threshold;

/// Return the program name. This can be useful for the user tio see,.
///
/// See also: `VIPS_INIT`.
extern fn vips_get_prgname() [*:0]const u8;
pub const getPrgname = vips_get_prgname;

/// Optional arguments:
///
/// * `page`: `gint`, page (frame) to read
/// * `n`: `gint`, load this many pages
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Read a GIF file into a libvips image.
///
/// Use `page` to select a page to render, numbering from zero.
///
/// Use `n` to select the number of pages to render. The default is 1. Pages are
/// rendered in a vertical column. Set to -1 to mean "until the end of the
/// document". Use `vips.Image.grid` to change page layout.
///
/// Use `fail_on` to set the type of error that will cause load to fail. By
/// default, loaders are permissive, that is, `VIPS_FAIL_ON_NONE`.
///
/// The output image is RGBA for GIFs containing transparent elements, RGB
/// otherwise.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_gifload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const gifload = vips_gifload;

/// Optional arguments:
///
/// * `page`: `gint`, page (frame) to read
/// * `n`: `gint`, load this many pages
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Exactly as `vips.gifload`, but read from a memory buffer.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.gifload`.
extern fn vips_gifload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const gifloadBuffer = vips_gifload_buffer;

/// Optional arguments:
///
/// * `page`: `gint`, page (frame) to read
/// * `n`: `gint`, load this many pages
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Exactly as `vips.gifload`, but read from a source.
///
/// See also: `vips.gifload`.
extern fn vips_gifload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const gifloadSource = vips_gifload_source;

/// Optional arguments:
///
/// * `extend`: `vips.Extend` to generate the edge pixels (default: black)
/// * `background`: `vips.ArrayDouble` colour for edge pixels
///
/// The opposite of `vips.Image.extractArea`: place `in` within an image of size
/// `width` by `height` at a certain gravity.
///
/// `extend`
/// controls what appears in the new pels, see `vips.Extend`.
///
/// See also: `vips.Image.extractArea`, `vips.Image.insert`.
extern fn vips_gravity(p_in: *vips.Image, p_out: **vips.Image, p_direction: vips.CompassDirection, p_width: c_int, p_height: c_int, ...) c_int;
pub const gravity = vips_gravity;

/// Optional arguments:
///
/// * `uchar`: output a uchar image
///
/// Create a one-band float image with the left-most column zero and the
/// right-most 1. Intermediate pixels are a linear ramp.
///
/// Set `uchar` to output a uchar image with the leftmost pixel 0 and the
/// rightmost 255.
///
/// See also: `vips.xyz`, `vips.identity`.
extern fn vips_grey(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const grey = vips_grey;

/// `vips.guessLibdir` tries to guess the install directory (usually the
/// configure libdir, or $prefix/lib). You should pass
/// in the value of argv[0] (the name your program was run as) as a clue to
/// help it out, plus the name of the environment variable you let the user
/// override your package install area with (eg. "VIPSHOME").
///
/// On success, `vips.guessLibdir` returns the libdir it discovered, and as a
/// side effect, sets the prefix environment variable (if it's not set).
///
/// Don't free the return string!
///
/// See also: `vips.guessPrefix`.
extern fn vips_guess_libdir(p_argv0: [*:0]const u8, p_env_name: [*:0]const u8) [*:0]const u8;
pub const guessLibdir = vips_guess_libdir;

/// `vips.guessPrefix` tries to guess the install directory. You should pass
/// in the value of argv[0] (the name your program was run as) as a clue to
/// help it out, plus the name of the environment variable you let the user
/// override your package install area with (eg. "VIPSHOME").
///
/// On success, `vips.guessPrefix` returns the prefix it discovered, and as a
/// side effect, sets the environment variable (if it's not set).
///
/// Don't free the return string!
///
/// See also: `vips.guessLibdir`.
extern fn vips_guess_prefix(p_argv0: [*:0]const u8, p_env_name: [*:0]const u8) [*:0]const u8;
pub const guessPrefix = vips_guess_prefix;

/// Optional arguments:
///
/// * `page`: `gint`, page (top-level image number) to read
/// * `n`: `gint`, load this many pages
/// * `thumbnail`: `gboolean`, fetch thumbnail instead of image
/// * `unlimited`: `gboolean`, remove all denial of service limits
///
/// Read a HEIF image file into a VIPS image.
///
/// Use `page` to select a page to render, numbering from zero. If neither `n`
/// nor `page` are set, `page` defaults to the primary page, otherwise to 0.
///
/// Use `n` to select the number of pages to render. The default is 1. Pages are
/// rendered in a vertical column. Set to -1 to mean "until the end of the
/// document". Use `vips.Image.grid` to reorganise pages.
///
/// HEIF images have a primary image. The metadata item `heif-primary` gives
/// the page number of the primary.
///
/// If `thumbnail` is `TRUE`, then fetch a stored thumbnail rather than the
/// image.
///
/// By default, input image dimensions are limited to 16384x16384.
/// If `unlimited` is `TRUE`, this increases to the maximum of 65535x65535.
///
/// The bitdepth of the heic image is recorded in the metadata item
/// `heif-bitdepth`.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_heifload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const heifload = vips_heifload;

/// Optional arguments:
///
/// * `page`: `gint`, page (top-level image number) to read
/// * `n`: `gint`, load this many pages
/// * `thumbnail`: `gboolean`, fetch thumbnail instead of image
/// * `unlimited`: `gboolean`, remove all denial of service limits
///
/// Read a HEIF image file into a VIPS image.
/// Exactly as `vips.heifload`, but read from a memory buffer.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.heifload`.
extern fn vips_heifload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const heifloadBuffer = vips_heifload_buffer;

/// Optional arguments:
///
/// * `page`: `gint`, page (top-level image number) to read
/// * `n`: `gint`, load this many pages
/// * `thumbnail`: `gboolean`, fetch thumbnail instead of image
/// * `unlimited`: `gboolean`, remove all denial of service limits
///
/// Exactly as `vips.heifload`, but read from a source.
///
/// See also: `vips.heifload`.
extern fn vips_heifload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const heifloadSource = vips_heifload_source;

extern fn vips_icc_is_compatible_profile(p_image: *vips.Image, p_data: ?*anyopaque, p_data_length: usize) c_int;
pub const iccIsCompatibleProfile = vips_icc_is_compatible_profile;

/// VIPS can optionally be built without the ICC library. Use this function to
/// test for its availability.
extern fn vips_icc_present() c_int;
pub const iccPresent = vips_icc_present;

/// Optional arguments:
///
/// * `bands`: number of bands to create
/// * `ushort`: `TRUE` for an unsigned short identity
/// * `size`: number of LUT elements for a ushort image
///
/// Creates an identity lookup table, ie. one which will leave an image
/// unchanged when applied with `vips.Image.maplut`. Each entry in the table has a
/// value equal to its position.
///
/// Use the arithmetic operations on these tables to make LUTs representing
/// arbitrary functions.
///
/// Normally LUTs are 8-bit. Set `ushort` to create a 16-bit table.
///
/// Normally 16-bit tables have 65536 entries. You can set this smaller with
/// `size`.
///
/// See also: `vips.xyz`, `vips.Image.maplut`.
extern fn vips_identity(p_out: **vips.Image, ...) c_int;
pub const identity = vips_identity;

/// Optional arguments:
///
/// * `blend`: blend smoothly between `in1` and `in2`
///
/// This operation scans the condition image `cond`
/// and uses it to select pixels from either the then image `in1` or the else
/// image `in2`. Non-zero means `in1`, 0 means `in2`.
///
/// Any image can have either 1 band or n bands, where n is the same for all
/// the non-1-band images. Single band images are then effectively copied to
/// make n-band images.
///
/// Images `in1` and `in2` are cast up to the smallest common format. `cond` is
/// cast to uchar.
///
/// If the images differ in size, the smaller images are enlarged to match the
/// largest by adding zero pixels along the bottom and right.
///
/// If `blend` is `TRUE`, then values in `out` are smoothly blended between `in1`
/// and `in2` using the formula:
///
///   `out` = (`cond` / 255) * `in1` + (1 - `cond` / 255) * `in2`
///
/// See also: `vips.equal`.
extern fn vips_ifthenelse(p_cond: *vips.Image, p_in1: *vips.Image, p_in2: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const ifthenelse = vips_ifthenelse;

/// This function starts up libvips, see `VIPS_INIT`.
///
/// This function is for bindings which need to start up vips. C programs
/// should use the `VIPS_INIT` macro, which does some extra checks.
///
/// See also: `VIPS_INIT`.
extern fn vips_init(p_argv0: [*:0]const u8) c_int;
pub const init = vips_init;

/// Look up the `interpolate` method in the class and call it. Use
/// `vips.Interpolate.getMethod` to get a direct pointer to the function and
/// avoid the lookup overhead.
///
/// You need to set `in` and `out` up correctly.
extern fn vips_interpolate(p_interpolate: *vips.Interpolate, p_out: ?*anyopaque, p_in: *vips.Region, p_x: f64, p_y: f64) void;
pub const interpolate = vips_interpolate;

/// Optional arguments:
///
/// * `expand`: `TRUE` to expand the output image to hold all of the input pixels
/// * `shim`: space between images, in pixels
/// * `background`: background ink colour
/// * `align`: low, centre or high alignment
///
/// Join `in1` and `in2` together, left-right or up-down depending on the value
/// of `direction`.
///
/// If one is taller or wider than the
/// other, `out` will be has high as the smaller. If `expand` is `TRUE`, then
/// the output will be expanded to contain all of the input pixels.
///
/// Use `align` to set the edge that the images align on. By default, they align
/// on the edge with the lower value coordinate.
///
/// Use `background` to set the colour of any pixels in `out` which are not
/// present in either `in1` or `in2`.
///
/// Use `shim` to set the spacing between the images. By default this is 0.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common type (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// If you are going to be joining many thousands of images in a regular
/// grid, `vips.arrayjoin` is a better choice.
///
/// See also: `vips.arrayjoin`, `vips.Image.insert`.
extern fn vips_join(p_in1: *vips.Image, p_in2: *vips.Image, p_out: **vips.Image, p_direction: vips.Direction, ...) c_int;
pub const join = vips_join;

/// Optional arguments:
///
/// * `page`: `gint`, load this page
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Read a JPEG2000 image. The loader supports 8, 16 and 32-bit int pixel
/// values, signed and unsigned. It supports greyscale, RGB, YCC, CMYK and
/// multispectral colour spaces. It will read any ICC profile on the image.
///
/// It will only load images where all channels have the same format.
///
/// Use `page` to set the page to load, where page 0 is the base resolution
/// image and higher-numbered pages are x2 reductions. Use the metadata item
/// "n-pages" to find the number of pyramid layers.
///
/// Use `fail_on` to set the type of error that will cause load to fail. By
/// default, loaders are permissive, that is, `VIPS_FAIL_ON_NONE`.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_jp2kload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const jp2kload = vips_jp2kload;

/// Optional arguments:
///
/// * `page`: `gint`, load this page
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Exactly as `vips.jp2kload`, but read from a buffer.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
extern fn vips_jp2kload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const jp2kloadBuffer = vips_jp2kload_buffer;

/// Optional arguments:
///
/// * `page`: `gint`, load this page
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
///
/// Exactly as `vips.jp2kload`, but read from a source.
extern fn vips_jp2kload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const jp2kloadSource = vips_jp2kload_source;

/// Optional arguments:
///
/// * `shrink`: `gint`, shrink by this much on load
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
/// * `autorotate`: `gboolean`, rotate image upright during load
///
/// Read a JPEG file into a VIPS image. It can read most 8-bit JPEG images,
/// including CMYK and YCbCr.
///
/// `shrink` means shrink by this integer factor during load.  Possible values
/// are 1, 2, 4 and 8. Shrinking during read is very much faster than
/// decompressing the whole image and then shrinking later.
///
/// Use `fail_on` to set the type of error that will cause load to fail. By
/// default, loaders are permissive, that is, `VIPS_FAIL_ON_NONE`.
///
/// Setting `autorotate` to `TRUE` will make the loader interpret the
/// orientation tag and automatically rotate the image appropriately during
/// load.
///
/// If `autorotate` is `FALSE`, the metadata field `VIPS_META_ORIENTATION` is set
/// to the value of the orientation tag. Applications may read and interpret
/// this field
/// as they wish later in processing. See `vips.Image.autorot`. Save
/// operations will use `VIPS_META_ORIENTATION`, if present, to set the
/// orientation of output images.
///
/// Example:
///
/// ```
/// vips_jpegload("fred.jpg", &amp;out,
///     "shrink", 8,
///     "fail_on", VIPS_FAIL_ON_TRUNCATED,
///     NULL);
/// ```
///
/// Any embedded ICC profiles are ignored: you always just get the RGB from
/// the file. Instead, the embedded profile will be attached to the image as
/// `VIPS_META_ICC_NAME`. You need to use something like
/// `vips.Image.iccImport` to get CIE values from the file.
///
/// EXIF metadata is attached as `VIPS_META_EXIF_NAME`, IPTC as
/// `VIPS_META_IPTC_NAME`, and XMP as `VIPS_META_XMP_NAME`.
///
/// The int metadata item "jpeg-multiscan" is set to the result of
/// `jpeg_has_multiple_scans`. Interlaced jpeg images need a large amount of
/// memory to load, so this field gives callers a chance to handle these
/// images differently.
///
/// The string-valued field "jpeg-chroma-subsample" gives the chroma subsample
/// in standard notation. 4:4:4 means no subsample, 4:2:0 means YCbCr with
/// Cb and Cr subsampled horizontally and vertically, 4:4:4:4 means a CMYK
/// image with no subsampling.
///
/// The EXIF thumbnail, if present, is attached to the image as
/// "jpeg-thumbnail-data". See `vips.Image.getBlob`.
///
/// See also: `vips.jpegloadBuffer`, `vips.Image.newFromFile`, `vips.Image.autorot`.
extern fn vips_jpegload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const jpegload = vips_jpegload;

/// Optional arguments:
///
/// * `shrink`: `gint`, shrink by this much on load
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
/// * `autorotate`: `gboolean`, use exif Orientation tag to rotate the image
///   during load
///
/// Read a JPEG-formatted memory block into a VIPS image. Exactly as
/// `vips.jpegload`, but read from a memory buffer.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.jpegload`.
extern fn vips_jpegload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const jpegloadBuffer = vips_jpegload_buffer;

/// Optional arguments:
///
/// * `shrink`: `gint`, shrink by this much on load
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
/// * `autorotate`: `gboolean`, use exif Orientation tag to rotate the image
///   during load
///
/// Read a JPEG-formatted memory block into a VIPS image. Exactly as
/// `vips.jpegload`, but read from a source.
///
/// See also: `vips.jpegload`.
extern fn vips_jpegload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const jpegloadSource = vips_jpegload_source;

/// Read a JPEG-XL image.
///
/// The JPEG-XL loader and saver are experimental features and may change
/// in future libvips versions.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_jxlload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const jxlload = vips_jxlload;

/// Exactly as `vips.jxlload`, but read from a buffer.
extern fn vips_jxlload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const jxlloadBuffer = vips_jxlload_buffer;

/// Exactly as `vips.jxlload`, but read from a source.
extern fn vips_jxlload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const jxlloadSource = vips_jxlload_source;

/// Turn on or off vips leak checking. See also --vips-leak,
/// `vips.addOptionEntries` and the `VIPS_LEAK` environment variable.
///
/// You should call this very early in your program.
extern fn vips_leak_set(p_leak: c_int) void;
pub const leakSet = vips_leak_set;

/// Perform `VIPS_OPERATION_RELATIONAL_LESS` on a pair of images. See
/// `vips.relational`.
extern fn vips_less(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const less = vips_less;

/// Perform `VIPS_OPERATION_RELATIONAL_LESSEQ` on a pair of images. See
/// `vips.relational`.
extern fn vips_lesseq(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const lesseq = vips_lesseq;

/// Optional arguments:
///
/// * `separable`: generate a separable mask
/// * `precision`: `vips.Precision` for `out`
///
/// Creates a circularly symmetric Laplacian of Gaussian mask
/// of radius
/// `sigma`.  The size of the mask is determined by the variable `min_ampl`;
/// if for instance the value .1 is entered this means that the produced mask
/// is clipped at values within 10 percent of zero, and where the change
/// between mask elements is less than 10%.
///
/// The program uses the following equation: (from Handbook of Pattern
/// Recognition and image processing by Young and Fu, AP 1986 pages 220-221):
///
///  H(r) = (1 / (2 * M_PI * s4)) *
///     (2 - (r2 / s2)) *
///     exp(-r2 / (2 * s2))
///
/// where s2 = `sigma` * `sigma`, s4 = s2 * s2, r2 = r * r.
///
/// The generated mask has odd size and its maximum value is normalised to
/// 1.0, unless `precision` is `VIPS_PRECISION_INTEGER`.
///
/// If `separable` is set, only the centre horizontal is generated. This is
/// useful for separable convolutions.
///
/// If `precision` is `VIPS_PRECISION_INTEGER`, an integer mask is generated.
/// This is useful for integer convolutions.
///
/// "scale" is set to the sum of all the mask elements.
///
/// See also: `vips.gaussmat`, `vips.Image.conv`.
extern fn vips_logmat(p_out: **vips.Image, p_sigma: f64, p_min_ampl: f64, ...) c_int;
pub const logmat = vips_logmat;

/// Perform `VIPS_OPERATION_BOOLEAN_LSHIFT` on a pair of images. See
/// `vips.boolean`.
extern fn vips_lshift(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const lshift = vips_lshift;

/// Optional arguments:
///
/// * `page`: `gint`, load from this page
/// * `n`: `gint`, load this many pages
/// * `density`: string, canvas resolution for rendering vector formats like SVG
///
/// Read in an image using libMagick, the ImageMagick library. This library can
/// read more than 80 file formats, including SVG, BMP, EPS, DICOM and many
/// others.
/// The reader can handle any ImageMagick image, including the float and double
/// formats. It will work with any quantum size, including HDR. Any metadata
/// attached to the libMagick image is copied on to the VIPS image.
///
/// The reader should also work with most versions of GraphicsMagick. See the
/// "--with-magickpackage" configure option.
///
/// The file format is usually guessed from the filename suffix, or sniffed
/// from the file contents.
///
/// Normally it will only load the first image in a many-image sequence (such
/// as a GIF or a PDF). Use `page` and `n` to set the start page and number of
/// pages to load. Set `n` to -1 to load all pages from `page` onwards.
///
/// `density` is "WxH" in DPI, e.g. "600x300" or "600" (default is "72x72"). See
/// the [density
/// docs](http://www.imagemagick.org/script/command-line-options.php`density`)
/// on the imagemagick website.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_magickload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const magickload = vips_magickload;

/// Optional arguments:
///
/// * `page`: `gint`, load from this page
/// * `n`: `gint`, load this many pages
/// * `density`: string, canvas resolution for rendering vector formats like SVG
///
/// Read an image memory block using libMagick into a VIPS image. Exactly as
/// `vips.magickload`, but read from a memory source.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.magickload`.
extern fn vips_magickload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const magickloadBuffer = vips_magickload_buffer;

/// `glib.malloc` local to `object`, that is, the memory will be automatically
/// freed for you when the object is closed. If `object` is `NULL`, you need to
/// free the memory explicitly with `glib.free`.
///
/// This function cannot fail. See `vips.trackedMalloc` if you are
/// allocating large amounts of memory.
///
/// See also: `vips.trackedMalloc`.
extern fn vips_malloc(p_object: ?*vips.Object, p_size: usize) ?*anyopaque;
pub const malloc = vips_malloc;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make an butterworth high- or low-pass filter, that is, one with a variable,
/// smooth transition
/// positioned at `frequency_cutoff`, where `frequency_cutoff` is in
/// range 0 - 1. The shape of the curve is controlled by
/// `order` --- higher values give a sharper transition. See Gonzalez and Wintz,
/// Digital Image Processing, 1987.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_butterworth(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_order: f64, p_frequency_cutoff: f64, p_amplitude_cutoff: f64, ...) c_int;
pub const maskButterworth = vips_mask_butterworth;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make an butterworth band-pass or band-reject filter, that is, one with a
/// variable, smooth transition positioned at `frequency_cutoff_x`,
/// `frequency_cutoff_y`, of radius `radius`.
/// The shape of the curve is controlled by
/// `order` --- higher values give a sharper transition. See Gonzalez and Wintz,
/// Digital Image Processing, 1987.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_butterworth_band(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_order: f64, p_frequency_cutoff_x: f64, p_frequency_cutoff_y: f64, p_radius: f64, p_amplitude_cutoff: f64, ...) c_int;
pub const maskButterworthBand = vips_mask_butterworth_band;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make a butterworth ring-pass or ring-reject filter, that is, one with a
/// variable,
/// smooth transition
/// positioned at `frequency_cutoff` of width `width`, where `frequency_cutoff` is
/// in the range 0 - 1. The shape of the curve is controlled by
/// `order` --- higher values give a sharper transition. See Gonzalez and Wintz,
/// Digital Image Processing, 1987.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_butterworth_ring(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_order: f64, p_frequency_cutoff: f64, p_amplitude_cutoff: f64, p_ringwidth: f64, ...) c_int;
pub const maskButterworthRing = vips_mask_butterworth_ring;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// This operation should be used to create fractal images by filtering the
/// power spectrum of Gaussian white noise. See `vips.gaussnoise`.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_fractal(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_fractal_dimension: f64, ...) c_int;
pub const maskFractal = vips_mask_fractal;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make a gaussian high- or low-pass filter, that is, one with a variable,
/// smooth transition positioned at `frequency_cutoff`.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_gaussian(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_frequency_cutoff: f64, p_amplitude_cutoff: f64, ...) c_int;
pub const maskGaussian = vips_mask_gaussian;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make a gaussian band-pass or band-reject filter, that is, one with a
/// variable, smooth transition positioned at `frequency_cutoff_x`,
/// `frequency_cutoff_y`, of radius `radius`.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_gaussian_band(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_frequency_cutoff_x: f64, p_frequency_cutoff_y: f64, p_radius: f64, p_amplitude_cutoff: f64, ...) c_int;
pub const maskGaussianBand = vips_mask_gaussian_band;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make a gaussian ring-pass or ring-reject filter, that is, one with a
/// variable, smooth transition positioned at `frequency_cutoff` of width
/// `ringwidth`.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_gaussian_ring(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_frequency_cutoff: f64, p_amplitude_cutoff: f64, p_ringwidth: f64, ...) c_int;
pub const maskGaussianRing = vips_mask_gaussian_ring;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make an ideal high- or low-pass filter, that is, one with a sharp cutoff
/// positioned at `frequency_cutoff`, where `frequency_cutoff` is in
/// the range 0 - 1.
///
/// This operation creates a one-band float image of the specified size.
/// The image has
/// values in the range [0, 1] and is typically used for multiplying against
/// frequency domain images to filter them.
/// Masks are created with the DC component at (0, 0). The DC pixel always
/// has the value 1.0.
///
/// Set `nodc` to not set the DC pixel.
///
/// Set `optical` to position the DC component in the centre of the image. This
/// makes the mask suitable for multiplying against optical Fourier transforms.
/// See `vips.Image.wrap`.
///
/// Set `reject` to invert the sense of
/// the filter. For example, low-pass becomes low-reject.
///
/// Set `uchar` to output an 8-bit unsigned char image rather than a
/// float image. In this case, pixels are in the range [0 - 255].
///
/// See also: `vips.maskIdeal`, `vips.maskIdealRing`,
/// `vips.maskIdealBand`, `vips.maskButterworth`,
/// `vips.maskButterworthRing`, `vips.maskButterworthBand`,
/// `vips.maskGaussian`, `vips.maskGaussianRing`,
/// `vips.maskGaussianBand`.
extern fn vips_mask_ideal(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_frequency_cutoff: f64, ...) c_int;
pub const maskIdeal = vips_mask_ideal;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make an ideal band-pass or band-reject filter, that is, one with a
/// sharp cutoff around the point `frequency_cutoff_x`, `frequency_cutoff_y`,
/// of size `radius`.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_ideal_band(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_frequency_cutoff_x: f64, p_frequency_cutoff_y: f64, p_radius: f64, ...) c_int;
pub const maskIdealBand = vips_mask_ideal_band;

/// Optional arguments:
///
/// * `nodc`: don't set the DC pixel
/// * `reject`: invert the filter sense
/// * `optical`: coordinates in optical space
/// * `uchar`: output a uchar image
///
/// Make an ideal ring-pass or ring-reject filter, that is, one with a sharp
/// ring positioned at `frequency_cutoff` of width `width`, where
/// `frequency_cutoff` and `width` are expressed as the range 0 - 1.
///
/// See also: `vips.maskIdeal`.
extern fn vips_mask_ideal_ring(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_frequency_cutoff: f64, p_ringwidth: f64, ...) c_int;
pub const maskIdealRing = vips_mask_ideal_ring;

/// Optional arguments:
///
/// * `search`: search to improve tie-points
/// * `hwindow`: half window size
/// * `harea`: half search size
/// * `interpolate`: interpolate pixels with this
///
/// Scale, rotate and translate `sec` so that the tie-points line up.
///
/// If `search` is `TRUE`, before performing the transformation, the tie-points
/// are improved by searching an area of `sec` of size `harea` for a
/// match of size `hwindow` to `ref`.
///
/// This function will only work well for small rotates and scales.
extern fn vips_match(p_ref: *vips.Image, p_sec: *vips.Image, p_out: **vips.Image, p_xr1: c_int, p_yr1: c_int, p_xs1: c_int, p_ys1: c_int, p_xr2: c_int, p_yr2: c_int, p_xs2: c_int, p_ys2: c_int, ...) c_int;
pub const match = vips_match;

/// This operation calculates a 2-ary maths operation on a pair of images
/// and writes the result to `out`. The images may have any
/// non-complex format. `out` is float except in the case that either of `left`
/// or `right` are double, in which case `out` is also double.
///
/// It detects division by zero, setting those pixels to zero in the output.
/// Beware: it does this silently!
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), and that format is the
/// result type.
///
/// See also: `vips.Image.math2Const`.
extern fn vips_math2(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, p_math2: vips.OperationMath2, ...) c_int;
pub const math2 = vips_math2;

/// Read a Matlab save file into a VIPS image.
///
/// This operation searches the save
/// file for the first array variable with between 1 and 3 dimensions and loads
/// it as an image. It will not handle complex images. It does not handle
/// sparse matrices.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_matload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const matload = vips_matload;

/// Reads a matrix from a file.
///
/// Matrix files have a simple format that's supposed to be easy to create with
/// a text editor or a spreadsheet.
///
/// The first line has four numbers for width, height, scale and
/// offset (scale and offset may be omitted, in which case they default to 1.0
/// and 0.0). Scale must be non-zero. Width and height must be positive
/// integers. The numbers are separated by any mixture of spaces, commas,
/// tabs and quotation marks ("). The scale and offset fields may be
/// floating-point, and must use '.'
/// as a decimal separator.
///
/// Subsequent lines each hold one row of matrix data, with numbers again
/// separated by any mixture of spaces, commas,
/// tabs and quotation marks ("). The numbers may be floating-point, and must
/// use '.'
/// as a decimal separator.
///
/// Extra characters at the ends of lines or at the end of the file are
/// ignored.
///
/// See also: `vips.matrixload`.
extern fn vips_matrixload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const matrixload = vips_matrixload;

/// Exactly as `vips.matrixload`, but read from a source.
///
/// See also: `vips.matrixload`.
extern fn vips_matrixload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const matrixloadSource = vips_matrixload_source;

/// Return the maximum coordinate value. This can be the default, a value set
/// set by the `--vips-max-coord` CLI arg, or a value set in the `VIPS_MAX_COORD`
/// environment variable.
///
/// These strings can include unit specifiers, eg. "10m" for 10 million pixels.
/// Values above INT_MAX are not supported.
extern fn vips_max_coord_get() c_int;
pub const maxCoordGet = vips_max_coord_get;

/// For each pixel, pick the maximum of a pair of images.
///
/// See also: `vips.minpair`.
extern fn vips_maxpair(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const maxpair = vips_maxpair;

/// Optional arguments:
///
/// * `mblend`: `gint`, maximum blend size
///
/// This operation joins two images left-right (with `ref` on the left) or
/// up-down (with `ref` above) with a smooth seam.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common type (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// `dx` and `dy` give the displacement of `sec` relative to `ref`, in other words,
/// the vector to get from the origin of `sec` to the origin of `ref`, in other
/// words, `dx` will generally be a negative number.
///
/// `mblend` limits  the  maximum width of the
/// blend area.  A value of "-1" means "unlimited". The two images are blended
/// with a raised cosine.
///
/// Pixels with all bands equal to zero are "transparent", that
/// is, zero pixels in the overlap area do not  contribute  to  the  merge.
/// This makes it possible to join non-rectangular images.
///
/// See also: `vips.mosaic`, `vips.Image.insert`.
extern fn vips_merge(p_ref: *vips.Image, p_sec: *vips.Image, p_out: **vips.Image, p_direction: vips.Direction, p_dx: c_int, p_dy: c_int, ...) c_int;
pub const merge = vips_merge;

/// For each pixel, pick the minimum of a pair of images.
///
/// See also: `vips.minpair`.
extern fn vips_minpair(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const minpair = vips_minpair;

/// Perform `VIPS_OPERATION_RELATIONAL_MORE` on a pair of images. See
/// `vips.relational`.
extern fn vips_more(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const more = vips_more;

/// Perform `VIPS_OPERATION_RELATIONAL_MOREEQ` on a pair of images. See
/// `vips.relational`.
extern fn vips_moreeq(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const moreeq = vips_moreeq;

/// Optional arguments:
///
/// * `bandno`: `gint`, band to search for features
/// * `hwindow`: `gint`, half window size
/// * `harea`: `gint`, half search size
/// * `mblend`: `gint`, maximum blend size
/// * `dx0`: `gint`, output, detected displacement
/// * `dy0`: `gint`, output, detected displacement
/// * `scale1`: `gdouble`, output, detected first order scale
/// * `angle1`: `gdouble`, output, detected first order rotation
/// * `dx1`: `gdouble`, output, detected first order displacement
/// * `dy1`: `gdouble`, output, detected first order displacement
///
/// This operation joins two images left-right (with `ref` on the left) or
/// top-bottom (with `ref` above) given an approximate overlap.
///
/// `sec` is positioned so that the pixel (`xsec`, `ysec`) in `sec` lies on top of
/// the pixel (`xref`, `yref`) in `ref`. The overlap area is divided into three
/// sections, 20 high-contrast points in band `bandno` of image `ref` are found
/// in each, and a window of pixels of size `hwindow` around each high-contrast
/// point is searched for in `sec` over an area of `harea`.
///
/// A linear model is fitted to the 60 tie-points, points a long way from the
/// fit are discarded, and the model refitted until either too few points
/// remain or the model reaches good agreement.
///
/// The detected displacement is used with `vips.merge` to join the two images
/// together.
///
/// You can read out the detected transform with `dx0`, `dy0`, `scale1`, `angle1`,
/// `dx1`, `dy1`.
///
/// See also: `vips.merge`, `vips.Image.insert`.
extern fn vips_mosaic(p_ref: *vips.Image, p_sec: *vips.Image, p_out: **vips.Image, p_direction: vips.Direction, p_xref: c_int, p_yref: c_int, p_xsec: c_int, p_ysec: c_int, ...) c_int;
pub const mosaic = vips_mosaic;

/// Optional arguments:
///
/// * `search`: search to improve tie-points
/// * `hwindow`: half window size
/// * `harea`: half search size
/// * `interpolate`: interpolate pixels with this
/// * `mblend`: maximum blend size
///
/// This operation joins two images top-bottom (with `sec` on the right)
/// or left-right (with `sec` at the bottom)
/// given an approximate pair of tie-points. `sec` is scaled and rotated as
/// necessary before the join.
///
/// If `search` is `TRUE`, before performing the transformation, the tie-points
/// are improved by searching an area of `sec` of size `harea` for a
/// object of size `hwindow` in `ref`.
///
/// `mblend` limits  the  maximum size of the
/// blend area.  A value of "-1" means "unlimited". The two images are blended
/// with a raised cosine.
///
/// Pixels with all bands equal to zero are "transparent", that
/// is, zero pixels in the overlap area do not  contribute  to  the  merge.
/// This makes it possible to join non-rectangular images.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common type (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// See also: `vips.merge`, `vips.Image.insert`, `vips.Image.globalbalance`.
extern fn vips_mosaic1(p_ref: *vips.Image, p_sec: *vips.Image, p_out: **vips.Image, p_direction: vips.Direction, p_xr1: c_int, p_yr1: c_int, p_xs1: c_int, p_ys1: c_int, p_xr2: c_int, p_yr2: c_int, p_xs2: c_int, p_ys2: c_int, ...) c_int;
pub const mosaic1 = vips_mosaic1;

/// This operation calculates `left` * `right` and writes the result to `out`.
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), then the
/// following table is used to determine the output type:
///
/// <table>
///   <title>VipsMultiply type promotion</title>
///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
///     <thead>
///       <row>
///         <entry>input type</entry>
///         <entry>output type</entry>
///       </row>
///     </thead>
///     <tbody>
///       <row>
///         <entry>uchar</entry>
///         <entry>ushort</entry>
///       </row>
///       <row>
///         <entry>char</entry>
///         <entry>short</entry>
///       </row>
///       <row>
///         <entry>ushort</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>short</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>uint</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>int</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>float</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>double</entry>
///         <entry>double</entry>
///       </row>
///       <row>
///         <entry>complex</entry>
///         <entry>complex</entry>
///       </row>
///       <row>
///         <entry>double complex</entry>
///         <entry>double complex</entry>
///       </row>
///     </tbody>
///   </tgroup>
/// </table>
///
/// In other words, the output type is just large enough to hold the whole
/// range of possible values.
///
/// See also: `vips.add`, `vips.Image.linear`.
extern fn vips_multiply(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const multiply = vips_multiply;

/// Return the VIPS nickname for a `gobject.Type`. Handy for language bindings.
extern fn vips_nickname_find(p_type: usize) [*:0]const u8;
pub const nicknameFind = vips_nickname_find;

/// Read a NIFTI image file into a VIPS image.
///
/// NIFTI metadata is attached with the "nifti-" prefix.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_niftiload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const niftiload = vips_niftiload;

/// Exactly as `vips.niftiload`, but read from a source.
extern fn vips_niftiload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const niftiloadSource = vips_niftiload_source;

/// Perform `VIPS_OPERATION_RELATIONAL_NOTEQ` on a pair of images. See
/// `vips.relational`.
extern fn vips_notequal(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const notequal = vips_notequal;

/// Read a OpenEXR file into a VIPS image.
///
/// The reader can handle scanline and tiled OpenEXR images. It can't handle
/// OpenEXR colour management, image attributes, many pixel formats, anything
/// other than RGBA.
///
/// This reader uses the rather limited OpenEXR C API. It should really be
/// redone in C++.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_openexrload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const openexrload = vips_openexrload;

/// Optional arguments:
///
/// * `level`: `gint`, load this level
/// * `associated`: `gchararray`, load this associated image
/// * `attach_associated`: `gboolean`, attach all associated images as metadata
/// * `autocrop`: `gboolean`, crop to image bounds
/// * `rgb`: `gboolean`, output RGB (not RGBA) pixels
///
/// Read a virtual slide supported by the OpenSlide library into a VIPS image.
/// OpenSlide supports images in Aperio, Hamamatsu, MIRAX, Sakura, Trestle,
/// and Ventana formats.
///
/// To facilitate zooming, virtual slide formats include multiple scaled-down
/// versions of the high-resolution image.  These are typically called
/// "levels".  By default, `vips.openslideload` reads the highest-resolution
/// level (level 0).  Set `level` to the level number you want.
///
/// In addition to the slide image itself, virtual slide formats sometimes
/// include additional images, such as a scan of the slide's barcode.
/// OpenSlide calls these "associated images".  To read an associated image,
/// set `associated` to the image's name.
/// A slide's associated images are listed in the
/// "slide-associated-images" metadata item.
///
/// If you set `attach_associated`, then all associated images are attached as
/// metadata items. Use `vips.Image.getImage` on `out` to retrieve them. Images
/// are attached as "openslide-associated-XXXXX", where XXXXX is the name of the
/// associated image.
///
/// By default, the output of this operator is RGBA. Set `rgb` to enable RGB
/// output.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_openslideload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const openslideload = vips_openslideload;

/// Optional arguments:
///
/// * `level`: `gint`, load this level
/// * `associated`: `gchararray`, load this associated image
/// * `attach_associated`: `gboolean`, attach all associated images as metadata
/// * `autocrop`: `gboolean`, crop to image bounds
/// * `rgb`: `gboolean`, output RGB (not RGBA) pixels
///
/// Exactly as `vips.openslideload`, but read from a source.
extern fn vips_openslideload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const openslideloadSource = vips_openslideload_source;

/// Perform `VIPS_OPERATION_BOOLEAN_OR` on a pair of images. See
/// `vips.boolean`.
extern fn vips_orimage(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const orimage = vips_orimage;

/// Return the filename part of a vips7 path. For testing only.
extern fn vips_path_filename7(p_path: [*:0]const u8) [*:0]u8;
pub const pathFilename7 = vips_path_filename7;

/// Return the mode part of a vips7 path. For testing only.
extern fn vips_path_mode7(p_path: [*:0]const u8) [*:0]u8;
pub const pathMode7 = vips_path_mode7;

/// Optional arguments:
///
/// * `page`: `gint`, load this page, numbered from zero
/// * `n`: `gint`, load this many pages
/// * `dpi`: `gdouble`, render at this DPI
/// * `scale`: `gdouble`, scale render by this factor
/// * `background`: `vips.ArrayDouble` background colour
/// * `password`: `gchararray` PDF password
///
/// Render a PDF file into a VIPS image.
///
/// The output image is always RGBA --- CMYK PDFs will be
/// converted. If you need CMYK bitmaps, you should use `vips.magickload`
/// instead.
///
/// Use `page` to select a page to render, numbering from zero.
///
/// Use `n` to select the number of pages to render. The default is 1. Pages are
/// rendered in a vertical column, with each individual page aligned to the
/// left. Set to -1 to mean "until the end of the document". Use `vips.Image.grid`
/// to change page layout.
///
/// Use `dpi` to set the rendering resolution. The default is 72. Additionally,
/// you can scale by setting `scale`. If you set both, they combine.
///
/// Use `background` to set the background RGBA colour. The default is 255
/// (solid white), use eg. 0 for a transparent background.
///
/// Use `password` to supply a decryption password.
///
/// The operation fills a number of header fields with metadata, for example
/// "pdf-author". They may be useful.
///
/// This function only reads the image header and does not render any pixel
/// data. Rendering occurs when pixels are accessed.
///
/// See also: `vips.Image.newFromFile`, `vips.magickload`.
extern fn vips_pdfload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const pdfload = vips_pdfload;

/// Optional arguments:
///
/// * `page`: `gint`, load this page, numbered from zero
/// * `n`: `gint`, load this many pages
/// * `dpi`: `gdouble`, render at this DPI
/// * `scale`: `gdouble`, scale render by this factor
/// * `background`: `vips.ArrayDouble` background colour
///
/// Read a PDF-formatted memory buffer into a VIPS image. Exactly as
/// `vips.pdfload`, but read from memory.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.pdfload`.
extern fn vips_pdfload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const pdfloadBuffer = vips_pdfload_buffer;

/// Optional arguments:
///
/// * `page`: `gint`, load this page, numbered from zero
/// * `n`: `gint`, load this many pages
/// * `dpi`: `gdouble`, render at this DPI
/// * `scale`: `gdouble`, scale render by this factor
/// * `background`: `vips.ArrayDouble` background colour
///
/// Exactly as `vips.pdfload`, but read from a source.
///
/// See also: `vips.pdfload`
extern fn vips_pdfload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const pdfloadSource = vips_pdfload_source;

/// Optional arguments:
///
/// * `cell_size`: `gint`, size of Perlin cells
/// * `uchar`: output a uchar image
///
/// Create a one-band float image of Perlin noise. See:
///
/// https://en.wikipedia.org/wiki/Perlin_noise
///
/// Use `cell_size` to set the size of the cells from which the image is
/// constructed. The default is 256 x 256.
///
/// If `width` and `height` are multiples of `cell_size`, the image will tessellate.
///
/// Normally, output pixels are `VIPS_FORMAT_FLOAT` in the range [-1, +1]. Set
/// `uchar` to output a uchar image with pixels in [0, 255].
///
/// See also: `vips.worley`, `vips.fractsurf`, `vips.gaussnoise`.
extern fn vips_perlin(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const perlin = vips_perlin;

/// Convert the two input images to Fourier space, calculate phase-correlation,
/// back to real space.
///
/// See also: `vips.Image.fwfft`, `vips.crossPhase`,
extern fn vips_phasecor(p_in1: *vips.Image, p_in2: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const phasecor = vips_phasecor;

/// Optional arguments:
///
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
/// * `unlimited`: `gboolean`, remove all denial of service limits
///
/// Read a PNG file into a VIPS image. It can read all png images, including 8-
/// and 16-bit images, 1 and 3 channel, with and without an alpha channel.
///
/// Any ICC profile is read and attached to the VIPS image. It also supports
/// XMP metadata.
///
/// Use `fail_on` to set the type of error that will cause load to fail. By
/// default, loaders are permissive, that is, `VIPS_FAIL_ON_NONE`.
///
/// By default, the PNG loader limits the number of text and data chunks to
/// block some denial of service attacks. Set `unlimited` to disable these
/// limits.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_pngload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const pngload = vips_pngload;

/// Optional arguments:
///
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
/// * `unlimited`: `gboolean`, Remove all denial of service limits
///
/// Exactly as `vips.pngload`, but read from a PNG-formatted memory block.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.pngload`.
extern fn vips_pngload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const pngloadBuffer = vips_pngload_buffer;

/// Optional arguments:
///
/// * `fail_on`: `vips.FailOn`, types of read error to fail on
/// * `unlimited`: `gboolean`, Remove all denial of service limits
///
/// Exactly as `vips.pngload`, but read from a source.
///
/// See also: `vips.pngload`.
extern fn vips_pngload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const pngloadSource = vips_pngload_source;

/// Perform `VIPS_OPERATION_MATH2_POW` on a pair of images. See
/// `vips.math2`.
extern fn vips_pow(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const pow = vips_pow;

/// Read a PPM/PBM/PGM/PFM file into a VIPS image.
///
/// It can read 1, 8, 16 and 32 bit images, colour or monochrome,
/// stored in binary or in ASCII. One bit images become 8 bit VIPS images,
/// with 0 and 255 for 0 and 1.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_ppmload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const ppmload = vips_ppmload;

/// Exactly as `vips.ppmload`, but read from a source.
///
/// See also: `vips.ppmload`.
extern fn vips_ppmload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const ppmloadSource = vips_ppmload_source;

/// Load a named profile.
///
/// Profiles are loaded from four sources:
///
/// - The special name `"none"` means no profile. `profile` will be `NULL` in this
///   case.
///
/// - `name` can be the name of one of the ICC profiles embedded in libvips.
///   These names can be at least `"cmyk"`, `"p3"` and `"srgb"`.
///
/// - `name` can be the full path to a file.
///
/// - `name` can be the name of an ICC profile in the system profile directory
///   for your platform.
extern fn vips_profile_load(p_name: [*:0]const u8, p_profile: **vips.Blob, ...) c_int;
pub const profileLoad = vips_profile_load;

/// Pythagorean distance between two points in colour space. Lab/XYZ/CMC etc.
extern fn vips_pythagoras(p_L1: f32, p_a1: f32, p_b1: f32, p_L2: f32, p_a2: f32, p_b2: f32) f32;
pub const pythagoras = vips_pythagoras;

/// Read a Radiance (HDR) file into a VIPS image.
///
/// Radiance files are read as `VIPS_CODING_RAD`. They have one byte for each of
/// red, green and blue, and one byte of shared exponent. Some operations (like
/// `vips.Image.extractArea`) can work directly with images in this format, but
/// mmany (all the arithmetic operations, for example) will not. Unpack
/// `VIPS_CODING_RAD` images to 3 band float with `vips.Image.rad2float` if
/// you want to do arithmetic on them.
///
/// This operation ignores some header fields, like VIEW and DATE. It will not
/// rotate/flip as the FORMAT string asks.
///
/// Sections of this reader from Greg Ward and Radiance with kind permission.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_radload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const radload = vips_radload;

/// Exactly as `vips.radload`, but read from a HDR-formatted memory block.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.radload`.
extern fn vips_radload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const radloadBuffer = vips_radload_buffer;

/// Exactly as `vips.radload`, but read from a source.
///
/// See also: `vips.radload`.
extern fn vips_radload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const radloadSource = vips_radload_source;

/// Optional arguments:
///
/// * `offset`: `guint64`, offset in bytes from start of file
/// * `format`: `vips.BandFormat`, set image format
/// * `interpretation`: `vips.Interpretation`, set image interpretation
///
/// This operation mmaps the file, setting up `out` so that access to that
/// image will read from the file.
///
/// By default, it assumes uchar pixels. Use `format` to select something else.
///
/// The image will be tagged as `VIPS_INTERPRETATION_MULTIBAND`. Use
/// `interpretation` to select something else.
///
/// Use `vips.Image.byteswap` to reverse the byte ordering if necessary.
///
/// See also: `vips.Image.newFromFile`, `vips.Image.copy`, `vips.Image.byteswap`.
extern fn vips_rawload(p_filename: [*:0]const u8, p_out: **vips.Image, p_width: c_int, p_height: c_int, p_bands: c_int, ...) c_int;
pub const rawload = vips_rawload;

/// Perform various relational operations on pairs of images.
///
/// The output type is always uchar, with 0 for FALSE and 255 for TRUE.
///
/// Less-than and greater-than for complex images compare the modulus.
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>).
///
/// To decide if pixels match exactly, that is have the same value in every
/// band, use `vips.Image.bandbool` after this operation to AND or OR image bands
/// together.
///
/// See also: `vips.boolean`, `vips.Image.bandbool`, `vips.Image.relationalConst`.
extern fn vips_relational(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, p_relational: vips.OperationRelational, ...) c_int;
pub const relational = vips_relational;

/// This operation calculates `left` % `right` (remainder after integer division)
/// and writes the result to `out`. The images may have any
/// non-complex format. For float formats, `vips.remainder` calculates `in1` -
/// `in2` * floor (`in1` / `in2`).
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), and that format is the
/// result type.
///
/// See also: `vips.Image.remainderConst`, `vips.divide`, `vips.Image.round`.
extern fn vips_remainder(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const remainder = vips_remainder;

/// Rotate `in` by 90 degrees clockwise. A convenience function over `vips.Image.rot`.
///
/// See also: `vips.Image.rot`.
extern fn vips_rot90(p_in: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const rot90 = vips_rot90;

/// Perform `VIPS_OPERATION_BOOLEAN_RSHIFT` on a pair of images. See
/// `vips.boolean`.
extern fn vips_rshift(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const rshift = vips_rshift;

/// Optional arguments:
///
/// * `a`: `vips.ArrayDouble`, first point
/// * `b`: `vips.ArrayDouble`, second point
/// * `r`: `gfloat`, radius
/// * `corners`: `vips.ArrayDouble`, corner radii
///
/// Create a signed distance field (SDF) image of the given shape. Different
/// shapes use different combinations of the optional arguments, see below.
///
/// `shape` `VIPS_SDF_SHAPE_CIRCLE`: create a circle centred on `a`, radius `r`.
///
/// `shape` `VIPS_SDF_SHAPE_BOX`: create a box with top-left corner `a` and
/// bottom-right corner `b`.
///
/// `shape` `VIPS_SDF_SHAPE_ROUNDED_BOX`: create a box with top-left corner `a`
/// and bottom-right corner `b`, whose four corners are
/// rounded by the four-element float array `corners`. `corners` will default to
/// 0.0.
///
/// `shape` `VIPS_SDF_SHAPE_LINE`: draw a line from `a` to `b`.
///
/// See also: `vips.grey`, `vips.Image.grid`, `vips.xyz`.
extern fn vips_sdf(p_out: **vips.Image, p_width: c_int, p_height: c_int, p_shape: vips.SdfShape, ...) c_int;
pub const sdf = vips_sdf;

/// Call this to drop caches, close plugins, terminate background threads, and
/// finalize any internal library testing.
///
/// `vips.shutdown` is optional. If you don't call it, your platform will
/// clean up for you. The only negative consequences are that the leak checker
/// and the profiler will not work.
///
/// You may call `VIPS_INIT` many times and `vips.shutdown` many times, but you
/// must not call `VIPS_INIT` after `vips.shutdown`. In other words, you cannot
/// stop and restart libvips.
///
/// See also: `vips_profile_set`, `vips.leakSet`.
extern fn vips_shutdown() void;
pub const shutdown = vips_shutdown;

/// Optional arguments:
///
/// * `hfreq`: horizontal frequency
/// * `vreq`: vertical frequency
/// * `uchar`: output a uchar image
///
/// Creates a float one band image of the a sine waveform in two
/// dimensions.
///
/// The number of horizontal and vertical spatial frequencies are
/// determined by the variables `hfreq` and `vfreq` respectively.  The
/// function is useful for creating displayable sine waves and
/// square waves in two dimensions.
///
/// If horfreq and verfreq are integers the resultant image is periodical
/// and therefore the Fourier transform does not present spikes
///
/// Pixels are normally in [-1, +1], set `uchar` to output [0, 255].
///
/// See also: `vips.grey`, `vips.xyz`.
extern fn vips_sines(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const sines = vips_sines;

/// `glib.strdup` a string. When `object` is freed, the string will be freed for
/// you.  If `object` is `NULL`, you need to
/// free the memory yourself with `glib.free`.
///
/// This function cannot fail.
///
/// See also: `vips.malloc`.
extern fn vips_strdup(p_object: ?*vips.Object, p_str: [*:0]const u8) [*:0]u8;
pub const strdup = vips_strdup;

/// This operation calculates `in1` - `in2` and writes the result to `out`.
///
/// If the images differ in size, the smaller image is enlarged to match the
/// larger by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, one of the images
/// must have one band. In this case, an n-band image is formed from the
/// one-band image by joining n copies of the one-band image together, and then
/// the two n-band images are operated upon.
///
/// The two input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), then the
/// following table is used to determine the output type:
///
/// <table>
///   <title>VipsSubtract type promotion</title>
///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
///     <thead>
///       <row>
///         <entry>input type</entry>
///         <entry>output type</entry>
///       </row>
///     </thead>
///     <tbody>
///       <row>
///         <entry>uchar</entry>
///         <entry>short</entry>
///       </row>
///       <row>
///         <entry>char</entry>
///         <entry>short</entry>
///       </row>
///       <row>
///         <entry>ushort</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>short</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>uint</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>int</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>float</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>double</entry>
///         <entry>double</entry>
///       </row>
///       <row>
///         <entry>complex</entry>
///         <entry>complex</entry>
///       </row>
///       <row>
///         <entry>double complex</entry>
///         <entry>double complex</entry>
///       </row>
///     </tbody>
///   </tgroup>
/// </table>
///
/// In other words, the output type is just large enough to hold the whole
/// range of possible values.
///
/// See also: `vips.add`, `vips.Image.linear`.
extern fn vips_subtract(p_in1: *vips.Image, p_in2: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const subtract = vips_subtract;

/// This operation sums all images in `in` and writes the result to `out`.
///
/// If the images differ in size, the smaller images are enlarged to match the
/// largest by adding zero pixels along the bottom and right.
///
/// If the number of bands differs, all but one of the images
/// must have one band. In this case, n-band images are formed from the
/// one-band images by joining n copies of the one-band images together, and then
/// the n-band images are operated upon.
///
/// The input images are cast up to the smallest common format (see table
/// Smallest common format in
/// <link linkend="libvips-arithmetic">arithmetic</link>), then the
/// following table is used to determine the output type:
///
/// <table>
///   <title>VipsSum type promotion</title>
///   <tgroup cols='2' align='left' colsep='1' rowsep='1'>
///     <thead>
///       <row>
///         <entry>input type</entry>
///         <entry>output type</entry>
///       </row>
///     </thead>
///     <tbody>
///       <row>
///         <entry>uchar</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>char</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>ushort</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>short</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>uint</entry>
///         <entry>uint</entry>
///       </row>
///       <row>
///         <entry>int</entry>
///         <entry>int</entry>
///       </row>
///       <row>
///         <entry>float</entry>
///         <entry>float</entry>
///       </row>
///       <row>
///         <entry>double</entry>
///         <entry>double</entry>
///       </row>
///       <row>
///         <entry>complex</entry>
///         <entry>complex</entry>
///       </row>
///       <row>
///         <entry>double complex</entry>
///         <entry>double complex</entry>
///       </row>
///     </tbody>
///   </tgroup>
/// </table>
///
/// In other words, the output type is just large enough to hold the whole
/// range of possible values.
///
/// See also: `vips.add`.
extern fn vips_sum(p_in: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, ...) c_int;
pub const sum = vips_sum;

/// Optional arguments:
///
/// * `dpi`: `gdouble`, render at this DPI
/// * `scale`: `gdouble`, scale render by this factor
/// * `unlimited`: `gboolean`, allow SVGs of any size
///
/// Render a SVG file into a VIPS image.  Rendering uses the librsvg library
/// and should be fast.
///
/// Use `dpi` to set the rendering resolution. The default is 72. You can also
/// scale the rendering by `scale`.
///
/// This function only reads the image header and does not render any pixel
/// data. Rendering occurs when pixels are accessed.
///
/// SVGs larger than 10MB are normally blocked for security. Set `unlimited` to
/// allow SVGs of any size.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_svgload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const svgload = vips_svgload;

/// Optional arguments:
///
/// * `dpi`: `gdouble`, render at this DPI
/// * `scale`: `gdouble`, scale render by this factor
/// * `unlimited`: `gboolean`, allow SVGs of any size
///
/// Read a SVG-formatted memory block into a VIPS image. Exactly as
/// `vips.svgload`, but read from a memory buffer.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.svgload`.
extern fn vips_svgload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const svgloadBuffer = vips_svgload_buffer;

/// Exactly as `vips.svgload`, but read from a source.
///
/// See also: `vips.svgload`.
extern fn vips_svgload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const svgloadSource = vips_svgload_source;

/// Optional arguments:
///
/// * `dpi`: `gdouble`, render at this DPI
/// * `scale`: `gdouble`, scale render by this factor
/// * `unlimited`: `gboolean`, allow SVGs of any size
///
/// Exactly as `vips.svgload`, but read from a string. This function takes a
/// copy of the string.
///
/// See also: `vips.svgload`.
extern fn vips_svgload_string(p_str: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const svgloadString = vips_svgload_string;

/// The `tests` images are evaluated and at each point the index of the first
/// non-zero value is written to `out`. If all `tests` are false, the value
/// (`n` + 1) is written.
///
/// Images in `tests` must have one band. They are expanded to the
/// bounding box of the set of images in `tests`, and that size is used for
/// `out`. `tests` can have up to 255 elements.
///
/// Combine with `vips.Image.case` to make an efficient multi-way `vips.ifthenelse`.
///
/// See also: `vips.Image.maplut`, `vips.Image.case`, `vips.ifthenelse`.
extern fn vips_switch(p_tests: [*]*vips.Image, p_out: **vips.Image, p_n: c_int, ...) c_int;
pub const @"switch" = vips_switch;

/// Optional arguments:
///
/// * `in`: array of input images
/// * `out`: output image
/// * `in_format`: write input files like this
/// * `out_format`: write output filename like this
/// * `log`: stdout of command is returned here
///
/// `vips.system` runs a command, optionally passing a set of images in and
/// optionally getting an image back. The command's stdout is returned in `log`.
///
/// First, if `in` is set, the array of images are written to files. See
/// `vips.Image.newTempFile` to see how temporary files are created.
/// If `in_format` is
/// something like &percnt;s.png, the file will be written in PNG format. By
/// default, `in_format` is &percnt;s.tif.
///
/// If `out_format` is set, an output filename is formed in the same way. Any
/// trailing [options] are stripped from `out_format`.
///
/// The command string to run is made by substituting the first set of &percnt;s
/// in `cmd_format` for the names of the input files, if `in` is set, and then
/// the next &percnt;s for the output filename, if `out_format` is set.
/// You can put a number between the &percnt; and the s to change the order
/// in which the substitution occurs.
///
/// The command is executed with `popen` and the output captured in `log`.
///
/// After the command finishes, if `out_format` is set, the output image is
/// opened and returned in `out`. You can append [options] to `out_format` to
/// control how this open happens.
/// Closing `out` image will automatically delete the output file.
///
/// Finally the input images are deleted.
///
/// For example, this call will run the ImageMagick convert program on an
/// image, using JPEG files to pass images into and out of the convert command.
///
/// ```
/// VipsArrayImage *in;
/// VipsImage *out;
/// char *log;
///
/// if (vips_system("convert `s` -swirl 45 `s`",
///         "in", in,
///         "out", &out,
///         "in_format", "`s`.jpg",
///         "out_format", "`s`.jpg",
///         "log", &log,
///         NULL))
///     error ...
/// ```
extern fn vips_system(p_cmd_format: [*:0]const u8, ...) c_int;
pub const system = vips_system;

/// Optional arguments:
///
/// * `font`: `gchararray`, font to render with
/// * `fontfile`: `gchararray`, load this font file
/// * `width`: `gint`, image should be no wider than this many pixels
/// * `height`: `gint`, image should be no higher than this many pixels
/// * `align`: `vips.Align`, set justification alignment
/// * `justify`: `gboolean`, justify lines
/// * `dpi`: `gint`, render at this resolution
/// * `autofit_dpi`: `gint`, read out auto-fitted DPI
/// * `rgba`: `gboolean`, enable RGBA output
/// * `spacing`: `gint`, space lines by this in points
/// * `wrap`: `vips.TextWrap`, wrap lines on characters or words
///
/// Draw the string `text` to an image. `out` is normally a one-band 8-bit
/// unsigned char image, with 0 for no text and 255 for text. Values between
/// are used for anti-aliasing.
///
/// Set `rgba` to enable RGBA output. This is useful for colour emoji rendering,
/// or support for pango markup features like `<span
/// foreground="red">Red!</span>`.
///
/// `text` is the text to render as a UTF-8 string. It can contain Pango markup,
/// for example `<i>The</i>Guardian`.
///
/// `font` is the font to render with, as a fontconfig name. Examples might be
/// `sans 12` or perhaps `bitstream charter bold 10`.
///
/// You can specify a font to load with `fontfile`. You'll need to also set the
/// name of the font with `font`.
///
/// `width` is the number of pixels to word-wrap at. By default, lines of text
/// wider than this will be broken at word boundaries.
/// Use `wrap` to set lines to wrap on word or character boundaries, or to
/// disable line breaks.
///
/// Set `justify` to turn on line justification.
/// `align` can be used to set the alignment style for multi-line
/// text to the low (left) edge centre, or high (right) edge. Note that the
/// output image can be wider than `width` if there are no
/// word breaks, or narrower if the lines don't break exactly at `width`.
///
/// `height` is the maximum number of pixels high the generated text can be. This
/// only takes effect when `dpi` is not set, and `width` is set, making a box.
/// In this case, `vips.text` will search for a `dpi` and set of line breaks
/// which will just fit the text into `width` and `height`.
///
/// You can use `autofit_dpi` to read out the DPI selected by auto fit.
///
/// `dpi` sets the resolution to render at. "sans 12" at 72 dpi draws characters
/// approximately 12 pixels high.
///
/// `spacing` sets the line spacing, in points. It would typically be something
/// like font size times 1.2.
///
/// You can read the coordinate of the top edge of the character from `Xoffset`
/// / `Yoffset`. This can be helpful if you need to line up the output of
/// several `vips.text`.
///
/// See also: `vips.bandjoin`, `vips.composite`.
extern fn vips_text(p_out: **vips.Image, p_text: [*:0]const u8, ...) c_int;
pub const text = vips_text;

/// Free any thread-private data and flush any profiling information.
///
/// This function needs to be called when a thread that has been using vips
/// exits. It is called for you by `vips.shutdown` and for any threads created
/// within the `VipsThreadPool`.
///
/// You will need to call it from threads created in
/// other ways or there will be memory leaks. If you do not call it, vips
/// will generate a warning message.
///
/// It may be called many times, and you can continue using vips after
/// calling it. Calling it too often will reduce performance.
extern fn vips_thread_shutdown() void;
pub const threadShutdown = vips_thread_shutdown;

/// Optional arguments:
///
/// * `height`: `gint`, target height in pixels
/// * `size`: `vips.Size`, upsize, downsize, both or force
/// * `no_rotate`: `gboolean`, don't rotate upright using orientation tag
/// * `crop`: `vips.Interesting`, shrink and crop to fill target
/// * `linear`: `gboolean`, perform shrink in linear light
/// * `import_profile`: `gchararray`, fallback import ICC profile
/// * `export_profile`: `gchararray`, export ICC profile
/// * `intent`: `vips.Intent`, rendering intent
/// * `fail_on`: `vips.FailOn`, load error types to fail on
///
/// Make a thumbnail from a file. Shrinking is done in three stages: using any
/// shrink-on-load features available in the file import library, using a block
/// shrink, and using a lanczos3 shrink. At least the final 200% is done with
/// lanczos3. The output should be high quality, and the operation should be
/// quick.
///
/// See `vips.thumbnailBuffer` to thumbnail from a memory buffer, or
/// `vips.thumbnailSource` to thumbnail from an arbitrary byte source.
///
/// By default, libvips will only use the first frame of animated or multipage
/// images. To thumbnail all pages or frames, pass `n=-1` to the loader in
/// `filename`, for example `"x.gif[n=-1]"`.
///
/// The output image will fit within a square of size `width` x `width`. You can
/// specify a separate height with the `height` option. Set either `width` or
/// `height` to a very large number to ignore that dimension.
///
/// If you set `crop`, then the output image will fill the whole of the `width` x
/// `height` rectangle, with any excess cropped away. See `vips.Image.smartcrop` for
/// details on the cropping strategy.
///
/// Normally the operation will upsize or downsize as required to fit the image
/// inside or outside the target size. If `size` is set
/// to `VIPS_SIZE_UP`, the operation will only upsize and will just
/// copy if asked to downsize.
/// If `size` is set
/// to `VIPS_SIZE_DOWN`, the operation will only downsize and will just
/// copy if asked to upsize.
/// If `size` is `VIPS_SIZE_FORCE`, the image aspect ratio will be broken and the
/// image will be forced to fit the target.
///
/// Normally any orientation tags on the input image (such as EXIF tags) are
/// interpreted to rotate the image upright. If you set `no_rotate` to `TRUE`,
/// these tags will not be interpreted.
///
/// Shrinking is normally done in sRGB colourspace. Set `linear` to shrink in
/// linear light colourspace instead. This can give better results, but can
/// also be far slower, since tricks like JPEG shrink-on-load cannot be used in
/// linear space.
///
/// If you set `export_profile` to the filename of an ICC profile, the image
/// will be transformed to the target colourspace before writing to the
/// output. You can also give an `import_profile` which will be used if the
/// input image has no ICC profile, or if the profile embedded in the
/// input image is broken.
///
/// Use `intent` to set the rendering intent for any ICC transform. The default
/// is `VIPS_INTENT_RELATIVE`.
///
/// Use `fail_on` to control the types of error that will cause loading to fail.
/// The default is `VIPS_FAIL_ON_NONE`, ie. thumbnail is permissive.
///
/// See also: `vips.thumbnailBuffer`.
extern fn vips_thumbnail(p_filename: [*:0]const u8, p_out: **vips.Image, p_width: c_int, ...) c_int;
pub const thumbnail = vips_thumbnail;

/// Optional arguments:
///
/// * `height`: `gint`, target height in pixels
/// * `size`: `vips.Size`, upsize, downsize, both or force
/// * `no_rotate`: `gboolean`, don't rotate upright using orientation tag
/// * `crop`: `vips.Interesting`, shrink and crop to fill target
/// * `linear`: `gboolean`, perform shrink in linear light
/// * `import_profile`: `gchararray`, fallback import ICC profile
/// * `export_profile`: `gchararray`, export ICC profile
/// * `intent`: `vips.Intent`, rendering intent
/// * `fail_on`: `vips.FailOn`, load error types to fail on
/// * `option_string`: `gchararray`, extra loader options
///
/// Exactly as `vips.thumbnail`, but read from a memory buffer. One extra
/// optional argument, `option_string`, lets you pass options to the underlying
/// loader.
///
/// See also: `vips.thumbnail`.
extern fn vips_thumbnail_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, p_width: c_int, ...) c_int;
pub const thumbnailBuffer = vips_thumbnail_buffer;

/// Optional arguments:
///
/// * `height`: `gint`, target height in pixels
/// * `size`: `vips.Size`, upsize, downsize, both or force
/// * `no_rotate`: `gboolean`, don't rotate upright using orientation tag
/// * `crop`: `vips.Interesting`, shrink and crop to fill target
/// * `linear`: `gboolean`, perform shrink in linear light
/// * `import_profile`: `gchararray`, fallback import ICC profile
/// * `export_profile`: `gchararray`, export ICC profile
/// * `intent`: `vips.Intent`, rendering intent
/// * `fail_on`: `vips.FailOn`, load error types to fail on
/// * `option_string`: `gchararray`, extra loader options
///
/// Exactly as `vips.thumbnail`, but read from a source. One extra
/// optional argument, `option_string`, lets you pass options to the underlying
/// loader.
///
/// See also: `vips.thumbnail`.
extern fn vips_thumbnail_source(p_source: *vips.Source, p_out: **vips.Image, p_width: c_int, ...) c_int;
pub const thumbnailSource = vips_thumbnail_source;

/// Optional arguments:
///
/// * `page`: `gint`, load this page
/// * `n`: `gint`, load this many pages
/// * `autorotate`: `gboolean`, use orientation tag to rotate the image
///   during load
/// * `subifd`: `gint`, select this subifd index
///
/// Read a TIFF file into a VIPS image. It is a full baseline TIFF 6 reader,
/// with extensions for tiled images, multipage images, XYZ and LAB colour
/// space, pyramidal images and JPEG compression, including CMYK and YCbCr.
///
/// `page` means load this page from the file. By default the first page (page
/// 0) is read.
///
/// `n` means load this many pages. By default a single page is read. All the
/// pages must have the same dimensions, and they are loaded as a tall, thin
/// "toilet roll" image. The `VIPS_META_PAGE_HEIGHT` metadata
/// tag gives the height in pixels of each page. Use -1 to load all pages.
///
/// Setting `autorotate` to `TRUE` will make the loader interpret the
/// orientation tag and automatically rotate the image appropriately during
/// load.
///
/// If `autorotate` is `FALSE`, the metadata field `VIPS_META_ORIENTATION` is set
/// to the value of the orientation tag. Applications may read and interpret
/// this field
/// as they wish later in processing. See `vips.Image.autorot`. Save
/// operations will use `VIPS_META_ORIENTATION`, if present, to set the
/// orientation of output images.
///
/// If `autorotate` is TRUE, the image will be rotated upright during load and
/// no metadata attached. This can be very slow.
///
/// If `subifd` is -1 (the default), the main image is selected for each page.
/// If it is 0 or greater and there is a SUBIFD tag, the indexed SUBIFD is
/// selected. This can be used to read lower resolution layers from
/// bioformats-style image pyramids.
///
/// Any ICC profile is read and attached to the VIPS image as
/// `VIPS_META_ICC_NAME`. Any XMP metadata is read and attached to the image
/// as `VIPS_META_XMP_NAME`. Any IPTC is attached as `VIPS_META_IPTC_NAME`. The
/// image description is
/// attached as `VIPS_META_IMAGEDESCRIPTION`. Data in the photoshop tag is
/// attached as `VIPS_META_PHOTOSHOP_NAME`.
///
/// See also: `vips.Image.newFromFile`, `vips.Image.autorot`.
extern fn vips_tiffload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const tiffload = vips_tiffload;

/// Optional arguments:
///
/// * `page`: `gint`, load this page
/// * `n`: `gint`, load this many pages
/// * `autorotate`: `gboolean`, use orientation tag to rotate the image
///   during load
/// * `subifd`: `gint`, select this subifd index
///
/// Read a TIFF-formatted memory block into a VIPS image. Exactly as
/// `vips.tiffload`, but read from a memory source.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.tiffload`.
extern fn vips_tiffload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const tiffloadBuffer = vips_tiffload_buffer;

/// Optional arguments:
///
/// * `page`: `gint`, load this page
/// * `n`: `gint`, load this many pages
/// * `autorotate`: `gboolean`, use orientation tag to rotate the image
///   during load
/// * `subifd`: `gint`, select this subifd index
///
/// Exactly as `vips.tiffload`, but read from a source.
///
/// See also: `vips.tiffload`.
extern fn vips_tiffload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const tiffloadSource = vips_tiffload_source;

/// Optional arguments:
///
/// * `in_max`: input range
/// * `out_max`: output range
/// * `Lb`: black-point [0-100]
/// * `Lw`: white-point [0-100]
/// * `Ps`: shadow point (eg. 0.2)
/// * `Pm`: mid-tone point (eg. 0.5)
/// * `Ph`: highlight point (eg. 0.8)
/// * `S`: shadow adjustment (+/- 30)
/// * `M`: mid-tone adjustment (+/- 30)
/// * `H`: highlight adjustment (+/- 30)
///
/// `vips.tonelut` generates a tone curve for the adjustment of image
/// levels. It is mostly designed for adjusting the L* part of a LAB image in
/// a way suitable for print work, but you can use it for other things too.
///
/// The curve is an unsigned 16-bit image with (`in_max` + 1) entries,
/// each in the range [0, `out_max`].
///
/// `Lb`, `Lw` are expressed as 0-100, as in LAB colour space. You
/// specify the scaling for the input and output images with the `in_max` and
/// `out_max` parameters.
extern fn vips_tonelut(p_out: **vips.Image, ...) c_int;
pub const tonelut = vips_tonelut;

/// Allocate an area of memory aligned on a boundary specified
/// by `align` that will be tracked by `vips.trackedGetMem`
/// and friends.
///
/// If allocation fails, `vips.trackedAlignedAlloc` returns `NULL`
/// and sets an error message.
///
/// You must only free the memory returned with `vips.trackedAlignedFree`.
///
/// See also: `vips.trackedMalloc`, `vips.trackedAlignedFree`, `vips.malloc`.
extern fn vips_tracked_aligned_alloc(p_size: usize, p_align: usize) ?*anyopaque;
pub const trackedAlignedAlloc = vips_tracked_aligned_alloc;

/// Only use it to free memory that was
/// previously allocated with `vips.trackedAlignedAlloc`
/// with a `NULL` first argument.
///
/// See also: `vips.trackedAlignedAlloc`.
extern fn vips_tracked_aligned_free(p_s: ?*anyopaque) void;
pub const trackedAlignedFree = vips_tracked_aligned_free;

/// Exactly as close(2), but update the number of files currently open via
/// `vips.trackedGetFiles`. This is used
/// by the vips operation cache to drop cache when the number of files
/// available is low.
///
/// You must only close file descriptors opened with `vips.trackedOpen`.
///
/// See also: `vips.trackedOpen`, `vips.trackedGetFiles`.
extern fn vips_tracked_close(p_fd: c_int) c_int;
pub const trackedClose = vips_tracked_close;

/// Only use it to free memory that was
/// previously allocated with `vips.trackedMalloc`
/// with a `NULL` first argument.
///
/// See also: `vips.trackedMalloc`.
extern fn vips_tracked_free(p_s: ?*anyopaque) void;
pub const trackedFree = vips_tracked_free;

/// Returns the number of active allocations.
extern fn vips_tracked_get_allocs() c_int;
pub const trackedGetAllocs = vips_tracked_get_allocs;

/// Returns the number of open files.
extern fn vips_tracked_get_files() c_int;
pub const trackedGetFiles = vips_tracked_get_files;

/// Returns the number of bytes currently allocated via `vips.malloc` and
/// friends. vips uses this figure to decide when to start dropping cache, see
/// `vips.Operation`.
extern fn vips_tracked_get_mem() usize;
pub const trackedGetMem = vips_tracked_get_mem;

/// Returns the largest number of bytes simultaneously allocated via
/// `vips.trackedMalloc`. Handy for estimating max memory requirements for a
/// program.
extern fn vips_tracked_get_mem_highwater() usize;
pub const trackedGetMemHighwater = vips_tracked_get_mem_highwater;

/// Allocate an area of memory that will be tracked by `vips.trackedGetMem`
/// and friends.
///
/// If allocation fails, `vips.trackedMalloc` returns `NULL` and
/// sets an error message.
///
/// You must only free the memory returned with `vips.trackedFree`.
///
/// See also: `vips.trackedFree`, `vips.malloc`.
extern fn vips_tracked_malloc(p_size: usize) ?*anyopaque;
pub const trackedMalloc = vips_tracked_malloc;

/// Exactly as open(2), but the number of files currently open via
/// `vips.trackedOpen` is available via `vips.trackedGetFiles`. This is used
/// by the vips operation cache to drop cache when the number of files
/// available is low.
///
/// You must only close the file descriptor with `vips.trackedClose`.
///
/// `pathname` should be utf8.
///
/// See also: `vips.trackedClose`, `vips.trackedGetFiles`.
extern fn vips_tracked_open(p_pathname: [*:0]const u8, p_flags: c_int, p_mode: c_int) c_int;
pub const trackedOpen = vips_tracked_open;

extern fn vips_type_depth(p_type: usize) c_int;
pub const typeDepth = vips_type_depth;

/// Search below `basename`, return the `gobject.Type` of the class whose name or
/// `nickname` matches, or 0 for not found.
/// If `basename` is NULL, the whole of `vips.Object` is searched.
///
/// This function uses a cache, so it should be quick.
///
/// See also: `vips.classFind`
extern fn vips_type_find(p_basename: [*:0]const u8, p_nickname: [*:0]const u8) usize;
pub const typeFind = vips_type_find;

/// Map over a type's children. Stop when `fn` returns non-`NULL`
/// and return that value.
extern fn vips_type_map(p_base: usize, p_fn: vips.TypeMap2Fn, p_a: ?*anyopaque, p_b: ?*anyopaque) ?*anyopaque;
pub const typeMap = vips_type_map;

/// Map over a type's children, direct and indirect. Stop when `fn` returns
/// non-`NULL` and return that value.
extern fn vips_type_map_all(p_base: usize, p_fn: vips.TypeMapFn, p_a: ?*anyopaque) ?*anyopaque;
pub const typeMapAll = vips_type_map_all;

/// Get the pointer from an area. Don't touch count (area is static).
extern fn vips_value_get_area(p_value: *const gobject.Value, p_length: ?*usize) ?*anyopaque;
pub const valueGetArea = vips_value_get_area;

/// Return the pointer to the array held by `value`.
/// Optionally return the other properties of the array in `n`, `type`,
/// `sizeof_type`.
///
/// See also: `vips.valueSetArray`.
extern fn vips_value_get_array(p_value: *const gobject.Value, p_n: ?*c_int, p_type: ?*usize, p_sizeof_type: ?*usize) ?*anyopaque;
pub const valueGetArray = vips_value_get_array;

/// Return the start of the array of doubles held by `value`.
/// optionally return the number of elements in `n`.
///
/// See also: `vips.ArrayDouble.new`.
extern fn vips_value_get_array_double(p_value: *const gobject.Value, p_n: ?*c_int) [*]f64;
pub const valueGetArrayDouble = vips_value_get_array_double;

/// Return the start of the array of images held by `value`.
/// optionally return the number of elements in `n`.
///
/// See also: `vips.valueSetArrayImage`.
extern fn vips_value_get_array_image(p_value: *const gobject.Value, p_n: ?*c_int) [*]*vips.Image;
pub const valueGetArrayImage = vips_value_get_array_image;

/// Return the start of the array of ints held by `value`.
/// optionally return the number of elements in `n`.
///
/// See also: `vips.ArrayInt.new`.
extern fn vips_value_get_array_int(p_value: *const gobject.Value, p_n: ?*c_int) [*]c_int;
pub const valueGetArrayInt = vips_value_get_array_int;

/// Return the start of the array of `gobject.Object` held by `value`.
/// Optionally return the number of elements in `n`.
///
/// See also: `vips.Area.newArrayObject`.
extern fn vips_value_get_array_object(p_value: *const gobject.Value, p_n: ?*c_int) [*]*gobject.Object;
pub const valueGetArrayObject = vips_value_get_array_object;

/// Returns the data pointer from a blob. Optionally returns the length too.
///
/// blobs are things like ICC profiles or EXIF data. They are relocatable, and
/// are saved to VIPS files for you coded as base64 inside the XML. They are
/// copied by copying reference-counted pointers.
///
/// See also: `vips.valueSetBlob`
extern fn vips_value_get_blob(p_value: *const gobject.Value, p_length: ?*usize) [*]u8;
pub const valueGetBlob = vips_value_get_blob;

/// Get the C string held internally by the `gobject.Value`.
extern fn vips_value_get_ref_string(p_value: *const gobject.Value, p_length: ?*usize) [*:0]const u8;
pub const valueGetRefString = vips_value_get_ref_string;

/// Get the C string held internally by the GValue.
extern fn vips_value_get_save_string(p_value: *const gobject.Value) [*:0]const u8;
pub const valueGetSaveString = vips_value_get_save_string;

extern fn vips_value_is_null(p_psoec: *gobject.ParamSpec, p_value: *const gobject.Value) c_int;
pub const valueIsNull = vips_value_is_null;

/// Set value to be a ref-counted area of memory with a free function.
extern fn vips_value_set_area(p_value: *gobject.Value, p_free_fn: ?vips.CallbackFn, p_data: ?*anyopaque) void;
pub const valueSetArea = vips_value_set_area;

/// Set `value` to be an array of things.
///
/// This allocates memory but does not
/// initialise the contents: get the pointer and write instead.
extern fn vips_value_set_array(p_value: *gobject.Value, p_n: c_int, p_type: usize, p_sizeof_type: usize) void;
pub const valueSetArray = vips_value_set_array;

/// Set `value` to hold a copy of `array`. Pass in the array length in `n`.
///
/// See also: `vips.ArrayDouble.get`.
extern fn vips_value_set_array_double(p_value: *gobject.Value, p_array: ?[*]const f64, p_n: c_int) void;
pub const valueSetArrayDouble = vips_value_set_array_double;

/// Set `value` to hold an array of images. Pass in the array length in `n`.
///
/// See also: `vips.ArrayImage.get`.
extern fn vips_value_set_array_image(p_value: *gobject.Value, p_n: c_int) void;
pub const valueSetArrayImage = vips_value_set_array_image;

/// Set `value` to hold a copy of `array`. Pass in the array length in `n`.
///
/// See also: `vips.ArrayInt.get`.
extern fn vips_value_set_array_int(p_value: *gobject.Value, p_array: ?[*]const c_int, p_n: c_int) void;
pub const valueSetArrayInt = vips_value_set_array_int;

/// Set `value` to hold an array of `gobject.Object`. Pass in the array length in `n`.
///
/// See also: `vips.valueGetArrayObject`.
extern fn vips_value_set_array_object(p_value: *gobject.Value, p_n: c_int) void;
pub const valueSetArrayObject = vips_value_set_array_object;

/// Sets `value` to hold a `data`. When `value` is freed, `data` will be
/// freed with `free_fn`. `value` also holds a note of the size of the memory
/// area.
///
/// blobs are things like ICC profiles or EXIF data. They are relocatable, and
/// are saved to VIPS files for you coded as base64 inside the XML. They are
/// copied by copying reference-counted pointers.
///
/// See also: `vips.valueGetBlob`
extern fn vips_value_set_blob(p_value: *gobject.Value, p_free_fn: ?vips.CallbackFn, p_data: [*]u8, p_length: usize) void;
pub const valueSetBlob = vips_value_set_blob;

/// Just like `vips.valueSetBlob`, but when
/// `value` is freed, `data` will be
/// freed with `glib.free`.
///
/// This can be easier to call for language bindings.
///
/// See also: `vips.valueSetBlob`
extern fn vips_value_set_blob_free(p_value: *gobject.Value, p_data: [*]u8, p_length: usize) void;
pub const valueSetBlobFree = vips_value_set_blob_free;

/// Copies the C string `str` into `value`.
///
/// vips_ref_string are immutable C strings that are copied between images by
/// copying reference-counted pointers, making them much more efficient than
/// regular `gobject.Value` strings.
///
/// `str` should be a valid utf-8 string.
extern fn vips_value_set_ref_string(p_value: *gobject.Value, p_str: [*:0]const u8) void;
pub const valueSetRefString = vips_value_set_ref_string;

/// Copies the C string into `value`.
///
/// `str` should be a valid utf-8 string.
extern fn vips_value_set_save_string(p_value: *gobject.Value, p_str: [*:0]const u8) void;
pub const valueSetSaveString = vips_value_set_save_string;

/// Generates a string and copies it into `value`.
extern fn vips_value_set_save_stringf(p_value: *gobject.Value, p_fmt: [*:0]const u8, ...) void;
pub const valueSetSaveStringf = vips_value_set_save_stringf;

/// Append a message to the error buffer.
///
/// See also: `vips.@"error"`.
extern fn vips_verror(p_domain: [*:0]const u8, p_fmt: [*:0]const u8, p_ap: std.builtin.VaList) void;
pub const verror = vips_verror;

/// Format the string in the style of `printf` and append to the error buffer.
/// Then create and append a localised message based on the system error code,
/// usually the value of errno.
///
/// See also: `vips.errorSystem`.
extern fn vips_verror_system(p_err: c_int, p_domain: [*:0]const u8, p_fmt: [*:0]const u8, p_ap: std.builtin.VaList) void;
pub const verrorSystem = vips_verror_system;

/// Get the major, minor or micro library version, with `flag` values 0, 1 and
/// 2.
///
/// Get the ABI current, revision and age (as used by Meson) with `flag`
/// values 3, 4, 5.
extern fn vips_version(p_flag: c_int) c_int;
pub const version = vips_version;

/// Get the VIPS version as a static string, including a build date and time.
/// Do not free.
extern fn vips_version_string() [*:0]const u8;
pub const versionString = vips_version_string;

/// Read in a vips image.
///
/// See also: `vips.Image.vipssave`.
extern fn vips_vipsload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const vipsload = vips_vipsload;

/// Exactly as `vips.vipsload`, but read from a source.
extern fn vips_vipsload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const vipsloadSource = vips_vipsload_source;

/// Optional arguments:
///
/// * `page`: `gint`, page (frame) to read
/// * `n`: `gint`, load this many pages
/// * `scale`: `gdouble`, scale by this much on load
///
/// Read a WebP file into a VIPS image.
///
/// Use `page` to select a page to render, numbering from zero.
///
/// Use `n` to select the number of pages to render. The default is 1. Pages are
/// rendered in a vertical column, with each individual page aligned to the
/// left. Set to -1 to mean "until the end of the document". Use `vips.Image.grid`
/// to change page layout.
///
/// Use `scale` to specify a scale-on-load factor. For example, 2.0 to double
/// the size on load. Animated webp images don't support shrink-on-load, so a
/// further resize may be necessary.
///
/// The loader supports ICC, EXIF and XMP metadata.
///
/// See also: `vips.Image.newFromFile`.
extern fn vips_webpload(p_filename: [*:0]const u8, p_out: **vips.Image, ...) c_int;
pub const webpload = vips_webpload;

/// Optional arguments:
///
/// * `page`: `gint`, page (frame) to read
/// * `n`: `gint`, load this many pages
/// * `scale`: `gdouble`, scale by this much on load
///
/// Read a WebP-formatted memory block into a VIPS image. Exactly as
/// `vips.webpload`, but read from a memory buffer.
///
/// You must not free the buffer while `out` is active. The
/// `vips.Object.signals.postclose` signal on `out` is a good place to free.
///
/// See also: `vips.webpload`
extern fn vips_webpload_buffer(p_buf: [*]u8, p_len: usize, p_out: **vips.Image, ...) c_int;
pub const webploadBuffer = vips_webpload_buffer;

/// Optional arguments:
///
/// * `page`: `gint`, page (frame) to read
/// * `n`: `gint`, load this many pages
/// * `scale`: `gdouble`, scale by this much on load
///
/// Exactly as `vips.webpload`, but read from a source.
///
/// See also: `vips.webpload`
extern fn vips_webpload_source(p_source: *vips.Source, p_out: **vips.Image, ...) c_int;
pub const webploadSource = vips_webpload_source;

/// Perform `VIPS_OPERATION_MATH2_WOP` on a pair of images. See
/// `vips.math2`.
extern fn vips_wop(p_left: *vips.Image, p_right: *vips.Image, p_out: **vips.Image, ...) c_int;
pub const wop = vips_wop;

/// Optional arguments:
///
/// * `cell_size`: `gint`, size of Worley cells
///
/// Create a one-band float image of Worley noise. See:
///
/// https://en.wikipedia.org/wiki/Worley_noise
///
/// Use `cell_size` to set the size of the cells from which the image is
/// constructed. The default is 256 x 256.
///
/// If `width` and `height` are multiples of `cell_size`, the image will tessellate.
///
/// See also: `vips.perlin`, `vips.fractsurf`, `vips.gaussnoise`.
extern fn vips_worley(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const worley = vips_worley;

/// Optional arguments:
///
/// * `csize`: `gint`, size for third dimension
/// * `dsize`: `gint`, size for fourth dimension
/// * `esize`: `gint`, size for fifth dimension
///
/// Create a two-band uint32 image where the elements in the first band have the
/// value of their x coordinate and elements in the second band have their y
/// coordinate.
///
/// You can make any image where the value of a pixel is a function of its (x,
/// y) coordinate by combining this operator with the arithmetic operators.
///
/// Set `csize`, `dsize`, `esize` to generate higher dimensions and add more
/// bands. The extra dimensions are placed down the vertical axis. Use
/// `vips.Image.grid` to change the layout.
///
/// See also: `vips.grey`, `vips.Image.grid`, `vips.identity`.
extern fn vips_xyz(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const xyz = vips_xyz;

/// Optional arguments:
///
/// * `uchar`: output a uchar image
///
/// Create a one-band image of a zone plate.
///
/// Pixels are normally in [-1, +1], set `uchar` to output [0, 255].
///
/// See also: `vips.eye`, `vips.xyz`.
extern fn vips_zone(p_out: **vips.Image, p_width: c_int, p_height: c_int, ...) c_int;
pub const zone = vips_zone;

pub const ArgumentClassMapFn = *const fn (p_object_class: *vips.ObjectClass, p_pspec: *gobject.ParamSpec, p_argument_class: *vips.ArgumentClass, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const ArgumentMapFn = *const fn (p_object: *vips.Object, p_pspec: *gobject.ParamSpec, p_argument_class: *vips.ArgumentClass, p_argument_instance: *vips.ArgumentInstance, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const CallbackFn = *const fn (p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) c_int;

pub const ClassMapFn = *const fn (p_cls: *vips.ObjectClass, p_a: ?*anyopaque) callconv(.c) ?*anyopaque;

/// Fill `out`->valid with pixels. `seq` contains per-thread state, such as the
/// input regions. Set `stop` to `TRUE` to stop processing.
///
/// See also: `vips_image_generate`, `vips_stop_many`.
pub const GenerateFn = *const fn (p_out: *vips.Region, p_seq: ?*anyopaque, p_a: ?*anyopaque, p_b: ?*anyopaque, p_stop: *c_int) callconv(.c) c_int;

pub const ImageMapFn = *const fn (p_image: *vips.Image, p_name: [*:0]const u8, p_value: *gobject.Value, p_a: ?*anyopaque) callconv(.c) ?*anyopaque;

/// An interpolation function. It should read source pixels from `in` with
/// `VIPS_REGION_ADDR`, it can look left and up from (x, y) by `window_offset`
/// pixels and it can access pixels in a window of size `window_size`.
///
/// The interpolated value should be written to the pixel pointed to by `out`.
///
/// See also: `vips.InterpolateClass`.
pub const InterpolateMethod = *const fn (p_interpolate: *vips.Interpolate, p_out: ?*anyopaque, p_in: *vips.Region, p_x: f64, p_y: f64) callconv(.c) void;

pub const ObjectSetArguments = *const fn (p_object: *vips.Object, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const OperationBuildFn = *const fn (p_object: *vips.Object) callconv(.c) c_int;

pub const SListFold2Fn = *const fn (p_item: ?*anyopaque, p_a: ?*anyopaque, p_b: ?*anyopaque, p_c: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const SListMap2Fn = *const fn (p_item: ?*anyopaque, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const SListMap4Fn = *const fn (p_item: ?*anyopaque, p_a: ?*anyopaque, p_b: ?*anyopaque, p_c: ?*anyopaque, p_d: ?*anyopaque) callconv(.c) ?*anyopaque;

/// Start a new processing sequence for this generate function. This allocates
/// per-thread state, such as an input region.
///
/// See also: `vips_start_one`, `vips_start_many`.
pub const StartFn = *const fn (p_out: *vips.Image, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) ?*anyopaque;

/// Stop a processing sequence. This frees
/// per-thread state, such as an input region.
///
/// See also: `vips_stop_one`, `vips_stop_many`.
pub const StopFn = *const fn (p_seq: ?*anyopaque, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) c_int;

pub const TypeMap2Fn = *const fn (p_type: usize, p_a: ?*anyopaque, p_b: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const TypeMapFn = *const fn (p_type: usize, p_a: ?*anyopaque) callconv(.c) ?*anyopaque;

pub const ARGUMENT_OPTIONAL_INPUT = 18;
pub const ARGUMENT_OPTIONAL_OUTPUT = 34;
pub const ARGUMENT_REQUIRED_INPUT = 19;
pub const ARGUMENT_REQUIRED_OUTPUT = 35;
/// Areas under curves for illuminant A (2856K), 2 degree observer.
pub const A_X0 = 109.850300;
pub const A_Y0 = 100.000000;
pub const A_Z0 = 35.584900;
/// Areas under curves for illuminant B (4874K), 2 degree observer.
pub const B_X0 = 99.072000;
pub const B_Y0 = 100.000000;
pub const B_Z0 = 85.223000;
pub const CONFIG = "enable debug: false\nenable deprecated: true\nenable modules: true\nenable cplusplus: true\nenable RAD load/save: true\nenable Analyze7 load: true\nenable PPM load/save: true\nenable GIF load: true\nFFTs with fftw3: true\nSIMD support with libhwy: true\nICC profile support with lcms2: true\ndeflate compression with zlib: true\ntext rendering with pangocairo: true\nfont file support with fontconfig: true\nEXIF metadata support with libexif: true\nJPEG load/save with libjpeg: true\nJXL load/save with libjxl: true (dynamic module: true)\nJPEG2000 load/save with libopenjp2: true\nPNG load/save with libpng: true\nimage quantisation with imagequant: true\nTIFF load/save with libtiff-4: true\nimage pyramid save with libarchive: true\nHEIC/AVIF load/save with libheif: true (dynamic module: true)\nWebP load/save with libwebp: true\nPDF load with poppler-glib: true (dynamic module: true)\nSVG load with librsvg-2.0: true\nEXR load with OpenEXR: true\nWSI load with openslide: true (dynamic module: true)\nMatlab load with Matio: false\nNIfTI load/save with libnifti: false\nFITS load/save with cfitsio: true\nGIF save with cgif: true\nMagick load/save with MagickCore: true (dynamic module: true)";
/// Areas under curves for illuminant C (6774K), 2 degree observer.
pub const C_X0 = 98.070000;
pub const C_Y0 = 100.000000;
pub const C_Z0 = 118.230000;
/// Areas under curves for black body at 3250K, 2 degree observer.
pub const D3250_X0 = 105.659000;
pub const D3250_Y0 = 100.000000;
pub const D3250_Z0 = 45.850100;
/// Areas under curves for D50, 2 degree observer.
pub const D50_X0 = 96.425000;
pub const D50_Y0 = 100.000000;
pub const D50_Z0 = 82.468000;
/// Areas under curves for D55, 2 degree observer.
pub const D55_X0 = 95.683100;
pub const D55_Y0 = 100.000000;
pub const D55_Z0 = 92.087100;
/// Areas under curves for D65, 2 degree observer.
pub const D65_X0 = 95.047000;
pub const D65_Y0 = 100.000000;
pub const D65_Z0 = 108.882700;
/// Areas under curves for D75, 2 degree observer.
pub const D75_X0 = 94.968200;
pub const D75_Y0 = 100.000000;
pub const D75_Z0 = 122.571000;
/// Areas under curves for D93, 2 degree observer.
pub const D93_X0 = 89.740000;
pub const D93_Y0 = 100.000000;
pub const D93_Z0 = 130.770000;
pub const DEFAULT_MAX_COORD = 100000000;
pub const ENABLE_DEPRECATED = 1;
/// Areas under curves for equal energy illuminant E.
pub const E_X0 = 100.000000;
pub const E_Y0 = 100.000000;
pub const E_Z0 = 100.000000;
/// `VIPS_INTERPOLATE_SHIFT` as a multiplicative constant.
pub const INTERPOLATE_SCALE = 1;
/// Many of the vips interpolators use fixed-point arithmetic for value
/// calculation. This is how many bits of precision they use.
pub const INTERPOLATE_SHIFT = 12;
pub const LIBRARY_AGE = 18;
pub const LIBRARY_CURRENT = 60;
pub const LIBRARY_REVISION = 1;
/// The first four bytes of a VIPS file in Intel byte ordering.
pub const MAGIC_INTEL = 3064394248;
/// The first four bytes of a VIPS file in SPARC byte ordering.
pub const MAGIC_SPARC = 150120118;
pub const MAJOR_VERSION = 8;
/// The bits per sample for each channel.
pub const META_BITS_PER_SAMPLE = "bits-per-sample";
/// If set, the suggested concurrency for this image.
pub const META_CONCURRENCY = "concurrency";
/// The name that read and write operations use for the image's EXIF data.
pub const META_EXIF_NAME = "exif-data";
/// The name we use to attach an ICC profile. The file read and write
/// operations for TIFF, JPEG, PNG and others use this item of metadata to
/// attach and save ICC profiles. The profile is updated by the
/// `vips.Image.iccTransform` operations.
pub const META_ICC_NAME = "icc-profile-data";
/// The IMAGEDESCRIPTION tag. Often has useful metadata.
pub const META_IMAGEDESCRIPTION = "image-description";
/// The name that read and write operations use for the image's IPTC data.
pub const META_IPTC_NAME = "iptc-data";
/// Record the name of the original loader here. Handy for hinting file formats
/// and for debugging.
pub const META_LOADER = "vips-loader";
/// If set, the number of pages in the original file.
pub const META_N_PAGES = "n-pages";
/// If set, the number of subifds in the first page of the file.
pub const META_N_SUBIFDS = "n-subifds";
/// The orientation tag for this image. An int from 1 - 8 using the standard
/// exif/tiff meanings.
///
/// * 1 - The 0th row represents the visual top of the image, and the 0th column
///   represents the visual left-hand side.
/// * 2 - The 0th row represents the visual top of the image, and the 0th column
///   represents the visual right-hand side.
/// * 3 - The 0th row represents the visual bottom of the image, and the 0th
///   column represents the visual right-hand side.
/// * 4 - The 0th row represents the visual bottom of the image, and the 0th
///   column represents the visual left-hand side.
/// * 5 - The 0th row represents the visual left-hand side of the image, and the
///   0th column represents the visual top.
/// * 6 - The 0th row represents the visual right-hand side of the image, and the
///   0th column represents the visual top.
/// * 7 - The 0th row represents the visual right-hand side of the image, and the
///   0th column represents the visual bottom.
/// * 8 - The 0th row represents the visual left-hand side of the image, and the
///   0th column represents the visual bottom.
pub const META_ORIENTATION = "orientation";
/// If set, the height of each page when this image was loaded. If you save an
/// image with "page-height" set to a format that supports multiple pages, such
/// as tiff, the image will be saved as a series of pages.
pub const META_PAGE_HEIGHT = "page-height";
/// Does this image have a palette?
pub const META_PALETTE = "palette";
/// The name that TIFF read and write operations use for the image's
/// TIFFTAG_PHOTOSHOP data.
pub const META_PHOTOSHOP_NAME = "photoshop-data";
/// The JPEG and TIFF read and write operations use this to record the
/// file's preferred unit for resolution.
pub const META_RESOLUTION_UNIT = "resolution-unit";
/// Images loaded via `vips.Image.sequential` have this int field defined. Some
/// operations (eg. `vips.Image.shrinkv`) add extra caches if they see it on their
/// input.
pub const META_SEQUENTIAL = "vips-sequential";
/// The name that read and write operations use for the image's XMP data.
pub const META_XMP_NAME = "xmp-data";
pub const MICRO_VERSION = 1;
pub const MINOR_VERSION = 16;
/// `VIPS_TRANSFORM_SHIFT` as a multiplicative constant.
pub const TRANSFORM_SCALE = 1;
/// Many of the vips interpolators use fixed-point arithmetic for coordinate
/// calculation. This is how many bits of precision they use.
pub const TRANSFORM_SHIFT = 6;
pub const VERSION = "8.16.1";
pub const VERSION_STRING = "8.16.1";

test {
    @setEvalBranchQuota(100_000);
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(ext);
}
