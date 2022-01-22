// TODO - This code is bad. Clean up later

const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Vector = std.meta.Vector;

const helpers = @import("../helpers.zig");

pub const RetDay3 = struct { p1: u32, p2: u32 };

fn parseBin(str: []u8) helpers.ConversionError!u32 {
    return std.fmt.parseInt(u32, str, 2) catch helpers.ConversionError.ConvFailed;
}

pub fn run(alloc: std.mem.Allocator) !RetDay3 {
    const lines = try helpers.readInAs(alloc, "input/day03.txt", []u8);
    defer lines.deinit();

    const num_bits: i32 = @intCast(i32, lines.items[0].len);

    var nums = try helpers.mapArrayList(alloc, []u8, u32, lines, parseBin);
    defer nums.deinit();

    return RetDay3{
        .p1 = try part1(nums, num_bits),
        .p2 = try part2(nums, num_bits),
    };
}

fn oxGen(mcb: u1) u1 {
    return mcb;
}

fn c02Scrub(mcb: u1) u1 {
    return ~mcb;
}

fn part1(nums: std.ArrayList(u32), num_bits: i32) !u32 {
    const oxygenRating = try getRating(nums, num_bits, oxGen, false);
    const c02Rating = try getRating(nums, num_bits, c02Scrub, false);
    return oxygenRating * c02Rating;
}

fn part2(nums: std.ArrayList(u32), num_bits: i32) !u32 {
    const oxygenRating = try getRating(nums, num_bits, oxGen, true);
    const c02Rating = try getRating(nums, num_bits, c02Scrub, true);
    return oxygenRating * c02Rating;
}

fn getRating(nums: std.ArrayList(u32), num_bits: i32, bitCriterion: fn (u1) u1, runningFilter: bool) !u32 {
    var index: i32 = num_bits - 1;

    var mask_len: u5 = 0;
    var mask: u32 = 0;

    short_circuit = null;

    while (index >= 0) : (index -= 1) {
        var most_common_bit = if (runningFilter) mostCommonBit(nums, index, mask, mask_len) else mostCommonBit(nums, index, null, 0);

        if (short_circuit) |sc| {
            return sc;
        }

        mask <<= 1;
        mask += bitCriterion(most_common_bit);
        mask_len += 1;
    }

    return mask;
}

fn matchesMask(n: u32, mask: u32, start_bit: u5, mask_len: u5) bool {

    // TODO -> Generics, extract mask len from type?

    // stdout.print("\t\tn {}, mask {}, start_bit {}, mask_len {}\n", .{n, mask, start_bit, mask_len}) catch {};

    // clear top bits
    // stdout.print("orig: {b}\n", .{n}) catch {};
    var nn = n & ((@intCast(u32, 1) << (start_bit + 1)) - 1);
    // stdout.print("clear top: {b}\n", .{nn}) catch {};
    // shift to clear low bits
    nn >>= (start_bit + 1 - mask_len);
    // stdout.print("shift bot: {b}\n", .{nn}) catch {};
    // stdout.print("mask = {b}\n", .{mask}) catch {};
    return nn == mask;
}

test "maskTest" {
    try expect(matchesMask(0b10101, 0b10, 2, 2) == true);
    try expect(matchesMask(0b10101, 0b10, 1, 2) == false);
    try expect(matchesMask(0b10101, 0b101, 2, 3) == true);
    try expect(matchesMask(0b10101, 0b101, 4, 3) == true);
    try expect(matchesMask(0b10101, 0b111, 4, 3) == false);
}

var short_circuit: ?u32 = null;

fn mostCommonBit(nums: std.ArrayList(u32), index: i32, opt_mask: ?u32, mask_len: u5) u1 {
    var total_nums = nums.items.len;
    var count_ones: i32 = 0;
    var count_zeros: i32 = 0;
    var shift = @intCast(u5, index);

    var last_tried: u32 = 0;

    if (opt_mask) |mask| {
        stdout.print("mask {b:>6}\n", .{mask}) catch {};
    }

    for (nums.items) |n| {
        if (opt_mask) |mask| {
            if (!matchesMask(@intCast(u32, n), @intCast(u32, mask), 11, mask_len)) {
                total_nums -= 1;
                continue;
            }
        }

        stdout.print("\ttrying    {b:>6}\n", .{n}) catch {};
        last_tried = n;
        if (((n >> shift) & 1) == 1) {
            count_ones += 1;
        } else {
            count_zeros += 1;
        }
    }

    const mcb: u1 = if (count_ones >= count_zeros) 1 else 0;
    stdout.print("count_ones = {}, total_nums = {}, mcb = {}", .{ count_ones, total_nums, mcb }) catch {};
    stdout.print("\n\n\n", .{}) catch {};

    if (total_nums == 1) {
        short_circuit = last_tried;
    }

    return mcb;
}

test "mostCommonBit test" {
    var tst = std.ArrayList(u32).init(std.testing.allocator_instance.allocator());
    defer tst.deinit();
    try tst.append(1);
    try tst.append(2);
    try tst.append(3);
    try expect(mostCommonBit(tst, 1, null, 0) == 1);
    try expect(mostCommonBit(tst, 0, null, 0) == 1);
    try tst.append(4);
    try tst.append(6);
    try expect(mostCommonBit(tst, 0, null, 0) == 0);
}
