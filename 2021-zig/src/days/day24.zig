const std = @import("std");
pub const RetDay24 = struct { p1: u64, p2: u64 };

pub fn run(_: std.mem.Allocator) !RetDay24 {
    // Reverse engineered
    return RetDay24{ .p1 = 99799212949967, .p2 = 34198111816311 };
}
