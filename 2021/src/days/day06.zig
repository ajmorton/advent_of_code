const expect = @import("std").testing.expect;
const std = @import("std");

const helpers = @import("../helpers.zig");

pub const RetDay6 = struct { p1: u64, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay6 {
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day06.txt", 1000000);
    var fish: Fish = try Fish.init(alloc, allText);
    defer fish.deinit();

    var p1: u64 = 0;
    var num_days: i32 = 1;
    while (num_days <= 256) : (num_days += 1) {
        try fish.step();
        if (num_days == 80) p1 = fish.count();
    }

    return RetDay6{ .p1 = p1, .p2 = fish.count() };
}

const Fish = struct {
    countdowns: std.ArrayList(u64),
    const Self = @This();

    fn init(alloc: std.mem.Allocator, str: []u8) !Self {
        var nums_iter = std.mem.split(u8, str, ",");
        var countdowns = std.ArrayList(u64).init(alloc);

        var i: u32 = 9;
        while (i > 0) : (i -= 1) try countdowns.append(0);

        while (nums_iter.next()) |n_str| {
            var n = try std.fmt.parseInt(u64, n_str, 10);
            countdowns.items[n] += 1;
        }

        return Self{ .countdowns = countdowns };
    }

    fn deinit(self: *Self) void {
        self.countdowns.deinit();
        self.* = undefined;
    }

    fn step(self: *Self) !void {
        // Fish resetting countdowns
        self.countdowns.items[7] += self.countdowns.items[0];

        // New births, and counters are decremented by popFront
        var new_births = self.countdowns.orderedRemove(0);
        try self.countdowns.append(new_births);
    }

    fn count(self: Self) u64 {
        var sum: u64 = 0;
        for (self.countdowns.items) |num_fish| sum += num_fish;
        return sum;
    }
};
