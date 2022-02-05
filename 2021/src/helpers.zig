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

pub const ConversionError = error{ConvFailed};

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

pub fn filterArrayList(
    comptime T: type,
    comptime VarArgs: type,
    arr: *std.ArrayList(T),
    filter_fn: fn (T, VarArgs) bool,
    v: VarArgs,
) void {
    var i: u32 = 0;
    while (i < arr.items.len) {
        if (!filter_fn(arr.items[i], v)) {
            _ = arr.orderedRemove(i);
        } else {
            i += 1;
        }
    }
}

pub fn Counter(comptime T: type) type {
    const MapType = if (T == []u8) std.StringHashMap(T) else std.AutoHashMap(T, u64);

    return struct {
        internal: MapType,
        const Self = @This();

        pub fn init(alloc: std.mem.Allocator) Self {
            return Self{ .internal = MapType.init(alloc) };
        }

        pub fn deinit(self: *Self) void {
            self.internal.deinit();
            self.* = undefined;
        }

        pub fn decr(self: *Self, val: T) !void {
            try self.decrMany(val, 1);
        }

        pub fn decrMany(self: *Self, val: T, n: u64) !void {
            if (self.internal.get(val)) |v| {
                if (v.* <= n) {
                    try self.internal.remove(val);
                } else {
                    v.* -= n;
                }
            }
        }

        pub fn incr(self: *Self, val: T) !void {
            try self.incrN(val, 1);
        }

        pub fn incrN(self: *Self, val: T, n: u64) !void {
            var entry = try self.internal.getOrPut(val);
            if (!entry.found_existing) {
                entry.value_ptr.* = 0;
            }
            entry.value_ptr.* += n;
        }

        pub fn iterator(self: *const Self) MapType.Iterator {
            return self.internal.iterator();
        }

        pub fn keyIterator(self: *const Self) MapType.KeyIterator {
            return self.internal.keyIterator();
        }

        pub fn valueIterator(self: *const Self) MapType.ValueIterator {
            return self.internal.valueIterator();
        }
    };
}
