# FIXME - This is 2019 Day 02

import strutils, sequtils

proc runProg(prog: seq[int], noun: int, verb: int): int =

    const ADD = 1
    const MUL = 2
    const END = 99

    var mem = prog

    mem[1] = noun
    mem[2] = verb

    var i = 0
    while i < mem.len:
        let op = mem[i]
        if op == END:
            break

        let r1 = mem[i+1]
        let r2 = mem[i+2]
        let out_reg = mem[i+3]

        case op
        of ADD:
            mem[out_reg] = mem[r1] + mem[r2]
        of MUL:
            mem[out_reg] = mem[r1] * mem[r2]
        else:
            quit "Unexpected"

        i += 4

    return mem[0]

proc part1*(mem: seq[int]): int =
    return runProg(mem, 12, 02);

proc part2*(mem: seq[int]): int =
    for noun in 0..99:
        for verb in 0..99:
            if runProg(mem, noun, verb) == 19690720:
                return (noun * 100) + verb
    
    return -1

proc run*(input_file: string): (int, int) =
    let input = readFile(input_file).strip(leading = false)
    var mem = input.split(',').map(parseInt)
    return (part1(mem), part2(mem))