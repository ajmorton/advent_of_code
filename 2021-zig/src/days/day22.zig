const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay22 = struct { p1: u64, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay22 {
    const lines = try helpers.asLines(alloc, "input/day22.txt");
    defer lines.deinit();

    var box_list = BoxList.init(alloc);
    defer box_list.deinit();

    for (lines.items) |line| {
        const box = try parseBox(line);
        try apply(alloc, box, &box_list);
    }

    var p1: u64 = 0;
    var p2: u64 = 0;
    for (box_list.items) |box| {
        p1 += box.count(true);
        p2 += box.count(false);
    }

    return RetDay22{ .p1 = p1, .p2 = p2 };
}

fn parseBox(line: []const u8) !Box {
    var split = std.mem.splitScalar(u8, line, ' ');
    const on_off = std.mem.eql(u8, split.next().?, "on");

    const coords = split.next().?;

    var coord_split = std.mem.splitScalar(u8, coords, ',');
    var x_range = coord_split.next().?;
    var x_min_max = std.mem.splitSequence(u8, x_range[2..], "..");
    const x_min = try std.fmt.parseInt(i32, x_min_max.next().?, 10);
    const x_max = try std.fmt.parseInt(i32, x_min_max.next().?, 10);

    var y_range = coord_split.next().?;
    var y_min_max = std.mem.splitSequence(u8, y_range[2..], "..");
    const y_min = try std.fmt.parseInt(i32, y_min_max.next().?, 10);
    const y_max = try std.fmt.parseInt(i32, y_min_max.next().?, 10);

    var z_range = coord_split.next().?;
    var z_min_max = std.mem.splitSequence(u8, z_range[2..], "..");
    const z_min = try std.fmt.parseInt(i32, z_min_max.next().?, 10);
    const z_max = try std.fmt.parseInt(i32, z_min_max.next().?, 10);

    return Box.init(on_off, x_min, x_max, y_min, y_max, z_min, z_max);
}

const Relation = union(enum) { engulfs, engulfed, independent, overlaps: Box };

const Box = struct {
    on: bool,
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,
    min_z: i32,
    max_z: i32,
    const Self = @This();

    fn init(on: bool, min_x: i32, max_x: i32, min_y: i32, max_y: i32, min_z: i32, max_z: i32) Self {
        return Self{ .on = on, .min_x = min_x, .max_x = max_x, .min_y = min_y, .max_y = max_y, .min_z = min_z, .max_z = max_z };
    }

    fn compare(self: Self, other: Self) Relation {
        const x_overlap = axisOverlap(self.min_x, self.max_x, other.min_x, other.max_x);
        const y_overlap = axisOverlap(self.min_y, self.max_y, other.min_y, other.max_y);
        const z_overlap = axisOverlap(self.min_z, self.max_z, other.min_z, other.max_z);

        if (x_overlap == null or y_overlap == null or z_overlap == null) {
            return .independent;
        }

        const overlap = Box.init(
            self.on,
            x_overlap.?.min,
            x_overlap.?.max,
            y_overlap.?.min,
            y_overlap.?.max,
            z_overlap.?.min,
            z_overlap.?.max,
        );

        if (std.meta.eql(other, overlap)) return .engulfs;
        if (std.meta.eql(self, overlap)) return .engulfed;

        return .{ .overlaps = overlap };
    }

    fn split(self: *Self, alloc: std.mem.Allocator, intersection: Box) !BoxList {
        var new_boxes = std.ArrayList(Box).init(alloc);

        if (self.max_z > intersection.max_z) {
            var above = self.*;
            above.min_z = intersection.max_z + 1;
            self.max_z = intersection.max_z;
            try new_boxes.append(above);
        }

        if (self.min_z < intersection.min_z) {
            var below = self.*;
            below.max_z = intersection.min_z - 1;
            self.min_z = intersection.min_z;
            try new_boxes.append(below);
        }

        if (self.max_x > intersection.max_x) {
            var left = self.*;
            left.min_x = intersection.max_x + 1;
            self.max_x = intersection.max_x;
            try new_boxes.append(left);
        }

        if (self.min_x < intersection.min_x) {
            var right = self.*;
            right.max_x = intersection.min_x - 1;
            self.min_x = intersection.min_x;
            try new_boxes.append(right);
        }

        if (self.max_y > intersection.max_y) {
            var back = self.*;
            back.min_y = intersection.max_y + 1;
            self.max_y = intersection.max_y;
            try new_boxes.append(back);
        }

        if (self.min_y < intersection.min_y) {
            var front = self.*;
            front.max_y = intersection.min_y - 1;
            self.min_y = intersection.min_y;
            try new_boxes.append(front);
        }

        return new_boxes;
    }

    fn count(self: Self, only_init_area: bool) u64 {
        if (only_init_area) {
            const init_area = Box.init(false, -50, 50, -50, 50, -50, 50);
            if (self.compare(init_area) == .independent) {
                return 0;
            } else {
                const min_x = @max(init_area.min_x, self.min_x);
                const max_x = @min(init_area.max_x, self.max_x);
                const min_y = @max(init_area.min_y, self.min_y);
                const max_y = @min(init_area.max_y, self.max_y);
                const min_z = @max(init_area.min_z, self.min_z);
                const max_z = @min(init_area.max_z, self.max_z);

                const len_x: u64 = @intCast(max_x - min_x + 1);
                const len_y: u64 = @intCast(max_y - min_y + 1);
                const len_z: u64 = @intCast(max_z - min_z + 1);
                return len_x * len_y * len_z;
            }
        }

        const len_x: u64 = @intCast(self.max_x - self.min_x + 1);
        const len_y: u64 = @intCast(self.max_y - self.min_y + 1);
        const len_z: u64 = @intCast(self.max_z - self.min_z + 1);
        return len_x * len_y * len_z;
    }
};

const Overlap = struct { min: i32, max: i32 };
fn axisOverlap(a_min: i32, a_max: i32, b_min: i32, b_max: i32) ?Overlap {
    if (a_min > b_max or a_max < b_min) {
        return null;
    }

    return Overlap{ .min = @max(a_min, b_min), .max = @min(a_max, b_max) };
}

const BoxList = std.ArrayList(Box);
fn apply(alloc: std.mem.Allocator, box: Box, existing_boxes: *BoxList) !void {
    var new_box = box;

    var i: u32 = 0;
    while (i < existing_boxes.items.len) {
        const existing_box = existing_boxes.items[i];
        switch (new_box.compare(existing_box)) {
            .independent => i += 1,
            .engulfs => _ = existing_boxes.orderedRemove(i),
            .engulfed => {
                if (new_box.on) {
                    return;
                } else {
                    var box_to_split = existing_boxes.orderedRemove(i);
                    var split_box = try box_to_split.split(alloc, new_box);
                    try existing_boxes.appendSlice(split_box.items);
                    split_box.deinit();
                }
            },
            .overlaps => |intersection| {
                var box_to_split = existing_boxes.orderedRemove(i);
                var split_box = try box_to_split.split(alloc, intersection);
                try existing_boxes.appendSlice(split_box.items);
                split_box.deinit();
            },
        }
    }

    if (new_box.on) {
        try existing_boxes.append(box);
    }
}
