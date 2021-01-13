use crate::computer::{Computer, SolveFor, read_prog};

pub fn run() -> (usize, usize) {
    let (prog, ip_reg) = read_prog("./input/19.txt");

    let init_regs = vec![0; 6];
    let mut computer = Computer::new(init_regs, ip_reg, prog.clone());

    let init_regs_2 = vec![1, 0, 0, 0, 0, 0];
    let mut computer_2 = Computer::new(init_regs_2, ip_reg, prog);

    (computer.run(SolveFor::Day19), computer_2.run(SolveFor::Day19))
}

#[test]
fn day_19() {
    assert_eq!(run(), (2520, 27941760));
}