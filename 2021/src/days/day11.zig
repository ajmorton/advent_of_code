const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const helpers = @import("../helpers.zig");

pub const RetDay11 = struct { p1: i32, p2: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay11 {
    const lines = try helpers.readInAs(alloc, "input/day11.txt", []u8);
    defer lines.deinit();

    var grid = try Grid.init(alloc, lines);
    defer grid.deinit();

    var res = RetDay11{ .p1 = 0, .p2 = 0 };

    var total_flashes: i32 = 0;
    var all_flashed = false;

    var step: i32 = 1;
    while (step <= 100 or !all_flashed) : (step += 1) {
        var new_flashes = grid.step();
        total_flashes += new_flashes;

        if (step == 100) {
            res.p1 = total_flashes;
        }
        if (new_flashes == 100) {
            res.p2 = step;
            all_flashed = true;
        }
    }

    return res;
}

const Octopus = struct { charge: i32, has_flashed: bool };

// TODO -> Common code with with Day 09
const Grid = struct {
    cells: std.ArrayList(Octopus),
    width: i32,
    height: i32,

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator, input: std.ArrayList([]u8)) !Self {
        var width: i32 = @intCast(i32, input.items[0].len);
        var height: i32 = 0;
        var cells = std.ArrayList(Octopus).init(alloc);

        for (input.items) |line| {
            for (line) |cell| {
                try cells.append(.{ .charge = cell - '0', .has_flashed = false });
            }
            height += 1;
        }
        return Self{ .cells = cells, .width = width, .height = height };
    }

    pub fn deinit(self: *Self) void {
        self.cells.deinit();
        self.* = undefined;
    }

    fn getCell(self: Self, r: i32, c: i32) ?*Octopus {
        if (r < 0 or r >= self.height or c < 0 or c >= self.width) {
            return null;
        }
        return &self.cells.items[@intCast(u32, r * self.width + c)];
    }

    fn print(self: Self) void {
        for (self.cells.items) |octopus, i| {
            if (i % @intCast(usize, self.width) == 0) {
                std.debug.print("\n", .{});
            }
            std.debug.print("{d}", .{octopus.charge});
        }
        std.debug.print("\n", .{});
    }

    fn incrNeigbours(self: *Self, r: i32, c: i32) void {
        for ([_]i32{ -1, 0, 1 }) |rr| {
            for ([_]i32{ -1, 0, 1 }) |cc| {
                if (rr == 0 and cc == 0) {
                    continue;
                }
                if (self.getCell(r + rr, c + cc)) |neighbour| {
                    if (!neighbour.has_flashed) {
                        neighbour.charge += 1;
                    }
                }
            }
        }
    }

    fn step(self: *Self) i32 {
        for (self.cells.items) |*octopus| {
            octopus.has_flashed = false;
            octopus.charge += 1;
        }

        var flashes: i32 = 0;
        var complete = false;
        while (!complete) {
            complete = true;
            var r: i32 = 0;
            while (r < self.height) : (r += 1) {
                var c: i32 = 0;
                while (c < self.width) : (c += 1) {
                    var octopus = self.getCell(r, c).?;
                    if (octopus.charge > 9 and !octopus.has_flashed) {
                        flashes += 1;
                        octopus.has_flashed = true;
                        octopus.charge = 0;
                        complete = false;

                        self.incrNeigbours(r, c);
                    }
                }
            }
        }

        return flashes;
    }
};
