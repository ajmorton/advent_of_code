const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay9 = struct { p1: i32, p2: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay9 {
    const lines = try helpers.readInAs(alloc, "input/day09.txt", []u8);
    defer lines.deinit();

    var grid = try Grid.init(alloc, lines);
    defer grid.deinit();

    return RetDay9{ .p1 = grid.scoreLowestPoints(), .p2 = try grid.findBasins(alloc) };
}

const Pos = struct { r: i32, c: i32 };
const Cell = struct { val: i32, explored: bool };

const Grid = struct {
    cells: std.ArrayList(Cell),
    width: i32,
    height: i32,

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator, input: std.ArrayList([]u8)) !Self {
        var width: i32 = @intCast(i32, input.items[0].len);
        var height: i32 = 0;
        var cells = std.ArrayList(Cell).init(alloc);

        for (input.items) |line| {
            for (line) |cell| {
                try cells.append(.{ .val = cell - '0', .explored = false });
            }
            height += 1;
        }
        return Self{ .cells = cells, .width = width, .height = height };
    }

    pub fn deinit(self: *Self) void {
        self.cells.deinit();
        self.* = undefined;
    }

    fn getCell(self: Self, r: i32, c: i32) ?*Cell {
        if (r < 0 or r >= self.height or c < 0 or c >= self.width) {
            return null;
        }
        return &self.cells.items[@intCast(u32, r * self.width + c)];
    }

    fn isLowestPoint(self: Self, r: i32, c: i32) bool {
        var cell = self.getCell(r, c).?;
        var lowest = true;
        lowest = lowest and if (self.getCell(r, c - 1)) |left| cell.val < left.val else true;
        lowest = lowest and if (self.getCell(r, c + 1)) |right| cell.val < right.val else true;
        lowest = lowest and if (self.getCell(r - 1, c)) |up| cell.val < up.val else true;
        lowest = lowest and if (self.getCell(r + 1, c)) |down| cell.val < down.val else true;
        return lowest;
    }

    fn tryNext(self: Self, r: i32, c: i32, explore_queue: *std.ArrayList(Pos)) !void {
        if (self.getCell(r, c)) |next| {
            if (next.explored == false) {
                try explore_queue.append(.{ .r = r, .c = c });
            }
        }
    }

    fn basinSize(self: *Self, alloc: std.mem.Allocator, r: i32, c: i32) !i32 {
        var explore_queue = std.ArrayList(Pos).init(alloc);
        defer explore_queue.deinit();
        var explored_cells: i32 = 0;

        try explore_queue.append(Pos{ .r = r, .c = c });

        while (explore_queue.items.len > 0) {
            var next = explore_queue.orderedRemove(0);

            var next_cell = self.getCell(next.r, next.c).?;
            if (next_cell.explored == false and next_cell.val != 9) {
                explored_cells += 1;
                next_cell.explored = true;

                try self.tryNext(next.r - 1, next.c, &explore_queue);
                try self.tryNext(next.r + 1, next.c, &explore_queue);
                try self.tryNext(next.r, next.c - 1, &explore_queue);
                try self.tryNext(next.r, next.c + 1, &explore_queue);
            }
        }

        return explored_cells;
    }

    pub fn findBasins(self: *Self, alloc: std.mem.Allocator) !i32 {
        var basin_sizes = std.ArrayList(i32).init(alloc);
        defer basin_sizes.deinit();

        var r: i32 = 0;
        while (r < self.height) : (r += 1) {
            var c: i32 = 0;
            while (c < self.width) : (c += 1) {
                if (self.isLowestPoint(r, c)) {
                    try basin_sizes.append(try self.basinSize(alloc, r, c));
                }
            }
        }

        std.sort.sort(i32, basin_sizes.items, {}, comptime std.sort.desc(i32));
        var prod: i32 = 1;
        for (basin_sizes.items[0..3]) |size| prod *= size;

        return prod;
    }

    pub fn scoreLowestPoints(self: Self) i32 {
        var score: i32 = 0;
        var r: i32 = 0;
        while (r < self.height) : (r += 1) {
            var c: i32 = 0;
            while (c < self.width) : (c += 1) {
                if (self.isLowestPoint(r, c)) {
                    score += self.getCell(r, c).?.val + 1;
                }
            }
        }

        return score;
    }
};
