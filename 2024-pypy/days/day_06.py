#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict

DIR = [(-1, 0), (0, 1), (1, 0), (0, -1)]  # Up, Right, Down, Left

def walk(grid, starting_pos, starting_dir, custom_blocker=None):
    visited = defaultdict(list)

    cur_pos, cur_dir = starting_pos, starting_dir
    height, width = len(grid), len(grid[0])

    new_blocker_makes_loop = 0
    while True:
        if cur_pos in visited and cur_dir in visited[cur_pos]:
            return None

        next_dir = DIR[cur_dir]
        next_pos = (cur_pos[0] + next_dir[0], cur_pos[1] + next_dir[1])

        visited[cur_pos].append(cur_dir)

        if not (0 <= next_pos[0] < height) or not (0 <= next_pos[1] < width):
            break
        elif grid[next_pos[0]][next_pos[1]] == '#' or next_pos == custom_blocker:
            cur_dir = (cur_dir + 1) % 4  # Turn right
        else:
            if custom_blocker is None and next_pos not in visited:
                if walk(grid, cur_pos, cur_dir, custom_blocker=next_pos) is None:
                    new_blocker_makes_loop += 1

            cur_pos = next_pos

    return len(visited), new_blocker_makes_loop

def run() -> (int, int):
    grid = read_as.grid("input/day06.txt")

    starting_pos = (-1, -1)
    for r, row in enumerate(grid):
        if '^' in row:
            starting_pos = (r, row.index('^'))

    return walk(grid, starting_pos, 0)
