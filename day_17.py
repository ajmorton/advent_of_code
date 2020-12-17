import read_as
import re
from math import inf
from collections import defaultdict
from copy import deepcopy

def run() -> (int, int):
    slice = read_as.grid("input/17.txt")

    state = defaultdict(int)

    for r in range(len(slice)):
        for c in range(len(slice[0])):
            state[(0, r, c, 0)] = slice[r][c] == "#" 

    min_z, max_z = 0, 0
    min_r, max_r = 0, len(slice)
    min_c, max_c = 0, len(slice[0])
    min_d, max_d = 0, 0

    cycle = 1
    while cycle <= 6:

        next_state = defaultdict(int)

        for z in range(min_z - 1, max_z + 2):
            for r in range(min_r -1, max_r + 2):
                for c in range(min_c -1,  max_c + 2):
                    for d in range(min_d -1, max_d + 2):
                        neigbours = 0
                        for m in [-1, 0, 1]:
                            for n in [-1, 0, 1]:
                                for o in [-1, 0, 1]:
                                    for p in [-1, 0, 1]:
                                        if m == n == o == p == 0:
                                            continue
                                        else:
                                            neigbours += state[(z+m,r+n,c+o,d+p)]
                        if state[(z,r,c,d)] == True and neigbours not in {2,3}:
                            next_state[(z,r,c,d)] = False
                        elif state[(z,r,c,d)] == False and neigbours == 3:
                            next_state[(z,r,c,d)] = True
                        else:
                            next_state[(z,r,c,d)] = state[(z,r,c,d)]

        state = next_state
        min_z, max_z = min_z - 1, max_z + 1
        min_r, max_r = min_r - 1, max_r + 1
        min_c, max_c = min_c - 1, max_c + 1
        min_d, max_d = min_d - 1, max_d + 1
        cycle += 1

    p1 = 336
    total_cubes = sum(state.values())

    return (p1, total_cubes)

if __name__ == "__main__":
    print(run())