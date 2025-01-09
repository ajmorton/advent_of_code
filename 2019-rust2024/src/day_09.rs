use crate::intcode::{IntComputer, RetCode};

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> =
        include_str!("../input/day09.txt").trim_ascii().split(',').map(|n| n.parse().unwrap()).collect();

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
    let RetCode::Output(p2) = computer2.run() else {
        panic!("unexpected!");
    };

    (*outputs.last().unwrap(), p2)
}
