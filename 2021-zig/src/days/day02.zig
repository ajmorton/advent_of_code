const expect = @import("std").testing.expect;
const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay2 = struct { p1: u32, p2: u32 };

const Direction = enum { up, down, forward };
const Move = struct { dir: Direction, dist: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay2 {
    var lines = try helpers.asLines(alloc, "input/day02.txt");
    defer lines.deinit();
    return try solve(lines.items);
}

fn solve(lines: [][]const u8) !RetDay2 {
    var vert: i32 = 0;
    var vert2: i32 = 0;
    var hor: i32 = 0;

    for (lines) |line| {
        const move = try parseMove(line);
        switch (move.dir) {
            Direction.up => vert += move.dist,
            Direction.down => vert -= move.dist,
            Direction.forward => {
                hor += move.dist;
                vert2 += move.dist * -vert;
            },
        }
    }

    return RetDay2{
        .p1 = @abs(vert * hor),
        .p2 = @abs(vert2 * hor),
    };
}

fn parseMove(str: []const u8) !Move {
    var split = std.mem.tokenize(u8, str, " ");
    return Move{
        .dir = std.meta.stringToEnum(Direction, split.next().?).?,
        .dist = try std.fmt.parseInt(i32, split.rest(), 10),
    };
}

test "Examples Day 2" {
    var lines = [_][]const u8{ "forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2" };
    const res = try solve(&lines);
    try expect(res.p1 == 150);
    try expect(res.p2 == 900);
}
