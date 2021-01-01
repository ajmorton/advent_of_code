import read_as
from collections import defaultdict
from copy import deepcopy
import itertools

def run() -> (int, int):
    slice = read_as.grid("input/17.txt")

    state = defaultdict(lambda: (False,False))

    for r in range(len(slice)):
        for c in range(len(slice[0])):
            state[(0, r, c, 0)] = (slice[r][c] == "#", slice[r][c] == "#")

    init_r, init_c = len(slice), len(slice[0])

    cycle = 1
    while cycle <= 6:
        next_state = defaultdict(lambda: (False,False))

        for z, r, c, d in itertools.product(range(-cycle, cycle +1), range(-cycle, init_r + cycle + 1), range(-cycle, init_c + cycle + 1), range(-cycle, cycle+1)):
            neighbours_3d, neighbours_4d = 0, 0
            for m,n,o,p in itertools.product([-1, 0, 1], repeat=4):
                if not (m == n == o == p == 0):
                    neighbours_4d += state[(z+m, r+n, c+o, d+p)][1]
                    if d == p == 0:
                        neighbours_3d += state[(z+m, r+n, c+o, d+p)][0]

            cube_3d_active = (state[(z,r,c,d)][0] and neighbours_3d in {2,3}) or (not state[(z,r,c,d)][0] and neighbours_3d == 3)
            cube_4d_active = (state[(z,r,c,d)][1] and neighbours_4d in {2,3}) or (not state[(z,r,c,d)][1] and neighbours_4d == 3)
            next_state[(z,r,c,d)] = (cube_3d_active, cube_4d_active)

        state = next_state
        cycle += 1

    total_3d_cubes = sum( [state[coord][0] for coord in state] )
    total_4d_cubes = sum( [state[coord][1] for coord in state] )

    return (total_3d_cubes, total_4d_cubes)

if __name__ == "__main__":
    print(run())