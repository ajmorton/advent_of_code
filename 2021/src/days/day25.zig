const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay25 = struct { p1: u32, p2: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay25 {
    const lines = try helpers.readInAs(alloc, "input/day25.txt", []u8);
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
    width: i32,
    height: i32,

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator, input: std.ArrayList([]u8)) !Self {
        var width: i32 = @intCast(i32, input.items[0].len);
        var height: i32 = 0;
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

    fn getCell(self: Self, r: i32, c: i32) ?*Cuke {
        if (r < 0 or r >= self.height or c < 0 or c >= self.width) {
            return null;
        }
        return &self.cells.items[@intCast(u32, r * self.width + c)];
    }

    fn updateDir(self: *Self, alloc: std.mem.Allocator, dir: Cuke) !bool {
        var cuke_moved = false;

        var next_grid = std.ArrayList(Cuke).init(alloc);
        try next_grid.appendSlice(self.cells.items);

        for (self.cells.items) |cuke, i| {
            if (cuke != dir) continue;
            var r: usize = @divFloor(i, @intCast(u32, self.width));
            var c: usize = @mod(i, @intCast(u32, self.width));
            var next_r: usize = if (dir == .down) @mod(r + 1, @intCast(u32, self.height)) else r;
            var next_c: usize = if (dir == .right) @mod(c + 1, @intCast(u32, self.width)) else c;

            if (self.cells.items[(next_r * @intCast(u32, self.width)) + next_c] == .none) {
                next_grid.items[(r * @intCast(u32, self.width)) + c] = .none;
                next_grid.items[(next_r * @intCast(u32, self.width)) + next_c] = dir;
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
