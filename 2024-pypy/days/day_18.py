#! /usr/bin/env pypy3
from . import read_as

def find_path(grid, start, end):

    seen = set()
    to_explore = [(start, 0)]
    while len(to_explore) > 0:
        cur_pos, cur_steps = to_explore[0]
        to_explore = to_explore[1:]

        if cur_pos == end:
            return cur_steps

        for n in [(cur_pos[0] + 1, cur_pos[1]), (cur_pos[0] - 1, cur_pos[1]), (cur_pos[0], cur_pos[1] + 1), (cur_pos[0], cur_pos[1] - 1)]:
            if 0 <= n[0] <= 70 and 0 <= n[1] <= 70 and n not in grid and n not in seen:
                seen.add(n)
                to_explore.append((n, cur_steps+1))

    return -1            

def run() -> (int, int):
    p1 = p2 = 0
    grid = {}
    bytess = []

    for line in read_as.lines("input/day18.txt"):
        x,y = line.split(',')
        x,y = int(x), int(y)
        bytess.append((x, y))

    for (x,y) in bytess[0:1024]:
        grid[(x,y)] = True

    p1 = find_path(grid, (0,0), (70,70))

    for (x, y) in bytess[1024:]:
        grid[(x,y)] = True
        if find_path(grid, (0,0), (70,70)) == -1:
            p2 = (x, y)
            break

    return p1, p2
