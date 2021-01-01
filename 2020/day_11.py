import read_as
import copy
from itertools import *

def get_neighbours(r, c, grid, ignore_floor):
    neighbours = []
    for m, n in product([-1, 0, 1], repeat=2):
        if m != 0 or n != 0:
            rr, cc = r + m, c + n
            while 0 <= rr < len(grid) and 0 <= cc < len(grid[0]):
                if grid[rr][cc] == "." and ignore_floor:
                    rr, cc = rr + m, cc + n
                else:
                    neighbours.append((rr, cc))
                    break
    return neighbours

def update(grid, neighbours, leave_threshold):
    new_grid = copy.deepcopy(grid)

    for r in range(len(grid)):
        for c in range(len(grid[0])):
            if grid[r][c] == "L":
                new_grid[r][c] = "#" if sum(grid[rr][cc] == "#" for (rr, cc) in neighbours[(r,c)]) == 0 else "L"
            elif grid[r][c] == "#":
                new_grid[r][c] = "L" if sum(grid[rr][cc] == "#" for (rr, cc) in neighbours[(r,c)]) >= leave_threshold else "#"
    return new_grid

def occupied_counts(grid, ignore_floor, leave_threshold):
    neighbours = {(r, c) : get_neighbours(r, c, grid, ignore_floor) for r in range(len(grid)) for c in range(len(grid[0]))}
    new_grid = update(grid, neighbours, leave_threshold)
    while grid != new_grid:
        grid, new_grid = new_grid, update(new_grid, neighbours, leave_threshold)

    return sum(row.count("#") for row in grid)

def run() -> (int, int):
    grid = read_as.grid("input/11.txt")
    return(occupied_counts(grid, False, 4), occupied_counts(grid, True, 5))

if __name__ == "__main__":
    print(run())