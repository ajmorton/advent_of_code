use std::{iter::FromIterator, str::FromStr};
use std::fs::read_to_string;
use regex::Regex;

pub type Regs = Vec<usize>;

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum Opcode { Addr, Addi, Mulr, Muli, Banr, Bani, Borr, Bori, Setr, Seti, Gtir, Gtri, Gtrr, Eqir, Eqri, Eqrr }

impl FromStr for Opcode {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "addr" => Ok(Self::Addr),
            "addi" => Ok(Self::Addi),
            "mulr" => Ok(Self::Mulr),
            "muli" => Ok(Self::Muli),
            "banr" => Ok(Self::Banr),
            "bani" => Ok(Self::Bani),
            "borr" => Ok(Self::Borr),
            "bori" => Ok(Self::Bori),
            "setr" => Ok(Self::Setr),
            "seti" => Ok(Self::Seti),
            "gtir" => Ok(Self::Gtir),
            "gtri" => Ok(Self::Gtri),
            "gtrr" => Ok(Self::Gtrr),
            "eqir" => Ok(Self::Eqir),
            "eqri" => Ok(Self::Eqri),
            "eqrr" => Ok(Self::Eqrr),
            _ => Err(()),
        }
    }
}

#[derive(PartialEq)]
pub enum SolveFor {Day16, Day19, Day21Part1, Day21Part2}

#[derive(Debug, Clone, Copy)]
pub struct Instruction { pub op: Opcode, pub a: usize, pub b: usize, pub c: usize }

pub type Prog = Vec<Instruction>;

#[derive(Debug)]
pub struct UnknownInstruction { pub op: usize, pub a: usize, pub b: usize, pub c: usize }

impl FromIterator<usize> for UnknownInstruction {
    fn from_iter<I: IntoIterator<Item = usize>>(iter: I) -> Self {
        let mut it = iter.into_iter();
        let op = it.next().unwrap();
        let a = it.next().unwrap();
        let b = it.next().unwrap();
        let c = it.next().unwrap();
        Self { op, a, b, c }
    }
}

pub fn read_prog(filepath: &str) -> (Prog, usize) {
    let input = read_to_string(filepath).unwrap();
    let mut input = input.trim_end_matches('\n').split('\n');

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

    (prog, ip_reg)
}

pub struct Computer { ip_reg: usize, regs: Regs, prog: Prog }

impl Computer {
    pub fn new(regs: Vec<usize>, ip_reg: usize, prog: Prog) -> Self {
        Self { ip_reg, regs, prog }
    }

    pub fn execute(regs: &mut Regs, instr: &Instruction) {
        regs[instr.c] = match instr.op {
            Opcode::Addr => regs[instr.a] + regs[instr.b],
            Opcode::Addi => regs[instr.a] + instr.b,
            Opcode::Mulr => regs[instr.a] * regs[instr.b],
            Opcode::Muli => regs[instr.a] * instr.b,
            Opcode::Banr => regs[instr.a] & regs[instr.b],
            Opcode::Bani => regs[instr.a] & instr.b,
            Opcode::Borr => regs[instr.a] | regs[instr.b],
            Opcode::Bori => regs[instr.a] | instr.b,
            Opcode::Setr => regs[instr.a],
            Opcode::Seti => instr.a,
            Opcode::Gtir => if instr.a       > regs[instr.b]  { 1 } else { 0 }
            Opcode::Gtri => if regs[instr.a] > instr.b        { 1 } else { 0 }
            Opcode::Gtrr => if regs[instr.a] > regs[instr.b]  { 1 } else { 0 }
            Opcode::Eqir => if instr.a       == regs[instr.b] { 1 } else { 0 }
            Opcode::Eqri => if regs[instr.a] == instr.b       { 1 } else { 0 }
            Opcode::Eqrr => if regs[instr.a] == regs[instr.b] { 1 } else { 0 }
        };
    }

    pub fn run(&mut self, solve_for: &SolveFor) -> usize {
        let mut state = self.regs.clone();
        let mut ip = 0;
        
        // used for day 21
        let mut last_val_in_reg_5 = 0;
        let mut prev_seen = std::collections::HashSet::new();

        loop {
            // opt
            match solve_for {
                SolveFor::Day16 => {}
                SolveFor::Day19 => {
                    if ip == 2 {
                        // prog is sum of factors
                        let target = state[5];
                        let root = f64::sqrt(state[5] as f64).floor() as usize;
    
                        return (1..=root)
                            .filter_map(|n| if target % n == 0 { Some(n + target / n) } else { None })
                            .sum();
                    }    
                }
                SolveFor::Day21Part1 => {
                    // ip 28 is the only instruction using reg[0] (reg[0] == reg[5]).
                    // return the value of reg[5] when instr 28 is first run
                    if ip == 28 {
                        return state[5];
                    }
                }
                SolveFor::Day21Part2 => {
                    // run until the value in reg[5] repeats during instruction 28, and return the prior value in reg[5].
                    if ip == 28 {
                        let val_in_5 = state[5];
                        if prev_seen.contains(&val_in_5) {
                            return last_val_in_reg_5;
                        } else {
                            prev_seen.insert(val_in_5);
                            last_val_in_reg_5 = val_in_5;
                        }
                    }
                }
            }

            if ip >= self.prog.len() {
                break;
            }
            state[self.ip_reg] = ip;

            let instr = &self.prog[ip];
            Self::execute(&mut state, instr);
            ip = state[self.ip_reg] + 1;
        }
        self.regs = state;
        self.regs[0]
    }
}
