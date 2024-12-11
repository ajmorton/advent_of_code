#! /usr/bin/env pypy3
from . import read_as
import functools

@functools.cache
def num_stone(stone, turns):
    if turns == 0:
        return 1
    elif turns == 1:
        if len(str(stone)) % 2 == 0:
            return 2
        else:
            return 1
    else:
        if len(str(stone)) % 2 == 0:
            stone_str = str(stone)
            l, r = stone_str[0:len(stone_str)//2], stone_str[len(stone_str)//2:]
            return num_stone(int(l), turns - 1) + num_stone(int(r), turns - 1)
        elif stone == 0:
            return num_stone(1, turns - 1)
        else:
            return num_stone(stone * 2024, turns - 1)

def run() -> (int, int):
    p1 = p2 = 0
    stones = [int(n) for n in read_as.one_line("input/day11.txt").split()]

    total = 0
    for stone in stones:
        total += num_stone(stone, 25)

    total2 = 0
    for stone in stones:
        total2 += num_stone(stone, 75)

    return (total, total2)