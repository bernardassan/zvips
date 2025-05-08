const std = @import("std");
const c = @import("root.zig").c;
const debug = std.debug;
const process = std.process;

const Heif = struct {
    const Load = struct {
        /// First page to load, input gint
        /// default: 0
        /// min: 0, max: 100000
        page: ?u10 = null,
        /// Number of pages to load, -1 for all, input gint
        /// default: 1
        /// min: -1, max: 100000
        n: ?i11 = null,
        /// Fetch thumbnail image, input gboolean
        /// default: false
        thumbnail: ?bool = null,
        /// Remove all denial of service limits, input gboolean
        unlimited: ?bool = null,
        /// TODO: this can't be passed with the [key=value] format
        /// as it is an out param
        /// get Flags for this file, output VipsForeignFlags
        flags: ?*c.vips.ForeignFlags = null,
        /// Force open via memory, input gboolean
        /// default: false
        memory: ?bool = null,
        /// Required access pattern for this file, input VipsAccess
        /// default enum: random
        access: ?c.vips.Access = null,
        /// Error level to fail on, input VipsFailOn
        /// default enum: none
        @"fail-on": ?c.vips.FailOn = null,
        /// Don't use a cached result for this operation, input gboolean
        /// default: false
        revalidate: ?bool = null,
    };

    //TODO: check input supplied meet contracts of these optional arguments
    const Save = struct {
        /// Q factor, input gint
        /// default: 50
        /// min: 1, max: 100
        Q: ?u7 = null,
        /// Number of bits per pixel, input gint
        /// default: 12
        /// min: 8, max: 12
        bitdepth: ?u4 = null,
        /// Enable lossless compression, input gboolean
        /// default: false
        lossless: ?bool = null,
        /// Compression format, input VipsForeignHeifCompression
        /// default enum: hevc
        /// allowed enums: hevc, avc, jpeg, av1
        compression: ?c.vips.ForeignHeifCompression = null,
        /// CPU effort, input gint
        /// default: 4
        /// min: 0, max: 9
        effort: ?u4 = null,
        /// Select chroma subsample operation mode, input VipsForeignSubsample
        /// default enum: auto
        /// allowed enums: auto, on, off
        @"subsample-mode": ?c.vips.ForeignSubsample = null,
        /// Select encoder to use, input VipsForeignHeifEncoder
        /// default enum: auto
        /// allowed enums: auto, aom, rav1e, svt, x265
        encoder: ?c.vips.ForeignHeifEncoder = null,
        /// Which metadata to retain, input VipsForeignKeep
        /// default flags: exif:xmp:iptc:icc:other:all
        /// allowed flags: none, exif, xmp, iptc, icc, other, all
        keep: ?c.vips.ForeignKeep = null,
        /// Background value, input VipsArrayDouble
        background: ?c.vips.ArrayDouble = null,
        /// Set page height for multipage save, input gint
        /// default: 0
        /// min: 0, max: 100000000
        @"page-height": ?u32 = null,
        /// Filename of ICC profile to embed, input gchararray
        profile: ?[]const u8 = null,
    };
};

// TODO: add general load and save options and loader specific options
// .ie general Foreign Load & Save options
pub const Image = struct {
    pub const Load = union(enum) {
        heif: Heif.Load,

        /// caller owns memory and must free with `allocator.free` when done
        pub fn toString(self: Load, allocator: std.mem.Allocator) ![]const u8 {
            const char_count = 128; //random number bump if limit is hit
            var options = try std.ArrayList(u8).initCapacity(allocator, char_count);
            options.appendAssumeCapacity('[');

            var writer = options.writer();

            switch (self) {
                .heif => |heif_options| {
                    if (heif_options.page) |page| {
                        const min_page, const max_page = .{ 0, 100000 };
                        debug.assert(page >= min_page and page <= max_page);
                        try writer.print("page={}", .{page});
                        try writer.writeByte(',');
                    } else if (heif_options.n) |page_n| {
                        const min_page_n, const max_page_n = .{ -1, 100000 };
                        debug.assert(page_n >= min_page_n and page_n <= max_page_n);
                        try writer.print("n={}", .{page_n});
                        try writer.writeByte(',');
                    } else if (heif_options.thumbnail) |thumbnail| {
                        try writer.print("thumbnail={}", .{thumbnail});
                        try writer.writeByte(',');
                    } else if (heif_options.unlimited) |unlimited| {
                        try writer.print("unlimited={}", .{unlimited});
                        try writer.writeByte(',');
                    } else if (heif_options.flags) |flags| {
                        _ = flags;
                        process.fatal("TODO: how to get ForeignFlags output", .{});
                    } else if (heif_options.memory) |memory| {
                        try writer.print("memory={}", .{memory});
                        try writer.writeByte(',');
                    } else if (heif_options.access) |access| {
                        try writer.print("access={s}", .{@tagName(access)});
                        try writer.writeByte(',');
                    } else if (heif_options.@"fail-on") |fail_on| {
                        try writer.print("fail-on={s}", .{@tagName(fail_on)});
                        try writer.writeByte(',');
                    } else if (heif_options.revalidate) |revalidate| {
                        try writer.print("revalidate={}", .{revalidate});
                        try writer.writeByte(',');
                    }
                },
            }

            // replace last ',' with ']'
            options.replaceRangeAssumeCapacity(options.items.len - 1, 1, "]");

            return try options.toOwnedSlice();
        }
    };

    pub const Save = union(enum) {
        heif: Heif.Save,

        /// caller owns memory and must free with `allocator.free` when done
        pub fn toString(self: Save, allocator: std.mem.Allocator) ![]const u8 {
            const char_count = 128; //random number bump if limit is hit
            var options = try std.ArrayList(u8).initCapacity(allocator, char_count);
            options.appendAssumeCapacity('[');

            var writer = options.writer();

            switch (self) {
                .heif => |heif_save| {
                    if (heif_save.Q) |Q| {
                        const min_q, const max_q = .{ 1, 100 };
                        debug.assert(Q >= min_q and Q <= max_q);
                        try writer.print("Q={}", .{Q});
                        try writer.writeByte(',');
                    } else if (heif_save.bitdepth) |bitdepth| {
                        const min_depth, const max_depth = .{ 8, 12 };
                        debug.assert(bitdepth >= min_depth and bitdepth <= max_depth);
                        try writer.print("bitdepth={}", .{bitdepth});
                        try writer.writeByte(',');
                    } else if (heif_save.lossless) |lossless| {
                        try writer.print("lossless={}", .{lossless});
                        try writer.writeByte(',');
                    } else if (heif_save.compression) |compression| {
                        try writer.print("compression={s}", .{@tagName(compression)});
                        try writer.writeByte(',');
                    } else if (heif_save.effort) |effort| {
                        const min_effort, const max_effort = .{ 0, 9 };
                        debug.assert(effort >= min_effort and effort <= max_effort);
                        try writer.print("effort={}", .{effort});
                        try writer.writeByte(',');
                    } else if (heif_save.@"subsample-mode") |subsample_mode| {
                        try writer.print("subsample-mode={s}", .{@tagName(subsample_mode)});
                        try writer.writeByte(',');
                    } else if (heif_save.encoder) |encoder| {
                        try writer.print("encoder={s}", .{@tagName(encoder)});
                        try writer.writeByte(',');
                    } else if (heif_save.keep) |keep| {
                        try writer.print("keep={s}", .{@tagName(keep)});
                        try writer.writeByte(',');
                    } else if (heif_save.background) |background| {
                        _ = background;
                        process.fatal("TODO: how to format ArrayDouble\nMaybe use native slice of doubles", .{});
                    } else if (heif_save.@"page-height") |page_height| {
                        const page_min, const page_max = .{ 0, 100000000 };
                        debug.assert(page_height >= page_min and page_height <= page_max);
                        try writer.print("page-height={}", .{page_height});
                        try writer.writeByte(',');
                    } else if (heif_save.profile) |profile| {
                        try writer.print("profile={s}", .{profile});
                        try writer.writeByte(',');
                    }
                },
                .all => {},
            }

            // replace last ',' with ']'
            options.replaceRangeAssumeCapacity(options.items.len - 1, 1, "]");

            return try options.toOwnedSlice();
        }
    };
};
