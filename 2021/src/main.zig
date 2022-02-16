const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const d01 = @import("days/day01.zig");
const d02 = @import("days/day02.zig");
const d03 = @import("days/day03.zig");
const d04 = @import("days/day04.zig");
const d05 = @import("days/day05.zig");
const d06 = @import("days/day06.zig");
const d07 = @import("days/day07.zig");
const d08 = @import("days/day08.zig");
const d09 = @import("days/day09.zig");
const d10 = @import("days/day10.zig");
const d11 = @import("days/day11.zig");
const d12 = @import("days/day12.zig");
const d13 = @import("days/day13.zig");
const d14 = @import("days/day14.zig");
const d15 = @import("days/day15.zig");
const d16 = @import("days/day16.zig");
const d17 = @import("days/day17.zig");
const d18 = @import("days/day18.zig");
const d19 = @import("days/day19.zig");
const d20 = @import("days/day20.zig");
const d21 = @import("days/day21.zig");
const d22 = @import("days/day22.zig");
const d23 = @import("days/day23.zig");
const d24 = @import("days/day24.zig");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    const result = try d24.run(gpa);
    try stdout.print("===== Results =====\n", .{});
    try stdout.print("{any}\n", .{result});
}

test "Day 01" {
    var res_d01 = try d01.run(gpa);
    try expect(res_d01.p1 == 1715);
    try expect(res_d01.p2 == 1739);
}

test "Day 02" {
    var res_d02 = try d02.run(gpa);
    try expect(res_d02.p1 == 1868935);
    try expect(res_d02.p2 == 1965970888);
}

test "Day 03" {
    var res_d03 = try d03.run(gpa);
    try expect(res_d03.p1 == 4174964);
    try expect(res_d03.p2 == 4474944);
}

test "Day 04" {
    var res_d04 = try d04.run(gpa);
    try expect(res_d04.p1 == 11536);
    try expect(res_d04.p2 == 1284);
}

test "Day 05" {
    var res_d05 = try d05.run(gpa);
    try expect(res_d05.p1 == 6548);
    try expect(res_d05.p2 == 19663);
}

test "Day 06" {
    var res_d06 = try d06.run(gpa);
    try expect(res_d06.p1 == 353079);
    try expect(res_d06.p2 == 1605400130036);
}

test "Day 07" {
    var res_d07 = try d07.run(gpa);
    try expect(res_d07.p1 == 342534);
    try expect(res_d07.p2 == 94004208);
}

test "Day 08" {
    var res_d08 = try d08.run(gpa);
    try expect(res_d08.p1 == 456);
    try expect(res_d08.p2 == 1091609);
}

test "Day 09" {
    var res_d09 = try d09.run(gpa);
    try expect(res_d09.p1 == 462);
    try expect(res_d09.p2 == 1397760);
}

test "Day 10" {
    var res_d10 = try d10.run(gpa);
    try expect(res_d10.p1 == 462693);
    try expect(res_d10.p2 == 3094671161);
}

test "Day 11" {
    var res_d11 = try d11.run(gpa);
    try expect(res_d11.p1 == 1741);
    try expect(res_d11.p2 == 440);
}

test "Day 12" {
    var res_d12 = try d12.run(gpa);
    try expect(res_d12.p1 == 4970);
    try expect(res_d12.p2 == 137948);
}

test "Day 13" {
    var res_d13 = try d13.run(gpa);
    try expect(res_d13.p1 == 638);
    const p2 =
        \\ ##    ##  ##  #  # ###   ##  ###  ### 
        \\#  #    # #  # # #  #  # #  # #  # #  #
        \\#       # #    ##   ###  #  # #  # ### 
        \\#       # #    # #  #  # #### ###  #  #
        \\#  # #  # #  # # #  #  # #  # #    #  #
        \\ ##   ##   ##  #  # ###  #  # #    ### 
        \\
    ;
    try std.testing.expectEqualStrings(p2, res_d13.p2);
}

test "Day 14" {
    var res_d14 = try d14.run(gpa);
    try expect(res_d14.p1 == 3009);
    try expect(res_d14.p2 == 3459822539451);
}

test "Day 15" {
    var res_d15 = try d15.run(gpa);
    try expect(res_d15.p1 == 687);
    try expect(res_d15.p2 == 2957);
}

test "Day 16" {
    var res_d16 = try d16.run(gpa);
    try expect(res_d16.p1 == 951);
    try expect(res_d16.p2 == 902198718880);
}

test "Day 17" {
    var res_d17 = try d17.run(gpa);
    try expect(res_d17.p1 == 11175);
    try expect(res_d17.p2 == 3540);
}

test "Day 18" {
    var res_d18 = try d18.run(gpa);
    try expect(res_d18.p1 == 3699);
    try expect(res_d18.p2 == 4735);
}

// TODO - This is slow. Speed up and re-enable
// test "Day 19" {
//     var res_d19 = try d19.run(gpa);
//     try expect(res_d19.p1 == 318);
//     try expect(res_d19.p2 == 12166);
// }

test "Day 20" {
    var res_d20 = try d20.run(gpa);
    try expect(res_d20.p1 == 5475);
    try expect(res_d20.p2 == 17548);
}

test "Day 21" {
    var res_d21 = try d21.run(gpa);
    try expect(res_d21.p1 == 1073709);
    try expect(res_d21.p2 == 148747830493442);
}

test "Day 22" {
    var res_d22 = try d22.run(gpa);
    try expect(res_d22.p1 == 591365);
    try expect(res_d22.p2 == 1211172281877240);
}

test "Day 23" {
    var res_d23 = try d23.run(gpa);
    try expect(res_d23.p1 == 16059);
    try expect(res_d23.p2 == 43117);
}

test "Day 24" {
    var res_d24 = try d24.run(gpa);
    try expect(res_d24.p1 == 99799212949967);
    try expect(res_d24.p2 == 34198111816311);
}
