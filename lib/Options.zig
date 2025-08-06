const std = @import("std");
const c = @import("root.zig").c;
const debug = std.debug;
const process = std.process;
const testing = std.testing;

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
/// caller owns memory and must free/reset when done
pub fn toString(file_name: []const u8, option: ?union(enum) {
    load: ?Load,
    save: ?Save,
}, fba: std.mem.Allocator) ![:0]const u8 {
    if (option) |options| {
        const option_string = switch (options) {
            .load => |load_| if (load_) |load| try load.toString(fba) else return try fba.dupeZ(u8, file_name),
            .save => |save_| if (save_) |save| try save.toString(fba) else return try fba.dupeZ(u8, file_name),
        };

        return try std.mem.joinZ(fba, "", &.{ file_name, option_string });
    } else {
        return try fba.dupeZ(u8, file_name);
    }
}

pub const Load = union(enum) {
    heif: Heif.Load,

    /// caller owns memory and must free/reset when done
    pub fn toString(self: Load, fba: std.mem.Allocator) ![]const u8 {
        // currently maximum option slice is 141
        const max_char_count = 192;
        var buf: [max_char_count]u8 = undefined;

        var options: std.Io.Writer = .fixed(&buf);
        try options.writeByte('[');

        switch (self) {
            .heif => |heif_options| {
                if (heif_options.page) |page| {
                    const min_page, const max_page = .{ 0, 100000 };
                    debug.assert(page >= min_page and page <= max_page);
                    try options.print("page={}", .{page});
                    try options.writeByte(',');
                }
                if (heif_options.n) |page_n| {
                    const min_page_n, const max_page_n = .{ -1, 100000 };
                    debug.assert(page_n >= min_page_n and page_n <= max_page_n);
                    try options.print("n={}", .{page_n});
                    try options.writeByte(',');
                }
                if (heif_options.thumbnail) |thumbnail| {
                    try options.print("thumbnail={}", .{thumbnail});
                    try options.writeByte(',');
                }
                if (heif_options.unlimited) |unlimited| {
                    try options.print("unlimited={}", .{unlimited});
                    try options.writeByte(',');
                }
                if (heif_options.flags) |flags| {
                    _ = flags;
                    process.fatal("TODO: how to get ForeignFlags output", .{});
                }
                if (heif_options.memory) |memory| {
                    try options.print("memory={}", .{memory});
                    try options.writeByte(',');
                }
                if (heif_options.access) |access| {
                    try options.print("access={s}", .{@tagName(access)});
                    try options.writeByte(',');
                }
                if (heif_options.@"fail-on") |fail_on| {
                    try options.print("fail-on={s}", .{@tagName(fail_on)});
                    try options.writeByte(',');
                }
                if (heif_options.revalidate) |revalidate| {
                    try options.print("revalidate={}", .{revalidate});
                    try options.writeByte(',');
                }
            },
        }
        // replace last ',' with ']'
        const writtern_options = options.buffered();
        if (writtern_options[writtern_options.len - 1] == ',') {
            writtern_options[writtern_options.len - 1] = ']';
        } else {
            try options.writeByte(']');
        }

        return try fba.dupe(u8, options.buffered());
    }
};

test Load {
    const allocator = testing.allocator;

    const avif: Heif.Load = .{
        .@"fail-on" = .warning,
        .access = .sequential,
        .flags = null,
        .memory = true,
        .n = -1,
        .page = 3,
        .revalidate = true,
        .thumbnail = true,
        .unlimited = true,
    };
    const load_avif: Load = .{ .heif = avif };

    const loaded_options = try load_avif.toString(allocator);
    defer allocator.free(loaded_options);

    const expect_options = "[page=3,n=-1,thumbnail=true,unlimited=true,memory=true,access=sequential,fail-on=warning,revalidate=true]";

    try testing.expectEqualStrings(expect_options, loaded_options);
}

pub const Save = union(enum) {
    heif: Heif.Save,

    /// caller owns memory and must free/reset when done
    pub fn toString(self: Save, fba: std.mem.Allocator) ![]const u8 {
        // currently maximum option slice is 141
        const max_char_count = 192;
        var buf: [max_char_count]u8 = undefined;

        var options: std.Io.Writer = .fixed(&buf);
        try options.writeByte('[');

        switch (self) {
            .heif => |heif_save| {
                if (heif_save.Q) |Q| {
                    const min_q, const max_q = .{ 1, 100 };
                    debug.assert(Q >= min_q and Q <= max_q);
                    try options.print("Q={}", .{Q});
                    try options.writeByte(',');
                }
                if (heif_save.bitdepth) |bitdepth| {
                    const min_depth, const max_depth = .{ 8, 12 };
                    debug.assert(bitdepth >= min_depth and bitdepth <= max_depth);
                    try options.print("bitdepth={}", .{bitdepth});
                    try options.writeByte(',');
                }
                if (heif_save.lossless) |lossless| {
                    try options.print("lossless={}", .{lossless});
                    try options.writeByte(',');
                }
                if (heif_save.compression) |compression| {
                    try options.print("compression={s}", .{@tagName(compression)});
                    try options.writeByte(',');
                }
                if (heif_save.effort) |effort| {
                    const min_effort, const max_effort = .{ 0, 9 };
                    debug.assert(effort >= min_effort and effort <= max_effort);
                    try options.print("effort={}", .{effort});
                    try options.writeByte(',');
                }
                if (heif_save.@"subsample-mode") |subsample_mode| {
                    try options.print("subsample-mode={s}", .{@tagName(subsample_mode)});
                    try options.writeByte(',');
                }
                if (heif_save.encoder) |encoder| {
                    try options.print("encoder={s}", .{@tagName(encoder)});
                    try options.writeByte(',');
                }
                if (heif_save.keep) |keep| {
                    try options.print("keep=", .{});

                    if (keep.exif) {
                        try options.print("exif:", .{});
                    }
                    if (keep.xmp) {
                        try options.print("xmp:", .{});
                    }
                    if (keep.iptc) {
                        try options.print("iptc:", .{});
                    }
                    if (keep.icc) {
                        try options.print("icc:", .{});
                    }
                    if (keep.other) {
                        try options.print("other", .{});
                    }

                    try options.writeByte(',');
                }
                if (heif_save.background) |background| {
                    _ = background;
                    process.fatal("TODO: how to format ArrayDouble\nMaybe use native slice of doubles", .{});
                } else if (heif_save.@"page-height") |page_height| {
                    const page_min, const page_max = .{ 0, 100000000 };
                    debug.assert(page_height >= page_min and page_height <= page_max);
                    try options.print("page-height={}", .{page_height});
                    try options.writeByte(',');
                }
                if (heif_save.profile) |profile| {
                    try options.print("profile={s}", .{profile});
                    try options.writeByte(',');
                }
            },
        }

        // replace last ',' with ']'
        const writtern_options = options.buffered();
        if (writtern_options[writtern_options.len - 1] == ',') {
            writtern_options[writtern_options.len - 1] = ']';
        } else {
            try options.writeByte(']');
        }

        return try fba.dupe(u8, options.buffered());
    }
};

test Save {
    const allocator = testing.allocator;

    const avif: Heif.Save = .{
        .@"page-height" = 100_000_000,
        .@"subsample-mode" = .on,
        .Q = 100,
        .background = null,
        .bitdepth = 12,
        .compression = .av1,
        .effort = 9,
        .encoder = .rav1e,
        .keep = .flags_all,
        .lossless = true,
        .profile = null,
    };
    const save_avif: Save = .{ .heif = avif };

    const options = try save_avif.toString(allocator);
    defer allocator.free(options);

    const expect = "[Q=100,bitdepth=12,lossless=true,compression=av1,effort=9,subsample-mode=on,encoder=rav1e,keep=exif:xmp:iptc:icc:other,page-height=100000000]";

    try testing.expectEqualStrings(expect, options);
}
