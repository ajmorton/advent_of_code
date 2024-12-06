#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict


def walk(grid, starting_pos) -> int:
    visited = set()
    starting_dir = 1j

    cur_pos = starting_pos
    cur_dir = starting_dir

    no_prog = 0

    while True:
        no_prog += 1
        if cur_pos not in visited:
            no_prog = 0

        visited.add(cur_pos)
        next_pos = cur_pos + cur_dir

        if next_pos not in grid.keys():
            break
        elif grid[next_pos]:
            # can't move, turn instead
            cur_dir = cur_dir * -1j
        else:
            cur_pos = cur_dir + cur_pos

        if no_prog > 1000:
            return -1

    return len(visited)

def run() -> (int, int):
    p1 = p2 = 0
    grid = defaultdict(bool)

    starting_pos = 0j
    for r, row in enumerate(read_as.lines("input/day06.txt")):
        for c, val in enumerate(row):
            if val == '^':
                starting_pos = -1j*r + c
                grid[r*-1j + c] = False
            elif val == '#':
                grid[r*-1j + c] = True
            else:
                grid[r*-1j + c] = False

    p1 = walk(grid.copy(), starting_pos)

    n = 0
    for pos in grid.keys():
        n+=1
        print(f"{n=} of {len(grid)}")
        if pos != starting_pos:
            new_grid = grid.copy()
            new_grid[pos] = True
            if walk(new_grid, starting_pos) == -1:
                p2 += 1

    return (p1, p2)
