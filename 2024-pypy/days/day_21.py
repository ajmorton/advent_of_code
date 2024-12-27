#! /usr/bin/env pypy3
from . import read_as

import functools

NUMBERS = { '7': (0, 0), '8': (0, 1), '9': (0, 2),
            '4': (1, 0), '5': (1, 1), '6': (1, 2),
            '1': (2, 0), '2': (2, 1), '3': (2, 2),
                         '0': (3, 1), 'A': (3, 2)}

DIRS = {              '^': (0, 1), 'A': (0, 2),
         '<': (1, 0), 'v': (1, 1), '>': (1, 2)}

# Cheapest paths will always have the min number of turns
def get_paths(off):
    hori_dir = '<' if off[1] < 0 else '>'
    vert_dir = '^' if off[0] < 0 else 'v'

    return [ 
        (abs(off[1]) * hori_dir) + (abs(off[0]) * vert_dir) + 'A', 
        (abs(off[0]) * vert_dir) + (abs(off[1]) * hori_dir) + 'A'
    ]

@functools.cache
def compute_best_path(path, depth, numeric):
    whole_path = 0

    if depth == 0:
        return len(path)

    cur_char = 'A'
    for char in path:

        pad = NUMBERS if numeric else DIRS
        cur_pos = pad[cur_char]
        next_pos = pad[char]

        offset = (next_pos[0] - cur_pos[0], next_pos[1] - cur_pos[1])
        poss_paths = get_paths(offset)

        # Remove paths that would enter the gap.
        match numeric, cur_pos, next_pos:
            case True,  (3, _), (_, 0): poss_paths = poss_paths[1:]
            case True,  (_, 0), (3, _): poss_paths = poss_paths[:1]
            case False, (0, _), (_, 0): poss_paths = poss_paths[1:]
            case False, (_, 0), (0, _): poss_paths = poss_paths[:1]

        best_path_score = min(map(lambda p: compute_best_path(p, depth - 1, False), poss_paths))
        whole_path += best_path_score

        cur_char = char

    return whole_path

def run() -> (int, int):
    p1 = p2 = 0

    for line in read_as.lines("input/day21.txt"):
        best_path_cost = compute_best_path(line, 3, True)
        p1 += best_path_cost * int(line[:-1])

        best_path_cost_p2 = compute_best_path(line, 26, True)
        p2 += best_path_cost_p2 * int(line[:-1])

    return (p1, p2)
