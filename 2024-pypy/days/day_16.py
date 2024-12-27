#! /usr/bin/env pypy3
from . import read_as
from heapq import *
from collections import defaultdict

U, R, D, L = 0, 1, 2, 3
DIRS = [(-1,0), (0,1), (1,0), (0,-1)] # U, R, D, L

def find_spots_on_shortest_paths(end_node, predecessors):
    nodes_on_shortest_paths = [end_node[0]]
    preds = predecessors[end_node]
    while preds:
        pred = preds.pop()
        nodes_on_shortest_paths.append(pred)
        preds.extend(predecessors[pred])
    positions_only = [p for (p, dirr) in nodes_on_shortest_paths]
    return set(positions_only)

def search(start_pos, end_pos, grid):
    seen = [[[999999999999999 for _ in DIRS] for _ in grid[0]] for _ in grid]
    seen[start_pos[0]][start_pos[1]][R] = 0

    to_explore = [(0, start_pos, R, [(start_pos, R)])]
    heapify(to_explore)

    best_dist = 999999999999999
    predecessors = defaultdict(list)

    while to_explore:
        cur_dist, cur_pos, cur_dir, cur_path = heappop(to_explore)

        if cur_dist >= best_dist:
            break

        if cur_pos == end_pos:
            # Shortest path found.
            best_dist = cur_dist
            spots_on_paths = find_spots_on_shortest_paths((end_pos, cur_dir), predecessors)
            return best_dist, spots_on_paths

        next_nodes = []
        forward = (cur_dist + 1, ((cur_pos[0] + DIRS[cur_dir][0], cur_pos[1] + DIRS[cur_dir][1])), cur_dir)
        if grid[forward[1][0]][forward[1][1]] != '#':
            next_nodes.append(forward)

        to_left = cur_pos[0] + DIRS[(cur_dir - 1) % 4][0], cur_pos[1] + DIRS[(cur_dir - 1) % 4][1]
        if grid[to_left[0]][to_left[1]] != '#':
            left = (cur_dist + 1000, cur_pos, (cur_dir - 1) % 4)
            next_nodes.append(left)

        to_right = cur_pos[0] + DIRS[(cur_dir + 1) % 4][0], cur_pos[1] + DIRS[(cur_dir + 1) % 4][1]
        if grid[to_right[0]][to_right[1]] != '#':
            right = (cur_dist + 1000, cur_pos, (cur_dir + 1) % 4)
            next_nodes.append(right)

        for next_dist, next_pos, next_dir in next_nodes:
            if next_dist < seen[next_pos[0]][next_pos[1]][next_dir]:
                seen[next_pos[0]][next_pos[1]][next_dir] = next_dist
                heappush(to_explore, (next_dist, next_pos, next_dir, []))
                predecessors[(next_pos, next_dir)] = [(cur_pos, cur_dir)]
            elif next_dist == seen[next_pos[0]][next_pos[1]][next_dir]:
                predecessors[(next_pos, next_dir)].append((cur_pos, cur_dir))

    assert(False) # No solution found

def run() -> (int, int):
    grid = read_as.grid("input/day16.txt")

    start_pos = end_pos = None
    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == 'S': start_pos = (r, c)
            if cell == 'E': end_pos = (r, c)

    ret = search(start_pos, end_pos, grid)

    return ret[0], len(ret[1])
