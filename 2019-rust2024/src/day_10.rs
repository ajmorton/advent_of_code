use core::f64;

use num::integer::gcd;

#[must_use]
pub fn run() -> (usize, isize) {
    let grid = include_str!("../input/day10.txt").trim_ascii().lines();

    let mut asteroids = vec![];

    let gridd: Vec<Vec<char>> = grid.clone().map(|line| line.chars().collect()).collect();

    for (r, row) in grid.enumerate() {
        for (c, cell) in row.chars().enumerate() {
            if cell == '#' {
                asteroids.push((r as isize, c as isize));
            }
        }
    }

    let mut best_ast = None;
    let mut most_visible = vec![];
    for ast1 in &asteroids {
        let mut visible = vec![];
        for ast2 in &asteroids {
            if ast1 == ast2 {
                continue;
            } else {
                let delta_r = ast2.0 - ast1.0;
                let delta_c = ast2.1 - ast1.1;

                let gcd = gcd(delta_r, delta_c);
                let delta_rr = delta_r / gcd;
                let delta_cc = delta_c / gcd;

                let mut i = 1;
                let mut can_see = true;

                loop {
                    let interim = (ast1.0 + i * delta_rr, ast1.1 + i * delta_cc);
                    if interim == *ast2 {
                        break;
                    } else if gridd[interim.0 as usize][interim.1 as usize] == '#' {
                        can_see = false;
                        break;
                    }
                    i += 1;
                }

                if can_see {
                    visible.push(ast2);
                }
            }
        }

        if visible.len() > most_visible.len() {
            most_visible = visible;
            best_ast = Some(ast1);
        }
    }

    assert!(most_visible.len() >= 200);
    let best_ast = best_ast.unwrap();

    let mut in_order = most_visible.clone();
    in_order.sort_by(|ast1, ast2| {
        let delta_r1 = (ast1.0 - best_ast.0) as f64;
        let delta_c1 = (ast1.1 - best_ast.1) as f64;
        let delta_r2 = (ast2.0 - best_ast.0) as f64;
        let delta_c2 = (ast2.1 - best_ast.1) as f64;
        let angle_1 = angle(delta_r1, delta_c1);
        let angle_2 = angle(delta_r2, delta_c2);

        angle_1.partial_cmp(&angle_2).unwrap()
    });

    let two_hundred = in_order[199];
    (most_visible.len(), two_hundred.1 * 100 + two_hundred.0)
}

fn angle(delta_r: f64, delta_c: f64) -> f64 {
    ((-(-delta_r).atan2(delta_c) + f64::consts::FRAC_PI_2) + 2.0 * f64::consts::PI) % (2.0 * f64::consts::PI)
}
