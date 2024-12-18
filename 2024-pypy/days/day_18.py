#! /usr/bin/env pypy3
from . import read_as

def find_path(start, end, bb, i):

    seen = set()
    to_explore = [(start, 0)]
    while len(to_explore) > 0:
        cur_pos, cur_steps = to_explore[0]
        to_explore = to_explore[1:]

        if cur_pos == end:
            return cur_steps

        for n in [(cur_pos[0] + 1, cur_pos[1]), (cur_pos[0] - 1, cur_pos[1]), (cur_pos[0], cur_pos[1] + 1), (cur_pos[0], cur_pos[1] - 1)]:
            if 0 <= n[0] <= 70 and 0 <= n[1] <= 70 and bb[n[0]][n[1]] > i and n not in seen:
                seen.add(n)
                to_explore.append((n, cur_steps+1))

    return -1            

def run() -> (int, int):
    p1 = p2 = 0

    bytess = []
    bb = [[ 99999999 for c in range(0, 71)] for r in range(0, 71)]
    for i, line in enumerate(read_as.lines("input/day18.txt")):
        x, y = map(int, line.split(','))
        bb[x][y] = i + 1
        bytess.append((x,y))

    p1 = find_path((0,0), (70,70), bb, 1024)

    l, r = 0, len(bytess) - 1
    while l < r - 1:
        center = l + (r - l)//2
        res = find_path((0,0), (70,70), bb, center)
        l, r = (l, center) if res == -1 else (center, r)

    return p1, bytess[l]
