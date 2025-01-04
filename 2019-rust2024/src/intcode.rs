#[derive(Debug)]
pub struct IntComputer {
    memory: Vec<isize>,
    pc: isize,
    input: Option<isize>,
}

#[derive(Debug)]
pub enum RetCode {
    Done(isize),
    NeedInput,
    Output(isize),
}

#[derive(Debug)]
enum Instr {
    Add { out: isize, a: isize, b: isize },
    Mult { out: isize, a: isize, b: isize },
    Input { save_to: isize },
    Output { fetch_from: isize },
    JumpNZ { chk: isize, jump_to: isize },
    JumpZ { chk: isize, jump_to: isize },
    LessThan { out: isize, a: isize, b: isize },
    Equals { out: isize, a: isize, b: isize },
    Halt,
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
    pub fn new(program: Vec<isize>) -> IntComputer {
        IntComputer {
            memory: program,
            pc: 0,
            input: None,
        }
    }

    pub fn input(&mut self, inp: isize) {
        assert!(self.input.is_none());
        self.input = Some(inp);
    }

    fn fetch_instr(&self, pc: isize) -> Instr {
        let instr = self.get(pc, &Param::Pos);
        let (param_mode, opcode) = (instr / 100, instr % 100);

        match opcode {
            1 => {
                let param_modes = get_modes(param_mode, 3);
                let a = self.get(pc + 1, &param_modes[0]);
                let b = self.get(pc + 2, &param_modes[1]);
                let out = self.get(pc + 3, &param_modes[2]);
                Instr::Add { a, b, out }
            }
            2 => {
                let param_modes = get_modes(param_mode, 3);
                let a = self.get(pc + 1, &param_modes[0]);
                let b = self.get(pc + 2, &param_modes[1]);
                let out = self.get(pc + 3, &param_modes[2]);
                Instr::Mult { a, b, out }
            }
            3 => {
                let param_modes = get_modes(param_mode, 1);
                let save_to = self.get(self.pc + 1, &param_modes[0]);
                Instr::Input { save_to }
            }
            4 => {
                let param_modes = get_modes(param_mode, 1);
                let fromm = self.get(self.pc + 1, &Param::Pos);
                let fetch_from = self.get(fromm, &param_modes[0]);
                Instr::Output { fetch_from }
            }
            5 => {
                let param_modes = get_modes(param_mode, 2);
                let arg1 = self.get(self.pc + 1, &Param::Pos);
                let arg2 = self.get(self.pc + 2, &Param::Pos);
                let chk = self.get(arg1, &param_modes[0]);
                let jump_to = self.get(arg2, &param_modes[1]);
                Instr::JumpNZ { chk, jump_to }
            }
            6 => {
                let param_modes = get_modes(param_mode, 2);
                let arg1 = self.get(self.pc + 1, &Param::Pos);
                let arg2 = self.get(self.pc + 2, &Param::Pos);
                let chk = self.get(arg1, &param_modes[0]);
                let jump_to = self.get(arg2, &param_modes[1]);
                Instr::JumpZ { chk, jump_to }
            }
            7 => {
                let param_modes = get_modes(param_mode, 3);
                let a = self.get(pc + 1, &param_modes[0]);
                let b = self.get(pc + 2, &param_modes[1]);
                let out = self.get(pc + 3, &param_modes[2]);
                Instr::LessThan { a, b, out }
            }
            8 => {
                let param_modes = get_modes(param_mode, 3);
                let a = self.get(pc + 1, &param_modes[0]);
                let b = self.get(pc + 2, &param_modes[1]);
                let out = self.get(pc + 3, &param_modes[2]);
                Instr::Equals { a, b, out }
            }
            99 => Instr::Halt,
            _ => panic!("Unknown opcode: {opcode}"),
        }
    }

    fn get(&self, pos: isize, mode: &Param) -> isize {
        match mode {
            Param::Imm => pos,
            Param::Pos => self.memory[pos as usize],
        }
    }

    fn set(&mut self, pos: isize, val: isize) {
        self.memory[pos as usize] = val;
    }

    pub fn run(&mut self) -> RetCode {
        loop {
            let instr = self.fetch_instr(self.pc);
            match instr {
                Instr::Add { out, a, b } => {
                    let val_a = self.get(a, &Param::Pos);
                    let val_b = self.get(b, &Param::Pos);
                    self.set(out, val_a + val_b);
                    self.pc += 4;
                }
                Instr::Mult { out, a, b } => {
                    let val_a = self.get(a, &Param::Pos);
                    let val_b = self.get(b, &Param::Pos);
                    self.set(out, val_a * val_b);
                    self.pc += 4;
                }
                Instr::Input { save_to } => {
                    if let Some(inp) = self.input {
                        self.set(save_to, inp);
                        self.pc += 2;
                    } else {
                        return RetCode::NeedInput;
                    }
                }
                Instr::Output { fetch_from } => {
                    self.pc += 2;
                    let outp = fetch_from;
                    return RetCode::Output(outp);
                }
                Instr::JumpNZ { chk, jump_to } => {
                    if chk != 0 {
                        self.pc = jump_to;
                    } else {
                        self.pc += 3;
                    }
                }
                Instr::JumpZ { chk, jump_to } => {
                    if chk == 0 {
                        self.pc = jump_to;
                    } else {
                        self.pc += 3;
                    }
                }
                Instr::LessThan { out, a, b } => {
                    let val_a = self.get(a, &Param::Pos);
                    let val_b = self.get(b, &Param::Pos);
                    self.set(out, if val_a < val_b { 1 } else { 0 });
                    self.pc += 4;
                }
                Instr::Equals { out, a, b } => {
                    let val_a = self.get(a, &Param::Pos);
                    let val_b = self.get(b, &Param::Pos);
                    self.set(out, if val_a == val_b { 1 } else { 0 });
                    self.pc += 4;
                }
                Instr::Halt => break,
            }
        }

        RetCode::Done(self.memory[0])
    }
}
