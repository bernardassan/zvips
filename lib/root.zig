const std = @import("std");
const builtin = @import("builtin");

pub const Image = @import("Image.zig");
const Options = @import("Options.zig");
const varargs = @import("varargs.zig");

pub const logger = std.log.scoped(.zvips);

pub const c = struct {
    pub const @"null" = @as(?*anyopaque, null);
    pub const glib = @import("glib2");
    pub const gobject = @import("gobject2");
    pub const vips = @import("vips8");

    extern "c" fn setenv(name: [*:0]const u8, value: [*:0]const u8, overwrite: i32) i32;
};

/// enables `c.vips.leakSet` in `.Debug` mode.
/// See `c.vips.init`
pub fn init(app_name: [:0]const u8) !void {
    disableLibsNotFoundStartupWarning();
    if (c.vips.init(app_name) != 0) return error.FailedToStart;
    switch (builtin.mode) {
        .Debug => {
            if (c.setenv("G_MESSAGES_DEBUG", "VIPS", @intFromBool(true)) != 0) {
                logger.warn("Unable to set env var G_MESSAGES_DEBUG", .{});
            }

            // This will print a table of any ref leaks on exit, very handy for development.
            leakSet(true);
        },
        else => {},
    }
}

/// Must be run if leak checker and profiler is enabled.
/// See `c.vips.shutdown`
pub fn deinit() void {
    c.vips.shutdown();
}

/// See `c.vips.errorExit`
pub fn errorExit(comptime efmt: []const u8, args: anytype) noreturn {
    std.debug.print(efmt, args);
    c.vips.errorExit(null, c.null);
    unreachable;
}

/// This will print a table of any ref leaks on exit, very handy for
/// development. See `c.vips.leakSet`
pub fn leakSet(leak: bool) void {
    c.vips.leakSet(@intFromBool(leak));
}

// Disable unable to load poppler, openslide and magick libs at startup
// vips-poppler.so -- libpoppler-glib.so.8
// vips-openslide.so -- libopenslide.so.1
// vips-magick.so -- libMagickCore-7.Q16HDRI.so.10
// NOTE: Must be called before `init`
fn disableLibsNotFoundStartupWarning() void {
    _ = c.glib.logSetHandler("VIPS", c.glib.LogLevelFlags.flags_level_warning, vipsWarningHandler, c.null);
}

// Custom warning handler to filter out module-loading errors
fn vipsWarningHandler(domain: ?[*:0]const u8, level: c.glib.LogLevelFlags, message: [*c]const u8, user_data: ?*anyopaque) callconv(.c) void {
    // Ignore ONLY "unable to load module" warnings
    if (std.mem.indexOf(u8, std.mem.span(message), "unable to load") == null) {
        // Print all other warnings to stderr
        c.glib.logDefaultHandler(domain, level, message, user_data);
    }
}

test {
    _ = Options;
}
