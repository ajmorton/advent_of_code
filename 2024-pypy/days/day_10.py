#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    starting_pointss = []

    g = read_as.lines("input/day10.txt")
    g = [list(map(int, line)) for line in g]

    height, width = len(g), len(g[0])
    for r, row in enumerate(g):
        for c, cell in enumerate(row):
            if cell == 0:
                starting_pointss.append((r, c))

    p1, p2 = 0, 0
    for start in starting_pointss:
        to_search = [start]
        trail_heads = []
        while len(to_search) > 0:
            cur_pos = to_search.pop()

            if g[cur_pos[0]][cur_pos[1]] == 9:
                trail_heads.append(cur_pos)
                continue
            
            for next_pos in [(cur_pos[0] + 1, cur_pos[1]),(cur_pos[0] - 1, cur_pos[1]),(cur_pos[0], cur_pos[1] + 1),(cur_pos[0], cur_pos[1] - 1)]:
                if 0 <= next_pos[0] < height and 0 <= next_pos[1] < width and (g[next_pos[0]][next_pos[1]] - g[cur_pos[0]][cur_pos[1]]) == 1:
                    to_search.append(next_pos)

        p1 += len(set(trail_heads))
        p2 += len(trail_heads)

    return (p1, p2)