const std = @import("std");

pub const c = struct {
    pub const @"null" = @as(?*anyopaque, null);
    pub const glib = @import("glib2");
    pub const gobject = @import("gobject2");
    pub const vips = @import("vips8");
};
pub const Image = @import("Image.zig");

/// See `c.vips.init` for more details
pub fn init(app_name: [:0]const u8) error{FailedToStart}!void {
    if (c.vips.init(app_name) != 0) return error.FailedToStart;
}

/// See `c.vips.errorExit` for more details
pub fn errorExit(comptime efmt: []const u8, args: anytype) noreturn {
    std.debug.print(efmt, args);
    c.vips.errorExit(null, c.null);
    unreachable;
}

/// See `c.vips.leakSet` for more details
pub fn leakSet(leak: bool) void {
    c.vips.leakSet(@intFromBool(leak));
}

pub fn defaultLogger() void {
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
