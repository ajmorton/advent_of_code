const std = @import("std");
const helpers = @import("../helpers.zig");

pub const RetDay20 = struct { p1: u32, p2: u64 };

pub fn run(alloc: std.mem.Allocator) !RetDay20 {
    _ = alloc;
    return RetDay20{ .p1 = part1(), .p2 = try part2(alloc) };
}

const Pawn = struct {
    pos: u32,
    score: u32,
    const Self = @This();

    fn move(self: *Self, dist: u32) void {
        self.pos = (self.pos + dist) % 10;
        self.score += self.pos + 1;
    }
};

const GameState = struct {
    players: [2]Pawn,
    turn: u32,
    const Self = @This();
    fn init(pos_p1: u32, pos_p2: u32) Self {
        return GameState{
            .players = [2]Pawn{ .{ .pos = pos_p1, .score = 0 }, .{ .pos = pos_p2, .score = 0 } },
            .turn = 0,
        };
    }
};

const Die = struct {
    num_rolls: u32,
    const Self = @This();

    fn roll(self: *Self) u32 {
        var next_roll: u32 = (self.num_rolls % 100) + 1;
        self.num_rolls += 1;
        return next_roll;
    }
};

const RollResult = struct { dist: u32, prob: u32 };
fn part2(alloc: std.mem.Allocator) !u64 {
    const dirac_results = [_]RollResult{
        .{ .dist = 3, .prob = 1 },
        .{ .dist = 4, .prob = 3 },
        .{ .dist = 5, .prob = 6 },
        .{ .dist = 6, .prob = 7 },
        .{ .dist = 7, .prob = 6 },
        .{ .dist = 8, .prob = 3 },
        .{ .dist = 9, .prob = 1 },
    };

    var all_states = helpers.Counter(GameState).init(alloc);
    defer all_states.deinit();

    var start_state = GameState.init(8, 2);
    try all_states.incr(start_state);

    var wins: [2]u64 = .{ 0, 0 };

    var turn: u32 = 0;
    var finished = false;
    while (!finished) {
        finished = true;
        var next_states = helpers.Counter(GameState).init(alloc);
        var cur_player = turn % 2;
        var cur_states = all_states.keyIterator();
        while (cur_states.next()) |cur_state| {
            finished = false;
            for (dirac_results) |dirac_res| {
                var num_new_results = dirac_res.prob * all_states.count(cur_state.*);

                var new_state = cur_state.*;
                new_state.players[cur_player].move(dirac_res.dist);
                if (new_state.players[cur_player].score >= 21) {
                    wins[cur_player] += num_new_results;
                } else {
                    try next_states.incrN(new_state, num_new_results);
                }
            }
        }
        turn += 1;
        all_states.deinit();
        all_states = next_states;
    }

    return std.math.max(wins[0], wins[1]);
}

fn part1() u32 {
    var die = Die{ .num_rolls = 0 };
    var game = GameState.init(8, 2);

    var winner = while (true) {
        var cur_player = game.turn % 2;
        var dist = die.roll() + die.roll() + die.roll();
        game.players[cur_player].move(dist);
        if (game.players[cur_player].score >= 1000) {
            break cur_player;
        }
        game.turn += 1;
    } else unreachable;

    var loser_score = game.players[(winner + 1) % 2].score;
    return loser_score * die.num_rolls;
}
