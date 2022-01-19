const std = @import("std");
const stdout = std.io.getStdOut().writer();

const helpers = @import("helpers.zig");

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();

    var inputs = try helpers.readInAs(gpa, "input/test.txt", u32);
    for (inputs.items) |i| {
        try stdout.print("{any}: {any}\n", .{ @TypeOf(i), i });
    }
    inputs.deinit();

}
