const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay8 = struct { p1: u64, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay8 {
    const lines = try helpers.asLines(alloc, "input/day08.txt");
    defer lines.deinit();

    var num_knowns: u32 = 0;
    var p2: u32 = 0;
    for (lines.items) |line| {
        // TODO - scanf function
        var inOut = std.mem.split(u8, line, " | ");
        var in = inOut.next().?;
        var out = inOut.next().?;

        var out_nums = std.mem.split(u8, out, " ");
        while (out_nums.next()) |num| {
            var num_len = std.mem.len(num);
            switch (num_len) {
                2, 3, 4, 7 => num_knowns += 1,
                else => {},
            }
        }

        var segs_to_nums = try determineSegs(alloc, in);
        defer segs_to_nums.deinit();

        var outNum: u32 = 0;
        out_nums = std.mem.split(u8, out, " ");
        while (out_nums.next()) |num_str| {
            outNum *= 10;
            outNum += segs_to_nums.get(createSevenSeg(num_str)).?;
        }
        p2 += outNum;
    }

    return RetDay8{ .p1 = num_knowns, .p2 = p2 };
}

fn determineSegs(alloc: std.mem.Allocator, str: []const u8) !std.AutoHashMap(SevenSeg, u32) {
    var map = std.AutoHashMap(SevenSeg, u32).init(alloc);

    var knownNums = std.mem.zeroes([10]SevenSeg);
    var seg_strs = std.mem.split(u8, str, " ");

    var len_fives = std.ArrayList(SevenSeg).init(alloc);
    defer len_fives.deinit();

    var len_sixes = std.ArrayList(SevenSeg).init(alloc);
    defer len_sixes.deinit();

    while (seg_strs.next()) |seg_str| {
        var seven_seg = createSevenSeg(seg_str);

        switch (@popCount(SevenSeg, seven_seg)) {
            2 => knownNums[1] = seven_seg,
            3 => knownNums[7] = seven_seg,
            4 => knownNums[4] = seven_seg,
            5 => try len_fives.append(seven_seg),
            6 => try len_sixes.append(seven_seg),
            7 => knownNums[8] = seven_seg,
            else => {},
        }
    }

    // 6 is the only SevenSeg with 6 arms set not masked by 1
    var i: u32 = 0;
    while (i < len_sixes.items.len) : (i += 1) {
        if (!canMask(knownNums[1], len_sixes.items[i])) {
            knownNums[6] = len_sixes.swapRemove(i);
            break;
        }
    }

    // 9 is the only SevenSeg with 6 arms and masked by 4
    i = 0;
    while (i < len_sixes.items.len) : (i += 1) {
        if (canMask(knownNums[4], len_sixes.items[i])) {
            knownNums[9] = len_sixes.swapRemove(i);
            break;
        }
    }

    // 0 is the last SevenSeg with 6 arms
    knownNums[0] = len_sixes.pop();

    // 2 is the only SevenSeg with 5 arms that 9 is not masked by
    i = 0;
    while (i < len_fives.items.len) : (i += 1) {
        if (!canMask(len_fives.items[i], knownNums[9])) {
            knownNums[2] = len_fives.swapRemove(i);
            break;
        }
    }

    // 3 is the only SevenSeg with 5 arms and masked by 1
    i = 0;
    while (i < len_fives.items.len) : (i += 1) {
        if (canMask(knownNums[1], len_fives.items[i])) {
            knownNums[3] = len_fives.swapRemove(i);
            break;
        }
    }

    // 5 is the last SevenSeg with 5 arms
    knownNums[5] = len_fives.pop();

    i = 0;
    while (i <= 9) : (i += 1) try map.put(knownNums[i], i);

    return map;
}

const SevenSeg = u7;
fn createSevenSeg(str: []const u8) SevenSeg {
    var seven_seg: SevenSeg = 0;
    for (str) |arm| {
        seven_seg |= @as(SevenSeg, 1) << @intCast(u3, arm - 'a');
    }
    return seven_seg;
}

fn canMask(mask: SevenSeg, target: SevenSeg) bool {
    return (mask & target) == mask;
}
