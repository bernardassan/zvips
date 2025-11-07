const std = @import("std");

const varargs = @import("varargs.zig");
const Options = @import("Options.zig");
const root = @import("root.zig");
const logger = root.logger;
const c = root.c;

const Image = @This();

cimage: *c.vips.Image,
// https://github.com/davidbyttow/govips/blob/master/vips/image.go#L126
// CLEAR_ASSUMPTION: vips might need multiple args before the optional args
/// See `c.vips.Image.newFromFile`
pub fn newFromFile(file_name: []const u8, options: ?Options.Load) ?Image {
    var buf: [256]u8 = undefined;
    var fba: std.heap.FixedBufferAllocator = .init(&buf);

    const buf_alloc = fba.allocator();
    defer fba.reset();

    const file_with_options = Options.toString(file_name, .{ .load = options }, buf_alloc) catch @panic("Oom");

    const image = varargs.call(c.vips.Image.newFromFile, .{file_with_options}) orelse return null;

    logger.debug("Created a new Vips Image from file {s} with options {s}", .{ file_name, file_with_options[file_name.len..] });

    return .{ .cimage = image };
}

/// See `c.vips.Image.writeToFile`
pub fn convert(img: Image, output_file: []const u8, options: ?Options.Save) !void {
    var buf: [256]u8 = undefined;
    var fba: std.heap.FixedBufferAllocator = .init(&buf);

    const buf_alloc = fba.allocator();
    defer fba.reset();

    const file_with_options: [:0]const u8 = Options.toString(output_file, .{ .save = options }, buf_alloc) catch @panic("Oom");

    if (varargs.call(c.vips.Image.writeToFile, .{ img.cimage, file_with_options }) != 0) return error.ConvertionError;

    logger.debug("Converted image to {s}", .{file_with_options});
}

/// See `c.vips.Image.writeToFile`
pub fn convertImage(img_file: []const u8, output_file: []const u8, options: ?Options.Save) !void {
    const img = Image.newFromFile(img_file, .{ .heif = .{} }) orelse {
        root.errorExit("unable to open file", .{});
    };
    defer img.deinit();

    img.convert(output_file, options);
}

/// See `c.vips.Image.avg`
pub fn avg(self: Image) error{FailedToComputeAvg}!f64 {
    var avg_: f64 = undefined;
    if (self.cimage.avg(&avg_, c.null) != 0) return error.FailedToComputeAvg;
    return avg_;
}

pub fn deinit(self: Image) void {
    self.cimage.unref();
}
