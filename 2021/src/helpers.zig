const std = @import("std");

/// Open `file_name` and read the contents into an ArrayList. Specify the type of the results via `T`.
pub fn readInAs(alloc: std.mem.Allocator, file_name: []const u8, comptime T: type) !std.ArrayList(T) {
    var file_contents = std.ArrayList(T).init(alloc);

    const file = try std.fs.cwd().openFile(file_name, .{ .read = true });
    defer file.close();

    while (try file.reader().readUntilDelimiterOrEofAlloc(alloc, '\n', 4096)) |line| {
        try file_contents.append(switch (@typeInfo(T)) {
            .Int => try std.fmt.parseInt(T, line, 10),
            .Float => try std.fmt.parseFloat(T, line),
            @typeInfo([]u8) => line,
            else => @compileError("readInAs doesn't handle type: " ++ std.fmt.comptimePrint("{any}", .{T})),
        });
    }

    return file_contents;
}

pub const ConversionError = error {ConvFailed};

/// Given an arrayList and a map function return an arrayList of converted values
pub fn mapArrayList(
    alloc: std.mem.Allocator,
    comptime S: type,
    comptime T: type,
    arr: std.ArrayList(S),
    map_fn: fn (S) ConversionError!T,
) !std.ArrayList(T) {
    var new_arr = std.ArrayList(T).init(alloc);
    for (arr.items) |elem| {
        try new_arr.append(try map_fn(elem));
    }
    return new_arr;
}