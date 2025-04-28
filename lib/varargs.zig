const std = @import("std");
const c = @import("root.zig").c;

pub fn call(func: anytype, start: anytype, valist: anytype) @typeInfo(@TypeOf(func)).@"fn".return_type.? {
    std.debug.assert(@typeInfo(@TypeOf(valist)).@"struct".is_tuple == true);
    return @call(.auto, func, .{start} ++ valist ++ .{c.c_null});
}
