#! /usr/bin/env pypy3
from . import read_as
import functools

@functools.cache
def can_make2(towel, colours):
    count = 0
    if towel == "":
        return 1

    for t in colours:
        if towel.startswith(t):
            count += can_make2(towel[len(t):], colours)
                
    return count

def run() -> (int, int):
    p1 = p2 = 0
    colours, towels = read_as.groups("input/day19.txt")
    colours = tuple(s.strip() for s in colours[0].split(","))

    possible_combos = [can_make2(towel, colours) for towel in towels]
    p1 = len([t for t in possible_combos if t > 0])
    p2 = sum(possible_combos)

    return (p1, p2)