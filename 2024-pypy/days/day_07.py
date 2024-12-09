#! /usr/bin/env pypy3
from . import read_as
import functools

@functools.cache
def can_score(target, inputs, is_p2):
    if len(inputs) == 0: return False
    if len(inputs) == 1: return inputs[0] == target

    if can_mul := target % inputs[-1] == 0 and can_score(target // inputs[-1], inputs[:-1], is_p2): 
        return True
    if can_add := can_score(target - inputs[-1], inputs[:-1], is_p2): 
        return True

    if(is_p2):
        target_str, inp_str = str(target), str(inputs[-1])
        if target_str.endswith(inp_str) and target_str != inp_str:
            if is_concat := can_score(int(target_str[:-len(inp_str)]), inputs[:-1], is_p2):
                return True

    return False

def run() -> (int, int):
    p1 = p2 = 0
    for line in read_as.lines("input/day07.txt"):
        answer, inputs = line.split(": ")
        answer, inputs = int(answer), tuple(map(int, inputs.split()))

        p1 += answer if can_score(answer, inputs, False) else 0
        p2 += answer if can_score(answer, inputs, True) else 0

    return (p1, p2)
