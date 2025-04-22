const std = @import("std");
pub const log = @import("log.zig");
pub const c = struct {
    pub const c_null = @as(?*anyopaque, null);
    pub const glib = @import("glib");
    pub const gobject = @import("gobject");
    pub const vips = @import("vips");
};

/// Mixin to provide methods to manipulate the `_counter` field.
pub fn Zimage(comptime T: type) type {
    return struct {
        const Self = @This();
        fn getParent(mixin: *Self) *T {
            return @alignCast(@fieldParentPtr("Image", mixin));
        }

        pub fn avg(self: *Self) f64 {
            var out: f64 = undefined;
            _ = self.getParent()._cImage.avg(&out, c.c_null);
            return out;
        }
    };
}

pub const zvips = struct {
    pub fn newFromFile(name: [:0]const u8) zvips {
        const image = c.vips.Image.newFromFile(name, c.c_null) orelse unreachable;
        return .{ ._cImage = image };
    }

    _cImage: *c.vips.Image,
    Image: Zimage(zvips) = .{},
};
