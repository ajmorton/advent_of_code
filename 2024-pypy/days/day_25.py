#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    p1 = p2 = 0
    grids = read_as.groups("input/day25.txt")
    keys = []
    locks = []
    tot_height = len(grids[0])
    for grid in grids:
        width = len(grid[0])
        assert(len(grid) <= tot_height)
        diag = []
        for c in range(0, width):
            height = 0
            for row in grid:
                height += row[c] == '#'
            diag.append(height - 1)
        if grid[0][0] == '#':
            keys.append(diag)
        else:
            locks.append(diag)

    for key in keys:
        for lock in locks:
            first = key[0] + lock[0]
            assert(len(key) == len(lock))
            all_small = True
            for i in range(len(key)):
                if key[i] + lock[i] > tot_height - 2:
                    # print(key, lock, "NOPE")
                    all_small = False
            
            if all_small:
                # print(key, lock, "YEP")
                p1 += 1

    return (p1, p2)