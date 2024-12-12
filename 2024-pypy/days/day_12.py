#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    p1, p2 = 0, 0
    grid = read_as.grid("input/day12.txt")

    height, width = len(grid), len(grid[0])
    in_grid = lambda pos: 0 <= pos[0] < height and 0 <= pos[1] < width
    seen = [[False] * width for _ in range(0, height)]

    for rr in range(0, len(grid)):
        for cc in range(0, len(grid[0])):
            if not seen[rr][cc]:
                plant_type = grid[rr][cc]
                area, perimeter, corners = 0, 0, 0

                to_explore = {(rr, cc)}
                while to_explore:
                    r,c = to_explore.pop()
                    seen[r][c] = True
                    area += 1
                    neighbours = [(r + 1, c), (r,c + 1), (r - 1,c), (r,c - 1)]
                    cant_reachh = lambda pos: not in_grid(pos) or grid[pos[0]][pos[1]] != plant_type
                    cant_reach = [cant_reachh(neighbours[i]) for i in range(0, 4)]
                    for i in range(0, 4):
                        if cant_reach[i]:
                            perimeter += 1
                            corners += cant_reach[(i + 1) % 4]
                        else:
                            if not seen[neighbours[i][0]][neighbours[i][1]]:
                                to_explore.add(neighbours[i])
                            if not cant_reach[(i + 1) % 4]:
                                foo = [(r+1,c+1), (r-1,c+1), (r-1, c-1), (r+1,c-1)]
                                if grid[foo[i][0]][foo[i][1]] != plant_type:
                                    corners += 1

                p1 += area * perimeter
                p2 += area * corners

    return (p1, p2)