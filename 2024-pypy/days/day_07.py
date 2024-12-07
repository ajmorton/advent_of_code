#! /usr/bin/env pypy3
from . import read_as

import itertools

def can_match(answer, inputs, operations):
    for perm in itertools.product(operations, repeat=len(inputs) - 1):
        x = inputs[0]
        for j, command in enumerate(perm):
            if command == '*':
                x *= inputs[j + 1]
            elif command == '+':
                x += inputs[j + 1]
            else:
                x = int(str(x) + str(inputs[j + 1]))

        if x == answer:
            return True
    return False

def run() -> (int, int):
    p1 = p2 = 0
    for line in read_as.lines("input/day07.txt"):
        answer, inputs = line.split(": ")
        answer = int(answer)
        inputs = list(map(int, inputs.split()))

        if can_match(answer, inputs, "*+"):
            p1 += answer

        if can_match(answer, inputs, "*+|"):
            p2 += answer

    return (p1, p2)
