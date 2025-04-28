const std = @import("std");
const builtin = @import("builtin");
const zvips = @import("zvips");
const c = zvips.c;

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

    zvips.defaultLogger();

    zvips.init(args[0]) catch |err| switch (err) {
        error.FailedToStart => zvips.errorExit("error: {s}: something went wrong", .{@errorName(err)}),
        else => unreachable,
    };

    // This will print a table of any ref leaks on exit,
    // very handy for development.
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

    const avg = image.avg() catch unreachable;
    std.debug.print("Pixel average of {s} is {}\n", .{ args[1], avg });
}
