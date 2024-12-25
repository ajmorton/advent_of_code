#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict

DIR = [(-1, 0), (0, 1), (1, 0), (0, -1)]  # Up, Right, Down, Left
FIRST_WALK = 9999999

def walk(grid, starting_pos, starting_dir, visitedd, custom_blocker=None, cnt=FIRST_WALK):
    sub_cnt = 1
    cur_pos, cur_dir = starting_pos, starting_dir
    height, width = len(grid), len(grid[0])

    new_blocker_makes_loop = 0
    while True:
        if visitedd[cur_pos[0]][cur_pos[1]][cur_dir] >= cnt:
            return None

        next_dir = DIR[cur_dir]
        next_pos = (cur_pos[0] + next_dir[0], cur_pos[1] + next_dir[1])

        visited_pos, visited_dir = cur_pos, cur_dir

        if not (0 <= next_pos[0] < height) or not (0 <= next_pos[1] < width):
            break
        elif grid[next_pos[0]][next_pos[1]] == '#' or next_pos == custom_blocker:
            cur_dir = (cur_dir + 1) % 4  # Turn right
        else:
            if custom_blocker is None:
                if not any(dir_visit >= cnt for dir_visit in visitedd[next_pos[0]][next_pos[1]]):
                    sub_cnt += 1
                    if walk(grid, cur_pos, cur_dir, visitedd, custom_blocker=next_pos, cnt=sub_cnt) is None:
                        new_blocker_makes_loop += 1

            cur_pos = next_pos

        visitedd[visited_pos[0]][visited_pos[1]][visited_dir] = cnt

    path_len = 0
    if cnt == FIRST_WALK:
        for row in visitedd:
            for col in row:
                path_len += any(dirr == FIRST_WALK for dirr in col)

    return path_len + 1, new_blocker_makes_loop

def run() -> (int, int):
    grid = read_as.grid("input/day06.txt")

    starting_pos = (-1, -1)
    for r, row in enumerate(grid):
        if '^' in row:
            starting_pos = (r, row.index('^'))

    visitedd = [[[0] * 4 for _ in range(len(grid[0]))] for _ in range(len(grid))]

    return walk(grid, starting_pos, 0, visitedd)
