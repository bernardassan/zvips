const std = @import("std");
// TODO: add general load and save options and loader specific options
// TODO: how to get the improved API to be the default binding

fn callVarArgs(func: anytype, comptime T: type, start: T, comptime valist: ?[]const T) @typeInfo(@TypeOf(func)).@"fn".return_type.? {
    if (valist) |args| {
        std.debug.assert(@typeInfo(@TypeOf(args)).pointer.size == .slice);
    }
    const c_null: ?*anyopaque = null;
    if (valist) |args| {
        switch (args.len) {
            1 => return func(start, args[0], c_null),
            2 => return func(start, args[0], args[1], c_null),
            3 => return func(start, args[0], args[1], args[2], c_null),
            4 => return func(start, args[0], args[1], args[2], args[3], c_null),
            5 => return func(start, args[0], args[1], args[2], args[3], args[4], c_null),
            6 => return func(start, args[0], args[1], args[2], args[3], args[4], args[5], c_null),
            7 => return func(start, args[0], args[1], args[2], args[3], args[5], args[5], args[6], c_null),
            8 => return func(start, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], c_null),
            else => @compileError("unsupported number of arguments"),
        }
    } else {
        return func(start, c_null);
    }
}

fn callVaA(func: anytype, start: anytype, valist: anytype) @typeInfo(@TypeOf(func)).@"fn".return_type.? {
    std.debug.assert(@typeInfo(@TypeOf(valist)).@"struct".is_tuple == true);
    inline for (valist, 0..) |value, i| {
        std.log.debug("Index {} is {s}", .{ i, value });
    }
    const c_null: ?*anyopaque = null;
    return @call(.auto, func, .{start} ++ valist ++ .{c_null});
}

const HeifLoader = struct {
    autorotate: bool,
    thumbnail: bool,
    page: u32,
    n: u32,
    access: u32,
};
const ImageOptions = union(enum) {
    all: struct {},
    heif: HeifLoader,
};

const a: ImageOptions = .{ .heif = .{ .access = 10 } };
// https://github.com/davidbyttow/govips/blob/master/vips/image.go#L126
// TODO: maybe set G_MESSAGES_DEBUG=VIPS in development
// CLEAR_ASSUMPTION: vips might need multiple args before the optional args
// TODO: use the input.extentions[option=value] parameter setting approach
// fn callVa(func: anytype, start: [*:0]const u8, img_opt: ?ImageOptions) @typeInfo(@TypeOf(func)).@"fn".return_type.? {
//     comptime var valist: [5 * 2][]const u8 = undefined;
//     inline for (valist, 0..) |value, i| {
//         std.log.debug("Index {} is {s}", .{ i, value });
//     }
//     const c_null: ?*anyopaque = null;
//     return @call(.auto, func, .{start} ++ valist ++ .{c_null});
// }
