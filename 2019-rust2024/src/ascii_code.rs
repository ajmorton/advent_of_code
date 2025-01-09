use crate::intcode::{IntComputer, RetCode};

pub struct AsciiComputer {
    int_computer: IntComputer,
}

#[derive(Debug)]
pub enum AsciiRetCode {
    Halt(isize),
    NeedInput,
}

impl AsciiComputer {
    pub fn new(program: &[isize], input: &str) -> Self {
        let inp: Vec<isize> = input.chars().map(|c| c as isize).collect();

        Self {
            int_computer: IntComputer::new(program, inp),
        }
    }

    pub fn run(&mut self) -> (AsciiRetCode, String) {
        let mut outp = vec![];
        let mut last_code;
        let mut ret = 0;
        loop {
            last_code = self.int_computer.run();
            match last_code {
                RetCode::Done(_) => break,
                RetCode::NeedInput => break,
                RetCode::Output(c) => {
                    if c > 256 {
                        ret = c;
                        break;
                    }
                    outp.push((c as u8) as char)
                }
            }
        }

        let msg = outp.iter().collect();
        match last_code {
            RetCode::Done(_) => (AsciiRetCode::Halt(-1), msg),
            RetCode::Output(_) => (AsciiRetCode::Halt(ret), msg),
            RetCode::NeedInput => (AsciiRetCode::NeedInput, msg),
        }
    }

    pub fn input(&mut self, input: &str) {
        let inp: Vec<_> = input.chars().map(|c| c as isize).collect();
        for i in inp {
            self.int_computer.input(i);
        }
    }
}
