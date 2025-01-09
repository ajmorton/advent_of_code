use ahash::AHashSet;
type Pos3D = (usize, usize, usize); // layer, r, c

fn neighbours_p1_count(pos: Pos3D, grid: &[[bool; 5]; 5]) -> usize {
    let mut num_neighbours = 0;
    let (_, r, c) = pos;

    // up
    if r != 0 && grid[r-1][c] {
        num_neighbours += 1;
    }

    // down
    if r != 4 && grid[r+1][c] {
        num_neighbours += 1;
    }
    
    // left
    if c != 0 && grid[r][c-1] {
        num_neighbours += 1;
    }

    // right
    if c != 4 && grid[r][c+1] {
        num_neighbours += 1;
    }

    num_neighbours
}

fn neighbours_p2_count(pos: Pos3D, grid: &[[[bool; 5];5];204]) -> usize {
    let mut num_neighbours = 0;
    let (layer, r, c) = pos;
    // up
    if r == 0 {
        num_neighbours += if grid[layer+1][1][2] {1} else {0};
    } else if r == 3 && c == 2 {
        num_neighbours += if grid[layer - 1][4][0] {1} else {0};
        num_neighbours += if grid[layer - 1][4][1] {1} else {0};
        num_neighbours += if grid[layer - 1][4][2] {1} else {0};
        num_neighbours += if grid[layer - 1][4][3] {1} else {0};
        num_neighbours += if grid[layer - 1][4][4] {1} else {0};
    } else {
        num_neighbours +=  if grid[layer][r-1][c] {1} else {0};
    }

    // down
    if r == 4 {
        num_neighbours += if grid[layer + 1][3][2] {1} else {0};
    } else if r == 1 && c == 2 {
        num_neighbours += if grid[layer - 1][0][0] {1} else {0};
        num_neighbours += if grid[layer - 1][0][1] {1} else {0};
        num_neighbours += if grid[layer - 1][0][2] {1} else {0};
        num_neighbours += if grid[layer - 1][0][3] {1} else {0};
        num_neighbours += if grid[layer - 1][0][4] {1} else {0};
    } else {
        num_neighbours += if grid[layer][r + 1][c] {1} else {0};
    }

    // left
    if c == 0 {
        num_neighbours += if grid[layer + 1][2][1] {1} else {0};
    } else if r == 2 && c == 3 {
        num_neighbours += if grid[layer - 1][0][4] {1} else {0};
        num_neighbours += if grid[layer - 1][1][4] {1} else {0};
        num_neighbours += if grid[layer - 1][2][4] {1} else {0};
        num_neighbours += if grid[layer - 1][3][4] {1} else {0};
        num_neighbours += if grid[layer - 1][4][4] {1} else {0};
    } else {
        num_neighbours += if grid[layer][r][c - 1] {1} else {0};
    }

    // right
    if c == 4 {
        num_neighbours += if grid[layer + 1][2][3] {1} else {0};
    } else if r == 2 && c == 1 {
        num_neighbours += if grid[layer - 1][0][0] {1} else {0};
        num_neighbours += if grid[layer - 1][1][0] {1} else {0};
        num_neighbours += if grid[layer - 1][2][0] {1} else {0};
        num_neighbours += if grid[layer - 1][3][0] {1} else {0};
        num_neighbours += if grid[layer - 1][4][0] {1} else {0};
    } else {
        num_neighbours += if grid[layer][r][c + 1] {1} else {0};
    }

    num_neighbours
}

#[must_use]
pub fn run() -> (usize, usize) {
    let grid: Vec<Vec<char>> = include_str!("../input/day24.txt")
        .trim_ascii()
        .lines()
        .map(|l| l.chars().collect())
        .collect();

    let height = grid.len();
    let width = grid[0].len();

    let mut seen = AHashSet::new();
    let mut grid_p1 = [[false; 5]; 5];
    for r in 0..5 {
        for c in 0..5 {
            if grid[r][c] == '#' {
                grid_p1[r][c] = true;
            }
        }
    }

    let p1;
    'p1: loop {
        let bio_score: usize = grid_p1
            .iter()
            .flatten()
            .enumerate()
            .filter(|(_, cell)| **cell)
            .map(|(i, _)| 1 << i)
            .sum();

        if seen.contains(&bio_score) {
            p1 = bio_score;
            break 'p1;
        } else {
            seen.insert(bio_score);
        }

        let mut new_grid = grid_p1.clone();
        for r in 0..height {
            for c in 0..width {
                let num_neighbours = neighbours_p1_count((0, r, c), &grid_p1);

                if grid_p1[r][c] && num_neighbours != 1 {
                    new_grid[r][c] = false;
                }

                if grid_p1[r][c] == false && (num_neighbours == 1 || num_neighbours == 2) {
                    new_grid[r][c] = true;
                }
            }
        }
        grid_p1 = new_grid;
    }

    // P2
    // Hardcode 204 layers. 200 minutes is at most 100 layers in each direction (one to move to 
    // a layer and then one to move adjacent to the next layer). Then add a buffer so we 
    // don't need to think about bounds checking.
    let mut grid_p2 = [[[false; 5]; 5]; 204];
    let start_layer = 102;
    let mut min_layer = start_layer;
    let mut max_layer = start_layer;

    for r in 0..5 {
        for c in 0..5 {
            if grid[r][c] == '#' {
                grid_p2[start_layer][r][c] = true;
            }
        }
    }

    for _ in 0..200 {
        let mut new_grid_p2 = grid_p2.clone();
        for layer in min_layer - 1..=max_layer + 1 {
            for r in 0..5 {
                for c in 0..5 {
                    if r == 2 && c == 2 {
                        continue;
                    }
                    let num_neighbours = neighbours_p2_count((layer, r, c), &grid_p2);

                    if grid_p2[layer][r][c] && num_neighbours != 1 {
                        new_grid_p2[layer][r][c] = false;
                    }

                    if !grid_p2[layer][r][c] && (num_neighbours == 1 || num_neighbours == 2) {
                        new_grid_p2[layer][r][c] = true;
                        min_layer = std::cmp::min(min_layer, layer);
                        max_layer = std::cmp::max(max_layer, layer);
                    }
                }
            }
        }

        grid_p2 = new_grid_p2;
    }

    let mut p2 = 0;
    for layer in 0 .. 204 {
        for r in 0 .. 5 {
            for c in 0 .. 5 {
                if grid_p2[layer][r][c] {
                    p2 += 1;
                }
            }
        }
    }

    (p1, p2)
}
