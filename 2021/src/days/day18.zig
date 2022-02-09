const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const helpers = @import("../helpers.zig");

pub const RetDay18 = struct { p1: u64, p2: u64 };

const Node = union(enum) { up, down, val: u32 };
const Num = std.ArrayList(Node);

pub fn run(alloc: std.mem.Allocator) !RetDay18 {
    const lines = try helpers.readInAs(alloc, "input/day18.txt", []u8);
    defer lines.deinit();

    var p1 = try magnitudeOfSum(alloc, lines.items);

    var p2: u32 = std.math.minInt(u32);
    for (lines.items) |line1, i| {
        for (lines.items[i + 1 ..]) |line2| {
            p2 = std.math.max(p2, try magnitudeOfSum(alloc, &[_][]u8{ line1, line2 }));
            p2 = std.math.max(p2, try magnitudeOfSum(alloc, &[_][]u8{ line2, line1 }));
        }
    }

    return RetDay18{ .p1 = p1, .p2 = p2 };
}

fn magnitudeOfSum(alloc: std.mem.Allocator, numbers: [][]u8) !u32 {
    var sum: ?Num = null;
    for (numbers) |number| {
        var num = try parseNum(alloc, number);
        sum = if (sum) |n| try addNums(alloc, n, num) else num;
        while (explode(&sum.?) or try split(&sum.?)) {}
    }
    var ptr: u32 = 0;
    return try magnitude(sum.?.items, &ptr);
}

fn addNums(alloc: std.mem.Allocator, a: Num, b: Num) !Num {
    var sum = Num.init(alloc);
    try sum.append(.down);
    try sum.appendSlice(a.items);
    try sum.appendSlice(b.items);
    try sum.append(.up);
    return sum;
}

fn addRight(num: *Num, pos: u32, val: u32) void {
    for (num.items) |*node, i| {
        if (i > pos and node.* == .val) {
            node.*.val += val;
            break;
        }
    }
}

fn addLeft(num: *Num, pos: u32, val: u32) void {
    var i: i32 = @intCast(i32, pos - 1);
    while (i >= 0) : (i -= 1) {
        var node = &num.items[@intCast(u32, i)];
        if (node.* == .val) {
            node.*.val += val;
            return;
        }
    }
}

fn explode(num: *Num) bool {
    var depth: u32 = 0;
    for (num.items) |node, i| {
        if (node == .down) depth += 1;
        if (node == .up) depth -= 1;
        if (depth >= 5) {
            var left = num.items[i + 1];
            var right = num.items[i + 2];
            addLeft(num, @intCast(u32, i + 1), left.val);
            addRight(num, @intCast(u32, i + 2), right.val);
            num.items[i + 1] = .{ .val = 0 };
            _ = num.orderedRemove(i); // [
            _ = num.orderedRemove(@intCast(u32, i + 1)); // second val
            _ = num.orderedRemove(@intCast(u32, i + 1)); // ]
            return true;
        }
    }

    return false;
}

fn readSubNode(nodes: []Node, p: *u32) !u32 {
    var next_node = nodes[p.*];
    p.* += 1;
    return switch (next_node) {
        .down => try magnitude(nodes, p),
        .val => |val| val,
        else => return error.unexpectedNode,
    };
}

const MagnitudeError = error{unexpectedNode};
fn magnitude(nodes: []Node, p: *u32) MagnitudeError!u32 {
    var left = try readSubNode(nodes, p);
    if (p.* >= nodes.len - 1) return left;
    var right = try readSubNode(nodes, p);

    p.* += 1;
    return 3 * left + 2 * right;
}

fn split(num: *Num) !bool {
    for (num.items) |node, i| {
        if (node == .val and node.val >= 10) {
            var left = try std.math.divFloor(u32, node.val, 2);
            var right = try std.math.divCeil(u32, node.val, 2);
            _ = num.orderedRemove(i);
            try num.insertSlice(i, &[_]Node{ .down, .{ .val = left }, .{ .val = right }, .up });
            return true;
        }
    }
    return false;
}

fn parseNum(alloc: std.mem.Allocator, str: []u8) !Num {
    var num = Num.init(alloc);
    for (str) |char| {
        switch (char) {
            '[' => try num.append(.down),
            ']' => try num.append(.up),
            '0'...'9' => try num.append(Node{ .val = char - '0' }),
            else => {},
        }
    }
    return num;
}
