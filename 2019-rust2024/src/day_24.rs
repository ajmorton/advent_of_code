use ahash::AHashSet;
type Pos3D = (usize, usize, usize); // layer, r, c

fn neighbours_p1(pos: Pos3D) -> Vec<Pos3D> {
    let mut neighbours = vec![];
    let (layer, r, c) = pos;
    // up
    if r != 0 {
        neighbours.push((layer, r - 1, c));
    }

    // down
    if r != 4 {
        neighbours.push((layer, r + 1, c));
    }

    // left
    if c != 0 {
        neighbours.push((layer, r, c - 1));
    }

    // right
    if c != 4 {
        neighbours.push((layer, r, c + 1));
    }

    neighbours
}

fn neighbours_p2(pos: Pos3D) -> Vec<Pos3D> {
    let mut neighbours = vec![];
    let (layer, r, c) = pos;
    // up
    if r == 0 {
        neighbours.push((layer + 1, 1, 2));
    } else if r == 3 && c == 2 {
        neighbours.push((layer - 1, 4, 0));
        neighbours.push((layer - 1, 4, 1));
        neighbours.push((layer - 1, 4, 2));
        neighbours.push((layer - 1, 4, 3));
        neighbours.push((layer - 1, 4, 4));
    } else {
        neighbours.push((layer, r - 1, c));
    }

    // down
    if r == 4 {
        neighbours.push((layer + 1, 3, 2));
    } else if r == 1 && c == 2 {
        neighbours.push((layer - 1, 0, 0));
        neighbours.push((layer - 1, 0, 1));
        neighbours.push((layer - 1, 0, 2));
        neighbours.push((layer - 1, 0, 3));
        neighbours.push((layer - 1, 0, 4));
    } else {
        neighbours.push((layer, r + 1, c));
    }

    // left
    if c == 0 {
        neighbours.push((layer + 1, 2, 1));
    } else if r == 2 && c == 3 {
        neighbours.push((layer - 1, 0, 4));
        neighbours.push((layer - 1, 1, 4));
        neighbours.push((layer - 1, 2, 4));
        neighbours.push((layer - 1, 3, 4));
        neighbours.push((layer - 1, 4, 4));
    } else {
        neighbours.push((layer, r, c - 1));
    }

    // right
    if c == 4 {
        neighbours.push((layer + 1, 2, 3));
    } else if r == 2 && c == 1 {
        neighbours.push((layer - 1, 0, 0));
        neighbours.push((layer - 1, 1, 0));
        neighbours.push((layer - 1, 2, 0));
        neighbours.push((layer - 1, 3, 0));
        neighbours.push((layer - 1, 4, 0));
    } else {
        neighbours.push((layer, r, c + 1));
    }

    neighbours
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
    let mut grid_p1 = grid.clone();
    let p1;
    'p1: loop {
        let bio_score: usize = grid_p1
            .iter()
            .flatten()
            .enumerate()
            .filter(|(_, cell)| **cell == '#')
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
                let mut num_neighbours = 0;
                for neighbour in neighbours_p1((0, r, c)) {
                    if grid_p1[neighbour.1][neighbour.2] == '#' {
                        num_neighbours += 1;
                    }
                }

                if grid_p1[r][c] == '#' && num_neighbours != 1 {
                    new_grid[r][c] = '.';
                }

                if grid_p1[r][c] == '.' && (num_neighbours == 1 || num_neighbours == 2) {
                    new_grid[r][c] = '#';
                }
            }
        }
        grid_p1 = new_grid;
    }

    // P2
    // Hardcode 500. 200 minutes is at most 200 layers in each direction, and realistically less than 100
    let mut grid_p2 = [[[false; 5]; 5]; 500];
    let start_layer = 250;
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
                    let mut num_neighbours = 0;
                    for n in neighbours_p2((layer, r, c)) {
                        if grid_p2[n.0][n.1][n.2] {
                            num_neighbours += 1;
                        }
                    }

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

    let p2 = grid_p2
        .iter()
        .map(|layer| {
            layer
                .iter()
                .map(|row| row.iter().filter(|x| **x).count())
                .sum::<usize>()
        })
        .sum();

    (p1, p2)
}
