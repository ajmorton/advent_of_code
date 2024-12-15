#! /usr/bin/env pypy3
from . import read_as

def move(pos, dirr, grid) -> bool:
    next_pos = (pos[0] + dirr[0], pos[1] + dirr[1])
    match grid[next_pos[0]][next_pos[1]]:
        case '.': pass
        case '#': return False
        case 'O':
            if not move(next_pos, dirr, grid): 
                return False

    grid[next_pos[0]][next_pos[1]] = grid[pos[0]][pos[1]]
    grid[pos[0]][pos[1]] = '.'
    return True

def move_p2(pos, dirr, grid, try_only = False) -> bool:
    next_pos = (pos[0] + dirr[0], pos[1] + dirr[1])
    next_cell = grid[next_pos[0]][next_pos[1]]
    match next_cell:
        case '.':
            if not try_only:
                grid[next_pos[0]][next_pos[1]] = grid[pos[0]][pos[1]]
                grid[pos[0]][pos[1]] = '.'
            return True
        case '#': 
            return False
        case '[' | ']':
            if dirr[0] == 0: # Horizontal
                if move_p2(next_pos, dirr, grid, try_only=False):
                    if not try_only:
                        grid[next_pos[0]][next_pos[1]] = grid[pos[0]][pos[1]]
                        grid[pos[0]][pos[1]] = '.'
                    return True
                else:
                    return False
            else:
                other_box = (next_pos[0], next_pos[1] + 1) if next_cell == '[' else (next_pos[0], next_pos[1] - 1)
                if not move_p2(next_pos, dirr, grid, try_only=True) or not move_p2(other_box, dirr, grid, try_only=True): 
                    return False
                else:
                    if not try_only:
                        move_p2(next_pos, dirr, grid, try_only=False)
                        move_p2(other_box, dirr, grid, try_only=False)
                        grid[next_pos[0]][next_pos[1]] = grid[pos[0]][pos[1]]
                        grid[pos[0]][pos[1]] = '.'
                    return True

def get_start_pos(grid):
    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell == '@':
                return (r,c)

def run() -> (int, int):
    double_mapping = {'.': "..", '@': "@.", '#': "##", 'O': "[]"}
    gridd, instrs = read_as.groups("input/day15.txt")

    grid = [list(row) for row in gridd]
    grid_p2 = [list("".join(double_mapping[c] for c in row)) for row in gridd]

    instrs = "".join(instrs)

    robut = get_start_pos(grid)
    robut_p2 = get_start_pos(grid_p2)
    for instr in instrs:
        dirr = [(-1, 0), (1, 0), (0, -1), (0, 1)]["^v<>".index(instr)]

        if move(robut, dirr, grid):
            robut = (robut[0] + dirr[0], robut[1] + dirr[1])

        if move_p2(robut_p2, dirr, grid_p2, try_only=False):
            robut_p2 = (robut_p2[0] + dirr[0], robut_p2[1] + dirr[1])

    p1 = sum(100*r + c for r, row in enumerate(grid)    for c, cell in enumerate(row) if cell == 'O')
    p2 = sum(100*r + c for r, row in enumerate(grid_p2) for c, cell in enumerate(row) if cell == '[')

    return (p1, p2)