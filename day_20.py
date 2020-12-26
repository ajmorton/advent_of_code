import read_as
import re
from collections import defaultdict
import itertools as it
import math

top_row = lambda tile: tile[0]
right_col = lambda tile: "".join([row[-1] for row in tile])
bottom_row = lambda tile: tile[-1]
left_col = lambda tile: "".join([row[0] for row in tile])
rot_r = lambda tile: ["".join([tile[x][y] for x in reversed(range(len(tile[0]))) ])  for y in range(len(tile)) ]

def rot_and_flip_while_cond(tile, conditions):
    tile_flipped = [row[::-1] for row in tile]
    for _ in range(4):
        tile = rot_r(tile)
        if all(cond(tile) for cond in conditions):
            yield tile

        tile_flipped = rot_r(tile_flipped)
        if all(cond(tile_flipped) for cond in conditions):
                yield tile_flipped

def pop_grid(top_left, tiles, matching_edges, matches):
    grid = defaultdict(lambda: None)

    top_left_cell = next(rot_and_flip_while_cond(tiles[top_left], {lambda t: top_row(t) not in matching_edges, lambda t: left_col(t) not in matching_edges}))

    grid[(0,0)] = top_left, top_left_cell
    already_placed = set({top_left})

    n = int(math.sqrt(len(tiles)))
    for r, c in it.product(range(n), repeat=2):
        if r == c == 0:
            continue

        if grid[r-1, c] and grid[r, c-1]:
            above_id, above_cell = grid[r-1, c]
            left_id, left_cell = grid[r, c-1]
            conds = {lambda t: top_row(t) == bottom_row(above_cell), lambda t: left_col(t) == right_col(left_cell)}
            elig_tiles = [other_tile for other_tile in matches[left_id].values()] + [other_tile for other_tile in matches[above_id].values()]
        elif grid[r, c-1]:
            left_id, left_cell = grid[r, c-1]
            conds = {lambda t: left_col(t) == right_col(left_cell)}
            elig_tiles = [other_tile for other_tile in matches[left_id].values()]
        elif grid[r-1, c]:
            above_id, above_cell = grid[r-1, c]
            conds = {lambda t: top_row(t) == bottom_row(above_cell)}
            elig_tiles = [other_tile for other_tile in matches[above_id].values()]
    
        poss_tiles = [ t for t in elig_tiles if t not in already_placed ]
        for pos in poss_tiles:
            val_orientation = next(rot_and_flip_while_cond(tiles[pos], conds), None)
            if val_orientation is not None:
                grid[(r,c)] = pos, val_orientation
                already_placed.add(pos)
    return grid

def run() -> (int, int):

    tiles, tile_edges = {}, {}
    for tile_info in read_as.groups("input/20.txt"):
        tile_id = int(re.search("Tile ([0-9]+):", tile_info[0]).groups()[0])
        tile = tile_info[1:]
        tiles[tile_id] = tile

        edges = [top_row(tile), right_col(tile), bottom_row(tile), left_col(tile)]
        tile_edges[tile_id] = edges

    matching_edges = set()
    matches = defaultdict(lambda: defaultdict(list))
    for t, other_t in it.product(tile_edges, repeat=2):
        if other_t != t:
            for i in range(len(tile_edges[t])):
                edge = tile_edges[t][i]
                for j in range(len(tile_edges[other_t])):
                    other_edge = tile_edges[other_t][j]
                    if edge == other_edge or edge == other_edge[::-1]:
                        matches[t][i] = other_t
                        matching_edges.add(edge)

    corners = [tile for tile in tiles if len(matches[tile]) == 2]
    prod_corners = math.prod(c for c in corners)

    # P2
    grid = pop_grid(corners[0], tiles, matching_edges, matches)

    n = int(math.sqrt(len(tiles)))

    grid_stripped = []
    for r in range(n):
        for sub_r in range(1, len(grid[(0,0)][1])-1):
            row_str = ""
            for c in range(n):
                row_str += grid[(r,c)][1][sub_r][1:-1]
            grid_stripped.append(row_str)

    monster = [
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   "
    ]

    rollover = len(grid_stripped[0]) - len(monster[0])
    monster_regex = "(?=" + ("."*rollover).join(monster).replace(' ', ".") + ")"

    grid_rots = rot_and_flip_while_cond(grid_stripped, {lambda x: True})
    max_monsters = max([len(re.findall(monster_regex, "".join(g))) for g in grid_rots])

    roughness = "".join(grid_stripped).count("#") - max_monsters * monster_regex.count("#")

    return (prod_corners, roughness)

if __name__ == "__main__":
    print(run())