use ahash::{AHashMap, AHashSet};
use std::collections::VecDeque;

struct BuildNode {
    computer: IntComputer,
    pos: Pos,
}

#[derive(PartialEq, Clone, Debug)]
enum Cell {
    Wall,
    Empty,
    Oxy,
}

type Pos = (isize, isize);
type Grid = AHashMap<Pos, Cell>;

fn build_grid(prog: &[isize]) -> (Grid, Pos) {
    let mut grid = Grid::new();
    let mut oxy_pos = None;

    let mut to_explore = VecDeque::new();
    to_explore.push_back(BuildNode { computer: IntComputer::new(prog, vec![]), pos: (0, 0) });

    while let Some(cur) = to_explore.pop_front() {
        // N S W E
        for dir in &[1, 2, 3, 4] {
            let travel = match dir {
                1 => (-1, 0),
                2 => (1, 0),
                3 => (0, -1),
                4 => (0, 1),
                _ => unreachable!(),
            };

            let next_pos = (cur.pos.0 + travel.0, cur.pos.1 + travel.1);
            if grid.contains_key(&next_pos) {
                continue;
            }

            // Try move
            let mut new_comp = cur.computer.clone();
            new_comp.input(*dir);
            let res = new_comp.run();
            if let RetCode::Output(res) = res {
                let next_cell = match res {
                    0 => Cell::Wall,
                    1 => Cell::Empty,
                    2 => Cell::Oxy,
                    _ => unreachable!(),
                };

                grid.insert(next_pos, next_cell.clone());
                if next_cell == Cell::Wall {
                    continue;
                }

                if next_cell == Cell::Oxy {
                    oxy_pos = Some(next_pos);
                }

                to_explore.push_back(BuildNode { computer: new_comp, pos: next_pos });
            } else {
                panic!("unexpected res {res:?}");
            }
        }
    }

    (grid, oxy_pos.unwrap())
}

struct ExploreNode {
    pos: Pos,
    dist: isize,
}

fn bfs(grid: &Grid, start_pos: Pos) -> Pos {
    let mut seen = AHashSet::<Pos>::new();
    let mut to_explore = VecDeque::new();

    to_explore.push_back(ExploreNode { pos: start_pos, dist: 0 });

    let mut oxy_dist = 0;
    let mut max_dist = 0;

    while let Some(cur) = to_explore.pop_front() {
        for travel in [(1, 0), (-1, 0), (0, -1), (0, 1)] {
            let next_pos = (cur.pos.0 + travel.0, cur.pos.1 + travel.1);
            match grid.get(&next_pos).unwrap_or(&Cell::Wall) {
                Cell::Wall => continue,
                Cell::Oxy => oxy_dist = cur.dist + 1,
                Cell::Empty => {
                    if seen.contains(&next_pos) {
                        continue;
                    } else {
                        seen.insert(next_pos);
                        to_explore.push_back(ExploreNode { pos: next_pos, dist: cur.dist + 1 });
                        max_dist = cur.dist + 1;
                    }
                }
            }
        }
    }
    (oxy_dist, max_dist)
}

use crate::intcode::{IntComputer, RetCode};
#[must_use]
pub fn run() -> Pos {
    let prog: Vec<isize> =
        include_str!("../input/day15.txt").trim_ascii().split(',').map(|n| n.parse().unwrap()).collect();

    let (grid, oxy_pos) = build_grid(&prog);
    let (p1, _) = bfs(&grid, (0, 0));
    let (_, p2) = bfs(&grid, oxy_pos);

    (p1, p2)
}
