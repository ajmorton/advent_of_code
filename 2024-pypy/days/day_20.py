#! /usr/bin/env pypy3
from . import read_as
 
NONE = 999999999999

def flood(grid, dists, start, end):
    cur_pos = start
    dist = 0
    while cur_pos != end:
        dists[cur_pos[0]][cur_pos[1]] = dist
        dist += 1
        for n in [(cur_pos[0] + 1, cur_pos[1]),(cur_pos[0] - 1, cur_pos[1]),(cur_pos[0], cur_pos[1] + 1),(cur_pos[0], cur_pos[1] - 1)]:
            if grid[n[0]][n[1]] != '#' and dists[n[0]][n[1]] == NONE:
                cur_pos = n
                break

    dists[cur_pos[0]][cur_pos[1]] = dist

def run() -> (int, int):
    p1 = p2 = 0
    grid = read_as.grid("input/day20.txt")

    start = end = 0
    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == 'S':
                start = (r, c)
            elif cell == 'E':
                end = (r,c)

    dists = [[NONE for c in row] for row in grid]
    flood(grid, dists, start, end)

    height, width = len(grid), len(grid[0])
    for r1 in range(0, height):
        for c1 in range(0, width):
            if dists[r1][c1] == NONE: continue

            for delta_r in range(-20, 21):
                if not (0 <= r1 + delta_r < height): continue
                for delta_c in range(-20 + abs(delta_r), 21 - abs(delta_r)):
                    if not (0 <= c1 + delta_c < width):  continue
                    if delta_r == delta_c == 0:          continue

                    r2, c2 = r1 + delta_r, c1 + delta_c
                    if dists[r2][c2] == NONE: continue

                    cur_dist, next_dist = dists[r2][c2], dists[r1][c1]
                    skip_len = abs(r2-r1) + abs(c2-c1)
                    if (cur_dist + skip_len) <= (next_dist - 100):
                        p2 += 1
                        p1 += skip_len == 2
    return p1, p2