const expect = @import("std").testing.expect;
const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay3 = struct { p1: u32, p2: u32 };

pub fn run(alloc: std.mem.Allocator) !RetDay3 {
    var lines = try helpers.asLines(alloc, "input/day03.txt");
    defer lines.deinit();

    const num_bits: u5 = @intCast(lines.items[0].len);
    var nums = std.ArrayList(u32).init(alloc);
    for (lines.items) |line| try nums.append(try std.fmt.parseInt(u32, line, 2));
    defer nums.deinit();

    return RetDay3{
        .p1 = try getRatings(alloc, nums, num_bits, false),
        .p2 = try getRatings(alloc, nums, num_bits, true),
    };
}

fn oxGen(mcb: u1) u1 {
    return mcb;
}

fn c02Scrub(mcb: u1) u1 {
    return ~mcb;
}

fn getRatings(alloc: std.mem.Allocator, nums: std.ArrayList(u32), num_bits: u5, running_filter: bool) !u32 {
    const oxygenRating = try getRating(alloc, nums, num_bits, oxGen, running_filter);
    const c02Rating = try getRating(alloc, nums, num_bits, c02Scrub, running_filter);
    return oxygenRating * c02Rating;
}

fn getRating(alloc: std.mem.Allocator, nums: std.ArrayList(u32), num_bits: u5, bitCriterion: *const fn (u1) u1, runningFilter: bool) !u32 {
    var nums_local = std.ArrayList(u32).init(alloc);
    defer nums_local.deinit();
    try nums_local.appendSlice(nums.items);

    var index: i32 = num_bits - 1;

    var mask_len: u5 = 0;
    var mask: u32 = 0;

    while (true) {
        const most_common_bit = mostCommonBit(nums_local, index);
        index -= 1;

        mask <<= 1;
        mask |= bitCriterion(most_common_bit);
        mask_len += 1;

        if (runningFilter) {
            var i: u32 = 0;
            while (i < nums_local.items.len) {
                if (!matchesMask(nums_local.items[i], mask, num_bits - 1, mask_len)) {
                    _ = nums_local.orderedRemove(i);
                } else {
                    i += 1;
                }
            }
        }

        if (nums_local.items.len == 1) return nums_local.pop();
        if (mask_len == num_bits) return mask;
    }

    unreachable;
}

fn matchesMask(n: u32, mask: u32, start_bit: u5, mask_len: u5) bool {
    // Shift left to clear top bits
    var nn = n & ((@as(u32, 1) << (start_bit + 1)) - 1);
    // Shift right to clear low bits
    nn >>= (start_bit + 1 - mask_len);
    return nn == mask;
}

test "maskTest" {
    try expect(matchesMask(0b10101, 0b10, 2, 2) == true);
    try expect(matchesMask(0b10101, 0b10, 1, 2) == false);
    try expect(matchesMask(0b10101, 0b101, 2, 3) == true);
    try expect(matchesMask(0b10101, 0b101, 4, 3) == true);
    try expect(matchesMask(0b10101, 0b111, 4, 3) == false);
}

fn mostCommonBit(nums: std.ArrayList(u32), index: i32) u1 {
    var count_ones: i32 = 0;
    const shift: u5 = @intCast(index);

    for (nums.items) |n| {
        if (((n >> shift) & 1) == 1) count_ones += 1;
    }

    return if (count_ones >= (nums.items.len + 1) / 2) 1 else 0;
}

test "mostCommonBit test" {
    var tst = std.ArrayList(u32).init(std.testing.allocator_instance.allocator());
    defer tst.deinit();
    try tst.appendSlice(&[_]u32{ 1, 2, 3 });
    try expect(mostCommonBit(tst, 1) == 1);
    try expect(mostCommonBit(tst, 0) == 1);
    try tst.appendSlice(&[_]u32{ 4, 6 });
    try expect(mostCommonBit(tst, 0) == 0);
}
