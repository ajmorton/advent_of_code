use std::{collections::VecDeque, usize};

use ahash::{AHashMap, AHashSet};

type Pos = (usize, usize);
struct PortalPair {
    portal: Pos,
    maze_entry: Pos,
    inner: bool,
}

struct ExploreNode {
    dist: usize,
    pos: Pos,
    level: isize,
}

fn find_shortest(
    grid: &Vec<Vec<char>>,
    jump_to: &AHashMap<Pos, (Pos, isize)>,
    start_pos: Pos,
    end_pos: Pos,
    p2: bool,
) -> usize {
    let mut seen = AHashSet::new();
    let mut to_explore = VecDeque::new();

    to_explore.push_back(ExploreNode {
        dist: 0,
        pos: start_pos,
        level: 0,
    });
    let mut shortest_dist = usize::MAX;

    'search: while let Some(cur) = to_explore.pop_front() {
        for travel in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
            let mut next_pos = (
                (cur.pos.0 as isize + travel.0) as usize,
                (cur.pos.1 as isize + travel.1) as usize,
            );
            let mut level_change = 0;

            if next_pos == end_pos {
                if p2 {
                    if cur.level == 0 {
                        shortest_dist = cur.dist + 1;
                        break 'search;
                    } else {
                        continue;
                    }
                } else {
                    shortest_dist = cur.dist + 1;
                    break 'search;
                }
            }

            if grid[next_pos.0][next_pos.1] == '#' {
                continue;
            }

            if ('A'..='Z').contains(&grid[next_pos.0][next_pos.1]) {
                // Through the portal we go.
                // println!("portal jump: {next_pos:?}");
                let foo = jump_to.get(&next_pos).unwrap();
                level_change = foo.1;
                if p2 {
                    // Can't go out from starting level
                    if level_change == -1 && cur.level == 0 {
                        continue;
                    }
                }
                next_pos = foo.0;
            }

            let next_level = cur.level + level_change;

            if seen.contains(&(next_pos, next_level)) {
                continue;
            }

            seen.insert((next_pos, next_level));
            to_explore.push_back(ExploreNode {
                dist: cur.dist + 1,
                pos: next_pos,
                level: next_level,
            });
        }
    }

    shortest_dist
}

#[must_use]
pub fn run() -> (usize, usize) {
    let grid: Vec<Vec<char>> = include_str!("../input/day20.txt")
        .lines()
        .map(|l| l.chars().collect())
        .collect();

    let mut portals = AHashMap::new();

    let height = grid.len();
    let width = grid[0].len();

    for r in 0..height {
        for c in 0..width - 1 {
            if grid[r][c].is_alphabetic() && grid[r][c + 1].is_alphabetic() {
                let portal_name = grid[r][c..=c + 1].iter().collect::<String>();
                let portal_points = if c > 0 && grid[r][c - 1] == '.' {
                    let inner = c != width - 2;
                    PortalPair {
                        portal: (r, c),
                        maze_entry: (r, c - 1),
                        inner,
                    }
                } else if c + 2 < width && grid[r][c + 2] == '.' {
                    let inner = c != 0;
                    PortalPair {
                        portal: (r, c + 1),
                        maze_entry: (r, c + 2),
                        inner,
                    }
                } else {
                    unreachable!();
                };
                portals.entry(portal_name).or_insert(vec![]).push(portal_points);
            }
        }
    }

    for c in 0..width {
        for r in 0..height - 1 {
            if grid[r][c].is_alphabetic() && grid[r + 1][c].is_alphabetic() {
                let portal_name = vec![grid[r][c], grid[r + 1][c]].iter().collect::<String>();
                let portal_points = if r > 0 && grid[r - 1][c] == '.' {
                    let inner = r != height - 2;
                    PortalPair {
                        portal: (r, c),
                        maze_entry: (r - 1, c),
                        inner,
                    }
                } else if r + 2 < width && grid[r + 2][c] == '.' {
                    let inner = r != 0;
                    PortalPair {
                        portal: (r + 1, c),
                        maze_entry: (r + 2, c),
                        inner,
                    }
                } else {
                    unreachable!();
                };
                portals.entry(portal_name).or_insert(vec![]).push(portal_points);
            }
        }
    }

    let mut end_pos = None;
    let mut start_pos = None;
    let mut jump_to = AHashMap::new();
    for (portal_name, portal_pair) in portals {
        match portal_name.as_str() {
            "AA" => {
                start_pos = Some(portal_pair[0].maze_entry);
                // Jump back to the entry. This is basically a "don't move" op that has a move cost. Dikstra will filter it quickly.
                jump_to.insert(portal_pair[0].portal, (portal_pair[0].maze_entry, 0));
            }
            "ZZ" => {
                end_pos = Some(portal_pair[0].maze_entry);
            }
            _ => {
                // Non A/Z portals always link inner to outer
                assert!(portal_pair[0].inner != portal_pair[1].inner);
                let port1 = &portal_pair[0];
                let port2 = &portal_pair[1];
                let level_change = if port1.inner { 1 } else { -1 };
                jump_to.insert(port1.portal, (port2.maze_entry, level_change));
                jump_to.insert(port2.portal, (port1.maze_entry, -level_change));
            }
        }
    }

    let p1 = find_shortest(&grid, &jump_to, start_pos.unwrap(), end_pos.unwrap(), false);
    let p2 = find_shortest(&grid, &jump_to, start_pos.unwrap(), end_pos.unwrap(), true);

    (p1, p2)
}
