pub const ext = @import("ext.zig");
const gmodule = @This();

const std = @import("std");
const compat = @import("compat");
const glib = @import("glib2");
/// The `gmodule.Module` struct is an opaque data structure to represent a
/// [dynamically-loaded module](modules.html`dynamic`-loading-of-modules).
/// It should only be accessed via the following functions.
///
/// To ensure correct lock ordering, these functions must not be called from
/// global constructors (for example, those using GCC’s
/// `__attribute__((constructor))` attribute).
pub const Module = opaque {
    /// A portable way to build the filename of a module. The platform-specific
    /// prefix and suffix are added to the filename, if needed, and the result
    /// is added to the directory, using the correct separator character.
    ///
    /// The directory should specify the directory where the module can be found.
    /// It can be `NULL` or an empty string to indicate that the module is in a
    /// standard platform-specific directory, though this is not recommended
    /// since the wrong module may be found.
    ///
    /// For example, calling `gmodule.moduleBuildPath` on a Linux system with a
    /// `directory` of `/lib` and a `module_name` of "mylibrary" will return
    /// `/lib/libmylibrary.so`. On a Windows system, using `\Windows` as the
    /// directory it will return `\Windows\mylibrary.dll`.
    extern fn g_module_build_path(p_directory: ?[*:0]const u8, p_module_name: [*:0]const u8) [*:0]u8;
    pub const buildPath = g_module_build_path;

    /// Gets a string describing the last module error.
    extern fn g_module_error() [*:0]const u8;
    pub const @"error" = g_module_error;

    extern fn g_module_error_quark() glib.Quark;
    pub const errorQuark = g_module_error_quark;

    /// A thin wrapper function around `gmodule.Module.openFull`
    extern fn g_module_open(p_file_name: ?[*:0]const u8, p_flags: gmodule.ModuleFlags) *gmodule.Module;
    pub const open = g_module_open;

    /// Opens a module. If the module has already been opened, its reference count
    /// is incremented. If not, the module is searched using `file_name`.
    ///
    /// Since 2.76, the search order/behavior is as follows:
    ///
    /// 1. If `file_name` exists as a regular file, it is used as-is; else
    /// 2. If `file_name` doesn't have the correct suffix and/or prefix for the
    ///    platform, then possible suffixes and prefixes will be added to the
    ///    basename till a file is found and whatever is found will be used; else
    /// 3. If `file_name` doesn't have the ".la"-suffix, ".la" is appended. Either
    ///    way, if a matching .la file exists (and is a libtool archive) the
    ///    libtool archive is parsed to find the actual file name, and that is
    ///    used.
    ///
    /// If, at the end of all this, we have a file path that we can access on disk,
    /// it is opened as a module. If not, `file_name` is attempted to be opened as a
    /// module verbatim in the hopes that the system implementation will somehow be
    /// able to access it. If that is not possible, `NULL` is returned.
    ///
    /// Note that this behaviour was different prior to 2.76, but there is some
    /// overlap in functionality. If backwards compatibility is an issue, kindly
    /// consult earlier `gmodule.Module` documentation for the prior search order/behavior
    /// of `file_name`.
    extern fn g_module_open_full(p_file_name: ?[*:0]const u8, p_flags: gmodule.ModuleFlags, p_error: ?*?*glib.Error) ?*gmodule.Module;
    pub const openFull = g_module_open_full;

    /// Checks if modules are supported on the current platform.
    extern fn g_module_supported() c_int;
    pub const supported = g_module_supported;

    /// Closes a module.
    extern fn g_module_close(p_module: *Module) c_int;
    pub const close = g_module_close;

    /// Ensures that a module will never be unloaded.
    /// Any future `gmodule.Module.close` calls on the module will be ignored.
    extern fn g_module_make_resident(p_module: *Module) void;
    pub const makeResident = g_module_make_resident;

    /// Returns the filename that the module was opened with.
    ///
    /// If `module` refers to the application itself, "main" is returned.
    extern fn g_module_name(p_module: *Module) [*:0]const u8;
    pub const name = g_module_name;

    /// Gets a symbol pointer from a module, such as one exported
    /// by `G_MODULE_EXPORT`. Note that a valid symbol can be `NULL`.
    extern fn g_module_symbol(p_module: *Module, p_symbol_name: [*:0]const u8, p_symbol: ?*anyopaque) c_int;
    pub const symbol = g_module_symbol;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Errors returned by `gmodule.Module.openFull`.
pub const ModuleError = enum(c_int) {
    failed = 0,
    check_failed = 1,
    _,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Flags passed to `gmodule.Module.open`.
/// Note that these flags are not supported on all platforms.
pub const ModuleFlags = packed struct(c_uint) {
    lazy: bool = false,
    local: bool = false,
    _padding2: bool = false,
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

    pub const flags_lazy: ModuleFlags = @bitCast(@as(c_uint, 1));
    pub const flags_local: ModuleFlags = @bitCast(@as(c_uint, 2));
    pub const flags_mask: ModuleFlags = @bitCast(@as(c_uint, 3));

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Specifies the type of the module initialization function.
/// If a module contains a function named `g_module_check_init` it is called
/// automatically when the module is loaded. It is passed the `gmodule.Module` structure
/// and should return `NULL` on success or a string describing the initialization
/// error.
pub const ModuleCheckInit = *const fn (p_module: *gmodule.Module) callconv(.c) [*:0]const u8;

/// Specifies the type of the module function called when it is unloaded.
/// If a module contains a function named `g_module_unload` it is called
/// automatically when the module is unloaded.
/// It is passed the `gmodule.Module` structure.
pub const ModuleUnload = *const fn (p_module: *gmodule.Module) callconv(.c) void;

pub const MODULE_IMPL_AR = 7;
pub const MODULE_IMPL_DL = 1;
pub const MODULE_IMPL_NONE = 0;
pub const MODULE_IMPL_WIN32 = 3;

test {
    @setEvalBranchQuota(100_000);
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(ext);
}
