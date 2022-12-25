use regex::Regex;
use std::collections::HashMap;

#[derive(Clone, Copy, Debug, PartialEq)]
enum Cell { Clay, Sand, Water, FallingWater, Spring }

#[derive(Debug, PartialEq)]
enum Side{Edge, Wall}

#[derive(Clone, Copy)]
struct Pos { r: usize, c: usize }

struct Map { grid: Vec<Vec<Cell>>, spring_pos: Pos }

fn create_map(input: &str) -> Map {
    let mut map = HashMap::new();

    let pattern = Regex::new(r"(\w)=(\d+), \w=(\d+)\.\.(\d+)").unwrap();
    map.insert((0, 500), Cell::Spring);

    let mut max_r = 0;
    let mut min_c = usize::max_value();
    let mut max_c = 0;

    let mut grid = vec![vec![Cell::Sand; 2000]; 2000];

    for line in input.trim_end_matches('\n').split('\n') {
        let caps = pattern.captures(line).unwrap();
        let coord_a = &caps[1].to_string();
        let a_val = caps[2].parse::<usize>().unwrap();
        let b_range_min = caps[3].parse::<usize>().unwrap();
        let b_range_max = caps[4].parse::<usize>().unwrap();

        for a in a_val..=a_val {
            for b in b_range_min..=b_range_max {
                let (r, c) = if coord_a == "x" { (b, a) } else { (a, b) };
                grid[r][c] = Cell::Clay;
                max_r = usize::max(r, max_r);
                min_c = usize::min(c, min_c);
                max_c = usize::max(c, max_c);
            }
        }
    }

    // trim extra cells
    grid[0][500] = Cell::Spring;
    let grid: Vec<Vec<Cell>> = grid
        .into_iter()
        .take(max_r + 1)
        .map(|r| r.into_iter().skip(min_c - 2).take(max_c - min_c + 5).collect())
        .collect();

    let spring_pos = Pos { r: 0, c: 500 - min_c + 2 };

    Map { grid, spring_pos }
}

impl Map {
    fn print_map(&self) {
        for row in &self.grid {
            for cell in row {
                match cell {
                    Cell::Clay => print!("\x1b[0;90m#\x1b[0m"),
                    Cell::Sand => print!(" "),
                    Cell::Spring => print!("+"),
                    Cell::Water => print!("\x1b[0;34m~\x1b[0m"),
                    Cell::FallingWater => print!("\x1b[0;36m|\x1b[0m"),
                };
            }
            println!();
        }
    }

    fn is_passable(&self, r: usize, c: usize) -> bool {
        self.grid[r][c] != Cell::Clay && self.grid[r][c] != Cell::Water
    }

    fn is_supported(&self, r: usize, c: usize) -> bool {
        !self.is_passable(r + 1, c)
    }

    fn fill_left(&self, r: usize, c: usize) -> (Side, Pos) {
        let mut left_col = c - 1;

        while self.is_supported(r, left_col) && self.is_passable(r, left_col) {
            left_col -= 1;
        }

        if self.is_passable(r, left_col) {
            (Side::Edge, Pos { r, c: left_col })
        } else {
            (Side::Wall, Pos { r, c: left_col + 1 })
        }
    }

    fn fill_right(&self, r: usize, c: usize) -> (Side, Pos) {
        let mut right_col = c + 1;

        while self.is_supported(r, right_col) && self.is_passable(r, right_col) {
            right_col += 1;
        }

        if self.is_passable(r, right_col) {
            (Side::Edge, Pos { r, c: right_col })
        } else {
            (Side::Wall, Pos { r, c: right_col - 1 })
        }
    }

    fn flow(&mut self, r: usize, c: usize) -> Vec<Pos> {
        let mut to_explore = vec![];

        let (left_side, left_pos) = self.fill_left(r, c);
        let (right_side, right_pos) = self.fill_right(r, c);

        if left_side == Side::Edge || right_side == Side::Edge {
            for cc in left_pos.c ..= right_pos.c {
                self.grid[r][cc] = Cell::FallingWater;
            }
            if left_side  == Side::Edge { to_explore.push(left_pos); }
            if right_side == Side::Edge { to_explore.push(right_pos);}
        } else {
            for cc in left_pos.c ..= right_pos.c {
                self.grid[r][cc] = Cell::Water;
            }
            self.grid[r - 1][c] = Cell::FallingWater;
            to_explore.push(Pos { r: r - 1, c });
        }

        to_explore
    }

    fn fill(&mut self, debug_print: bool) -> (usize, usize) {
        let mut to_explore: Vec<Pos> = vec![self.spring_pos];

        while let Some(Pos { r, c }) = to_explore.pop() {
            if r == self.grid.len() - 1 {
                // bottom of grid
                continue;
            }

            match self.grid[r][c] {
                Cell::Spring => {
                    self.grid[r + 1][c] = Cell::FallingWater;
                    to_explore.push(Pos { r: r + 1, c });
                }
                Cell::FallingWater => match self.grid[r + 1][c] {
                    Cell::Water | Cell::Clay => {
                        to_explore.append(&mut self.flow(r, c));
                    }
                    Cell::Sand => {
                        self.grid[r + 1][c] = Cell::FallingWater;
                        to_explore.push(Pos { r: r + 1, c });
                    }
                    _ => continue,
                },
                _ => continue,
            }
        }

        if debug_print {
            self.print_map();
        }

        let (mut flat_water, mut falling_water) = (0, 0);
        for cell in self.grid.iter().skip_while(|row| !row.contains(&Cell::Clay)).flatten() {
            match cell {
                Cell::Water        => flat_water    += 1,
                Cell::FallingWater => falling_water += 1,
                _ => continue,
            }
        }
        (flat_water + falling_water, flat_water)
    }
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/day17.txt");
    let mut map = create_map(input);
    map.fill(false)
}

#[test]
fn day_17() {
    assert_eq!(run(), (40879, 34693));
}
