use crate::intcode::{IntComputer, RetCode};

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> = include_str!("../input/day05.txt")
        .trim_ascii()
        .split(",")
        .map(|n| n.parse().unwrap())
        .collect();

    let mut intcomputer = IntComputer::new(prog.clone());

    let mut p1 = 0;
    loop {
        match intcomputer.run() {
            RetCode::Done(_) => break,
            RetCode::NeedInput => {
                intcomputer.input(1);
            }
            RetCode::Output(out) => {
                if out != 0 {
                    p1 = out;
                }
            }
        }
    }

    let mut p2 = 0;
    let mut intcomputer2 = IntComputer::new(prog.clone());
    loop {
        match intcomputer2.run() {
            RetCode::Done(_) => break,
            RetCode::NeedInput => {
                intcomputer2.input(5);
            }
            RetCode::Output(out) => {
                if out != 0 {
                    p2 = out;
                }
            }
        }
    }

    (p1, p2)
}
