use likely_stable::if_unlikely;
use std::collections::VecDeque;

#[derive(Debug, Clone)]
pub struct IntComputer {
    memory: Vec<isize>,
    pc: isize,
    input: VecDeque<isize>,
    relative_base: isize,
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
    AdjustBase,
    Halt,
}

const fn to_instr(opcode: isize) -> Result<Instr, isize> {
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

fn get_modes(mut param: isize, num_args: isize) -> [Param; 4] {
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
    pub fn new(program: &[isize], input: Vec<isize>) -> Self {
        Self {
            memory: program.to_owned(),
            pc: 0,
            input: VecDeque::from(input),
            relative_base: 0,
        }
    }

    pub fn input(&mut self, inp: isize) {
        self.input.push_back(inp);
    }

    fn get_out(&self, pos: isize, mode: Param) -> isize {
        match mode {
            Param::Imm => panic!("outputs will never be immediates!"),
            Param::Pos => pos,
            Param::Rel => pos + self.relative_base,
        }
    }

    fn get_in(&mut self, pos: isize, mode: Param) -> isize {
        match mode {
            Param::Imm => pos,
            Param::Pos => self.get(pos),
            Param::Rel => self.get(pos + self.relative_base),
        }
    }

    fn get(&mut self, pos: isize) -> isize {
        if_unlikely! {pos + 3 >= self.memory.len() as isize => {
            self.memory.resize((pos + 100) as usize, 0);
        }};

        self.memory[pos as usize]
    }

    fn set(&mut self, pos: isize, val: isize) {
        if_unlikely! {pos + 3 >= self.memory.len() as isize => {
            self.memory.resize((pos + 100) as usize, 0);
        }};
        self.memory[pos as usize] = val;
    }

    pub fn run(&mut self) -> RetCode {
        loop {
            let instr = self.get(self.pc);
            let (param_flag, opcode) = (instr / 100, instr % 100);
            let param_modes = get_modes(param_flag, 3);

            // These unchecked memory accesses are safe. The instr = get() above will allocate
            // these slots if we're near or past the end of memory.
            let arg1 = self.memory[self.pc as usize + 1];
            let arg2 = self.memory[self.pc as usize + 2];
            let arg3 = self.memory[self.pc as usize + 3];

            match to_instr(opcode).expect("unknown opcode!") {
                Instr::Add => {
                    let a = self.get_in(arg1, param_modes[0]);
                    let b = self.get_in(arg2, param_modes[1]);
                    let c = self.get_out(arg3, param_modes[2]);
                    self.set(c, a + b);
                    self.pc += 4;
                }
                Instr::Mult => {
                    let a = self.get_in(arg1, param_modes[0]);
                    let b = self.get_in(arg2, param_modes[1]);
                    let c = self.get_out(arg3, param_modes[2]);
                    self.set(c, a * b);
                    self.pc += 4;
                }
                Instr::Input => {
                    if let Some(inp) = self.input.pop_front() {
                        let a = self.get_out(arg1, param_modes[0]);
                        self.set(a, inp);
                        self.pc += 2;
                    } else {
                        return RetCode::NeedInput;
                    }
                }
                Instr::Output => {
                    let a = self.get_in(arg1, param_modes[0]);
                    self.pc += 2;
                    return RetCode::Output(a);
                }
                Instr::JumpNZ => {
                    let a = self.get_in(arg1, param_modes[0]);
                    let b = self.get_in(arg2, param_modes[1]);
                    if a != 0 {
                        self.pc = b;
                    } else {
                        self.pc += 3;
                    }
                }
                Instr::JumpZ => {
                    let a = self.get_in(arg1, param_modes[0]);
                    let b = self.get_in(arg2, param_modes[1]);
                    if a == 0 {
                        self.pc = b;
                    } else {
                        self.pc += 3;
                    }
                }
                Instr::LessThan => {
                    let a = self.get_in(arg1, param_modes[0]);
                    let b = self.get_in(arg2, param_modes[1]);
                    let c = self.get_out(arg3, param_modes[2]);

                    self.set(c, isize::from(a < b));
                    self.pc += 4;
                }
                Instr::Equals => {
                    let a = self.get_in(arg1, param_modes[0]);
                    let b = self.get_in(arg2, param_modes[1]);
                    let c = self.get_out(arg3, param_modes[2]);

                    self.set(c, isize::from(a == b));
                    self.pc += 4;
                }
                Instr::AdjustBase => {
                    let a = self.get_in(arg1, param_modes[0]);
                    self.relative_base += a;
                    self.pc += 2;
                }
                Instr::Halt => break,
            }
        }

        RetCode::Done(self.memory[0])
    }
}
