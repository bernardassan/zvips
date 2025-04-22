const std = @import("std");
const builtin = @import("builtin");
const zivips = @import("zivips");
const log = zivips.log;
const zvips = zivips.zvips;
const vips = zivips.c.vips;
const c_null = zivips.c.c_null;

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

    log.defaultLogger();

    if (vips.init(args[0]) != 0) {
        vips.errorExit("Unable to start VIPS", "something went wrong");
    }

    // This will print a table of any ref leaks on exit,
    // very handy for development.
    vips.leakSet(@intFromBool(true));

    if (args.len != 2) {
        vips.errorExit("usage: {s} <filename>", vips.getPrgname());
    }

    // const image = @call(.auto, vips.Image.newFromFile, .{ args[1], @as(?*anyopaque, null) }) orelse {
    //     vips.errorExit("unable to open file");
    //     unreachable;
    // };
    var a = zvips.newFromFile(args[1]);
    const image = vips.Image.newFromFile(std.mem.sliceTo(args[1], 0)) orelse {
        vips.errorExit("unable to open file");
        unreachable;
    };
    defer image.unref();

    var avg: f64 = undefined;
    if (image.avg(&avg, c_null) != 0) {
        vips.errorExit("unable to find avg");
    }

    std.debug.assert(a.Image.avg() == avg);
    std.debug.print("Pixel average of {s} is {}\n", .{ args[1], avg });
}
