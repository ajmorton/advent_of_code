#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    keys, locks = [], []
    diag_height = None
    for grid in read_as.groups("input/day25.txt"):
        assert(diag_height is None or diag_height == len(grid))
        diag_height = len(grid)

        counts = tuple([row[c] for row in grid].count('#') for c in range(len(grid[0])))
        keys.append(counts) if grid[0][0] == '#' else locks.append(counts)

    p1 = 0
    for key in keys:
        matching_locks = locks.copy()
        for i in range(0,len(key)):
            matching_locks = [lock for lock in matching_locks if key[i] + lock[i] <= diag_height]
        p1 += len(matching_locks)
    return (p1, 0)