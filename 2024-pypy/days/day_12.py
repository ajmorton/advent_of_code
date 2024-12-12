#! /usr/bin/env pypy3
from . import read_as

# from collection import defaultdict

def explore_region(pos, gridd, seen, regions):
    to_explore = set()
    cur_region = (0, 0) # area, perim
    cur_plant_type = gridd[pos]

    area, perimeter = 0, 0
    edges = set()
    to_explore.add(pos)
    while len(to_explore) > 0:
        next_pos = to_explore.pop()
        seen.add(next_pos)
        area += 1
        for dirr, neighbour in enumerate([next_pos + 1j, next_pos -1j, next_pos +1, next_pos - 1]):
            if neighbour not in gridd or gridd[neighbour] != gridd[pos]:
                perimeter += 1
                edges.add((next_pos, dirr))
            else:
                if neighbour not in seen:
                    to_explore.add(neighbour)

    regions.append((area, perimeter, edges))

def run() -> (int, int):
    p1, p2 = 0, 0

    grid = read_as.grid("input/day12.txt")
    gridd = {}

    height = len(grid)
    width = len(grid[0])

    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            gridd[r*1j + c] = cell

    region = {}
    seen = set()
    regions = []
    for pos in gridd.keys():
        if pos not in seen:
            explore_region(pos, gridd, seen, regions)

    # print(regions)

    for (area, perim, edges) in regions:
        p1 += area * perim

        num_edges = 0
        # hori
        for r in range(0, height):
            for dirr in [0, 1]:
                on_edge = False
                for c in range(0, width):
                    if (r*1j + c, dirr) in edges:
                        if on_edge == False:
                            num_edges += 1
                            on_edge = True
                    else:
                        on_edge = False 

        # vert
        for c in range(0, width):
            for dirr in [2, 3]:
                on_edge = False
                for r in range(0, height):
                    if (r*1j + c, dirr) in edges:
                        if on_edge == False:
                            num_edges += 1
                            on_edge = True
                    else:
                        on_edge = False 
        p2 += area * num_edges

    return (p1, p2)