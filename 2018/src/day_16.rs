use regex::Regex;
use std::collections::HashMap;

use crate::computer::{Computer, Instruction, Opcode, Prog, Regs, UnknownInstruction, SolveFor};

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
struct Execution {
    before: Regs,
    instr: UnknownInstruction,
    after: Regs,
}

fn matches_opcodes(exec: &Execution) -> Vec<Opcode> {
    ALL_OPS
        .iter()
        .filter_map(|&op| {
            let instr = Instruction {
                op,
                a: exec.instr.a,
                b: exec.instr.b,
                c: exec.instr.c,
            };
            let mut regs = exec.before.clone();
            Computer::execute(&mut regs, &instr);
            if regs == exec.after {
                Some(op)
            } else {
                None
            }
        })
        .collect()
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/16.txt").trim_end_matches('\n');
    let breakpoint = input.find("\n\n\n").unwrap();
    let (examples, program) = input.split_at(breakpoint);
    let before_after_regex =
        Regex::new(r"Before: \[(\d+, \d+, \d+, \d+)\]\n(\d+ \d+ \d+ \d+)\nAfter:  \[(\d+, \d+, \d+, \d+)\]").unwrap();

    let executions: Vec<Execution> = before_after_regex
        .captures_iter(examples)
        .map(|caps| {
            let before = caps[1].split(", ").collect::<Vec<_>>().iter().map(|n| n.parse::<usize>().unwrap()).collect();
            let instr = caps[2].split(' ').collect::<Vec<_>>().iter().map(|n| n.parse::<usize>().unwrap()).collect();
            let after = caps[3].split(", ").collect::<Vec<_>>().iter().map(|n| n.parse::<usize>().unwrap()).collect();

            Execution { before, instr, after }
        })
        .collect();

    let mut pos_mappings: HashMap<usize, Vec<&Opcode>> = HashMap::new();
    for i in 0..16 {
        let all_codes = vec![ 
            &Opcode::Addr, &Opcode::Addi, &Opcode::Mulr, &Opcode::Muli, &Opcode::Banr, &Opcode::Bani, &Opcode::Borr, &Opcode::Bori,
            &Opcode::Setr, &Opcode::Seti, &Opcode::Gtir, &Opcode::Gtri, &Opcode::Gtrr, &Opcode::Eqir, &Opcode::Eqri, &Opcode::Eqrr,
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
            let instr = Instruction {
                op: *pos_opcodes[i],
                a: exec.instr.a,
                b: exec.instr.b,
                c: exec.instr.c,
            };
            let mut regs = exec.before.clone();
            Computer::execute(&mut regs, &instr);
            if regs == exec.after {
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
                .filter(|&op| !opcode_mapping.values().any(|&x| x == *op))
                .count()
        });
        let (i, mappings) = pos_mappings.remove(0);
        let unique_mapping: Vec<_> = mappings
            .iter()
            .filter(|&op| !opcode_mapping.values().any(|&x| x == *op))
            .collect();
        if unique_mapping.len() == 1 {
            opcode_mapping.insert(i, unique_mapping[0]);
            pos_mappings = pos_mappings.into_iter().filter(|(j, _a)| *j != i).collect();
        } else {
            panic!("mapping not unique!");
        }
    }

    let program_regex = Regex::new(r"(\d+ \d+ \d+ \d+)").unwrap();
    let program: Vec<UnknownInstruction> = program_regex
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

    let program_known: Prog = program
        .iter()
        .map(|unknown_instr| Instruction {
            op: *opcode_mapping[&unknown_instr.op],
            a: unknown_instr.a,
            b: unknown_instr.b,
            c: unknown_instr.c,
        })
        .collect();

    let init_regs = vec![0; 5];
    let mut computer = Computer::new(init_regs, 4, program_known);
    let p2 = computer.run(&SolveFor::Day16);

    (three_plus_possible_opcodes, p2)
}

#[test]
fn check_opcode_matches() {
    let exec = Execution {
        before: vec![3, 2, 1, 1],
        instr: UnknownInstruction {
            op: 9,
            a: 2,
            b: 1,
            c: 2,
        },
        after: vec![3, 2, 2, 1],
    };

    assert_eq!(matches_opcodes(&exec), vec!(Opcode::Addi, Opcode::Mulr, Opcode::Seti));
}

#[test]
fn day_16() {
    assert_eq!(run(), (646, 681));
}