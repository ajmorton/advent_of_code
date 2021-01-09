use crate::computer::{Computer, SolveFor, read_prog};

pub fn run() -> (usize, usize) {

    let (prog, ip_reg) = read_prog("./input/21.txt");

    let mut computer_p1 = Computer::new(vec![0; 6], ip_reg, prog.clone());    
    let p1 = computer_p1.run(SolveFor::Day21Part1);

    let mut computer_p2 = Computer::new(vec![0; 6], ip_reg, prog.clone());    
    let p2 = computer_p2.run(SolveFor::Day21Part2);

    (p1, p2)
}
