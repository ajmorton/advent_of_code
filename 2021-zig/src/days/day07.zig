const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay7 = struct { p1: u64, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay7 {
    var crabsAtPos = try getCrabsList(alloc);
    defer crabsAtPos.deinit();

    return RetDay7{
        .p1 = findBestPos(crabsAtPos, true),
        .p2 = findBestPos(crabsAtPos, false),
    };
}

fn getCrabsList(alloc: std.mem.Allocator) !helpers.Counter(u32) {
    var crabsAtPos = helpers.Counter(u32).init(alloc);
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day07.txt", 1000000);
    defer alloc.free(allText);
    var nums_iter = std.mem.tokenize(u8, allText, ",\n");

    while (nums_iter.next()) |num_str| {
        const num = try std.fmt.parseInt(u32, num_str, 10);
        try crabsAtPos.incr(num);
    }

    return crabsAtPos;
}

fn findBestPos(crabsAtPos: helpers.Counter(u32), part1: bool) u64 {
    var min_pos: u32 = std.math.maxInt(u32);
    var max_pos: u32 = 0;

    var posIter = crabsAtPos.keyIterator();
    while (posIter.next()) |pos| {
        min_pos = @min(pos.*, min_pos);
        max_pos = @max(pos.*, max_pos);
    }

    var min_cost: u64 = std.math.maxInt(u64);
    var try_pos: u32 = min_pos;
    while (try_pos <= max_pos) : (try_pos += 1) {
        var move_cost: u64 = 0;
        var crabs_iter = crabsAtPos.iterator();
        while (crabs_iter.next()) |kv| {
            var dist: u32 = if (kv.key_ptr.* > try_pos) kv.key_ptr.* - try_pos else try_pos - kv.key_ptr.*;

            var fuel_cost: u32 = if (part1) dist else (dist * (dist + 1)) / 2;
            var num_crabs: u64 = kv.value_ptr.*;
            move_cost += num_crabs * fuel_cost;
        }
        min_cost = @min(min_cost, move_cost);
    }
    return min_cost;
}
