const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const helpers = @import("../helpers.zig");

pub const RetDay17 = struct { p1: i32, p2: i32 };

const Box = struct {
    x_min: i32,
    x_max: i32,
    y_min: i32,
    y_max: i32,
    const Self = @This();

    fn inBox(self: Self, x: i32, y: i32) bool {
        return x >= self.x_min and x <= self.x_max and y >= self.y_min and y <= self.y_max;
    }

    fn beyondBox(self: Self, x: i32, y: i32) bool {
        return x > self.x_max or y < self.y_min;
    }
};

pub fn run(alloc: std.mem.Allocator) !RetDay17 {
    _ = alloc;

    // TODO -> find regex package
    var box = Box{ .x_min = 81, .x_max = 129, .y_min = -150, .y_max = -108 };
    var total_possibilities: i32 = 0;
    var max_y_vel: i32 = std.math.minInt(i32);

    var init_x_vel: i32 = 0;
    while (init_x_vel <= box.x_max) : (init_x_vel += 1) {
        var init_y_vel: i32 = -box.y_min + 1;
        while (init_y_vel >= box.y_min) : (init_y_vel -= 1) {
            var vx: i32 = init_x_vel;
            var vy: i32 = init_y_vel;
            var x: i32 = 0;
            var y: i32 = 0;
            while (!box.beyondBox(x, y)) {
                if (box.inBox(x, y)) {
                    total_possibilities += 1;
                    max_y_vel = std.math.max(max_y_vel, init_y_vel);
                    break;
                }

                x += vx;
                if (vx > 0) {
                    vx -= 1;
                }
                y += vy;
                vy -= 1;
            }
        }
    }

    var max_height = @divFloor((max_y_vel) * (max_y_vel + 1), 2);

    return RetDay17{ .p1 = max_height, .p2 = total_possibilities };
}
