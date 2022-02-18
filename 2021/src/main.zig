const expect = @import("std").testing.expect;
const std = @import("std");
const days = @import("days/all_days.zig");
const benchmark = @import("benchmark.zig");

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = general_purpose_allocator.allocator();

pub fn main() !void {
    // const result = try d25.run(gpa);
    // std.debug.print("===== Results =====\n", .{});
    // std.debug.print("{any}\n", .{result});
    try benchmark.naiveBenchmarkAll(10);
}

fn expectResults(mod: anytype, comptime p1: anytype, comptime p2: anytype) !void {
    var res = try mod.run(gpa);
    try expect(p1 == res.p1);
    try expect(p2 == res.p2);
}

// zig fmt: off
test "Day 01" { try expectResults(days.d01, 1715, 1739); }
test "Day 02" { try expectResults(days.d02, 1868935, 1965970888); }
test "Day 03" { try expectResults(days.d03, 4174964, 4474944); }
test "Day 04" { try expectResults(days.d04, 11536, 1284); }
test "Day 05" { try expectResults(days.d05, 6548, 19663); }
test "Day 06" { try expectResults(days.d06, 353079, 1605400130036); }
test "Day 07" { try expectResults(days.d07, 342534, 94004208); }
test "Day 08" { try expectResults(days.d08, 456, 1091609); }
test "Day 09" { try expectResults(days.d09, 462, 1397760); }
test "Day 10" { try expectResults(days.d10, 462693, 3094671161); }
test "Day 11" { try expectResults(days.d11, 1741, 440); }
test "Day 12" { try expectResults(days.d12, 4970, 137948); }
test "Day 13" {
    var res_d13 = try days.d13.run(gpa);
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
test "Day 14" { try expectResults(days.d14, 3009, 3459822539451);}
test "Day 15" { try expectResults(days.d15, 687, 2957);}
test "Day 16" { try expectResults(days.d16, 951, 902198718880);}
test "Day 17" { try expectResults(days.d17, 11175, 3540);}
test "Day 18" { try expectResults(days.d18, 3699, 4735);}
// test "Day 19" { try expectResuldays.ts(d19, 318, 12166);} // TODO - This is slow. Speed up and re-enable
test "Day 20" { try expectResults(days.d20, 5475, 17548);}
test "Day 21" { try expectResults(days.d21, 1073709, 148747830493442);}
test "Day 22" { try expectResults(days.d22, 591365, 1211172281877240);}
test "Day 23" { try expectResults(days.d23, 16059, 43117);}
test "Day 24" { try expectResults(days.d24, 99799212949967, 34198111816311);}
test "Day 25" { try expectResults(days.d25, 374, 0);}