#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict

def run() -> (int, int):
    p1 = p2 = 0
    grid = read_as.grid("input/day08.txt")

    antennae = defaultdict(set)

    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell != ".":
                antennae[cell].add((r, c))

    height, width = len(grid), len(grid[0])

    antis = set()
    antis2 = set()

    for ant in antennae.values():
        ant = list(ant)
        for i in range(0, len(ant)):
            for j in range(i + 1, len(ant)):
                delta = (ant[j][0] - ant[i][0], ant[j][1] - ant[i][1])

                xx = 0
                while True:
                    smaller = (ant[i][0] - delta[0]*xx, ant[i][1] - delta[1]*xx)
                    if 0 <= smaller[0] < height and 0 <= smaller[1] < width:
                        antis2.add(smaller)
                        xx += 1
                    else: 
                        break

                xx = 0
                while True:
                    larger = (ant[j][0] + delta[0]*xx, ant[j][1] + delta[1]*xx)
                    if 0 <= larger[0] < height and 0 <= larger[1] < width:
                        antis2.add(larger)
                        xx += 1
                    else: 
                        break

                # P1
                smaller = (ant[i][0] - delta[0], ant[i][1] - delta[1])
                larger = (ant[j][0] + delta[0], ant[j][1] + delta[1])

                if 0 <= smaller[0] < height and 0 <= smaller[1] < width:
                    antis.add(smaller)
                if 0 <= larger [0] < height and 0 <= larger [1] < width:
                    antis.add(larger)

    p1 = len(antis)
    p2 = len(antis2)
    return (p1, p2)
