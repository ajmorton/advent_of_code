use std::iter::FromIterator;

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

#[derive(Debug)]
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
    pub fn new(num_regs: usize, ip_reg: usize, prog: Prog) -> Self {
        Computer {
            ip_reg,
            regs: vec![0; num_regs],
            prog,
        }
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

    pub fn run(&mut self) -> usize {
        let mut state = self.regs.clone();
        loop {
            let ip = state[self.ip_reg];
            if ip >= self.prog.len() {
                break;
            }

            let instr = &self.prog[ip];
            Computer::execute(&mut state, instr);
            state[self.ip_reg] += 1;
        }
        self.regs = state;
        self.regs[0]
    }
}
