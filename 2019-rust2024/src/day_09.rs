use crate::intcode::{IntComputer, RetCode};

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> = include_str!("../input/day09.txt")
        .trim_ascii()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let mut computer = IntComputer::new(&prog, vec![1]);
    let mut outputs = vec![];

    loop {
        match computer.run() {
            RetCode::Done(_) => break,
            RetCode::NeedInput => panic!("unexpected"),
            RetCode::Output(out) => outputs.push(out),
        }
    }

    let mut computer2 = IntComputer::new(&prog, vec![2]);
    let p2;
    if let RetCode::Output(out) = computer2.run() {
        p2 = out;
    } else {
        panic!("unexpected!");
    }

    (*outputs.last().unwrap(), p2)
}