#! /usr/bin/env pypy3
from . import read_as
 
def find_path(grid, start_node, end):

    height, width = len(grid), len(grid[0])

    to_explore = [start_node]
    dists = []
    while to_explore:
        cur_node = to_explore[0]
        to_explore = to_explore[1:]

        cur_dist, cur_pos, cur_seen = cur_node

        if cur_pos == end:
            return cur_dist, cur_seen

        for n in [(cur_pos[0] +1, cur_pos[1]),(cur_pos[0] -1, cur_pos[1]),(cur_pos[0], cur_pos[1] + 1),(cur_pos[0], cur_pos[1] - 1)]:
            if n in cur_seen:
                continue

            if 0 <= cur_pos[0] < height and 0 <= cur_pos[1] < width:
                new_seen = cur_seen.copy()
                new_seen[n] = cur_dist + 1
                if grid[n[0]][n[1]] != '#':
                    next_node = (cur_dist + 1, n, new_seen)
                    to_explore.append(next_node)

    print("nope")
    exit(1)

def run() -> (int, int):
    p1 = p2 = 0
    grid = read_as.grid("input/day20.txt")

    height, width = len(grid), len(grid[0])

    start = end = 0
    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == 'S':
                start = (r, c)
            elif cell == 'E':
                end = (r,c)

    start_node = (0, start, {start: 0})
    no_cheat_dist, path_dists = find_path(grid, start_node, end)

    saves = []
    for (pos1, dist1) in path_dists.items():
        for (pos2, dist2) in path_dists.items():
            if dist1 < dist2:
                cheat_dist = abs(abs(pos1[0] - pos2[0]) + abs(pos1[1] - pos2[1]))
                saves.append((cheat_dist, dist1 - dist2 + cheat_dist))

    p1 = [time_save for (dist, time_save) in saves if time_save <= -100 and dist == 2]
    p2 = [time_save for (dist, time_save) in saves if time_save <= -100 and dist <= 20]

    return len(p1), len(p2)