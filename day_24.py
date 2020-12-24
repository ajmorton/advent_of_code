import read_as
import re
from collections import Counter

def update(tiles, n):
    for _ in range(n):
        neighbours_black = Counter()

        for (n, e) in tiles:
            neighbours_black.update({(n, e+2), (n+1, e+1), (n-1, e+1), (n, e-2), (n+1, e-1), (n-1, e-1)})

        flip_black = set(tile for tile in neighbours_black if tile not in tiles and neighbours_black[tile] == 2)
        stay_black = set(tile for tile in neighbours_black if tile in tiles and neighbours_black[tile] in {1,2})
        tiles = flip_black.union(stay_black)

    return tiles

def run() -> (int, int):
    visited = set()

    for path in read_as.lines("input/24.txt"):
        north, east = 0, 0
        for move in re.findall("[ns]?[ew]", path):
            north, east = {
                'e':  (north,     east + 2),
                'ne': (north + 1, east + 1),
                'se': (north - 1, east + 1),
                'w':  (north,     east - 2),
                'nw': (north + 1, east - 1),
                'sw': (north - 1, east - 1)
            }[move]

        visited ^= {(north, east)}

    return (len(visited), len(update(visited, 100)))

if __name__ == "__main__":
    print(run())