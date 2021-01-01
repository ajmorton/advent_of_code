use regex::Regex;
use std::collections::{HashMap, VecDeque};

fn play(num_players: usize, num_marbles: usize) -> (usize, usize) {
    let mut scores: HashMap<usize, usize> = HashMap::new();
    let mut cur_player: usize = 0;

    let mut marbles = VecDeque::new();
    marbles.push_back(0);

    for marble in 1..=num_marbles {
        cur_player = (cur_player + 1) % num_players;

        if marble % 23 == 0 {
            for _ in 0..7 {
                let last = marbles.pop_back().unwrap();
                marbles.push_front(last);
            }
            let score_incr = marbles.pop_front().unwrap() + marble;
            scores
                .entry(cur_player)
                .and_modify(|score| *score += score_incr)
                .or_insert(score_incr);
        } else {
            for _ in 0..2 {
                let front = marbles.pop_front().unwrap();
                marbles.push_back(front);
            }
            marbles.push_front(marble);
        }
    }

    let winner = scores.into_iter().max_by_key(|p| p.1).unwrap();
    winner
}

pub fn run() -> (usize, usize) {
    let input = include_str!("../input/9.txt").trim();
    let pattern = Regex::new(r"(\d+) players; last marble is worth (\d+) points").unwrap();
    let caps = pattern.captures(input).unwrap();
    let num_players = caps[1].parse::<usize>().unwrap();
    let num_marbles = caps[2].parse::<usize>().unwrap();

    (
        play(num_players, num_marbles).1,
        play(num_players, num_marbles * 100).1,
    )
}

#[test]
fn day_09_helpers() {
    assert_eq!(play(10, 1618).1, 8317);
    assert_eq!(play(13, 7999).1, 146373);
    assert_eq!(play(17, 1104).1, 2764);
    assert_eq!(play(21, 6111).1, 54718);
    assert_eq!(play(30, 5807).1, 37305);
}
