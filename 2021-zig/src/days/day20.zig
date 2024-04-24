const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay20 = struct { p1: i32, p2: i32 };

pub fn run(alloc: std.mem.Allocator) !RetDay20 {
    const allText = try std.fs.cwd().readFileAlloc(alloc, "input/day20.txt", 1000000);
    defer alloc.free(allText);
    var sections = std.mem.splitSequence(u8, allText, "\n\n");

    const algorithm: []const u8 = sections.next().?;
    var image = try Image.init(alloc, sections.next().?);
    defer image.deinit();

    var p1: i32 = 0;
    var step: i32 = 0;
    while (step < 50) : (step += 1) {
        const new_image = try image.step(alloc, algorithm, @mod(step, 2) == 1);
        image.deinit();
        image = new_image;
        if (step == 1) p1 = image.countPixels();
    }

    return RetDay20{ .p1 = p1, .p2 = image.countPixels() };
}

const Pos = struct { r: i32, c: i32 };
const Image = struct {
    lit_pixels: std.AutoHashMap(Pos, void),
    min_r: i32,
    max_r: i32,
    min_c: i32,
    max_c: i32,
    const Self = @This();

    fn init(alloc: std.mem.Allocator, input_str: []const u8) !Self {
        var lit_pixels = std.AutoHashMap(Pos, void).init(alloc);

        var max_c: i32 = 0;

        var lines = std.mem.tokenize(u8, input_str, "\n");
        var r: i32 = 0;
        while (lines.next()) |line| {
            max_c = @as(i32, @intCast(line.len)) - 1;
            var c: i32 = 0;
            for (line) |char| {
                if (char == '#') try lit_pixels.put(Pos{ .r = r, .c = c }, {});
                c += 1;
            }
            r += 1;
        }

        return Self{ .lit_pixels = lit_pixels, .min_r = 0, .max_r = r - 1, .min_c = 0, .max_c = max_c };
    }

    fn deinit(self: *Self) void {
        self.lit_pixels.deinit();
        self.* = undefined;
    }

    fn pixelIsLit(self: Self, r: i32, c: i32, odd_step: bool) bool {
        if (r < self.min_r or r > self.max_r or c < self.min_c or c > self.max_c) {
            return if (odd_step) true else false;
        }

        return self.lit_pixels.contains(Pos{ .r = r, .c = c });
    }

    fn print(self: Self) void {
        std.debug.print("r: {}-{}, c: {}-{}\n", .{ self.min_r, self.max_r, self.min_c, self.max_c });
        var r: i32 = self.min_r;
        while (r <= self.max_r) : (r += 1) {
            var c: i32 = self.min_c;
            while (c <= self.max_c) : (c += 1) {
                if (self.lit_pixels.contains(Pos{ .r = r, .c = c })) {
                    std.debug.print("#", .{});
                } else {
                    std.debug.print(".", .{});
                }
            }
            std.debug.print("\n", .{});
        }
    }

    fn scorePixel(self: Self, r: i32, c: i32, odd_step: bool) u32 {
        var score: u32 = 0;

        var rr: i32 = r - 1;
        while (rr <= r + 1) : (rr += 1) {
            var cc: i32 = c - 1;
            while (cc <= c + 1) : (cc += 1) {
                score <<= 1;
                if (self.pixelIsLit(rr, cc, odd_step)) score += 1;
            }
        }

        return score;
    }

    fn step(self: Self, alloc: std.mem.Allocator, algorithm: []const u8, odd_step: bool) !Self {
        var next_pixels = std.AutoHashMap(Pos, void).init(alloc);

        var r = self.min_r - 1;
        while (r <= self.max_r + 1) : (r += 1) {
            var c = self.min_r - 1;
            while (c <= self.max_r + 1) : (c += 1) {
                const score: u32 = self.scorePixel(r, c, odd_step);
                if (algorithm[score] == '#') {
                    try next_pixels.put(Pos{ .r = r, .c = c }, {});
                }
            }
        }

        return Self{
            .lit_pixels = next_pixels,
            .min_r = self.min_r - 1,
            .max_r = self.max_r + 1,
            .min_c = self.min_c - 1,
            .max_c = self.max_c + 1,
        };
    }

    fn countPixels(self: Self) i32 {
        var count: i32 = 0;
        var iter = self.lit_pixels.keyIterator();
        while (iter.next()) |_| count += 1;
        return count;
    }
};
