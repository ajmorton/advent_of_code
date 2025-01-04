use std::collections::VecDeque;

#[derive(Debug)]
pub struct IntComputer {
    memory: Vec<i128>,
    pc: i128,
    input: VecDeque<i128>,
    relative_base: i128
}

#[derive(Debug)]
pub enum RetCode {
    Done(i128),
    NeedInput,
    Output(i128),
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
    AdjustBase,
    Halt,
}

fn to_instr(opcode: i128) -> Result<Instr, i128> {
    match opcode {
        1 => Ok(Instr::Add),
        2 => Ok(Instr::Mult),
        3 => Ok(Instr::Input),
        4 => Ok(Instr::Output),
        5 => Ok(Instr::JumpNZ),
        6 => Ok(Instr::JumpZ),
        7 => Ok(Instr::LessThan),
        8 => Ok(Instr::Equals),
        9 => Ok(Instr::AdjustBase),
        99 => Ok(Instr::Halt),
        _ => Err(opcode),
    }
}

#[derive(PartialEq, Debug, Copy, Clone)]
enum Param {
    Imm, // Treat the argument as an immediate
    Pos, // Treat the argument as a position in memory
    Rel, // Treat the argument as a position in memory, but offset from the relative_base
}

fn get_modes(mut param: i128, num_args: i128) -> [Param; 4] {
    let mut param_modes = [Param::Pos; 4];
    for mode in param_modes.iter_mut().take(num_args as usize) {
        *mode = match param % 10 {
            0 => Param::Pos,
            1 => Param::Imm,
            2 => Param::Rel,
            _ => panic!("unexpected bit in param flag {param} {}", param % 10),
        };

        param /= 10;
    }

    param_modes
}

impl IntComputer {
    pub fn new(program: Vec<i128>, input: Vec<i128>) -> IntComputer {
        IntComputer {
            memory: program,
            pc: 0,
            input: VecDeque::from(input),
            relative_base: 0
        }
    }

    pub fn input(&mut self, inp: i128) {
        self.input.push_back(inp);
    }

    fn get_out(&mut self, pos: i128, mode: &Param) -> i128 {
        match mode {
            Param::Imm => panic!("outputs will never be immediates!"),
            Param::Pos => self.get(pos),
            Param::Rel => self.get(pos) + self.relative_base
        }
    }

    fn get_in(&mut self, pos: i128, mode: &Param) -> i128 {
        let reg_content = self.get(pos);
        match mode {
            Param::Imm => reg_content,
            Param::Pos => self.get(reg_content),
            Param::Rel => self.get(reg_content + self.relative_base)
        }
    }

    fn get(&mut self, pos: i128) -> i128 {
        if pos >= self.memory.len() as i128 {
            self.memory.resize((pos + 1) as usize, 0);
        }

        self.memory[pos as usize]
    }

    fn set(&mut self, pos: i128, val: i128) {
        if pos >= self.memory.len() as i128 {
            self.memory.resize((pos + 1) as usize, 0);
        }
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
                Ok(Instr::AdjustBase) => {
                    let a = self.get_in(self.pc + 1, &param_modes[0]);
                    self.relative_base += a;
                    self.pc += 2;
                }
                Ok(Instr::Halt) => break,
                Err(_) => panic!("Unrecognised opcode {opcode}!"),
            }
        }

        RetCode::Done(self.memory[0])
    }
}
