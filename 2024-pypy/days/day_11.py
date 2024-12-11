#! /usr/bin/env pypy3
from . import read_as
import functools

@functools.cache
def num_stone(stone, turns):
    if turns == 1:
        return 2 if len(str(stone)) % 2 == 0 else 1
    else:
        if stone == 0:
            return num_stone(1, turns - 1)
        else:
            stone_str = str(stone)
            if len(stone_str) % 2 == 0:
                l, r = stone_str[0:len(stone_str)//2], stone_str[len(stone_str)//2:]
                return num_stone(int(l), turns - 1) + num_stone(int(r), turns - 1)
            else:
                return num_stone(stone * 2024, turns - 1)

def run() -> (int, int):
    p1 = p2 = 0
    stones = [int(n) for n in read_as.one_line("input/day11.txt").split()]
    stones_after = lambda n: sum(num_stone(s, n) for s in stones)

    return stones_after(25), stones_after(75)