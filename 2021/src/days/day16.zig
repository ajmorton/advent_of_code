const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay16 = struct { p1: u64, p2: u64 };

const OperatorPacket = struct {
    version: u64,
    type_id: ID,
    oper: u64,
    subpackets: std.ArrayList(Packet),
};
const LiteralPacket = struct { version: u64, type_id: ID, val: u64 };
const Packet = union(enum) { operator: OperatorPacket, literal: LiteralPacket };

const ID = enum(u64) { sum = 0, product = 1, min = 2, max = 3, literal = 4, greater_than = 5, less_than = 6, equal_to = 7 };
const State = enum { version, typeID, lengthType, numSubpackets };

pub fn run(alloc: std.mem.Allocator) !RetDay16 {
    var hex_str = try std.fs.cwd().readFileAlloc(alloc, "input/day16.txt", 1000000);
    defer alloc.free(hex_str);

    var bin_str = try hexToBin(alloc, hex_str);

    var pointer: u64 = 0;
    var packets = try parse(alloc, bin_str, &pointer);
    // TODO - free packets
    // printPacket(packets, 0);

    return RetDay16{ .p1 = versionSum(packets), .p2 = performComputation(packets) };
}

fn hexToBin(alloc: std.mem.Allocator, hex_str: []const u8) ![]u8 {
    var binary_str = std.ArrayList([]const u8).init(alloc);

    const num_strs = [_][]const u8{ "0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001" };
    const letter_strs = [_][]const u8{ "1010", "1011", "1100", "1101", "1110", "1111" };

    for (hex_str) |char| {
        switch (char) {
            '0'...'9' => try binary_str.append(num_strs[char - '0']),
            'A'...'F' => try binary_str.append(letter_strs[char - 'A']),
            else => {},
        }
    }

    return try std.mem.join(alloc, "", binary_str.items);
}

fn printPacket(packet: Packet, depth: u64) void {
    switch (packet) {
        .literal => |lit| std.debug.print("{}  {}\n", .{ depth, lit }),
        .operator => |op| {
            std.debug.print("{}  Oper (vers = {}, ID = {}):\n", .{ depth, op.version, op.type_id });
            for (op.subpackets.items) |subp| {
                printPacket(subp, depth + 1);
            }
        },
    }
}

fn versionSum(packet: Packet) u64 {
    switch (packet) {
        .literal => |lit| return lit.version,
        .operator => |op| {
            var sum: u64 = op.version;
            for (op.subpackets.items) |subp| sum += versionSum(subp);
            return sum;
        },
    }
}

fn performComputation(packet: Packet) u64 {
    switch (packet) {
        .literal => |lit| return lit.val,
        .operator => |op| {
            var res: u64 = 0;
            switch (op.type_id) {
                .sum => {
                    for (op.subpackets.items) |subp| {
                        res += performComputation(subp);
                    }
                },
                .product => {
                    res = 1;
                    for (op.subpackets.items) |subp| {
                        res *= performComputation(subp);
                    }
                },
                .min => {
                    res = std.math.maxInt(u64);
                    for (op.subpackets.items) |subp| {
                        res = std.math.min(res, performComputation(subp));
                    }
                },
                .max => {
                    res = std.math.minInt(u64);
                    for (op.subpackets.items) |subp| {
                        res = std.math.max(res, performComputation(subp));
                    }
                },
                .literal => {},
                .greater_than => res = if (performComputation(op.subpackets.items[0]) > performComputation(op.subpackets.items[1])) 1 else 0,
                .less_than => res = if (performComputation(op.subpackets.items[0]) < performComputation(op.subpackets.items[1])) 1 else 0,
                .equal_to => res = if (performComputation(op.subpackets.items[0]) == performComputation(op.subpackets.items[1])) 1 else 0,
            }
            return res;
        },
    }
    unreachable;
}

fn scanInt(bytes: []const u8, p: *u64, len: u64) !u64 {
    var val = bytes[p.* .. p.* + len];
    p.* += len;
    return try std.fmt.parseInt(u64, val, 2);
}

fn parse(alloc: std.mem.Allocator, bytes: []const u8, p: *u64) anyerror!Packet {
    var version_num = try scanInt(bytes, p, 3);
    var type_id = @intToEnum(ID, try scanInt(bytes, p, 3));
    if (type_id == .literal) {
        return Packet{ .literal = LiteralPacket{ .version = version_num, .type_id = type_id, .val = try scanLiteral(bytes, p) } };
    } else {
        var length_type = try scanInt(bytes, p, 1);
        var operator = OperatorPacket{
            .version = version_num,
            .type_id = type_id,
            .oper = 0,
            .subpackets = std.ArrayList(Packet).init(alloc),
        };

        if (length_type == 0) {
            var contents_len: u64 = try scanInt(bytes, p, 15);
            var end_of_subpackets = p.* + contents_len;
            while (p.* < end_of_subpackets) {
                try operator.subpackets.append(try parse(alloc, bytes, p));
            }
            return Packet{ .operator = operator };
        } else {
            var num_children: u64 = try scanInt(bytes, p, 11);
            var children_parsed: u64 = 0;
            while (children_parsed < num_children) : (children_parsed += 1) {
                try operator.subpackets.append(try parse(alloc, bytes, p));
            }
            return Packet{ .operator = operator };
        }
    }

    unreachable;
}

fn scanLiteral(bytes: []const u8, p: *u64) !u64 {
    var value: u64 = 0;
    while (true) : (p.* += 5) {
        value <<= 4;
        value += try std.fmt.parseInt(u64, bytes[p.* + 1 .. p.* + 5], 2);

        if (bytes[p.*] == '0') {
            p.* += 5;
            break;
        }
    }
    return value;
}
