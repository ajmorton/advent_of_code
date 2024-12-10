#! /usr/bin/env pypy3
from . import read_as

def search(gridd, starting_pos, trail_heads):

    seen = set()
    trail_heads = set()
    to_search = [starting_pos]
    while len(to_search) > 0:
        cur_pos = to_search.pop()

        if cur_pos in seen:
            continue
        else:
            seen.add(cur_pos)

        if gridd[cur_pos] == 9:
            trail_heads.add(cur_pos)
            continue
        
        for next_pos in [cur_pos + 1j, cur_pos - 1j, cur_pos + 1, cur_pos - 1]:
            if next_pos in gridd and (gridd[next_pos] - gridd[cur_pos]) in [1]:
                to_search.append(next_pos)

    return len(trail_heads)

def search2(gridd, starting_pos, trail_heads):

    seen = set()
    score = 0
    trail_heads = set()
    to_search = [starting_pos]
    while len(to_search) > 0:
        cur_pos = to_search.pop()

        # if cur_pos in seen:
        #     continue
        # else:
        #     seen.add(cur_pos)

        if gridd[cur_pos] == 9:
            # trail_heads.add(cur_pos)
            score += 1
            continue
        
        for next_pos in [cur_pos + 1j, cur_pos - 1j, cur_pos + 1, cur_pos - 1]:
            if next_pos in gridd and (gridd[next_pos] - gridd[cur_pos]) in [1]:
                to_search.append(next_pos)

    return score


def run() -> (int, int):
    p1 = p2 = 0
    grid = read_as.grid("input/day10.txt")

    trail_heads = set()
    starting_points = set()

    gridd = {}

    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == '9':
                trail_heads.add(r*1j + c)
            elif cell == '0':
                starting_points.add(r*1j + c)
            # cast to ints
            gridd[r*1j + c] = int(cell)

    p1 = 0
    for starting_point in starting_points:
        score = search(gridd, starting_point, trail_heads)
        p1 += score


    p2 = 0
    for starting_point in starting_points:
        score = search2(gridd, starting_point, trail_heads)
        p2 += score



    return (p1, p2)
