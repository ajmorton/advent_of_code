const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay18 = struct { p1: u64, p2: u64 };

const Node = union(enum) { up, down, val: u32 };
const Num = std.ArrayList(Node);

pub fn run(alloc: std.mem.Allocator) !RetDay18 {
    const lines = try helpers.asLines(alloc, "input/day18.txt");
    defer lines.deinit();

    const p1 = try magnitudeOfSum(alloc, lines.items);

    var p2: u32 = std.math.minInt(u32);
    for (lines.items, 0..) |line1, i| {
        for (lines.items[i + 1 ..]) |line2| {
            // TODO - How to pass these in as anonymous list literals?
            // e.g. p2 = @max(p2, try magnitudeOfSum(alloc, .{line1, line2}));
            var foo: [2][]const u8 = .{ line1, line2 };
            var foo2: [2][]const u8 = .{ line2, line1 };
            p2 = @max(p2, try magnitudeOfSum(alloc, &foo));
            p2 = @max(p2, try magnitudeOfSum(alloc, &foo2));
        }
    }

    return RetDay18{ .p1 = p1, .p2 = p2 };
}

fn magnitudeOfSum(alloc: std.mem.Allocator, numbers: [][]const u8) !u32 {
    var sum: ?Num = null;
    defer sum.?.deinit();
    for (numbers) |number| {
        const num = try parseNum(alloc, number);
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
    a.deinit();
    b.deinit();
    return sum;
}

fn addRight(num: *Num, pos: u32, val: u32) void {
    for (num.items, 0..) |*node, i| {
        if (i > pos and node.* == .val) {
            node.*.val += val;
            break;
        }
    }
}

fn addLeft(num: *Num, pos: u32, val: u32) void {
    var i: i32 = @intCast(pos - 1);
    while (i >= 0) : (i -= 1) {
        const node = &num.items[@intCast(i)];
        if (node.* == .val) {
            node.*.val += val;
            return;
        }
    }
}

fn explode(num: *Num) bool {
    var depth: u32 = 0;
    for (num.items, 0..) |node, i| {
        if (node == .down) depth += 1;
        if (node == .up) depth -= 1;
        if (depth >= 5) {
            addLeft(num, @intCast(i + 1), num.items[i + 1].val);
            addRight(num, @intCast(i + 2), num.items[i + 2].val);
            num.items[i + 1] = .{ .val = 0 };
            _ = num.orderedRemove(i); // [
            _ = num.orderedRemove(@intCast(i + 1)); // second val
            _ = num.orderedRemove(@intCast(i + 1)); // ]
            return true;
        }
    }

    return false;
}

fn readSubNode(nodes: []Node, p: *u32) !u32 {
    const next_node = nodes[p.*];
    p.* += 1;
    return switch (next_node) {
        .down => try magnitude(nodes, p),
        .val => |val| val,
        else => return error.unexpectedNode,
    };
}

const MagnitudeError = error{unexpectedNode};
fn magnitude(nodes: []Node, p: *u32) MagnitudeError!u32 {
    const left = try readSubNode(nodes, p);
    if (p.* >= nodes.len - 1) return left;
    const right = try readSubNode(nodes, p);

    p.* += 1;
    return 3 * left + 2 * right;
}

fn split(num: *Num) !bool {
    for (num.items, 0..) |node, i| {
        if (node == .val and node.val >= 10) {
            const left = try std.math.divFloor(u32, node.val, 2);
            const right = try std.math.divCeil(u32, node.val, 2);
            _ = num.orderedRemove(i);
            try num.insertSlice(i, &[_]Node{ .down, .{ .val = left }, .{ .val = right }, .up });
            return true;
        }
    }
    return false;
}

fn parseNum(alloc: std.mem.Allocator, str: []const u8) !Num {
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
