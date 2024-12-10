#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    starting_points = []
    grid = {}

    for r, row in enumerate(read_as.lines("input/day10.txt")):
        for c, cell in enumerate(row):
            if cell == '0':
                starting_points.append(r*1j + c)
            grid[r*1j + c] = int(cell)

    p1, p2 = 0, 0
    for start in starting_points:
        to_search = [start]
        trail_heads = []
        while len(to_search) > 0:
            cur_pos = to_search.pop()

            if grid[cur_pos] == 9:
                trail_heads.append(cur_pos)
                continue
            
            for next_pos in [cur_pos + 1j, cur_pos - 1j, cur_pos + 1, cur_pos - 1]:
                if next_pos in grid and (grid[next_pos] - grid[cur_pos]) == 1:
                    to_search.append(next_pos)

        p1 += len(set(trail_heads))
        p2 += len(trail_heads)

    return (p1, p2)