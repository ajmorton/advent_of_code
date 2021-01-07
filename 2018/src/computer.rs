use std::{iter::FromIterator, str::FromStr};

pub type Regs = Vec<usize>;

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum Opcode {
    Addr,
    Addi,
    Mulr,
    Muli,
    Banr,
    Bani,
    Borr,
    Bori,
    Setr,
    Seti,
    Gtir,
    Gtri,
    Gtrr,
    Eqir,
    Eqri,
    Eqrr,
}

impl FromStr for Opcode {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "addr" => Ok(Opcode::Addr),
            "addi" => Ok(Opcode::Addi),
            "mulr" => Ok(Opcode::Mulr),
            "muli" => Ok(Opcode::Muli),
            "banr" => Ok(Opcode::Banr),
            "bani" => Ok(Opcode::Bani),
            "borr" => Ok(Opcode::Borr),
            "bori" => Ok(Opcode::Bori),
            "setr" => Ok(Opcode::Setr),
            "seti" => Ok(Opcode::Seti),
            "gtir" => Ok(Opcode::Gtir),
            "gtri" => Ok(Opcode::Gtri),
            "gtrr" => Ok(Opcode::Gtrr),
            "eqir" => Ok(Opcode::Eqir),
            "eqri" => Ok(Opcode::Eqri),
            "eqrr" => Ok(Opcode::Eqrr),
            _ => Err(()),
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Instruction {
    pub op: Opcode,
    pub a: usize,
    pub b: usize,
    pub c: usize,
}

pub type Prog = Vec<Instruction>;

#[derive(Debug)]
pub struct UnknownInstruction {
    pub op: usize,
    pub a: usize,
    pub b: usize,
    pub c: usize,
}

impl FromIterator<usize> for UnknownInstruction {
    fn from_iter<I: IntoIterator<Item = usize>>(iter: I) -> Self {
        let mut it = iter.into_iter();
        let op = it.next().unwrap();
        let a = it.next().unwrap();
        let b = it.next().unwrap();
        let c = it.next().unwrap();
        UnknownInstruction { op, a, b, c }
    }
}

pub struct Computer {
    ip_reg: usize,
    regs: Regs,
    prog: Prog,
}

impl Computer {
    pub fn new(regs: Vec<usize>, ip_reg: usize, prog: Prog) -> Self {
        Computer { ip_reg, regs, prog }
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
            Opcode::Gtir => {
                if instr.a > regs[instr.b] {
                    1
                } else {
                    0
                }
            }
            Opcode::Gtri => {
                if regs[instr.a] > instr.b {
                    1
                } else {
                    0
                }
            }
            Opcode::Gtrr => {
                if regs[instr.a] > regs[instr.b] {
                    1
                } else {
                    0
                }
            }
            Opcode::Eqir => {
                if instr.a == regs[instr.b] {
                    1
                } else {
                    0
                }
            }
            Opcode::Eqri => {
                if regs[instr.a] == instr.b {
                    1
                } else {
                    0
                }
            }
            Opcode::Eqrr => {
                if regs[instr.a] == regs[instr.b] {
                    1
                } else {
                    0
                }
            }
        };
    }

    pub fn run(&mut self, opt_for_19: bool) -> usize {
        let mut state = self.regs.clone();
        let mut ip = 0;
        loop {
            // opt
            if opt_for_19 {
                if ip == 2 {
                    // prog is sum of factors
                    let target = state[5];
                    let root = f64::sqrt(state[5] as f64).floor() as usize;

                    return (1..=root)
                        .filter_map(|n| if target % n == 0 { Some(n + target / n) } else { None })
                        .sum();
                }
            }

            if ip >= self.prog.len() {
                break;
            }
            state[self.ip_reg] = ip;

            let instr = &self.prog[ip];
            Computer::execute(&mut state, instr);
            ip = state[self.ip_reg] + 1;
        }
        self.regs = state;
        self.regs[0]
    }
}
