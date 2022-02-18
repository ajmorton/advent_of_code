const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay19 = struct { p1: i32, p2: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay19 {
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day19.txt", 1000000);
    var sections = std.mem.split(u8, allText, "\n\n");

    var scanners = std.ArrayList(Scanner).init(alloc);

    while (sections.next()) |scanner_str| {
        var lines = std.mem.split(u8, scanner_str, "\n");
        try scanners.append(try Scanner.init(alloc, &lines));
    }

    var map = try buildMap(alloc, scanners);

    // P1
    var machines = map.keyIterator();
    var num_beacons: i32 = 0;
    var scanner_locs = std.ArrayList(Pos).init(alloc);
    while (machines.next()) |machine| {
        if (machine.* == .scanner) {
            try scanner_locs.append(machine.*.scanner);
        } else {
            num_beacons += 1;
        }
    }

    // P2
    var biggest_dist: i32 = 0;
    for (scanner_locs.items) |s1| {
        for (scanner_locs.items) |s2| {
            var x_dist = try std.math.absInt(s1.x - s2.x);
            var y_dist = try std.math.absInt(s1.y - s2.y);
            var z_dist = try std.math.absInt(s1.z - s2.z);
            var manhattan = x_dist + y_dist + z_dist;
            if (manhattan > biggest_dist) {
                biggest_dist = manhattan;
            }
        }
    }

    return RetDay19{ .p1 = num_beacons, .p2 = biggest_dist };
}

const Pos = struct { x: i32, y: i32, z: i32 };
const Machine = union(enum) { beacon: Pos, scanner: Pos };
const Map = std.AutoHashMap(Machine, void);

const Scanner = struct {
    id: i32,
    beacons: std.ArrayList(Pos),
    const Self = @This();

    fn init(alloc: std.mem.Allocator, lines: *std.mem.SplitIterator(u8)) !Self {
        var beacons = std.ArrayList(Pos).init(alloc);
        var scanner_name = lines.next().?;
        var split = std.mem.split(u8, scanner_name, " ");
        _ = split.next();
        _ = split.next();
        var scanner_id = try std.fmt.parseInt(i32, split.next().?, 10);
        while (lines.next()) |line| {
            var vals = std.mem.split(u8, line, ",");
            try beacons.append(Pos{
                .x = try std.fmt.parseInt(i32, vals.next().?, 10),
                .y = try std.fmt.parseInt(i32, vals.next().?, 10),
                .z = try std.fmt.parseInt(i32, vals.next().?, 10),
            });
        }
        return Self{ .id = scanner_id, .beacons = beacons };
    }
};

fn buildMap(alloc: std.mem.Allocator, scanners: std.ArrayList(Scanner)) !Map {
    var map = Map.init(alloc);
    var base_scanner = Machine{ .scanner = .{ .x = 0, .y = 0, .z = 0 } };
    try map.put(base_scanner, {});
    var first_scanner = scanners.items[0];
    for (first_scanner.beacons.items) |beacon_pos| {
        var beacon = Machine{ .beacon = beacon_pos };
        try map.put(beacon, {});
    }

    var placed_scanners = std.AutoHashMap(i32, void).init(alloc);
    defer placed_scanners.deinit();
    var all_placed = false;
    while (!all_placed) {
        all_placed = true;
        for (scanners.items[1..]) |scanner| {
            if (!placed_scanners.contains(scanner.id)) {
                var found = try findOrientationAndOffset(alloc, &map, scanner);
                if (found) {
                    all_placed = false;
                    try placed_scanners.put(scanner.id, {});
                }
            }
        }
    }
    return map;
}

fn vecDesc(comptime T: type) fn (void, T, T) bool {
    const impl = struct {
        fn inner(context: void, a: T, b: T) bool {
            _ = context;
            return a > b;
        }
    };

    return impl.inner;
}

fn compPos(context: void, a: Pos, b: Pos) bool {
    _ = context;
    if (a.x > b.x) {
        return true;
    } else if (a.x == b.x and a.y > b.y) {
        return true;
    } else if (a.x == b.x and a.y == b.y and a.z > b.z) {
        return true;
    }
    return false;
}

fn add(p: Pos, other: Pos) Pos {
    return .{ .x = p.x + other.x, .y = p.y + other.y, .z = p.z + other.z };
}

fn sub(p: Pos, other: Pos) Pos {
    return .{ .x = p.x - other.x, .y = p.y - other.y, .z = p.z - other.z };
}

fn rotate(pos: Pos, rot_x: i32, rot_y: i32, rot_z: i32) Pos {
    var p = pos;
    var p1 = switch (rot_x) {
        1 => Pos{ .x = p.x, .y = p.z, .z = -p.y },
        2 => Pos{ .x = p.x, .y = -p.y, .z = -p.z },
        3 => Pos{ .x = p.x, .y = -p.z, .z = p.y },
        else => p,
    };

    var p2 = switch (rot_y) {
        1 => Pos{ .x = p1.z, .y = p1.y, .z = -p1.x },
        2 => Pos{ .x = -p1.x, .y = p1.y, .z = -p1.z },
        3 => Pos{ .x = -p1.z, .y = p1.y, .z = p1.x },
        else => p1,
    };

    var p3 = switch (rot_z) {
        1 => Pos{ .x = p2.y, .y = -p2.x, .z = p2.z },
        2 => Pos{ .x = -p2.x, .y = -p2.y, .z = p2.z },
        3 => Pos{ .x = -p2.y, .y = p2.x, .z = p2.z },
        else => p2,
    };

    return p3;
}

fn findOrientationAndOffset(alloc: std.mem.Allocator, map: *Map, scanner: Scanner) !bool {
    var best_rot: Pos = Pos{ .x = 0, .y = 0, .z = 0 };
    var best_offset: Pos = Pos{ .x = 0, .y = 0, .z = 0 };
    var best_score: i32 = 0;

    var rot_x: i32 = 0;
    while (rot_x <= 3) : (rot_x += 1) {
        var rot_y: i32 = 0;
        while (rot_y <= 3) : (rot_y += 1) {
            var rot_z: i32 = 0;
            while (rot_z <= 3) : (rot_z += 1) {
                var rotated = std.ArrayList(Pos).init(alloc);
                defer rotated.deinit();

                for (scanner.beacons.items) |pos| {
                    try rotated.append(rotate(pos, rot_x, rot_y, rot_z));
                }
                std.sort.sort(Pos, rotated.items, {}, compPos);

                var attempted_offsets = std.AutoHashMap(Pos, void).init(alloc);
                defer attempted_offsets.deinit();

                for (rotated.items) |pot_point| {
                    var known_positions = map.keyIterator();
                    while (known_positions.next()) |known_pos| {
                        if (known_pos.* == .beacon) {
                            var offset = sub(known_pos.*.beacon, pot_point);
                            if (attempted_offsets.contains(offset)) {
                                continue;
                            }
                            try attempted_offsets.put(offset, {});
                            var score = try offsetOverlapScore(alloc, offset, rotated.items, &map.keyIterator());
                            if (score >= best_score) {
                                best_score = score;
                                best_rot = .{ .x = rot_x, .y = rot_y, .z = rot_z };
                                best_offset = offset;
                            }
                        }
                    }
                }
            }
        }
    }

    // add to map
    if (best_score >= 12) {
        try map.put(.{ .scanner = best_offset }, {});
        for (scanner.beacons.items) |point| {
            var p = point;
            p = rotate(p, best_rot.x, best_rot.y, best_rot.z);
            p = add(p, best_offset);
            try map.put(.{ .beacon = p }, {});
        }
        return true;
    } else {
        return false;
    }
}

fn offsetOverlapScore(alloc: std.mem.Allocator, offset: Pos, rotated: []Pos, known_positions: *Map.KeyIterator) !i32 {
    var sum: i32 = 0;
    var known_poses = std.ArrayList(Pos).init(alloc);
    defer known_poses.deinit();
    while (known_positions.next()) |kp| {
        if (kp.* == .beacon) try known_poses.append(kp.*.beacon);
    }

    for (rotated) |point| {
        var offset_point = add(point, offset);
        for (known_poses.items) |known_pos| {
            if (std.meta.eql(offset_point, known_pos)) sum += 1;
        }
    }
    return sum;
}
