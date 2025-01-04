use std::collections::VecDeque;

#[derive(Debug)]
pub struct IntComputer {
    memory: Vec<isize>,
    pc: isize,
    input: VecDeque<isize>,
}

#[derive(Debug)]
pub enum RetCode {
    Done(isize),
    NeedInput,
    Output(isize),
}

#[derive(Debug, Clone, Copy)]
enum Instr {
    Add,
    Mult,
    Input,
    Output,
    JumpNZ,
    JumpZ,
    LessThan,
    Equals,
    Halt,
}

fn to_instr(opcode: isize) -> Result<Instr, isize> {
    match opcode {
        1 => Ok(Instr::Add),
        2 => Ok(Instr::Mult),
        3 => Ok(Instr::Input),
        4 => Ok(Instr::Output),
        5 => Ok(Instr::JumpNZ),
        6 => Ok(Instr::JumpZ),
        7 => Ok(Instr::LessThan),
        8 => Ok(Instr::Equals),
        99 => Ok(Instr::Halt),
        _ => Err(opcode),
    }
}

#[derive(PartialEq, Debug, Copy, Clone)]
enum Param {
    Imm, // Treat the argument as an immediate
    Pos, // Treat the argument as a position in memory
}

fn get_modes(mut param: isize, num_args: isize) -> [Param; 4] {
    let mut param_modes = [Param::Pos; 4];
    for mode in param_modes.iter_mut().take(num_args as usize) {
        *mode = match param % 10 {
            0 => Param::Pos,
            1 => Param::Imm,
            _ => panic!("unexpected bit in param flag {param} {}", param % 10),
        };

        param /= 10;
    }

    param_modes
}

impl IntComputer {
    pub fn new(program: Vec<isize>, input: Vec<isize>) -> IntComputer {
        IntComputer {
            memory: program,
            pc: 0,
            input: VecDeque::from(input),
        }
    }

    pub fn input(&mut self, inp: isize) {
        self.input.push_back(inp);
    }

    fn get_out(&self, pos: isize, mode: &Param) -> isize {
        match mode {
            Param::Imm => panic!("outputs will never be immediates!"),
            Param::Pos => self.get(pos),
        }
    }

    fn get_in(&self, pos: isize, mode: &Param) -> isize {
        match mode {
            Param::Imm => self.get(pos),
            Param::Pos => self.get(self.get(pos)),
        }
    }

    fn get(&self, pos: isize) -> isize {
        self.memory[pos as usize]
    }

    fn set(&mut self, pos: isize, val: isize) {
        self.memory[pos as usize] = val;
    }

    pub fn run(&mut self) -> RetCode {
        loop {
            let instr = self.get(self.pc);
            let (param_flag, opcode) = (instr / 100, instr % 100);
            let param_modes = get_modes(param_flag, 3);
            match to_instr(opcode) {
                Ok(Instr::Add) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    let b = self.get_in(self.pc + 2, &param_modes[1]);
                    let c = self.get_out(self.pc + 3, &param_modes[2]);
                    self.set(c, a + b);
                    self.pc += 4;
                }
                Ok(Instr::Mult) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    let b = self.get_in(self.pc + 2, &param_modes[1]);
                    let c = self.get_out(self.pc + 3, &param_modes[2]);
                    self.set(c, a * b);
                    self.pc += 4;
                }
                Ok(Instr::Input) => {
                    if let Some(inp) = self.input.pop_front() {
                        let a = self.get_out(self.pc + 1, &param_modes[0]);
                        self.set(a, inp);
                        self.pc += 2;
                    } else {
                        return RetCode::NeedInput;
                    }
                }
                Ok(Instr::Output) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    self.pc += 2;
                    return RetCode::Output(a);
                }
                Ok(Instr::JumpNZ) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    let b = self.get_in(self.pc + 2, &param_modes[1]);
                    if a != 0 {
                        self.pc = b;
                    } else {
                        self.pc += 3;
                    }
                }
                Ok(Instr::JumpZ) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    let b = self.get_in(self.pc + 2, &param_modes[1]);
                    if a == 0 {
                        self.pc = b;
                    } else {
                        self.pc += 3;
                    }
                }
                Ok(Instr::LessThan) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    let b = self.get_in(self.pc + 2, &param_modes[1]);
                    let c = self.get_out(self.pc + 3, &param_modes[2]);

                    self.set(c, if a < b { 1 } else { 0 });
                    self.pc += 4;
                }
                Ok(Instr::Equals) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    let b = self.get_in(self.pc + 2, &param_modes[1]);
                    let c = self.get_out(self.pc + 3, &param_modes[2]);

                    self.set(c, if a == b { 1 } else { 0 });
                    self.pc += 4;
                }
                Ok(Instr::Halt) => break,
                Err(_) => panic!("Unrecognised opcode {opcode}!"),
            }
        }

        RetCode::Done(self.memory[0])
    }
}
