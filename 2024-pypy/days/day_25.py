#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):

    keys, locks = [], []
    for schematic in read_as.flat_groups("input/day25.txt"):
        bitmap = 0
        for cell in schematic:
            bitmap *= 2
            bitmap += cell == '#'

        (keys if (bitmap & 1) else locks).append(bitmap)

    p1 = 0
    for key in keys:
        for lock in locks:
            p1 += not key & lock

    return (p1, 0)