use crate::computer::{Computer, SolveFor, read_prog};

#[must_use]
pub fn run() -> (usize, usize) {

    let (prog, ip_reg) = read_prog("./input/21.txt");

    let mut computer_p1 = Computer::new(vec![0; 6], ip_reg, prog.clone());    
    let p1 = computer_p1.run(&SolveFor::Day21Part1);

    let mut computer_p2 = Computer::new(vec![0; 6], ip_reg, prog);    
    let p2 = computer_p2.run(&SolveFor::Day21Part2);

    (p1, p2)
}

#[test]
fn day_21() {
    assert_eq!(run(), (3_941_014, 13_775_890));
}