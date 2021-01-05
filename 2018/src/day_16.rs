use regex::Regex;
use std::{collections::HashMap, iter::FromIterator};

type Regs = Vec<usize>;

#[derive(Debug, Clone, Copy, PartialEq)]
enum Opcode {
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

const ALL_OPS: [Opcode; 16] = [
    Opcode::Addr,
    Opcode::Addi,
    Opcode::Mulr,
    Opcode::Muli,
    Opcode::Banr,
    Opcode::Bani,
    Opcode::Borr,
    Opcode::Bori,
    Opcode::Setr,
    Opcode::Seti,
    Opcode::Gtir,
    Opcode::Gtri,
    Opcode::Gtrr,
    Opcode::Eqir,
    Opcode::Eqri,
    Opcode::Eqrr,
];

#[derive(Debug)]
struct Instruction {
    op: usize,
    a: usize,
    b: usize,
    c: usize,
}

impl FromIterator<usize> for Instruction {
    fn from_iter<I: IntoIterator<Item = usize>>(iter: I) -> Self {
        let mut it = iter.into_iter();
        let op = it.next().unwrap();
        let a = it.next().unwrap();
        let b = it.next().unwrap();
        let c = it.next().unwrap();
        Instruction { op, a, b, c }
    }
}

#[derive(Debug)]
struct Execution {
    before: Regs,
    instr: Instruction,
    after: Regs,
}

fn execute_instr(regs: &Regs, instr: &Instruction, opcode: &Opcode) -> Regs {
    let mut result = regs.clone();
    result[instr.c] = match opcode {
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

    result
}

fn matches_opcodes(exec: &Execution) -> Vec<Opcode> {
    ALL_OPS
        .iter()
        .filter_map(|&op| {
            if execute_instr(&exec.before, &exec.instr, &op) == exec.after {
                Some(op)
            } else {
                None
            }
        })
        .collect()
}

pub fn run() -> (usize, usize) {
    let input = include_str!("../input/16.txt").trim_end_matches('\n');
    let breakpoint = input.find("\n\n\n").unwrap();
    let (examples, program) = input.split_at(breakpoint);
    let before_after_regex =
        Regex::new(r"Before: \[(\d+, \d+, \d+, \d+)\]\n(\d+ \d+ \d+ \d+)\nAfter:  \[(\d+, \d+, \d+, \d+)\]").unwrap();

    let executions: Vec<Execution> = before_after_regex
        .captures_iter(examples)
        .map(|caps| {
            let before = caps[1]
                .split(", ")
                .collect::<Vec<_>>()
                .iter()
                .map(|n| n.parse::<usize>().unwrap())
                .collect();
            let instr = caps[2]
                .split(' ')
                .collect::<Vec<_>>()
                .iter()
                .map(|n| n.parse::<usize>().unwrap())
                .collect();
            let after = caps[3]
                .split(", ")
                .collect::<Vec<_>>()
                .iter()
                .map(|n| n.parse::<usize>().unwrap())
                .collect();

            Execution { before, instr, after }
        })
        .collect();

    let mut pos_mappings: HashMap<usize, Vec<&Opcode>> = HashMap::new();
    for i in 0..16 {
        let all_codes = vec![
            &Opcode::Addr,
            &Opcode::Addi,
            &Opcode::Mulr,
            &Opcode::Muli,
            &Opcode::Banr,
            &Opcode::Bani,
            &Opcode::Borr,
            &Opcode::Bori,
            &Opcode::Setr,
            &Opcode::Seti,
            &Opcode::Gtir,
            &Opcode::Gtri,
            &Opcode::Gtrr,
            &Opcode::Eqir,
            &Opcode::Eqri,
            &Opcode::Eqrr,
        ];
        pos_mappings.insert(i, all_codes);
    }

    let three_plus_possible_opcodes = executions
        .iter()
        .filter(|&exec| matches_opcodes(exec).iter().count() >= 3)
        .count();

    for exec in executions {
        let unknown_opcode = exec.instr.op;
        let pos_opcodes = pos_mappings.get_mut(&unknown_opcode).unwrap();

        let mut i = 0;
        while i != pos_opcodes.len() {
            if execute_instr(&exec.before, &exec.instr, pos_opcodes[i]) == exec.after {
                i += 1;
            } else {
                pos_opcodes.remove(i);
            }
        }
    }

    let mut pos_mappings = pos_mappings.into_iter().collect::<Vec<_>>();

    let mut opcode_mapping: HashMap<usize, &Opcode> = HashMap::new();
    while !pos_mappings.is_empty() {
        pos_mappings.sort_by_key(|(_i, opcodes)| {
            opcodes
                .iter()
                .filter(|op| !opcode_mapping.values().collect::<Vec<_>>().contains(op))
                .count()
        });
        let (i, mappings) = pos_mappings.remove(0);
        let unique_mapping: Vec<_> = mappings
            .iter()
            .filter(|op| !opcode_mapping.values().collect::<Vec<_>>().contains(op))
            .collect();
        if unique_mapping.len() != 1 {
            panic!("mapping not unique!");
        } else {
            opcode_mapping.insert(i, unique_mapping[0]);
            pos_mappings = pos_mappings.into_iter().filter(|(j, _a)| *j != i).collect();
        }
    }

    let program_regex = Regex::new(r"(\d+ \d+ \d+ \d+)").unwrap();
    let program: Vec<Instruction> = program_regex
        .captures_iter(program)
        .map(|caps| {
            caps[1]
                .split(' ')
                .collect::<Vec<_>>()
                .iter()
                .map(|n| n.parse::<usize>().unwrap())
                .collect()
        })
        .collect();

    let mut state: Regs = vec![0, 0, 0, 0];
    for instr in program {
        state = execute_instr(&state, &instr, opcode_mapping.get(&instr.op).unwrap());
    }

    (three_plus_possible_opcodes, state[0])
}

#[test]
fn check_opcode_matches() {
    let exec = Execution {
        before: vec![3, 2, 1, 1],
        instr: Instruction {
            op: 9,
            a: 2,
            b: 1,
            c: 2,
        },
        after: vec![3, 2, 2, 1],
    };

    assert_eq!(matches_opcodes(&exec), vec!(Opcode::Addi, Opcode::Mulr, Opcode::Seti));
}
