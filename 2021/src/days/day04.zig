const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

const helpers = @import("../helpers.zig");

pub const RetDay4 = struct { p1: u32, p2: u32 };

pub fn run(alloc: std.mem.Allocator) !RetDay4 {
    var allText = try std.fs.cwd().readFileAlloc(alloc, "input/day04.txt", 1000000);
    var sections = std.mem.split(u8, allText, "\n\n");

    var nums_iter = std.mem.split(u8, sections.next().?, ",");

    var boards = std.ArrayList(Board).init(alloc);
    defer {
        for (boards.items) |*board| {
            board.deinit();
        }
        boards.deinit();
    }

    while (sections.next()) |board_str| {
        try boards.append(try Board.parse(alloc, board_str));
    }

    return play(&boards, &nums_iter);
}

fn play(boards: *std.ArrayList(Board), nums_iter: *std.mem.SplitIterator(u8)) !RetDay4 {
    var p1: ?u32 = null;
    var p2: u32 = 0;
    var remaining_boards = boards.items.len;

    while (nums_iter.next()) |num| {
        var n = try std.fmt.parseInt(u32, num, 10);
        for (boards.items) |*board| {
            board.hit(n);
            if (!board.has_won and board.isWin()) {
                p1 = p1 orelse n * board.score();
                remaining_boards -= 1;
                if (remaining_boards == 0) {
                    p2 = n * board.score();
                }
            }
        }
    }

    return RetDay4{ .p1 = p1.?, .p2 = p2 };
}

const Cell = struct { val: u32, hit: bool };

const Board = struct {
    cells: std.ArrayList(Cell),
    n: u32,
    has_won: bool,

    const Self = @This();

    fn parse(alloc: std.mem.Allocator, str: []const u8) !Self {
        var nums = std.ArrayList(Cell).init(alloc);
        errdefer nums.deinit();

        var rows = std.mem.split(u8, str, "\n");
        while (rows.next()) |r| {
            var cells = std.mem.tokenize(u8, r, " ");
            while (cells.next()) |cell| {
                try nums.append(Cell{ .val = try std.fmt.parseInt(u32, cell, 10), .hit = false });
            }
        }

        var n = std.math.sqrt(nums.items.len);

        return Board{ .cells = nums, .n = n, .has_won = false };
    }

    fn score(self: Self) u32 {
        var sum: u32 = 0;
        for (self.cells.items) |cell| {
            if (!cell.hit) {
                sum += cell.val;
            }
        }
        return sum;
    }

    fn colWin(self: Self, c: u32) bool {
        var r: u32 = 0;
        while (r < self.n) : (r += 1) {
            if (!self.cells.items[r * self.n + c].hit) {
                return false;
            }
        }
        return true;
    }

    fn rowWin(self: Self, r: u32) bool {
        var c: u32 = 0;
        while (c < self.n) : (c += 1) {
            if (!self.cells.items[r * self.n + c].hit) {
                return false;
            }
        }
        return true;
    }

    fn isWin(self: *Self) bool {
        var i: u32 = 0;
        while (i < self.n) : (i += 1) {
            if (self.colWin(i) or self.rowWin(i)) {
                self.has_won = true;
                return true;
            }
        }
        return false;
    }

    fn hit(self: *Self, num: u32) void {
        for (self.cells.items) |*cell| {
            if (cell.val == num) {
                cell.hit = true;
                break;
            }
        }
    }

    fn deinit(self: *Self) void {
        self.cells.deinit();
        self.* = undefined;
    }
};
