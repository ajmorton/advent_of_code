use std::collections::HashMap;
use itertools::iproduct;

type Grid = Vec<Vec<char>>;

#[allow(clippy::ptr_arg)] // clippy doesn't play well with typedefs
fn count_neighbours(grid: &Grid, r: usize, c: usize) -> (usize, usize) {
    let min_r = r.checked_sub(1).unwrap_or(r);
    let min_c = c.checked_sub(1).unwrap_or(c);
    let max_r = usize::min(r + 1, grid.len() - 1);
    let max_c = usize::min(c + 1, grid[0].len() - 1);

    let mut num_trees = 0;
    let mut num_yards = 0;

    for (rr, cc) in iproduct!(min_r..=max_r, min_c..=max_c) {
        if rr == r && cc == c {
            continue;
        }
        match grid[rr][cc] {
            '|' => num_trees += 1,
            '#' => num_yards += 1,
            _ => {}
        }
    }
    (num_trees, num_yards)
}

#[allow(clippy::ptr_arg)] // clippy doesn't play well with typedefs
fn update(grid: &Grid) -> Grid {
    let mut new_grid = grid.clone();

    for r in 0..grid.len() {
        for c in 0..grid[r].len() {
            let (num_trees, num_yards) = count_neighbours(grid, r, c);

            if grid[r][c] == '.' && num_trees >= 3 {
                new_grid[r][c] = '|'
            } else if grid[r][c] == '|' && num_yards >= 3 {
                new_grid[r][c] = '#'
            } else if grid[r][c] == '#' && (num_trees == 0 || num_yards == 0) {
                new_grid[r][c] = '.'
            }
        }
    }

    new_grid
}

#[allow(clippy::ptr_arg)] // clippy doesn't play well with typedefs
fn resources_after(grid: &Grid, n: usize) -> usize {
    let mut grid = grid.clone();

    let mut history: HashMap<Grid, usize> = HashMap::new();
    let mut skip_performed = false;
    let mut i = 0;

    while i < n {
        grid = update(&grid);

        if !skip_performed && history.contains_key(&grid) {
            let cycle = history[&grid];
            let cycle_len = i - cycle;

            while i + cycle_len < n {
                i += cycle_len;
            }
            skip_performed = true;
        }
        history.insert(grid.clone(), i);
        i += 1;
    }

    let num_trees: usize = grid.iter().flatten().filter(|&c| *c == '|').count();
    let num_yards: usize = grid.iter().flatten().filter(|&c| *c == '#').count();

    num_trees * num_yards
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/18.txt").trim_end_matches('\n').split('\n');
    let grid: Grid = input.into_iter().map(|row| row.chars().collect()).collect();

    let p1 = resources_after(&grid, 10);
    let p2 = resources_after(&grid, 1_000_000_000);

    (p1, p2)
}

#[test]
fn day_18() {
    assert_eq!(run(), (384_416, 195_776));
}