const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay5 = struct { p1: u32, p2: u32 };

pub fn run(alloc: std.mem.Allocator) !RetDay5 {
    const lines = try helpers.asLines(alloc, "input/day05.txt");
    defer lines.deinit();

    var pipes = try helpers.mapArrayList(alloc, []const u8, Pipe, lines, parsePipe);
    defer pipes.deinit();

    var ret: RetDay5 = .{ .p1 = 0, .p2 = 0 };

    var grid = Grid.init(alloc);
    defer grid.deinit();

    for (pipes.items) |pipe| {
        if (pipe.direction != Direction.Diagonal) try grid.layPipe(pipe);
    }
    ret.p1 = grid.countIntersections();

    for (pipes.items) |pipe| {
        if (pipe.direction == Direction.Diagonal) try grid.layPipe(pipe);
    }
    ret.p2 = grid.countIntersections();

    return ret;
}

fn parsePoint(str: []const u8) helpers.ConversionError!Point {
    var coords = std.mem.split(u8, str, ",");
    var x = std.fmt.parseInt(i32, coords.next().?, 10) catch {
        return helpers.ConversionError.ConvFailed;
    };
    var y = std.fmt.parseInt(i32, coords.next().?, 10) catch {
        return helpers.ConversionError.ConvFailed;
    };
    return Point{ .x = x, .y = y };
}

fn parsePipe(str: []const u8) helpers.ConversionError!Pipe {
    var points = std.mem.split(u8, str, " -> ");
    var start = try parsePoint(points.next().?);
    var end = try parsePoint(points.next().?);
    var dir = Direction.Vertical; // TODO - How to write multibranch if expressions
    if (start.x == end.x) {
        dir = Direction.Vertical;
    } else if (start.y == end.y) {
        dir = Direction.Horizontal;
    } else {
        dir = Direction.Diagonal;
    }

    return Pipe{ .direction = dir, .start = start, .end = end };
}

const Point = struct { x: i32, y: i32 };
const Direction = enum { Vertical, Horizontal, Diagonal };
const Pipe = struct { direction: Direction, start: Point, end: Point };

const Grid = struct {
    cells: helpers.Counter(Point),
    const Self = @This();

    fn init(alloc: std.mem.Allocator) Self {
        return .{ .cells = helpers.Counter(Point).init(alloc) };
    }

    fn deinit(self: *Self) void {
        self.cells.deinit();
        self.* = undefined;
    }

    fn gradient(start: i32, end: i32) i32 {
        if (start < end) return 1;
        if (start == end) return 0;
        return -1;
    }

    fn layPipe(self: *Self, pipe: Pipe) !void {
        var x = pipe.start.x;
        var y = pipe.start.y;

        var x_dir = gradient(pipe.start.x, pipe.end.x);
        var y_dir = gradient(pipe.start.y, pipe.end.y);

        while (x != pipe.end.x or y != pipe.end.y) {
            try self.cells.incr(.{ .x = x, .y = y });
            x += x_dir;
            y += y_dir;
        }

        // one last time at destination
        try self.cells.incr(.{ .x = x, .y = y });
    }

    fn countIntersections(self: Self) u32 {
        var count: u32 = 0;
        var vals = self.cells.valueIterator();
        while (vals.next()) |val| {
            if (val.* > 1) count += 1;
        }
        return count;
    }
};
