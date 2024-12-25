#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    p1 = p2 = 0
    grid = read_as.lines("input/day04.txt")
    height, width = len(grid), len(grid[0])

    # Pad the grid so we don't need bounds checking
    grid.extend(['.' * width] * 3)    
    for r, row in enumerate(grid):
        grid[r] += '...'

    for r in range(0, height):
        for c in range(0, width):
            if grid[r][c] in "XS":
                down       = grid[r][c] + grid[r+1][c  ] + grid[r+2][c  ] + grid[r+3][c  ] in ("XMAS", "SAMX")
                right      = grid[r][c] + grid[r  ][c+1] + grid[r  ][c+2] + grid[r  ][c+3] in ("XMAS", "SAMX")
                down_right = grid[r][c] + grid[r+1][c+1] + grid[r+2][c+2] + grid[r+3][c+3] in ("XMAS", "SAMX") 
                up_right   = grid[r][c] + grid[r-1][c+1] + grid[r-2][c+2] + grid[r-3][c+3] in ("XMAS", "SAMX") 
                p1 += down + right + down_right + up_right

            if grid[r][c] == 'A':
                p2 += grid[r-1][c-1] + grid[r][c] + grid[r+1][c+1] in ("MAS", "SAM") and \
                    grid[r+1][c-1] + grid[r][c] + grid[r-1][c+1] in ("MAS", "SAM")
    return (p1, p2)
