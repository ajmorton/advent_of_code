import read_as
import itertools as it
from collections import defaultdict
import re

def update(orig_tiles):
    black_neighbours = defaultdict(int)

    for (ns, ew) in orig_tiles:
        black_neighbours[(ns, ew - 2)] += 1
        black_neighbours[(ns, ew + 2)] += 1
        black_neighbours[(ns + 1, ew - 1)] += 1
        black_neighbours[(ns - 1, ew - 1)] += 1
        black_neighbours[(ns + 1, ew + 1)] += 1
        black_neighbours[(ns - 1, ew + 1)] += 1

    next_day = set()
    for tile in black_neighbours:
        if tile in orig_tiles and black_neighbours[tile] in {1,2}:
            next_day.add(tile)
        elif tile not in orig_tiles and black_neighbours[tile] == 2:
            next_day.add(tile)

    return next_day

def run() -> (int, int):
    lines = read_as.lines("input/24.txt")

    visited = set()

    next_dir = ""
    for path in lines:
        cur_ew, cur_ns = 0, 0
        for char in path:
            next_dir += char
            if next_dir == 'e':
                cur_ew += 2
            elif next_dir == 'se':
                cur_ew += 1
                cur_ns -= 1
            elif next_dir == 'sw':
                cur_ew -= 1
                cur_ns -= 1
            elif next_dir == 'w':
                cur_ew -= 2
            elif next_dir == 'nw':
                cur_ew -= 1
                cur_ns += 1
            elif next_dir == 'ne':
                cur_ew += 1
                cur_ns += 1
            else:
                continue

        
            next_dir = ""
        if (cur_ns, cur_ew) in visited:
            visited.remove((cur_ns, cur_ew))
        else:
            visited.add( (cur_ns, cur_ew) )

    p1 = len(visited)

    for i in range(100):
        visited = update(visited)

    return (p1, len(visited))

if __name__ == "__main__":
    print(run())