const std = @import("std");

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
