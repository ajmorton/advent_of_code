use ahash::AHashMap;

use crate::intcode::{IntComputer, RetCode};

// U, R, D, L
static DIR: [(isize, isize); 4] = [(-1, 0), (0, 1), (1, 0), (0, -1)];

#[repr(isize)]
#[derive(Copy, Clone)]
enum Colour {
    Black = 0,
    White = 1,
}

struct Robut {
    pos: (isize, isize),
    dir: usize,
}

fn run_robut_run(prog: &[isize], start_colour: Colour) -> AHashMap<(isize, isize), Colour> {
    let mut computer = IntComputer::new(prog, vec![]);

    let mut grid: AHashMap<(isize, isize), Colour> = AHashMap::new();
    let mut robut = Robut { pos: (0, 0), dir: 0 };

    grid.insert((0, 0), start_colour);

    loop {
        match computer.run() {
            RetCode::Done(_) => break,
            RetCode::NeedInput => {
                let floor = grid.get(&robut.pos).unwrap_or(&Colour::Black);
                computer.input(*floor as isize);
            }
            RetCode::Output(out) => {
                match out {
                    0 => grid.insert(robut.pos, Colour::Black),
                    1 => grid.insert(robut.pos, Colour::White),
                    _ => panic!("Unexpected output for colour! {out}"),
                };
                if let RetCode::Output(out) = computer.run() {
                    match out {
                        0 => {
                            // Turn left
                            robut.dir = ((robut.dir as isize - 1) + 4) as usize % 4;
                            robut.pos = (robut.pos.0 + DIR[robut.dir].0, robut.pos.1 + DIR[robut.dir].1);
                        }
                        1 => {
                            // Turn right
                            robut.dir = ((robut.dir + 1) + 4) % 4;
                            robut.pos = (robut.pos.0 + DIR[robut.dir].0, robut.pos.1 + DIR[robut.dir].1);
                        }
                        _ => {}
                    }
                } else {
                    panic!("wat");
                }
            }
        }
    }

    grid
}

#[must_use]
pub fn run() -> (usize, String) {
    let prog: Vec<isize> = include_str!("../input/day11.txt")
        .trim_ascii()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let p1 = run_robut_run(&prog, Colour::Black);
    let p2 = run_robut_run(&prog, Colour::White);

    let min_r = p2.keys().min_by_key(|pos| pos.0).unwrap().0;
    let max_r = p2.keys().max_by_key(|pos| pos.0).unwrap().0;
    let min_c = p2.keys().min_by_key(|pos| pos.1).unwrap().1;
    let max_c = p2.keys().max_by_key(|pos| pos.1).unwrap().1;

    let mut id_string = String::new();
    for r in min_r..=max_r {
        for c in min_c..=max_c {
            match p2.get(&(r, c)).unwrap_or(&Colour::Black) {
                Colour::Black => id_string += " ",
                Colour::White => id_string += "#",
            };
        }
        id_string += "\n";
    }

    (p1.len(), id_string)
}
