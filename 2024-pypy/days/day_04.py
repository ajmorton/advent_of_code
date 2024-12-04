#! /usr/bin/env pypy3
from . import read_as
import re
import itertools as itools

def run() -> (int, int):
    p1 = p2 = 0

    grid = read_as.grid("input/day04.txt")

    for r in range(0, len(grid) - 3):
        for c in range(0, len(grid[r])):
            down = grid[r][c] + grid[r+1][c] + grid[r+2][c] + grid[r+3][c] 
            if down == "XMAS" or down == "SAMX":
                p1 += 1

    for r in range(0, len(grid)):
        for c in range(0, len(grid[r]) - 3):
            right = grid[r][c] + grid[r][c+1] + grid[r][c+2] + grid[r][c+3] 
            if right == "XMAS" or right == "SAMX":
                p1 += 1

    for r in range(0, len(grid) - 3):
        for c in range(0, len(grid[r]) - 3):
            down_right = grid[r][c] + grid[r+1][c+1] + grid[r+2][c+2] + grid[r+3][c+3] 
            if down_right == "XMAS" or down_right == "SAMX":
                p1 += 1

    for r in range(3, len(grid)):
        for c in range(0, len(grid[r]) - 3):
            up_right = grid[r][c] + grid[r-1][c+1] + grid[r-2][c+2] + grid[r-3][c+3] 
            if up_right == "XMAS" or up_right == "SAMX":
                p1 += 1

    for r in range(1, len(grid) - 1):
        for c in range(1, len(grid[r]) - 1):
            if grid[r][c] == 'A':
                if ((grid[r-1][c-1] == 'M' and grid[r+1][c+1] == 'S') or (grid[r-1][c-1] == 'S' and grid[r+1][c+1] == 'M')) and \
                   ((grid[r+1][c-1] == 'M' and grid[r-1][c+1] == 'S') or (grid[r+1][c-1] == 'S' and grid[r-1][c+1] == 'M')):
                    p2 += 1

    return (p1, p2)
