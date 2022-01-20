const expect = @import("std").testing.expect;
const std = @import("std");

const helpers = @import("../helpers.zig");

pub const RetDay1 = struct { p1: u32, p2: u32 };

pub fn run(alloc: std.mem.Allocator) !RetDay1 {
    const depths = try helpers.readInAs(alloc, "input/day01.txt", u32);
    defer depths.deinit();

    return RetDay1{
        .p1 = decreasing(depths.items, 1),
        .p2 = decreasing(depths.items, 3),
    };
}

/// Count the number of times `depths[n]` is shallower than `depths[n + lookahead]`
fn decreasing(depths: []u32, lookahead: u32) u32 {
    var sum: u32 = 0;
    var i: u32 = 0;
    while (i < depths.len - lookahead) : (i += 1) {
        if (depths[i] < depths[i + lookahead]) {
            sum += 1;
        }
    }
    return sum;
}

test "Examples day 1" {
    var depths = [_]u32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    try expect(decreasing(&depths, 1) == 7);
    try expect(decreasing(&depths, 3) == 5);
}
