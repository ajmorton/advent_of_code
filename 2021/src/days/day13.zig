const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay13 = struct { p1: u32, p2: []u8 };

const Point = struct { x: i32, y: i32 };
const Fold = union(enum) { vertical: i32, horizontal: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay13 {
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day13.txt", 1000000);
    var sections = std.mem.split(u8, allText, "\n\n");

    var points = std.AutoHashMap(Point, void).init(alloc);
    defer points.deinit();

    var point_strs = std.mem.split(u8, sections.next().?, "\n");
    while (point_strs.next()) |point_str| {
        var coords = std.mem.split(u8, point_str, ",");
        var point = Point{
            .x = try std.fmt.parseInt(i32, coords.next().?, 10),
            .y = try std.fmt.parseInt(i32, coords.next().?, 10),
        };
        try points.put(point, {});
    }

    var commands = std.ArrayList(Fold).init(alloc);
    var commands_str = std.mem.split(u8, sections.next().?, "\n");
    while (commands_str.next()) |command_str| {
        var fold_line = command_str[11..];
        if (fold_line[0] == 'x') {
            try commands.append(.{ .vertical = try std.fmt.parseInt(i32, fold_line[2..], 10) });
        } else if (fold_line[0] == 'y') {
            try commands.append(.{ .horizontal = try std.fmt.parseInt(i32, fold_line[2..], 10) });
        }
    }

    var p1: ?u32 = null;
    for (commands.items) |command| {
        switch (command) {
            .vertical => |fold_x_pos| {
                var pt_iter = points.keyIterator();
                while (pt_iter.next()) |point| {
                    if (point.x > fold_x_pos) {
                        var tmp_point = point.*;
                        tmp_point.x = (fold_x_pos) - (point.x - fold_x_pos);
                        _ = points.remove(point.*);
                        try points.put(tmp_point, {});
                    }
                }
            },
            .horizontal => |fold_y_pos| {
                var pt_iter = points.keyIterator();
                while (pt_iter.next()) |point| {
                    if (point.y > fold_y_pos) {
                        var tmp_point = point.*;
                        tmp_point.y = (fold_y_pos) - (point.y - fold_y_pos);
                        _ = points.remove(point.*);
                        try points.put(tmp_point, {});
                    }
                }
            },
        }
        p1 = p1 orelse points.count();
    }

    var min_x: i32 = std.math.maxInt(i32);
    var max_x: i32 = std.math.minInt(i32);
    var min_y: i32 = std.math.maxInt(i32);
    var max_y: i32 = std.math.minInt(i32);

    var points_iter = points.keyIterator();
    while (points_iter.next()) |point| {
        min_x = std.math.min(min_x, point.x);
        max_x = std.math.max(max_x, point.x);
        min_y = std.math.min(min_y, point.y);
        max_y = std.math.max(max_y, point.y);
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

    return RetDay13{
        .p1 = p1.?,
        .p2 = str_acc.items,
    };
}
