const std = @import("std");
const builtin = @import("builtin");
const varargs = @import("varargs.zig");
const Options = @import("Options.zig");

pub const std_options: std.Options = .{ .log_level = .debug };
pub const logger = std.log.scoped(.zvips);

pub const c = struct {
    pub const @"null" = @as(?*anyopaque, null);
    pub const glib = @import("glib2");
    pub const gobject = @import("gobject2");
    pub const vips = @import("vips8");

    extern "c" fn setenv(name: [*:0]const u8, value: [*:0]const u8, overwrite: i32) i32;
};
pub const Image = @import("Image.zig");

/// Docs `c.vips.init`
/// enables `c.vips.leakSet` in .Debug mode
pub fn init(app_name: [:0]const u8) !void {
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

/// Docs `c.vips.Image.writeToFile`
pub fn convert(input: union(enum) {
    file: []const u8,
    img: Image,
}, output_file: []const u8, options: ?Options.Save) !void {
    var buf: [256]u8 = undefined;
    var fba: std.heap.FixedBufferAllocator = .init(&buf);

    const buf_alloc = fba.allocator();
    defer fba.reset();

    const img = switch (input) {
        .file => |file| Image.newFromFile(file, .{ .heif = .{} }) orelse {
            errorExit("unable to open file", .{});
        },
        .img => |img| img,
    };
    defer img.deinit();

    const file_with_options: [:0]const u8 = Options.toString(output_file, .{ .save = options }, buf_alloc) catch @panic("Oom");

    if (varargs.call(c.vips.Image.writeToFile, .{ img.cimage, file_with_options }) != 0) return error.ConvertionError;

    switch (input) {
        .file => |file| logger.info("convert {s} to {s}", .{ file, file_with_options }),
        .img => logger.info("convert image to {s}", .{file_with_options}),
    }
}

/// Docs `c.vips.errorExit`
pub fn errorExit(comptime efmt: []const u8, args: anytype) noreturn {
    std.debug.print(efmt, args);
    c.vips.errorExit(null, c.null);
    unreachable;
}

/// Docs `c.vips.leakSet`
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

test {
    _ = Options;
}
