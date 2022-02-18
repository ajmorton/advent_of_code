const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay10 = struct { p1: u64, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay10 {
    const lines = try helpers.readInAs(alloc, "input/day10.txt", []u8);
    defer lines.deinit();

    var incomplete_scores = std.ArrayList(u64).init(alloc);
    incomplete_scores.deinit();

    var sum: u64 = 0;
    for (lines.items) |line| {
        switch (try firstMismatch(alloc, line)) {
            .illegal => |score| sum += score,
            .incomplete => |score| try incomplete_scores.append(score),
        }
    }

    std.sort.sort(u64, incomplete_scores.items, {}, comptime std.sort.desc(u64));
    var mid = (incomplete_scores.items.len / 2);

    return RetDay10{ .p1 = sum, .p2 = incomplete_scores.items[mid] };
}

const Score = union(enum) { illegal: u64, incomplete: u64 };
fn firstMismatch(alloc: std.mem.Allocator, line: []const u8) !Score {
    var stack = std.ArrayList(u8).init(alloc);
    defer stack.deinit();

    for (line) |char| {
        switch (char) {
            '(', '[', '{', '<' => try stack.append(char),
            ')' => if (stack.pop() != '(') return Score{ .illegal = 3 },
            ']' => if (stack.pop() != '[') return Score{ .illegal = 57 },
            '}' => if (stack.pop() != '{') return Score{ .illegal = 1197 },
            '>' => if (stack.pop() != '<') return Score{ .illegal = 25137 },
            else => unreachable,
        }
    }

    var score: u64 = 0;
    while (stack.items.len > 0) {
        score *= 5;
        score += switch (stack.pop()) {
            '(' => @as(u64, 1),
            '[' => @as(u64, 2),
            '{' => @as(u64, 3),
            '<' => @as(u64, 4),
            else => unreachable,
        };
    }

    return Score{ .incomplete = score };
}
