#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict
import itertools

def run() -> (int, int):
    grid = read_as.grid("input/day08.txt")
    height, width = len(grid), len(grid[0])

    antennae_sets = defaultdict(list)
    for r, row in enumerate(grid):
        {antennae_sets[cell].append((r, c)) for c, cell in enumerate(row) if cell != "."}

    p1, p2 = set(), set()
    for ant_set in antennae_sets.values():
        for (ant1, ant2) in itertools.combinations(ant_set, 2):
            delta = (ant2[0] - ant1[0], ant2[1] - ant1[1])

            for dir in [-1, 1]:
                xx = 0
                while True:
                    step = xx * dir
                    antinode = (ant1[0] + delta[0]*step, ant1[1] + delta[1]*step)
                    if 0 <= antinode[0] < height and 0 <= antinode[1] < width:
                        if step in [-1, 2]: # One step before ant1, or one step after ant2
                            p1.add(antinode)
                        p2.add(antinode)
                        xx += 1
                    else: 
                        break

    return (len(p1), len(p2))
