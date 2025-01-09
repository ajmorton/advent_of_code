use crate::intcode::{IntComputer, RetCode};

fn poll(prog: &[isize], y: isize, x: isize) -> bool {
    let mut comp = IntComputer::new(prog, vec![y, x]);
    if let RetCode::Output(x) = comp.run() {
        return x == 1;
    }

    unreachable!();
}

#[must_use]
pub fn run() -> (usize, isize) {
    let prog: Vec<isize> =
        include_str!("../input/day19.txt").trim_ascii().split(',').map(|n| n.parse().unwrap()).collect();

    let mut num_cells = 0;
    for y in 0..50 {
        for x in 0..50 {
            if poll(&prog, y, x) {
                num_cells += 1;
            }
        }
    }

    // P2
    let mut x = 0;
    let mut y = 0;
    while !poll(&prog, x + 99, y) {
        // Doesn't fit horizontally. Move down.
        y += 1;
        while !poll(&prog, x, y + 99) {
            // Doesn't fit vertically. Move right.
            x += 1;
        }
    }

    (num_cells, 10_000 * x + y)
}
