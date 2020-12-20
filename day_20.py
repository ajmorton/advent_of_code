import read_as
import re
import math
from copy import deepcopy
from collections import defaultdict
import itertools
from enum import Enum

# class Trans(Enum):
#     NONE = 0,
#     ROT_R = 1,
#     FLIP = 2,
#     ROT_L = 3

# def get_change(orig, new):
#     if orig == new:
#         change = Trans.NONE
#     elif orig + 1 % 4 == new:
#         change = Trans.ROT_L
#     elif orig + 2 % 4 == new:
#         change = Trans.FLIP
#     else:
#         change = Trans.ROT_R
#     return change


# def strip_and_transform(r, c, matches, filled_grid, tiles):
#     cur_tile = filled_grid[(r,c)]
#     tile_cells = tiles[cur_tile]

#     # orig_ends
#     orig_up, orig_right, orig_down, orig_left = 0,1,2,3
    
#     up = filled_grid.get((r-1, c), None) #0
#     down = filled_grid.get((r+1, c), None) #2
#     right = filled_grid.get((r, c+1), None) #1
#     left = filled_grid.get((r, c-1), None) #3
    
#     vert_change = None
#     if up is not None:
#         actual_up = [i for i in matches[cur_tile] if up in matches[cur_tile][i]][0]
#         vert_change = get_change(orig_up, actual_up)
#     else:
#         actual_down = [i for i in matches[cur_tile] if down in matches[cur_tile][i]][0]
#         vert_change = get_change(orig_down, actual_down)


#     if vert_change == Trans.NONE:
#         pass
#     elif vert_change == Trans.FLIP:
#         tile_cells = tile_cells[::-1]
#         orig_up, orig_right, orig_down, orig_left = orig_down, orig_right, orig_up, orig_left
#     elif vert_change == Trans.ROT_R:
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#         orig_up, orig_right, orig_down, orig_left = orig_left, orig_up, orig_right, orig_down
#     elif vert_change == Trans.ROT_L:
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#         orig_up, orig_right, orig_down, orig_left = orig_right, orig_down, orig_left, orig_up


#     hori_change = None
#     if left is not None:
#         actual_left = [i for i in matches[cur_tile] if left in matches[cur_tile][i]][0]
#         hori_change = get_change(orig_left, actual_left)
#     else:
#         actual_right = [i for i in matches[cur_tile] if right in matches[cur_tile][i]][0]
#         hori_change = get_change(orig_right, actual_right)

#     if hori_change == Trans.NONE:
#         pass
#     elif hori_change == Trans.FLIP:
#         tile_cells = tile_cells[::-1]
#     elif hori_change == Trans.ROT_R:
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#     elif hori_change == Trans.ROT_L:
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]
#         tile_cells = ["".join([tile_cells[x][y] for x in reversed(range(len(tile_cells[0]))) ])  for y in range(len(tile_cells)) ]


#     return [tile_cells[r][1:len(tile_cells[0])-1] for r in range(1, len(tile_cells) - 1)]
    # return tile_cells

# def fill(grid, matches, already_placed: set):
#     # pop
#     next_most_constrained = (-1,-1)
#     num_n = math.inf
#     for (r,c) in itertools.product(range(12), repeat=2):
#         if grid[(r,c)] is not None:
#             continue

#         new_n = 0
#         for m, n in itertools.product([-1, 0, 1], repeat=2):
#             if m == n == 0 or abs(m) + abs(n) > 1:
#                 continue
#             if (r + m, c + n) in grid and grid[(r+m, c+n)] is None:
#                 new_n += 1
        
#         if new_n != 0 and new_n < num_n:
#             num_n = new_n
#             next_most_constrained = (r, c)
    
#     r, c = next_most_constrained
#     if (r,c) == (-1, -1):
#         return grid

#     count_empty_neighbours = 0
#     known_neighbours = []
#     for m, n in itertools.product([-1, 0, 1], repeat=2):
#         if m == n == 0 or abs(m) + abs(n) > 1:
#             continue
#         if (r + m, c + n) in grid:
#             if grid[(r + m, c + n)] is None:
#                 count_empty_neighbours += 1
#             else:
#                 known_neighbours.append(grid[(r+m, c+n)])

#     possible_candidates = [tile for tile in matches if len(matches[tile]) == count_empty_neighbours + len(known_neighbours) and tile not in already_placed]

#     for cand in possible_candidates:
#         elig = True
#         for neighbour in known_neighbours:
#             if [neighbour] not in matches[cand].values():
#                 elig = False
#                 break

#         if elig:
#             # greedy
#             grid[(r,c)] = cand
#             already_placed.add(cand)
#             return fill(grid, matches, already_placed)


def run() -> (int, int):
    groups = read_as.groups("input/20.txt")

    tiles = {}
    tiles_foo = {}

    for tile in groups:

        tile_id = re.search("Tile ([0-9]+):", tile[0]).groups()[0]
        tile_cells = tile[1:]
        tiles_foo[tile_id] = tile_cells

        edges = [tile_cells[0], "".join([row[len(row)-1] for row in tile_cells]) , tile_cells[len(tile_cells)-1], "".join([row[0] for row in tile_cells])]
        tiles[tile_id] = edges


    matches = defaultdict(lambda: defaultdict(list))
    for t in tiles:
        for i in range(len(tiles[t])):
            edge = tiles[t][i]
            for other_t in tiles:
                if other_t != t:
                    for j in range(len(tiles[other_t])):
                        other_edge = tiles[other_t][j]
                        if edge == other_edge or edge == other_edge[::-1]:
                            matches[t][i].append(other_t)

    corners = [tile for tile in tiles if len(matches[tile]) == 2]

    prod = 1
    for corner in corners:
        prod *= int(corner)

    n = int(math.sqrt(len(tiles)))


    # P2
    # grid = {(r,c): None for r in range(n) for c in range(n)}

    # filled_grid = fill(grid, matches, set())
    # filled_grid[(n-1, n-1)] = "1657"  # hack

    # rot_grid = {}
    # for (r,c) in itertools.product(range(n), repeat=2):
    #     rot_grid[(r,c)] = strip_and_transform(r, c, matches, filled_grid, tiles_foo)

    # pic = []
    # for r in range(n):
    #     for subr in range(len(rot_grid[(r, 0)])):
    #         line = ""
    #         for c in range(n):
    #             line += rot_grid[(r,c)][subr]
    #         pic.append(line)

    # monster0 = "                  # "
    # monster1 = "#    ##    ##    ###"
    # monster2 = " #  #  #  #  #  #   "

    # monster_offsets = []
    # for i in range(len(monster0)):
    #     if monster0[i] == "#":
    #         monster_offsets.append((0, i))
    #     if monster1[i] == "#":
    #         monster_offsets.append((1, i))
    #     if monster2[i] == "#":
    #         monster_offsets.append((2, i))

    # monsters = 0
    # for r in range(len(pic) - 2):
    #     for c in range(len(pic[0]) - 19):
    #         is_hash = lambda offset: pic[r+offset[0]][c+offset[1]] == "#"
    #         if all(map(is_hash, monster_offsets)):
    #             monsters += 1

    return (prod, False)

if __name__ == "__main__":
    print(run())