const std = @import("std");
const builtin = @import("builtin");

const zvips = @import("zvips");
const c = zvips.c;

pub const logger = std.log.scoped(.basic);

pub const std_options: std.Options = .{
    .log_level = .debug,
    // FIXME: Remove when upgraded to Zig > 0.15.2
    .logFn = logFn,
};

// FIXME: Remove when upgraded to Zig > 0.15.2
pub fn logFn(
    comptime level: std.log.Level,
    comptime scope: @Type(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    var buffer: [64]u8 = undefined;
    const ttyconf = std.Io.tty.Config.detect(.stderr());
    const stderr = std.debug.lockStderrWriter(&buffer);
    defer std.debug.unlockStderrWriter();
    ttyconf.setColor(stderr, switch (level) {
        .err => .red,
        .warn => .yellow,
        .info => .green,
        .debug => .magenta,
    }) catch {};
    ttyconf.setColor(stderr, .bold) catch {};
    stderr.writeAll(level.asText()) catch return;
    ttyconf.setColor(stderr, .reset) catch {};
    ttyconf.setColor(stderr, .dim) catch {};
    ttyconf.setColor(stderr, .bold) catch {};
    if (scope != .default) {
        stderr.print("({s})", .{@tagName(scope)}) catch return;
    }
    stderr.writeAll(": ") catch return;
    ttyconf.setColor(stderr, .reset) catch {};
    stderr.print(format ++ "\n", args) catch return;
}

pub fn main() !void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    const gpa, const is_debug = gpa: {
        if (builtin.os.tag == .wasi) break :gpa .{ std.heap.wasm_allocator, false };
        break :gpa switch (builtin.mode) {
            .Debug, .ReleaseSafe => .{ debug_allocator.allocator(), true },
            .ReleaseFast, .ReleaseSmall => .{ std.heap.smp_allocator, false },
        };
    };
    defer if (is_debug) {
        _ = debug_allocator.deinit();
    };

    var arena: std.heap.ArenaAllocator = .init(gpa);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    const args = std.process.argsAlloc(arena_alloc) catch unreachable;
    defer std.process.argsFree(arena_alloc, args);

    zvips.init(args[0]) catch |err| switch (err) {
        error.FailedToStart => zvips.errorExit("error: {s}: something went wrong", .{@errorName(err)}),
        else => unreachable,
    };
    defer zvips.deinit();

    zvips.leakSet(true);

    if (args.len != 2) {
        zvips.errorExit("usage: {s} <filename>", .{c.vips.getPrgname()});
    }

    const image = zvips.Image.newFromFile(args[1], .{
        .heif = .{ .@"fail-on" = .warning },
    }) orelse {
        zvips.errorExit("unable to open file", .{});
    };
    defer image.deinit();

    try image.convert("output.avif", null);

    const avg = image.avg() catch unreachable;
    logger.info("Pixel average of {s} is {}\n", .{ args[1], avg });
}
