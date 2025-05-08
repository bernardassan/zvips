const std = @import("std");

const varargs = @import("varargs.zig");
const Options = @import("Options.zig");
const c = @import("root.zig").c;
const c_null = c.c_null;

const Image = @This();

image: ?*c.vips.Image,
// TODO: maybe set G_MESSAGES_DEBUG=VIPS in development
// TODO: how to get the improved API to be the default binding
// https://github.com/davidbyttow/govips/blob/master/vips/image.go#L126
// CLEAR_ASSUMPTION: vips might need multiple args before the optional args
// TODO: use the input.extentions[option=value] parameter setting approach
/// See `vips.Image.newFromFile` for more details
pub fn newFromFile(file_name: []const u8, options: Options.Image.Load) ?Image {
    var buf: [256]u8 = undefined;
    var ba: std.heap.FixedBufferAllocator = .init(&buf);
    const fba = ba.allocator();

    const option_string = options.toString(fba);
    defer fba.free(option_string);

    const file_with_options: [:0]const u8 = std.mem.joinZ(fba, "", &.{ file_name, option_string }) catch unreachable;

    return .{ .image = varargs.call(c.vips.Image.newFromFile, file_with_options, .{}) };
}

pub fn avg(self: Image) error{FailedToComputeAvg}!f64 {
    var _avg: f64 = undefined;
    if (self.image.?.avg(&_avg, c_null) != 0) return error.FailedToComputeAvg;
    return _avg;
}

pub fn deinit(self: Image) void {
    self.image.?.unref();
}
