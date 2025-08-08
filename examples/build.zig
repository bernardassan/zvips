const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const all_step = b.step("all", "Run all examples");
    const check_step = b.step("check", "Check all compilation errors");
    b.default_step = all_step;

    for (b.available_deps) |available_dep| {
        const example_name, _ = available_dep;
        const run_example = &b.dependency(example_name, .{
            .target = target,
            .optimize = optimize,
        }).builder.top_level_steps.get("run").?.step;

        const check_example = &b.dependency(example_name, .{
            .target = target,
            .optimize = optimize,
        }).builder.top_level_steps.get("check").?.step;

        const example_run_step = b.step(example_name, b.fmt("Run the '{s}' example", .{example_name}));

        const example_check_step = b.step(b.fmt("{s}-{s}", .{ example_name, "check" }), b.fmt("Check the '{s}' example for compilation errors", .{example_name}));

        example_run_step.dependOn(run_example);
        example_check_step.dependOn(check_example);

        all_step.dependOn(example_run_step);
        check_step.dependOn(example_check_step);
    }
}
