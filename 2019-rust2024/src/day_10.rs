use core::f64;
use num::integer::gcd;

#[must_use]
pub fn run() -> (usize, isize) {
    let input = include_str!("../input/day10.txt").trim_ascii().lines();
    let gridd: Vec<Vec<char>> = input.clone().map(|line| line.chars().collect()).collect();

    let mut asteroids = vec![];
    for (r, row) in input.enumerate() {
        for (c, cell) in row.chars().enumerate() {
            if cell == '#' {
                asteroids.push((r as isize, c as isize));
            }
        }
    }

    // Build list of which asteroids can be seen from which other asteroids
    let mut seen_from_ast = vec![vec![]; asteroids.len()];
    for (id_1, ast1) in asteroids.iter().enumerate() {
        for (id_2, ast2) in asteroids.iter().enumerate().skip(id_1 + 1) {
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
                seen_from_ast[id_1].push(ast2);
                seen_from_ast[id_2].push(ast1);
            }
        }
    }

    let (best_ast_id, best_seen) = seen_from_ast
        .iter()
        .enumerate()
        .max_by_key(|(_, seen)| seen.len())
        .unwrap();

    let best_ast2 = asteroids[best_ast_id];
    let mut most_visible = best_seen.clone();

    // P2
    assert!(most_visible.len() >= 200);
    most_visible.sort_by(|ast1, ast2| {
        // Angle from best_ast2 to the other asteroid. Start as 0 at true north and moving clockwise
        let angle_1 = -((ast1.1 - best_ast2.1) as f64).atan2((ast1.0 - best_ast2.0) as f64);
        let angle_2 = -((ast2.1 - best_ast2.1) as f64).atan2((ast2.0 - best_ast2.0) as f64);
        angle_1.partial_cmp(&angle_2).unwrap()
    });

    let two_hundred = most_visible[199];
    (most_visible.len(), two_hundred.1 * 100 + two_hundred.0)
}
