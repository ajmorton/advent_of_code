#! /usr/bin/env pypy3
from . import read_as
from heapq import *

U, R, D, L = 0, 1, 2, 3
DIRS = [(-1,0), (0,1), (1,0), (0,-1)] # U, R, D, L

def search(start_pos, end_pos, grid):
    seen = [[[999999999999999 for _ in DIRS] for _ in grid[0]] for _ in grid]

    to_explore = [(0, start_pos, R, [start_pos]), (1000, start_pos, D, [start_pos]), (1000, start_pos, U, [start_pos])]
    heapify(to_explore)

    best_dist = 999999999999999
    all_spots = set()

    while to_explore:
        cur_dist, cur_pos, cur_dir, cur_path = heappop(to_explore)

        if cur_dist > best_dist:
            break

        if cur_pos == end_pos:
            if cur_dist < best_dist:
                best_dist = cur_dist
                all_spots = set(cur_path)
                all_spots.add(end_pos)
            elif cur_dist == best_dist:
                for spot in cur_path:
                    all_spots.add(spot)
        else:

            # Walk to end
            num_steps = 1
            interim_positions = []
            while True:
                next_pos = (cur_pos[0] + num_steps * DIRS[cur_dir][0], cur_pos[1] + num_steps * DIRS[cur_dir][1])
                next_dist = cur_dist + num_steps
                interim_positions.append(next_pos)
                if grid[next_pos[0]][next_pos[1]] != '#':
                    if grid[(next_pos[0] + DIRS[cur_dir][0])][(next_pos[1] + DIRS[cur_dir][1])] == '#':
                        # About to hit wall
                        if next_dist <= seen[next_pos[0]][next_pos[1]][cur_dir]:
                            seen[next_pos[0]][next_pos[1]][cur_dir] = next_dist
                            new_path = cur_path + interim_positions
                            heappush(to_explore, (next_dist, next_pos, cur_dir, new_path))
                else:
                    # In a wall
                    break

                next_dist_turn = next_dist + 1000
                for turn in [(cur_dir - 1) % 4, (cur_dir + 1) % 4]:
                    if grid[next_pos[0] + DIRS[turn][0]][next_pos[1] + DIRS[turn][1]] != '#':
                        if next_dist_turn <= seen[next_pos[0]][next_pos[1]][turn]:
                            seen[next_pos[0]][next_pos[1]][turn] = next_dist_turn
                            new_path = cur_path + interim_positions
                            heappush(to_explore, (next_dist_turn, next_pos, turn, new_path))
    
                num_steps += 1

    return best_dist, len(all_spots)

def run() -> (int, int):
    grid = read_as.grid("input/day16.txt")

    start_pos = end_pos = None
    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == 'S': start_pos = (r, c)
            if cell == 'E': end_pos = (r, c)

    return search(start_pos, end_pos, grid)
