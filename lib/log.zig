const std = @import("std");
const zivips = @import("root.zig");
const vips = zivips.vips;
const glib = zivips.glib;
const c_null = zivips.c_null;

// Custom warning handler to filter out module-loading errors
fn vipsWarningHandler(domain: ?[*:0]const u8, level: glib.LogLevelFlags, message: [*c]const u8, user_data: ?*anyopaque) callconv(.c) void {
    // Ignore ONLY "unable to load module" warnings
    if (std.mem.indexOf(u8, std.mem.span(message), "unable to load") == null) {
        // Print all other warnings to stderr
        glib.logDefaultHandler(domain, level, message, user_data);
    }
}

pub fn defaultLogger() void {
    _ = glib.logSetHandler("VIPS", glib.LogLevelFlags.flags_level_warning, vipsWarningHandler, c_null);
}
