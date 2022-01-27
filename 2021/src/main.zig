const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const d1 = @import("days/day01.zig");
const d2 = @import("days/day02.zig");
const d3 = @import("days/day03.zig");
const d4 = @import("days/day04.zig");
const d5 = @import("days/day05.zig");
const d6 = @import("days/day06.zig");
const d7 = @import("days/day07.zig");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    const result = try d7.run(gpa);
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

test "Day 3" {
    var res_d3 = try d3.run(gpa);
    try expect(res_d3.p1 == 4174964);
    try expect(res_d3.p2 == 4474944);
}

test "Day 4" {
    var res_d4 = try d4.run(gpa);
    try expect(res_d4.p1 == 11536);
    try expect(res_d4.p2 == 1284);
}

test "Day 5" {
    var res_d5 = try d5.run(gpa);
    try expect(res_d5.p1 == 6548);
    try expect(res_d5.p2 == 19663);
}

test "Day 6" {
    var res_d6 = try d6.run(gpa);
    try expect(res_d6.p1 == 353079);
    try expect(res_d6.p2 == 1605400130036);
}

test "Day 7" {
    var res_d7 = try d7.run(gpa);
    try expect(res_d7.p1 == 342534);
    try expect(res_d7.p2 == 94004208);
}
