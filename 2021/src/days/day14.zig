const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay14 = struct { p1: u64, p2: u64 };
const Pair = [2]u8;

pub fn run(alloc: std.mem.Allocator) !RetDay14 {
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day14.txt", 1000000);
    var sections = std.mem.split(u8, allText, "\n\n");

    var initial_molecule = sections.next().?;
    var insertion_map = try parseInsertionMap(alloc, sections.next().?);

    var letter_freqs = std.mem.zeroes([26]u64);
    var pair_freqs = helpers.Counter(Pair).init(alloc);
    defer pair_freqs.deinit();
    try countFrequencies(initial_molecule, &letter_freqs, &pair_freqs);

    var p1: u64 = 0;
    var step: u64 = 1;
    while (step <= 40) : (step += 1) {
        try performExpansion(alloc, &insertion_map, &letter_freqs, &pair_freqs);
        if (step == 10) p1 = letterScore(letter_freqs);
    }

    return RetDay14{ .p1 = p1, .p2 = letterScore(letter_freqs) };
}

fn parseInsertionMap(alloc: std.mem.Allocator, lines: []const u8) !std.AutoHashMap(Pair, u8) {
    var insertion_map = std.AutoHashMap(Pair, u8).init(alloc);
    var insertions_iter = std.mem.split(u8, lines, "\n");
    while (insertions_iter.next()) |insertion| {
        var in_out = std.mem.split(u8, insertion, " -> ");
        var in = in_out.next().?;
        var out = in_out.next().?[0];
        try insertion_map.put(in[0..2].*, out);
    }
    return insertion_map;
}

fn countFrequencies(initial_molecule: []const u8, letter_freqs: *[26]u64, pair_freqs: *helpers.Counter(Pair)) !void {
    var j: u64 = 0;
    while (j < initial_molecule.len - 1) : (j += 1) {
        var pair = Pair{ initial_molecule[j], initial_molecule[j + 1] };
        try pair_freqs.incr(pair);
    }

    for (initial_molecule) |letter| {
        letter_freqs['Z' - letter] += 1;
    }
}

fn performExpansion(alloc: std.mem.Allocator, insertion_map: *std.AutoHashMap(Pair, u8), letter_freqs: *[26]u64, pair_freqs: *helpers.Counter(Pair)) !void {
    var new_pair_freqs = helpers.Counter(Pair).init(alloc);
    var pairs = pair_freqs.iterator();
    while (pairs.next()) |kv| {
        var pair = kv.key_ptr.*;
        var new_insert = insertion_map.get(pair).?;
        letter_freqs['Z' - new_insert] += kv.value_ptr.*;

        var pre = Pair{ pair[0], new_insert };
        var post = Pair{ new_insert, pair[1] };

        try new_pair_freqs.incrN(pre, kv.value_ptr.*);
        try new_pair_freqs.incrN(post, kv.value_ptr.*);
    }
    pair_freqs.deinit();
    pair_freqs.* = new_pair_freqs;
}

fn letterScore(letter_freqs: [26]u64) u64 {
    var max_occ = std.mem.max(u64, &letter_freqs);
    var min_occ: u64 = std.math.maxInt(u64);
    for (letter_freqs) |letter_freq| {
        if (letter_freq > 0) {
            min_occ = std.math.min(min_occ, letter_freq);
        }
    }
    return max_occ - min_occ;
}
