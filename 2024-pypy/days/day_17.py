#! /usr/bin/env pypy3
from . import read_as

def run_prog(A, B, C, instrs):
    pc = 0
    output = []
    while pc < len(instrs) - 1:
        combo = [0,1,2,3,A,B,C]
        match instrs[pc], instrs[pc + 1]:
            case 0, op: A = A >> combo[op]
            case 1, op: B = B ^ op
            case 2, op: B = combo[op] % 8
            case 3, op:
                if A != 0:
                    pc = op
                    continue
            case 4, op: B = B ^ C
            case 5, op: output.append(combo[op] % 8)
            case 6, op: B = int(A >> combo[op])
            case 7, op: C = int(A >> combo[op])
            case _: 
                print("unsupported opcode: ", instrs[pc])
                exit(1)
        pc += 2 

    return output   

def solve(val, depth, target) -> (bool, int):
    if depth == len(target):
        return True, val

    for try_bits in range(0, 8):
        new_a = (val << 3) + try_bits
        if run_prog(new_a, 0, 0, target) == target[-depth -1:]:
            match, p2 = solve(new_a, depth + 1, target)
            if match:
                return match, p2

    return False, -1

def run() -> (int, int):
    reg_start, instrs = read_as.groups("input/day17.txt")
    [A, B, C] = [int(line.split(':')[1]) for line in reg_start]
    instrs = [int(n) for n in instrs[0].split(" ")[1].split(",")]

    p1 = run_prog(A, B, C, instrs)
    _, p2 = solve(0, 0, instrs)
    p1 = ",".join(map(str,p1))

    return (p1, p2)