#! /usr/bin/env pypy3
from . import read_as
 
NONE = 999999999999

def flood(grid, dists, start, end):
    height, width = len(grid), len(grid[0])
    cur_pos = start
    dist = 0
    path = []
    while cur_pos != end:
        dists[cur_pos[0] * height + cur_pos[1]] = dist
        path.append((cur_pos, dist))
        dist += 1
        for n in [(cur_pos[0] + 1, cur_pos[1]),(cur_pos[0] - 1, cur_pos[1]),(cur_pos[0], cur_pos[1] + 1),(cur_pos[0], cur_pos[1] - 1)]:
            if grid[n[0]][n[1]] != '#' and dists[n[0] * height + n[1]] == NONE:
                cur_pos = n
                break

    dists[cur_pos[0] * height + cur_pos[1]] = dist
    path.append((cur_pos, dist))

    return path

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

    height, width = len(grid), len(grid[0])
    dists = [NONE] * height * width # 1D array for faster accesses
    path = flood(grid, dists, start, end)

    for pos in path:
        r1, c1 = pos[0]
        next_dist = dists[r1 * height + c1]
        for delta_r in range(max(-20, -r1), min(21, height - r1)):
            for delta_c in range(max(-20 + abs(delta_r), -c1), min(21 - abs(delta_r), width - c1)):
                if delta_r == delta_c == 0: continue

                r2, c2 = r1 + delta_r, c1 + delta_c
                if dists[r2 * height + c2] == NONE: continue

                cur_dist = dists[r2 * height + c2]
                skip_len = abs(r2-r1) + abs(c2-c1)
                if (cur_dist + skip_len) <= (next_dist - 100):
                    p2 += 1
                    p1 += skip_len == 2
    return p1, p2