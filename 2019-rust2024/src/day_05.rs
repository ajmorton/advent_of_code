use crate::intcode::{IntComputer, RetCode};

#[must_use]
pub fn run() -> (i128, i128) {
    let prog: Vec<i128> = include_str!("../input/day05.txt")
        .trim_ascii()
        .split(",")
        .map(|n| n.parse().unwrap())
        .collect();

    let mut intcomputer = IntComputer::new(prog.clone(), vec![1]);

    let mut p1 = 0;
    loop {
        match intcomputer.run() {
            RetCode::Done(_) => break,
            RetCode::NeedInput => panic!("Missing input"),
            RetCode::Output(out) => {
                if out != 0 {
                    p1 = out;
                }
            }
        }
    }

    let mut p2 = 0;
    let mut intcomputer2 = IntComputer::new(prog.clone(), vec![5]);
    loop {
        match intcomputer2.run() {
            RetCode::Done(_) => break,
            RetCode::NeedInput => panic!("missing input!"),
            RetCode::Output(out) => {
                if out != 0 {
                    p2 = out;
                }
            }
        }
    }

    (p1, p2)
}
