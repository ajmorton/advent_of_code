const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const helpers = @import("../helpers.zig");

pub const RetDay12 = struct { p1: u32, p2: u32 };

const FooErr = std.mem.Allocator.Error || std.os.WriteError;

pub fn run(alloc: std.mem.Allocator) !RetDay12 {
    const lines = try helpers.readInAs(alloc, "input/day12.txt", []u8);
    defer lines.deinit();

    var cave = try Cave.init(alloc, lines);
    defer cave.deinit();

    var path = std.ArrayList(Room).init(alloc);
    try path.append("start");

    return RetDay12{
        .p1 = try cave.countPaths(alloc, path, false, false),
        .p2 = try cave.countPaths(alloc, path, true, false),
    };
}

fn isLowerCase(room: Room) bool {
    for (room) |char| {
        if (char < 'a' or char > 'z') {
            return false;
        }
    }
    return true;
}

const Room = []const u8;
const Rooms = std.StringHashMap(void); // TODO - std.arrayList

const Cave = struct {
    connections: std.StringHashMap(Rooms),

    const Self = @This();

    pub fn init(alloc: std.mem.Allocator, lines: std.ArrayList([]u8)) !Self {
        var connections = std.StringHashMap(Rooms).init(alloc);
        for (lines.items) |line| {
            var split = std.mem.split(u8, line, "-");
            var from = split.next().?;
            var to = split.next().?;

            // conn to-from
            var kv = try connections.getOrPut(from);
            if (!kv.found_existing) {
                kv.value_ptr.* = Rooms.init(alloc);
            }
            try kv.value_ptr.*.put(to, {});

            // conn from-to
            kv = try connections.getOrPut(to);
            if (!kv.found_existing) {
                kv.value_ptr.* = Rooms.init(alloc);
            }
            try kv.value_ptr.*.put(from, {});
        }

        return Self{ .connections = connections };
    }

    pub fn deinit(self: *Self) void {
        var iter = self.connections.iterator();
        while (iter.next()) |kv| {
            kv.value_ptr.*.deinit();
        }
        self.connections.deinit();
        self.* = undefined;
    }

    pub fn countPaths(self: Self, alloc: std.mem.Allocator, path: std.ArrayList(Room), can_revisit_once: bool, has_revisited: bool) FooErr!u32 {
        var cur_room = path.items[path.items.len - 1];

        var path_str = try std.mem.join(alloc, ",", path.items);
        defer alloc.free(path_str);

        if (std.mem.eql(u8, cur_room, "end")) {
            return 1;
        }

        var total_paths: u32 = 0;

        var path_copy = std.ArrayList(Room).init(alloc);
        try path_copy.appendSlice(path.items);
        defer path_copy.deinit();

        var next_rooms = self.connections.get(cur_room).?.keyIterator();
        while (next_rooms.next()) |next_room| {
            if (std.mem.eql(u8, next_room.*, "start")) {
                continue;
            }

            var has_revisited2 = has_revisited;
            if (isLowerCase(next_room.*)) {
                var alreadyExplored = false;
                for (path.items) |explored_room| {
                    if (std.mem.eql(u8, explored_room, next_room.*)) {
                        alreadyExplored = true;
                        break;
                    }
                }

                if (alreadyExplored) {
                    if (!has_revisited2 and can_revisit_once) {
                        has_revisited2 = true;
                    } else {
                        continue;
                    }
                }
            }

            try path_copy.append(next_room.*);
            total_paths += try self.countPaths(alloc, path_copy, can_revisit_once, has_revisited2);
            _ = path_copy.pop();
        }

        return total_paths;
    }
};
