const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay23 = struct { p1: u64, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay23 {
    return RetDay23{
        .p1 = try Problem(3).findShortestPathP1(alloc, [4][3]Amphipod{
            .{ .None, .D, .B },
            .{ .None, .D, .A },
            .{ .None, .C, .B },
            .{ .None, .C, .A },
        }),
        .p2 = try Problem(5).findShortestPathP1(alloc, [4][5]Amphipod{
            .{ .None, .D, .D, .D, .B },
            .{ .None, .D, .C, .B, .A },
            .{ .None, .C, .B, .A, .B },
            .{ .None, .C, .A, .C, .A },
        }),
    };
}

const Amphipod = enum { None, A, B, C, D };
const Pos = struct { x: u32, y: u32 };

fn Problem(comptime room_size: u32) type {
    return struct {
        fn nodeLT(context: void, a: State, b: State) std.math.Order {
            _ = context;
            return std.math.order(a.path_cost, b.path_cost);
        }

        const NodeQueue = std.PriorityQueue(State, void, nodeLT);
        fn findShortestPathP1(alloc: std.mem.Allocator, init_rooms: [4][room_size]Amphipod) !u32 {
            var explored_states = std.AutoHashMap(Map(room_size), void).init(alloc);
            defer explored_states.deinit();

            var queue = NodeQueue.init(alloc, {});
            defer queue.deinit();
            const start_state = State{ .path_cost = 0, .map = Map(room_size).init(init_rooms) };

            try queue.add(start_state);

            while (queue.len > 0) {
                var cur_state = queue.remove();

                if (explored_states.contains(cur_state.map)) continue;
                try explored_states.put(cur_state.map, {});
                if (cur_state.map.allAmphisInPlace()) return cur_state.path_cost;

                for (cur_state.map.rooms, 0..) |room, x| {
                    const max_y = if (room == .hall) 0 else cur_state.map.room_size - 1;
                    var y: u32 = 0;
                    while (y <= max_y) : (y += 1) {
                        const cur_pos = Pos{ .x = @intCast(x), .y = @intCast(y) };
                        if (cur_state.map.get(cur_pos) != .None) {
                            try tryAllPositions(cur_state, cur_pos, &queue);
                        }
                    }
                }
            }
            return std.math.maxInt(u32);
        }

        fn tryAllPositions(cur_state: State, cur_pos: Pos, queue: *NodeQueue) !void {
            for (cur_state.map.rooms, 0..) |room, x| {
                const max_y = if (room == .hall) 0 else cur_state.map.room_size - 1;
                var y: u32 = 0;
                while (y <= max_y) : (y += 1) {
                    const next_pos = Pos{ .x = @intCast(x), .y = @intCast(y) };
                    if (std.meta.eql(cur_pos, next_pos)) {
                        continue;
                    }
                    try tryNextPos(cur_state, cur_pos, next_pos, queue);
                }
            }
        }

        fn tryNextPos(cur_state: State, cur_pos: Pos, end_pos: Pos, queue: *NodeQueue) !void {
            const amphipod = cur_state.map.get(cur_pos);

            if (cur_state.map.canMoveTo(amphipod, cur_pos, end_pos)) {
                if (cur_state.map.canReach(cur_pos, end_pos)) {
                    var new_state = cur_state;
                    new_state.map.set(cur_pos, .None);
                    new_state.map.set(end_pos, amphipod);
                    new_state.path_cost += try moveCost(amphipod, cur_pos, end_pos);
                    try queue.add(new_state);
                }
            }
        }

        const State = struct { map: Map(room_size), path_cost: u32 };
    };
}

fn Map(comptime room_size: u32) type {
    return struct {
        rooms: [11]Cell,
        room_size: u32 = room_size,
        const Self = @This();
        const Cell = union(enum) { room: [room_size]Amphipod, hall: Amphipod };

        fn init(init_rooms: [4][room_size]Amphipod) Self {
            var rooms = [_]Cell{.{ .hall = .None }} ** 11;
            rooms[2] = .{ .room = init_rooms[0] };
            rooms[4] = .{ .room = init_rooms[1] };
            rooms[6] = .{ .room = init_rooms[2] };
            rooms[8] = .{ .room = init_rooms[3] };
            return Self{ .rooms = rooms };
        }

        fn isEmpty(self: Self, pos: Pos) bool {
            return self.get(pos) == .None;
        }

        fn canMoveTo(self: Self, amphipod: Amphipod, cur_pos: Pos, end_pos: Pos) bool {
            const cur_col = self.rooms[cur_pos.x];
            const next_col = self.rooms[end_pos.x];
            if (cur_col == .hall and next_col == .hall) {
                return false;
            }

            if (targetRoom(amphipod) == cur_pos.x) {
                var already_in_place = true;
                for (self.rooms[cur_pos.x].room[cur_pos.y..]) |occ| {
                    if (occ != amphipod) {
                        already_in_place = false;
                    }
                }
                if (already_in_place) {
                    return false;
                }
            }

            if (next_col == .room) {
                if (end_pos.x != targetRoom(amphipod)) return false;
                if (end_pos.y == 0) return false;
                if (end_pos.x == targetRoom(amphipod) and end_pos.y != self.rooms[end_pos.x].room.len - 1) {
                    for (self.rooms[end_pos.x].room[end_pos.y + 1 ..]) |other_occ| {
                        if (other_occ != amphipod) return false;
                    }
                }
            }
            return true;
        }

        fn canReach(self: Self, cur_pos: Pos, end_pos: Pos) bool {
            var pos = cur_pos;

            while (pos.y != 0) {
                pos.y -= 1;
                if (!self.isEmpty(pos)) return false;
            }

            const dir: i32 = if (cur_pos.x > end_pos.x) -1 else 1;
            while (pos.x != end_pos.x) {
                pos.x = @intCast(@as(i32, @intCast(pos.x)) + dir);
                if (!self.isEmpty(pos)) return false;
            }

            while (pos.y != end_pos.y) {
                pos.y += 1;
                if (!self.isEmpty(pos)) return false;
            }

            return true;
        }

        fn get(self: Self, pos: Pos) Amphipod {
            const col = self.rooms[pos.x];
            return switch (col) {
                .hall => return col.hall,
                .room => return col.room[pos.y],
            };
        }

        fn set(self: *Self, pos: Pos, amphi: Amphipod) void {
            return switch (self.rooms[pos.x]) {
                .hall => self.rooms[pos.x].hall = amphi,
                .room => self.rooms[pos.x].room[pos.y] = amphi,
            };
        }

        fn allAmphisInPlace(self: Self) bool {
            for ([4]Amphipod{ .A, .B, .C, .D }) |amphi| {
                const target_room = targetRoom(amphi);
                for (self.rooms[target_room].room[1..]) |contents| {
                    if (contents != amphi) {
                        return false;
                    }
                }
            }
            return true;
        }
    };
}

fn moveCost(amphipod: Amphipod, start_pos: Pos, end_pos: Pos) !u32 {
    const x_dist = if (end_pos.x > start_pos.x) end_pos.x - start_pos.x else start_pos.x - end_pos.x;
    const dist = start_pos.y + x_dist + end_pos.y;
    const cost: u32 = switch (amphipod) {
        .A => 1,
        .B => 10,
        .C => 100,
        .D => 1000,
        else => unreachable,
    };
    return dist * cost;
}

fn targetRoom(amphipod: Amphipod) u32 {
    return switch (amphipod) {
        .A => 2,
        .B => 4,
        .C => 6,
        .D => 8,
        else => unreachable,
    };
}
