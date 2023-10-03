const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay25 = struct { p1: u32, p2: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay25 {
    const lines = try helpers.asLines(alloc, "input/day25.txt");
    defer lines.deinit();

    var grid = try Grid.init(alloc, lines);
    defer grid.deinit();

    var step: u32 = 1;
    while (try grid.step(alloc)) step += 1;

    return RetDay25{ .p1 = step, .p2 = 0 };
}

const Pos = struct { r: i32, c: i32 };
const Cuke = enum { none, down, right };

const Grid = struct {
    cells: std.ArrayList(Cuke),
    width: u32,
    height: u32,

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator, input: std.ArrayList([]const u8)) !Self {
        var width: u32 = @intCast(input.items[0].len);
        var height: u32 = 0;
        var cells = std.ArrayList(Cuke).init(alloc);

        for (input.items) |line| {
            for (line) |cell| {
                try cells.append(switch (cell) {
                    '.' => .none,
                    '>' => .right,
                    'v' => .down,
                    else => unreachable,
                });
            }
            height += 1;
        }
        return Self{ .cells = cells, .width = width, .height = height };
    }

    pub fn deinit(self: *Self) void {
        self.cells.deinit();
        self.* = undefined;
    }

    fn updateDir(self: *Self, alloc: std.mem.Allocator, dir: Cuke) !bool {
        var cuke_moved = false;

        var next_grid = std.ArrayList(Cuke).init(alloc);
        try next_grid.appendSlice(self.cells.items);

        for (self.cells.items, 0..) |cuke, i| {
            if (cuke != dir) continue;
            var r: usize = @divFloor(i, self.width);
            var c: usize = @mod(i, self.width);
            var next_r: usize = if (dir == .down) @mod(r + 1, self.height) else r;
            var next_c: usize = if (dir == .right) @mod(c + 1, self.width) else c;

            if (self.cells.items[(next_r * self.width) + next_c] == .none) {
                next_grid.items[(r * self.width) + c] = .none;
                next_grid.items[(next_r * self.width) + next_c] = dir;
                cuke_moved = true;
            }
        }

        self.cells.deinit();
        self.cells = next_grid;
        return cuke_moved;
    }

    fn step(self: *Self, alloc: std.mem.Allocator) !bool {
        var cuke_moved = false;
        cuke_moved = (try self.updateDir(alloc, .right)) or cuke_moved;
        cuke_moved = (try self.updateDir(alloc, .down)) or cuke_moved;
        return cuke_moved;
    }
};
