use regex::Regex;
use std::{collections::HashMap, thread::sleep, time::Duration};

#[derive(Clone, Copy, Debug, PartialEq)]
enum Cell {
    Clay,
    Sand,
    Water,
    FallingWater,
    Spring,
}

#[derive(Clone, Copy)]
struct Pos {
    r: usize,
    c: usize,
}

struct Map {
    grid: Vec<Vec<Cell>>,
    spring_pos: Pos,
    width: usize,
    height: usize,
}

fn create_map(input: &str) -> Map {
    let mut map = HashMap::new();

    let pattern = Regex::new(r"(\w)=(\d+), \w=(\d+)\.\.(\d+)").unwrap();
    map.insert((0, 500), Cell::Spring);

    let _min_r = 0;
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

    let spring_pos = Pos {
        r: 0,
        c: 500 - min_c + 2,
    };
    let height = grid.len();
    let width = grid[0].len();

    Map {
        grid,
        spring_pos,
        height,
        width,
    }
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

    fn fill(&mut self, debug_print: bool) -> (usize, usize) {
        loop {
            let finished = self.drip(self.spring_pos);
            if debug_print {
                print!("\x1B[2J"); // clear console
                self.print_map();
                sleep(Duration::from_millis(1000));
            }
            if finished {
                break;
            }
        }

        let water_cells: usize = self
            .grid
            .iter()
            .skip_while(|row| !row.contains(&Cell::Clay))
            .map(|row| row.iter().filter(|&cell| *cell == Cell::Water).count())
            .sum();
        let falling_water_cells: usize = self
            .grid
            .iter()
            .skip_while(|row| !row.contains(&Cell::Clay))
            .map(|row| row.iter().filter(|&cell| *cell == Cell::FallingWater).count())
            .sum();
        (water_cells + falling_water_cells, water_cells)
    }

    fn drip(&mut self, start: Pos) -> bool {
        let mut drip = start;
        drip.r += 1;

        // drip down
        while drip.r < self.height {
            self.grid[drip.r][drip.c] = Cell::FallingWater;
            if drip.r == self.height - 1 {
                // bottom of grid, finished filling
                return true;
            }
            if self.grid[drip.r + 1][drip.c] == Cell::Clay || self.grid[drip.r + 1][drip.c] == Cell::Water {
                break;
            }
            drip.r += 1;
        }

        // left right
        let mut left_to_wall = true;
        let mut left = drip;
        let mut finished = true;
        while left.c != 0 && self.grid[left.r][left.c - 1] != Cell::Clay {
            if self.grid[left.r + 1][left.c] != Cell::Water && self.grid[left.r + 1][left.c] != Cell::Clay {
                left_to_wall = false;
                finished &= self.drip(left);
                break;
            }
            left.c -= 1;
        }

        let mut right_to_wall = true;
        let mut right = drip;
        while right.c != self.width - 1 && self.grid[right.r][right.c + 1] != Cell::Clay {
            if self.grid[right.r + 1][right.c] != Cell::Water && self.grid[right.r + 1][right.c] != Cell::Clay {
                right_to_wall = false;
                finished &= self.drip(right);
                break;
            }
            right.c += 1;
        }

        let cell_type = if left_to_wall && right_to_wall {
            Cell::Water
        } else {
            Cell::FallingWater
        };

        finished &= cell_type != Cell::Water;

        // println!("filling row {}", drip.r);
        for c in left.c..=right.c {
            self.grid[drip.r][c] = cell_type;
        }

        finished
    }
}

pub fn run() -> (usize, usize) {
    let input = include_str!("../input/17.txt");
    let mut map = create_map(input);
    map.fill(false)
}
