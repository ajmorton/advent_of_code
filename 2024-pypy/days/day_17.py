#! /usr/bin/env pypy3
from . import read_as
from .helpers import *

def combo(op, regs):
    match op:
        case 0 | 1 | 2 | 3: return op
        case 4: return regs[0]
        case 5: return regs[1]
        case 6: return regs[2]
        case 7:
            print("INVAL!!!")
            exit(1)

    print("bad", op)
    exit(1)

def run_prog(regs, instrs):
    pc = 0

    output = []
    while pc < len(instrs):

        if instrs[pc] == 4:
            op = None
        else:
            op = instrs[pc + 1]

        # print(regs, output)
        # print("pc = ", pc, " op = ", op)
        # print()
        match instrs[pc]:
            case 0: regs[0] = int(regs[0] / (2**combo(op, regs)))
            case 1: regs[1] = regs[1] ^ op
            case 2: regs[1] = combo(op, regs) % 8
            case 3:
                if regs[0] != 0:
                    pc = op
                    continue
            case 4: regs[1] = regs[1] ^ regs[2]
            case 5: output.append(combo(op, regs) % 8)
            case 6: regs[1] = int(regs[0] / (2**combo(op, regs)))
            case 7: regs[2] = int(regs[0] / (2**combo(op, regs)))
            case _: 
                print("FFFAAAAA")
                exit(1)
        pc += 2 

    return regs, output   

def run_prog2(a):
    # outputt = []
    A = a
    B = 0
    C = 0
    outputt = []
    while A != 0:
        B = (A % 8)
        B = B ^ 1
        C = int(A / (2**B))
        A = int(A / 8)
        B = B ^ C
        B = B ^ 6
        outputt.append(B % 8)

    return outputt

def run_prog3(a, most_match, expected):
    # outputt = []
    A = a
    B = 0
    C = 0
    i = 0
    outputt = []
    while A != 0:
        B = (A % 8)
        B = B ^ 1
        C = int(A / (2**B))
        A = int(A / 8)
        B = B ^ C
        B = B ^ 6
        outputt.append(B % 8)

        if outputt[i] != expected[i]:
            break
        i += 1

    if i-1 >= most_match:
        print(bin(a), outputt[:i-1])
        most_match = i - 1

    if outputt == expected:
        print("P2!!! ", a)
        exit(0)

    return most_match


def run() -> (int, int):
    p1 = p2 = 0

    reg_start, instrs = read_as.groups("input/day17.txt")

    reg_a = int(reg_start[0].split(":")[1])
    reg_b = int(reg_start[1].split(":")[1])
    reg_c = int(reg_start[2].split(":")[1])
    regs = [reg_a, reg_b, reg_c]

    instrs = instrs[0].split(" ")[1]
    instrs = list(map(int, instrs.split(",")))

    rr, ii = run_prog(regs, instrs)

    last_1 = [
        0b0,
        0b1
    ]

    # [2, 4, 1, 1, 7, 5]
    last_18 = [
        0b101001100010111010,
        0b101001100010111011,
        0b101001100010111111,
        0b101001100111111010,
        0b101001100111111011,
        0b101001100111111110,
    ]

    # [2, 4, 1, 1, 7, 5, 0, 3, 4, 3]
    last_29 = [
        0b00011101110101001100010111010,
        0b00011101110101001100010111011,
        0b00011101110101001100010111111,
        0b00011101110101001100111111010,
        0b00011101110101001100111111011,
        0b00011101110101001100111111110,
    ]

    a = 0
    most_match = 0
    while True:
        for l29 in last_29:
            most_match = run_prog3(a*(2**29) + l29, most_match, instrs)
        a += 1

    return ("2,0,7,3,0,3,1,3,7", 247839539763386)