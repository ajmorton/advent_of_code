const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay15 = struct { p1: u32, p2: u32 };

pub fn run(alloc: std.mem.Allocator) !RetDay15 {
    const lines = try helpers.asLines(alloc, "input/day15.txt");
    defer lines.deinit();

    var grid = try Grid.init(alloc, lines);
    defer grid.deinit();

    return RetDay15{
        .p1 = (try grid.findShortestPath(alloc, true)).?,
        .p2 = (try grid.findShortestPath(alloc, false)).?,
    };
}

const Point = struct { r: i32, c: i32 };
const Node = struct { path_cost: u32, cur_pos: Point };
const NodeQueue = std.PriorityQueue(Node, void, nodeLT);
const ExploredSet = std.AutoHashMap(Point, void);

fn nodeLT(context: void, a: Node, b: Node) std.math.Order {
    _ = context;
    return std.math.order(a.path_cost, b.path_cost);
}

// TODO -> Common code with with Days 09, 15
const Grid = struct {
    cells: std.ArrayList(u32),
    width: i32,
    height: i32,

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator, input: std.ArrayList([]const u8)) !Self {
        var width: i32 = @intCast(input.items[0].len);
        var height: i32 = 0;
        var cells = std.ArrayList(u32).init(alloc);

        for (input.items) |line| {
            for (line) |cell| try cells.append(cell - '0');
            height += 1;
        }
        return Self{ .cells = cells, .width = width, .height = height };
    }

    pub fn deinit(self: *Self) void {
        self.cells.deinit();
        self.* = undefined;
    }

    fn getCell(self: Self, r: i32, c: i32) ?u32 {
        if (r < 0 or r >= self.height or c < 0 or c >= self.width) {
            return null;
        }
        return self.cells.items[@intCast(r * self.width + c)];
    }

    fn getCell2(self: Self, r: i32, c: i32) ?u32 {
        if (r < 0 or r >= self.height * 5 or c < 0 or c >= self.width * 5) {
            return null;
        }

        var rr = @as(u32, @intCast(r)) % @as(u32, @intCast(self.height));
        var cc = @as(u32, @intCast(c)) % @as(u32, @intCast(self.width));
        var cell_orig_map = self.cells.items[rr * @as(u32, @intCast(self.height)) + cc];

        var risk_h = std.math.divFloor(i32, r, self.height) catch unreachable;
        var risk_w = std.math.divFloor(i32, c, self.width) catch unreachable;
        var cell_additional_score: u32 = @intCast(risk_h + risk_w);

        var cell_score = cell_orig_map + cell_additional_score;
        while (cell_score > 9) cell_score -= 9;

        return cell_score;
    }

    fn print(self: Self) void {
        for (self.cells.items, 0..) |cell, i| {
            if (i % @as(usize, @intCast(self.width)) == 0) {
                std.debug.print("\n", .{});
            }
            std.debug.print("{d}", .{cell});
        }
        std.debug.print("\n", .{});
    }

    fn tryNode(self: Self, p1: bool, r: i32, c: i32, cur_cost: u32, queue: *NodeQueue, explored: *ExploredSet) !void {
        var try_neighbour = if (p1) self.getCell(r, c) else self.getCell2(r, c);
        if (try_neighbour) |neigbour| {
            var new_node = Node{
                .path_cost = cur_cost + neigbour,
                .cur_pos = .{ .r = r, .c = c },
            };
            if (!explored.contains(new_node.cur_pos)) {
                try explored.put(new_node.cur_pos, {});
                try queue.add(new_node);
            }
        }
    }

    fn findShortestPath(self: Self, alloc: std.mem.Allocator, p1: bool) !?u32 {
        var start = Node{ .path_cost = 0, .cur_pos = .{ .r = 0, .c = 0 } };
        var queue = NodeQueue.init(alloc, {});
        defer queue.deinit();

        var explored = ExploredSet.init(alloc);
        defer explored.deinit();

        try queue.add(start);

        while (queue.len > 0) {
            var cur_node = queue.remove();
            var cur_pos = cur_node.cur_pos;

            if (p1 and cur_pos.r == self.height - 1 and cur_pos.c == self.height - 1) {
                return cur_node.path_cost;
            }
            if (!p1 and cur_pos.r == (self.height * 5) - 1 and cur_pos.c == (self.width * 5) - 1) {
                return cur_node.path_cost;
            }
            try self.tryNode(p1, cur_pos.r - 1, cur_pos.c, cur_node.path_cost, &queue, &explored);
            try self.tryNode(p1, cur_pos.r + 1, cur_pos.c, cur_node.path_cost, &queue, &explored);
            try self.tryNode(p1, cur_pos.r, cur_pos.c - 1, cur_node.path_cost, &queue, &explored);
            try self.tryNode(p1, cur_pos.r, cur_pos.c + 1, cur_node.path_cost, &queue, &explored);
        }

        return null;
    }
};
