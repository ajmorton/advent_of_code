#! /usr/bin/env pypy3
from . import read_as

import functools

# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+

# 179A
# <A>vA^A
#     <<vA>A>^AAA<A>vA^A
#         <<vAA>A>^AA<A>vA^AvA^A<<vA>>^AAvA^A<vA>^AA<A>A<<vA>A>^AAA<A>vA^A


NUMBERS = {
    '7': (0, 0),
    '8': (0, 1),
    '9': (0, 2),
    '4': (1, 0),
    '5': (1, 1),
    '6': (1, 2),
    '1': (2, 0),
    '2': (2, 1),
    '3': (2, 2),
    '0': (3, 1),
    'A': (3, 2)
}

#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+
DIRS = {
    '^': (0, 1),
    'A': (0, 2),
    '<': (1, 0),
    'v': (1, 1),
    '>': (1, 2),
}

# def prios(dirr):
#     match dirr:
#         case 'A': 0
#         case '^': 2
#         case '<': 4
#         case 'v': 3
#         case '>': 1

# def to_dirs(off, cur_pos_on):
#     hori_dir = '<' if off[1] < 0 else '>'
#     vert_dir = '^' if off[0] < 0 else 'v'

#     hori_cost = ((DIRS[cur_pos_on][0] - DIRS[hori_dir][0]) != 0 + (DIRS[cur_pos_on][1] - DIRS[hori_dir][1]) != 0, prios(hori_dir))
#     vert_cost = ((DIRS[cur_pos_on][0] - DIRS[vert_dir][0]) != 0 + (DIRS[cur_pos_on][1] - DIRS[vert_dir][1]) != 0, prios(vert_dir))

#     if hori_cost < vert_cost:
#         return abs(off[1]) * hori_dir + abs(off[0]) * vert_dir + 'A'
#     else:
#         return abs(off[0]) * vert_dir + abs(off[1]) * hori_dir + 'A'


# def shortest_dist_numeric(string):

#     control_str = ""

#     cur_pos_on = 'A'

#     cur_char = 'A'
#     for char in string:
#         # print("    ", char)
#         cur_pos = NUMBERS[cur_char]
#         next_pos = NUMBERS[char]

#         # print("from ", cur_char, " to ", char)

#         offset = (next_pos[0] - cur_pos[0], next_pos[1] - cur_pos[1])
#         # print("    ", char, to_dirs(offset, cur_pos_on))
#         control_str += to_dirs(offset, cur_pos_on)
#         cur_pos_on = control_str[-1]
#         cur_char = char

#     return control_str

# def shortest_dist_directional(string):

#     control_str = ""

#     cur_pos_on = 'A'

#     cur_char = 'A'
#     for char in string:
#         # print("    ", char)
#         cur_pos = DIRS[cur_char]
#         next_pos = DIRS[char]

#         # print("from ", cur_char, " to ", char)

#         offset = (next_pos[0] - cur_pos[0], next_pos[1] - cur_pos[1])
#         # print("    ", char, to_dirs(offset, cur_pos_on))
#         control_str += to_dirs(offset, cur_pos_on)
#         cur_pos_on = control_str[-1]
#         cur_char = char

#     return control_str

# def run() -> (int, int):
#     p1 = p2 = 0
#     for line in read_as.lines("input/day21.txt"):
#         one = shortest_dist_numeric(line)
#         two = shortest_dist_directional(one)
#         three = shortest_dist_directional(two)
#         print(len(three), int(line[:-1]))
#         score = len(three) * int(line[:-1])
#         p1 += score

#     return (p1, p2)


import itertools as itt
def get_paths(off):
    hori_dir = '<' if off[1] < 0 else '>'
    vert_dir = '^' if off[0] < 0 else 'v'

    # poss_paths = []
    # all_steps = (abs(off[1]) * hori_dir) + (abs(off[0]) * vert_dir)

    # for poss in itt.permutations(all_steps):
    #     poss_paths.append("".join(poss) + 'A')

    # return poss_paths

    return [ 
        (abs(off[1]) * hori_dir) + (abs(off[0]) * vert_dir) + 'A', 
        (abs(off[0]) * vert_dir) + (abs(off[1]) * hori_dir) + 'A'
    ]

import functools

@functools.cache
def compute_best_path(path, depth, numeric):
    whole_path = 0

    if depth == 0:
        return len(path)

    cur_char = 'A'
    for char in path:

        if numeric:
            cur_pos = NUMBERS[cur_char]
            next_pos = NUMBERS[char]
        else:
            cur_pos = DIRS[cur_char]
            next_pos = DIRS[char]

        offset = (next_pos[0] - cur_pos[0], next_pos[1] - cur_pos[1])
        poss_paths = get_paths(offset)

#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+

        if numeric:
            if cur_pos[0] == 3 and next_pos[1] == 0:
                poss_paths = poss_paths[1:] # don't go hori. Enters the gap
            if next_pos[0] == 3 and cur_pos[1] == 0:
                poss_paths = poss_paths[:1] # don't go vert. Enters the gap
        else:
            if cur_pos[0] == 0 and next_pos[1] == 0:
                poss_paths = poss_paths[1:] # don't go hori. Enters the gap
            if next_pos[0] == 0 and cur_pos[1] == 0:
                poss_paths = poss_paths[:1] # don't go vert. Enters the gap

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

