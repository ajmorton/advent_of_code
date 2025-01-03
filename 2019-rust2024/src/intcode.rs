#[derive(Debug)]
pub struct IntComputer {
    memory: Vec<usize>,
    pc: usize,
}

impl IntComputer {
    pub fn new(program: Vec<usize>) -> IntComputer {
        IntComputer {
            memory: program,
            pc: 0,
        }
    }

    pub fn run(&mut self) -> usize {
        loop {
            match self.memory[self.pc] {
                1 => {
                    let arg1 = self.memory[self.pc + 1];
                    let arg2 = self.memory[self.pc + 2];
                    let output = self.memory[self.pc + 3];
                    self.memory[output] = self.memory[arg1] + self.memory[arg2];
                    self.pc += 4;
                }
                2 => {
                    let arg1 = self.memory[self.pc + 1];
                    let arg2 = self.memory[self.pc + 2];
                    let output = self.memory[self.pc + 3];
                    self.memory[output] = self.memory[arg1] * self.memory[arg2];
                    self.pc += 4;
                }
                99 => break,
                unexpected => panic!("Unexpected opcode {}", unexpected),
            }
        }

        self.memory[0]
    }
}
