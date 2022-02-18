const expect = @import("std").testing.expect;
const std = @import("std");

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
const d25 = @import("days/day25.zig");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    const result = try d25.run(gpa);
    std.debug.print("===== Results =====\n", .{});
    std.debug.print("{any}\n", .{result});
}

fn expectResults(mod: anytype, comptime p1: anytype, comptime p2: anytype) !void {
    var res = try mod.run(gpa);
    try expect(p1 == res.p1);
    try expect(p2 == res.p2);
}

// zig fmt: off
test "Day 01" { try expectResults(d01, 1715, 1739); }
test "Day 02" { try expectResults(d02, 1868935, 1965970888); }
test "Day 03" { try expectResults(d03, 4174964, 4474944); }
test "Day 04" { try expectResults(d04, 11536, 1284); }
test "Day 05" { try expectResults(d05, 6548, 19663); }
test "Day 06" { try expectResults(d06, 353079, 1605400130036); }
test "Day 07" { try expectResults(d07, 342534, 94004208); }
test "Day 08" { try expectResults(d08, 456, 1091609); }
test "Day 09" { try expectResults(d09, 462, 1397760); }
test "Day 10" { try expectResults(d10, 462693, 3094671161); }
test "Day 11" { try expectResults(d11, 1741, 440); }
test "Day 12" { try expectResults(d12, 4970, 137948); }
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
test "Day 14" { try expectResults(d14, 3009, 3459822539451);}
test "Day 15" { try expectResults(d15, 687, 2957);}
test "Day 16" { try expectResults(d16, 951, 902198718880);}
test "Day 17" { try expectResults(d17, 11175, 3540);}
test "Day 18" { try expectResults(d18, 3699, 4735);}
// test "Day 19" { try expectResults(d19, 318, 12166);} // TODO - This is slow. Speed up and re-enable
test "Day 20" { try expectResults(d20, 5475, 17548);}
test "Day 21" { try expectResults(d21, 1073709, 148747830493442);}
test "Day 22" { try expectResults(d22, 591365, 1211172281877240);}
test "Day 23" { try expectResults(d23, 16059, 43117);}
test "Day 24" { try expectResults(d24, 99799212949967, 34198111816311);}
test "Day 25" { try expectResults(d25, 374, 0);}
