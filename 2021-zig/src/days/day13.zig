const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay13 = struct { p1: u32, p2: std.ArrayList(u8) };

const Point = struct { x: i32, y: i32 };
const Fold = union(enum) { vertical: i32, horizontal: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay13 {
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day13.txt", 1000000);
    defer alloc.free(allText);
    var sections = std.mem.splitSequence(u8, allText, "\n\n");

    var points = std.AutoHashMap(Point, void).init(alloc);
    defer points.deinit();

    var point_strs = std.mem.splitScalar(u8, sections.next().?, '\n');
    while (point_strs.next()) |point_str| {
        var coords = std.mem.splitScalar(u8, point_str, ',');
        try points.put(Point{
            .x = try std.fmt.parseInt(i32, coords.next().?, 10),
            .y = try std.fmt.parseInt(i32, coords.next().?, 10),
        }, {});
    }

    var commands = std.ArrayList(Fold).init(alloc);
    defer commands.deinit();
    var commands_str = std.mem.tokenize(u8, sections.next().?, "\n");
    while (commands_str.next()) |command_str| {
        try commands.append(switch (command_str[11]) {
            'x' => .{ .vertical = try std.fmt.parseInt(i32, command_str[13..], 10) },
            'y' => .{ .horizontal = try std.fmt.parseInt(i32, command_str[13..], 10) },
            else => unreachable,
        });
    }

    var p1: ?u32 = null;
    for (commands.items) |command| {
        var pt_iter = points.keyIterator();
        while (pt_iter.next()) |point| {
            switch (command) {
                .vertical => |fold_x_pos| {
                    if (point.x > fold_x_pos) {
                        try points.put(Point{ .x = 2 * fold_x_pos - point.x, .y = point.y }, {});
                        _ = points.remove(point.*);
                    }
                },
                .horizontal => |fold_y_pos| {
                    if (point.y > fold_y_pos) {
                        try points.put(Point{ .x = point.x, .y = 2 * fold_y_pos - point.y }, {});
                        _ = points.remove(point.*);
                    }
                },
            }
        }
        p1 = p1 orelse points.count();
    }

    var min_x: i32 = std.math.maxInt(i32);
    var max_x: i32 = std.math.minInt(i32);
    var min_y: i32 = std.math.maxInt(i32);
    var max_y: i32 = std.math.minInt(i32);

    var points_iter = points.keyIterator();
    while (points_iter.next()) |point| {
        min_x = @min(min_x, point.x);
        max_x = @max(max_x, point.x);
        min_y = @min(min_y, point.y);
        max_y = @max(max_y, point.y);
    }

    var str_acc = std.ArrayList(u8).init(alloc);

    var y: i32 = min_y;
    while (y <= max_y) : (y += 1) {
        var x: i32 = min_x;
        while (x <= max_x) : (x += 1) {
            var point = .{ .x = x, .y = y };
            try str_acc.append(if (points.contains(point)) '#' else ' ');
        }
        try str_acc.append('\n');
    }

    return RetDay13{ .p1 = p1.?, .p2 = str_acc };
}
