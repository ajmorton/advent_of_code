use std::collections::{BinaryHeap, VecDeque};

use ahash::{AHashMap, AHashSet};

type Pos = (isize, isize);
type Keys = [bool; 26]; // hack. We know grids contain all 26 letters
type State = ([Pos; 4], Keys);

#[derive(PartialEq, Eq, Debug)]
struct ExploreNode {
    dist: usize,
    state: State,
}

impl PartialOrd for ExploreNode {
    fn partial_cmp(&self, other: &ExploreNode) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for ExploreNode {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        let selff = (-(self.dist as isize), self.state.1.len());
        let otherr = (-(other.dist as isize), other.state.1.len());

        selff.cmp(&otherr)
    }
}

fn key_dists(grid: &[Vec<char>], pos: Pos, found_keys: &[bool; 26]) -> Vec<(char, usize, Pos)> {
    let mut seen = AHashSet::new();
    let mut to_explore = VecDeque::new();
    let mut key_dists = vec![];

    struct FloodNode {
        pos: Pos,
        dist: usize,
    }

    to_explore.push_back(FloodNode { dist: 0, pos });
    while let Some(cur) = to_explore.pop_front() {
        for travel in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            let next_pos = (cur.pos.0 + travel.0, cur.pos.1 + travel.1);

            if seen.contains(&next_pos) {
                continue;
            }

            let next_cell = grid[next_pos.0 as usize][next_pos.1 as usize];
            match next_cell {
                '#' => continue,
                'a'..='z' => {
                    if !found_keys[next_cell as usize - 'a' as usize] {
                        key_dists.push((next_cell, cur.dist + 1, next_pos));
                        continue;
                    }
                }
                'A'..='Z' => {
                    if !found_keys[next_cell as usize - 'A' as usize] {
                        continue;
                    }
                }
                _ => {}
            }

            seen.insert(next_pos);
            to_explore.push_back(FloodNode {
                pos: next_pos,
                dist: cur.dist + 1,
            });
        }
    }

    key_dists
}

fn find_keys(grid: &[Vec<char>], start_pos: Pos, num_keys: usize, p2: bool) -> isize {
    let mut seen = AHashMap::<State, usize>::new();

    let mut to_explore = BinaryHeap::new();

    let mut grid = grid.to_owned();

    let start_node = if p2 {
        let positions = [
            (start_pos.0 - 1, start_pos.1 - 1),
            (start_pos.0 - 1, start_pos.1 + 1),
            (start_pos.0 + 1, start_pos.1 - 1),
            (start_pos.0 + 1, start_pos.1 + 1),
        ];

        grid[start_pos.0 as usize][start_pos.1 as usize] = '#';
        grid[start_pos.0 as usize - 1][start_pos.1 as usize] = '#';
        grid[start_pos.0 as usize + 1][start_pos.1 as usize] = '#';
        grid[start_pos.0 as usize][start_pos.1 as usize - 1] = '#';
        grid[start_pos.0 as usize][start_pos.1 as usize + 1] = '#';

        ExploreNode {
            dist: 0,
            state: (positions, [false; 26]),
        }
    } else {
        ExploreNode {
            dist: 0,
            state: ([start_pos, (-1, -1), (-1, -1), (-1, -1)], [false; 26]),
        }
    };

    to_explore.push(start_node);

    let mut best = isize::MAX;

    let num_robuts = if p2 { 4 } else { 1 };
    while let Some(cur) = to_explore.pop() {
        let prev = seen.entry(cur.state).or_insert(usize::MAX);

        if *prev < cur.dist {
            continue;
        }

        let (poses, keys) = cur.state;
        for i in 0..num_robuts {
            let pos = poses[i];
            let can_reach = key_dists(&grid, pos, &cur.state.1);
            for (key, key_dist, key_pos) in can_reach {
                let mut next_keys = keys;
                next_keys[key as usize - 'a' as usize] = true;

                if next_keys.iter().filter(|x| **x).count() == num_keys {
                    best = std::cmp::min(best, (cur.dist + key_dist) as isize);
                }

                let mut next_poses = poses;
                next_poses[i] = key_pos;

                let new_state = (next_poses, next_keys);
                let xx = seen.entry(new_state).or_insert(usize::MAX);
                if (cur.dist + key_dist) < *xx {
                    *xx = cur.dist + key_dist;
                    // println!("pushing key {key} {}", cur.dist + key_dist);
                    to_explore.push(ExploreNode {
                        dist: cur.dist + key_dist,
                        state: new_state,
                    });
                }
            }
        }
    }

    best
}

#[must_use]
pub fn run() -> (isize, isize) {
    let grid: Vec<Vec<char>> = include_str!("../input/day18.txt")
        .trim_ascii()
        .lines()
        .map(|l| l.chars().collect())
        .collect();

    let mut num_keys = 0;

    let mut start_pos = None;
    for (r, row) in grid.iter().enumerate() {
        for (c, cell) in row.iter().enumerate() {
            match cell {
                'a'..='z' => num_keys += 1,
                '@' => start_pos = Some((r as isize, c as isize)),
                _ => {}
            }
        }
    }

    let p1 = find_keys(&grid, start_pos.unwrap(), num_keys, false);
    let p2 = find_keys(&grid, start_pos.unwrap(), num_keys, true);

    (p1, p2)
}
