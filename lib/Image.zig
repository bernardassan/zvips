const std = @import("std");

const varargs = @import("varargs.zig");
const Options = @import("Options.zig");
const c = @import("root.zig").c;

const Image = @This();

cimage: *c.vips.Image,
// https://github.com/davidbyttow/govips/blob/master/vips/image.go#L126
// CLEAR_ASSUMPTION: vips might need multiple args before the optional args
/// Docs `c.vips.Image.newFromFile`
pub fn newFromFile(file_name: []const u8, options: ?Options.Load) ?Image {
    var buf: [256]u8 = undefined;
    var fba: std.heap.FixedBufferAllocator = .init(&buf);

    const buf_alloc = fba.allocator();
    defer fba.reset();

    const file_with_options = Options.toString(file_name, .{ .load = options }, buf_alloc) catch @panic("Oom");

    const image = varargs.call(c.vips.Image.newFromFile, .{file_with_options}) orelse return null;

    return .{ .cimage = image };
}

pub fn avg(self: Image) error{FailedToComputeAvg}!f64 {
    var _avg: f64 = undefined;
    if (self.cimage.avg(&_avg, c.null) != 0) return error.FailedToComputeAvg;
    return _avg;
}

pub fn deinit(self: Image) void {
    self.cimage.unref();
}
