const expect = @import("std").testing.expect;
const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay3 = struct { p1: u32, p2: u32 };

fn parseBin(str: []u8) helpers.ConversionError!u32 {
    return std.fmt.parseInt(u32, str, 2) catch helpers.ConversionError.ConvFailed;
}

pub fn run(alloc: std.mem.Allocator) !RetDay3 {
    const lines = try helpers.readInAs(alloc, "input/day03.txt", []u8);
    defer lines.deinit();

    const num_bits = @intCast(u5, lines.items[0].len);
    var nums = try helpers.mapArrayList(alloc, []u8, u32, lines, parseBin);
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

const VarArg = struct { mask: u32, start_bit: u5, mask_len: u5 };

fn getRating(alloc: std.mem.Allocator, nums: std.ArrayList(u32), num_bits: u5, bitCriterion: fn (u1) u1, runningFilter: bool) !u32 {
    var nums_local = std.ArrayList(u32).init(alloc);
    defer nums_local.deinit();
    try nums_local.appendSlice(nums.items);

    var index: i32 = num_bits - 1;

    var mask_len: u5 = 0;
    var mask: u32 = 0;

    while (true) {
        var most_common_bit = mostCommonBit(nums_local, index);
        index -= 1;

        mask <<= 1;
        mask += bitCriterion(most_common_bit);
        mask_len += 1;

        if (runningFilter) {
            var v = VarArg{ .mask = mask, .start_bit = num_bits - 1, .mask_len = mask_len };
            helpers.filterArrayList(u32, VarArg, &nums_local, matchesMask, v);
        }

        if (nums_local.items.len == 1) return nums_local.pop();
        if (mask_len == num_bits) return mask;
    }

    unreachable;
}

fn matchesMask(n: u32, v: VarArg) bool {
    // Shift left to clear top bits
    var nn = n & ((@intCast(u32, 1) << (v.start_bit + 1)) - 1);
    // Shift right to clear low bits
    nn >>= (v.start_bit + 1 - v.mask_len);
    return nn == v.mask;
}

test "maskTest" {
    try expect(matchesMask(0b10101, .{ .mask = 0b10, .start_bit = 2, .mask_len = 2 }) == true);
    try expect(matchesMask(0b10101, .{ .mask = 0b10, .start_bit = 1, .mask_len = 2 }) == false);
    try expect(matchesMask(0b10101, .{ .mask = 0b101, .start_bit = 2, .mask_len = 3 }) == true);
    try expect(matchesMask(0b10101, .{ .mask = 0b101, .start_bit = 4, .mask_len = 3 }) == true);
    try expect(matchesMask(0b10101, .{ .mask = 0b111, .start_bit = 4, .mask_len = 3 }) == false);
}

fn mostCommonBit(nums: std.ArrayList(u32), index: i32) u1 {
    var count_ones: i32 = 0;
    var count_zeros: i32 = 0;
    var shift = @intCast(u5, index);

    for (nums.items) |n| {
        if (((n >> shift) & 1) == 1) {
            count_ones += 1;
        } else {
            count_zeros += 1;
        }
    }

    return if (count_ones >= count_zeros) 1 else 0;
}

test "mostCommonBit test" {
    var tst = std.ArrayList(u32).init(std.testing.allocator_instance.allocator());
    defer tst.deinit();
    try tst.append(1);
    try tst.append(2);
    try tst.append(3);
    try expect(mostCommonBit(tst, 1) == 1);
    try expect(mostCommonBit(tst, 0) == 1);
    try tst.append(4);
    try tst.append(6);
    try expect(mostCommonBit(tst, 0) == 0);
}
