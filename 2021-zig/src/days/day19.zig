const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay19 = struct { p1: i32, p2: u32 };

pub fn run(alloc: std.mem.Allocator) !RetDay19 {
    const allText = try std.fs.cwd().readFileAlloc(alloc, "input/day19.txt", 1000000);
    defer alloc.free(allText);
    var sections = std.mem.splitSequence(u8, allText, "\n\n");

    var scanners = std.ArrayList(Scanner).init(alloc);
    defer {
        for (scanners.items) |*scanner| scanner.deinit();
        scanners.deinit();
    }

    while (sections.next()) |scanner_str| {
        var lines = std.mem.tokenize(u8, scanner_str, "\n");
        try scanners.append(try Scanner.init(alloc, &lines));
    }

    try positionScanners(alloc, &scanners);
    return RetDay19{
        .p1 = try numBeacons(alloc, scanners.items),
        .p2 = farthestScanners(scanners.items),
    };
}

fn numBeacons(alloc: std.mem.Allocator, scanners: []Scanner) !i32 {
    var beacon_count: i32 = 0;
    var seen_beacons = std.AutoHashMap(Pos, void).init(alloc);
    defer seen_beacons.deinit();
    for (scanners) |scanner| {
        for (scanner.beacons.items) |beacon| {
            if (!seen_beacons.contains(beacon)) {
                beacon_count += 1;
                try seen_beacons.put(beacon, {});
            }
        }
    }
    return beacon_count;
}

fn farthestScanners(scanners: []Scanner) u32 {
    var biggest_dist: u32 = 0;
    for (scanners, 0..) |s1, i| {
        for (scanners[i + 1 ..]) |s2| {
            const manhattan = s1.pos.manhattanDist(s2.pos);
            if (manhattan > biggest_dist) biggest_dist = manhattan;
        }
    }
    return biggest_dist;
}

const Rot = struct {
    x: i32,
    y: i32,
    z: i32,
    fn init(x: i32, y: i32, z: i32) Rot {
        return .{ .x = x, .y = y, .z = z };
    }
};

const Pos = struct {
    x: i32,
    y: i32,
    z: i32,
    const Self = @This();

    fn add(self: Pos, other: Pos) Pos {
        return .{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z };
    }

    fn sub(self: Pos, other: Pos) Pos {
        return .{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z };
    }

    pub fn manhattanDist(self: Self, other: Self) u32 {
        return (@abs(self.x - other.x)) +
            (@abs(self.y - other.y)) +
            (@abs(self.z - other.z));
    }

    fn rotate(self: Pos, rot: Rot) Pos {
        const p1 = switch (rot.x) {
            1 => Pos{ .x = self.x, .y = self.z, .z = -self.y },
            2 => Pos{ .x = self.x, .y = -self.y, .z = -self.z },
            3 => Pos{ .x = self.x, .y = -self.z, .z = self.y },
            else => self,
        };

        const p2 = switch (rot.y) {
            1 => Pos{ .x = p1.z, .y = p1.y, .z = -p1.x },
            2 => Pos{ .x = -p1.x, .y = p1.y, .z = -p1.z },
            3 => Pos{ .x = -p1.z, .y = p1.y, .z = p1.x },
            else => p1,
        };

        const p3 = switch (rot.z) {
            1 => Pos{ .x = p2.y, .y = -p2.x, .z = p2.z },
            2 => Pos{ .x = -p2.x, .y = -p2.y, .z = p2.z },
            3 => Pos{ .x = -p2.y, .y = p2.x, .z = p2.z },
            else => p2,
        };

        return p3;
    }
};

const Scanner = struct {
    id: i32,
    pos: Pos,
    beacons: std.ArrayList(Pos),
    const Self = @This();

    fn init(alloc: std.mem.Allocator, lines: *std.mem.TokenIterator(u8, .any)) !Self {
        var beacons = std.ArrayList(Pos).init(alloc);
        const scanner_name = lines.next().?;
        var split = std.mem.splitScalar(u8, scanner_name, ' ');
        _ = split.next();
        _ = split.next();
        const scanner_id = try std.fmt.parseInt(i32, split.next().?, 10);
        while (lines.next()) |line| {
            var vals = std.mem.splitScalar(u8, line, ',');
            try beacons.append(Pos{
                .x = try std.fmt.parseInt(i32, vals.next().?, 10),
                .y = try std.fmt.parseInt(i32, vals.next().?, 10),
                .z = try std.fmt.parseInt(i32, vals.next().?, 10),
            });
        }
        return Self{ .id = scanner_id, .pos = Pos{ .x = 0, .y = 0, .z = 0 }, .beacons = beacons };
    }

    fn deinit(self: *Self) void {
        self.beacons.deinit();
        self.* = undefined;
    }
};

fn posLT(context: void, a: Pos, b: Pos) bool {
    _ = context;
    if (a.x > b.x) return false;
    if (a.x == b.x and a.y > b.y) return false;
    if (a.x == b.x and a.y == b.y and a.z > b.z) return false;
    return true;
}

fn positionScanners(alloc: std.mem.Allocator, scanners: *std.ArrayList(Scanner)) !void {

    // Don't compare a pair of scanners twice, the result won't change.
    var already_compared = std.AutoHashMap([2]i32, void).init(alloc);
    defer already_compared.deinit();

    var unknown_scanners = std.ArrayList(Scanner).init(alloc);
    defer unknown_scanners.deinit();

    // Use the first scanner in the list as the baseline. Treat all other scanners as unknown
    while (scanners.items.len > 1) try unknown_scanners.append(scanners.orderedRemove(1));

    // Sort beacons in the known scanner. This is required for offsetOverlapScore.
    std.sort.block(Pos, scanners.items[0].beacons.items, {}, posLT);

    while (unknown_scanners.items.len > 0) {
        var i: u32 = 0;
        while (i < unknown_scanners.items.len) : (i += 1) {
            const unknown_scanner = unknown_scanners.items[i];

            for (scanners.items) |known_scanner| {
                const scanner_pair = [2]i32{ known_scanner.id, unknown_scanner.id };
                if (already_compared.contains(scanner_pair)) continue;
                try already_compared.put(scanner_pair, {});

                if (try findRotationAndOffset(alloc, known_scanner, unknown_scanner)) |found| {
                    var found_scanner = unknown_scanners.orderedRemove(i);
                    found_scanner.pos = found.offset;
                    for (found_scanner.beacons.items) |*beacon| {
                        beacon.* = beacon.*.rotate(found.rot);
                        beacon.* = beacon.*.add(found.offset);
                    }
                    std.sort.block(Pos, found_scanner.beacons.items, {}, posLT);

                    try scanners.append(found_scanner);
                    break;
                }
            }
        }
    }
}

// Permutations of all rotations around the x,y,z axes.
// Rotations not listed here are duplications of others in the list.
const all_rotations = [24]Rot{
    Rot.init(0, 0, 0), Rot.init(0, 0, 1), Rot.init(0, 0, 2), Rot.init(0, 0, 3),
    Rot.init(0, 1, 0), Rot.init(0, 1, 1), Rot.init(0, 1, 2), Rot.init(0, 1, 3),
    Rot.init(0, 2, 0), Rot.init(0, 2, 1), Rot.init(0, 2, 2), Rot.init(0, 2, 3),
    Rot.init(0, 3, 0), Rot.init(0, 3, 1), Rot.init(0, 3, 2), Rot.init(0, 3, 3),
    Rot.init(1, 0, 0), Rot.init(1, 0, 1), Rot.init(1, 0, 2), Rot.init(1, 0, 3),
    Rot.init(1, 2, 0), Rot.init(1, 2, 1), Rot.init(1, 2, 2), Rot.init(1, 2, 3),
};

const RotAndOffset = struct { rot: Rot, offset: Pos };
fn findRotationAndOffset(alloc: std.mem.Allocator, known_scanner: Scanner, unknown_scanner: Scanner) !?RotAndOffset {
    for (comptime all_rotations) |rot| {
        var rotated = std.ArrayList(Pos).init(alloc);
        defer rotated.deinit();

        for (unknown_scanner.beacons.items) |beacon| {
            try rotated.append(beacon.rotate(rot));
        }
        std.sort.block(Pos, rotated.items, {}, posLT);

        for (rotated.items) |pot_point| {
            for (known_scanner.beacons.items) |known_pos| {
                const offset = known_pos.sub(pot_point);
                const score = offsetOverlapScore(offset, rotated.items, known_scanner.beacons.items);
                if (score >= 12) {
                    return RotAndOffset{ .rot = rot, .offset = offset };
                }
            }
        }
    }
    return null;
}

fn offsetOverlapScore(offset: Pos, candidate: []Pos, target: []Pos) i32 {
    // Assumes both arrays are sorted
    var i: u32 = 0;
    var j: u32 = 0;
    var count: i32 = 0;
    while (i < candidate.len and j < target.len) {
        const candidate_pos = candidate[i].add(offset);
        const target_pos = target[j];
        if (std.meta.eql(candidate_pos, target_pos)) {
            count += 1;
            i += 1;
            j += 1;
        } else if (posLT({}, candidate_pos, target_pos)) {
            i += 1;
        } else {
            j += 1;
        }
    }
    return count;
}
