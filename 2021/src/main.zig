const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const d1 = @import("days/day01.zig");
const d2 = @import("days/day02.zig");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    const result = d2.run(gpa);
    try stdout.print("===== Results =====\n", .{});
    try stdout.print("{any}\n", .{result});
}

test "Day 1" {
    var res_d1 = try d1.run(gpa);
    try expect(res_d1.p1 == 1715);
    try expect(res_d1.p2 == 1739);
}

test "Day 2" {
    var res_d2 = try d2.run(gpa);
    try expect(res_d2.p1 == 1868935);
    try expect(res_d2.p2 == 1965970888);
}
