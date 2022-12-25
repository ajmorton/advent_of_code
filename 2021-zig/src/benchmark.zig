const days = @import("days/all_days.zig");
const std = @import("std");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn naiveBenchmarkAll(run_for: u64) !void {
    std.debug.print("Benchmarking all days. Running each for {} seconds\n", .{run_for});
    try naiveBenchmark(days.d01, run_for);
    try naiveBenchmark(days.d02, run_for);
    try naiveBenchmark(days.d03, run_for);
    try naiveBenchmark(days.d04, run_for);
    try naiveBenchmark(days.d05, run_for);
    try naiveBenchmark(days.d06, run_for);
    try naiveBenchmark(days.d07, run_for);
    try naiveBenchmark(days.d08, run_for);
    try naiveBenchmark(days.d09, run_for);
    try naiveBenchmark(days.d10, run_for);
    try naiveBenchmark(days.d11, run_for);
    try naiveBenchmark(days.d12, run_for);
    try naiveBenchmark(days.d13, run_for);
    try naiveBenchmark(days.d14, run_for);
    try naiveBenchmark(days.d15, run_for);
    try naiveBenchmark(days.d16, run_for);
    try naiveBenchmark(days.d17, run_for);
    try naiveBenchmark(days.d18, run_for);
    try naiveBenchmark(days.d19, run_for);
    try naiveBenchmark(days.d20, run_for);
    try naiveBenchmark(days.d21, run_for);
    try naiveBenchmark(days.d22, run_for);
    try naiveBenchmark(days.d23, run_for);
    try naiveBenchmark(days.d24, run_for);
    try naiveBenchmark(days.d25, run_for);
}

pub fn naiveBenchmark(mod: anytype, run_for: u64) !void {
    std.debug.print("{}: ", .{mod});

    // run once to warm up and determine number of runs
    const baseline_start = std.time.nanoTimestamp();
    _ = try mod.run(gpa);
    const baseline_runtime = std.time.nanoTimestamp() - baseline_start;
    var final_time: u64 = 0;

    if (baseline_runtime > std.time.ns_per_us and baseline_runtime < std.time.ns_per_s * (run_for / 2)) {
        var total: u64 = 0;
        var run: u32 = 1;
        var num_runs = @intCast(u64, @divFloor(run_for * std.time.ns_per_s, baseline_runtime) + 1);
        if (num_runs == 1) {
            // Test is too slow to run multiple times. Just take the baseline run time
            total = @intCast(u64, baseline_runtime);
            run = std.math.maxInt(u32);
        }

        while (run <= num_runs) : (run += 1) {
            std.debug.print("\x1B[8G{} of {}", .{ run, num_runs });
            const start_time = std.time.nanoTimestamp();
            _ = try mod.run(gpa);
            const run_time = @intCast(u64, std.time.nanoTimestamp() - start_time);
            total += run_time;
        }

        final_time = @divFloor(total, num_runs);
    } else {
        final_time = @intCast(u64, baseline_runtime);
    }

    const green = "\x1B[;32m";
    const red = "\x1B[;31m";
    const white = "\x1B[;37m";
    const end = "\x1B[;0m";

    const color = if (final_time < std.time.ns_per_ms) green else if (final_time > std.time.ns_per_s) red else white;

    var buf: [24]u8 = undefined;
    const final_time_str = try std.fmt.bufPrint(&buf, "{}", .{std.fmt.fmtDuration(final_time)});

    std.debug.print("{s}\x1B[8G{s:>10}\x1B[0K{s}\n", .{ color, final_time_str, end });
}
