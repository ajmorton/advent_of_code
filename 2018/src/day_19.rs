use crate::computer;
use computer::{Computer, Instruction, Opcode, Prog};
use regex::Regex;

pub fn run() -> (usize, usize) {
    let mut input = include_str!("../input/19.txt")
        .trim_end_matches('\n')
        .split('\n')
        .into_iter();
    let ip_reg = input.next().unwrap().trim_start_matches("#ip ").parse().unwrap();

    let pattern = Regex::new(r"([a-z]+) (\d+) (\d+) (\d+)").unwrap();

    let mut prog: Prog = vec![];
    for line in input {
        let caps = pattern.captures(line).unwrap();
        let op: Opcode = caps[1].to_string().parse().unwrap();
        let a: usize = caps[2].parse().unwrap();
        let b: usize = caps[3].parse().unwrap();
        let c: usize = caps[4].parse().unwrap();
        prog.push(Instruction { op, a, b, c });
    }

    let init_regs = vec![0; 6];
    let mut computer = Computer::new(init_regs, ip_reg, prog.clone());

    let init_regs_2 = vec![1, 0, 0, 0, 0, 0];
    let mut computer_2 = Computer::new(init_regs_2, ip_reg, prog);

    (computer.run(true), computer_2.run(true))
}
