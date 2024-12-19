#! /usr/bin/env pypy3
from . import read_as

import functools

@functools.cache
def can_make(towel, colours):

    if towel in colours:
        return True
    for t in colours:
        if towel.startswith(t):
            if can_make(towel[len(t):], colours):
                return True

    return False

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
    colours, towel_list = read_as.groups("input/day19.txt")

    colours = [s.strip() for s in colours[0].split(",")]
    for towel in towel_list:
        towel = towel.strip()

        p1 += can_make(towel, tuple(colours))
        p2 += can_make2(towel, tuple(colours))

    return (p1, p2)