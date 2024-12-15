#! /usr/bin/env pypy3
from . import read_as

WALL = '#'
BOX = 'O'
ROBUT = '@'
EMPTY = '.'
LEFT_BOX = '['
RIGHT_BOX = ']'

def get_boxes_up(l_box, wide_grid):
    if wide_grid[l_box - 1j] == EMPTY and wide_grid[l_box + 1 - 1j] == EMPTY:
        return [l_box]
    elif wide_grid[l_box - 1j] == WALL or wide_grid[l_box + 1 - 1j] == WALL:
        return []
    elif wide_grid[l_box - 1j] == LEFT_BOX and wide_grid[l_box + 1 - 1j] == RIGHT_BOX:
        if boxes_above := get_boxes_up(l_box - 1j, wide_grid):
            boxes_above.append(l_box)
            return boxes_above
        else:
            return []
     
    all_boxes = [l_box]
    if wide_grid[l_box - 1j] == RIGHT_BOX:
        left_boxes = get_boxes_up(l_box -1j -1, wide_grid)
        if len(left_boxes) == 0:
            return []
        else:
            all_boxes.extend(left_boxes)

    if wide_grid[l_box - 1j + 1] == LEFT_BOX:
        right_boxes = get_boxes_up(l_box -1j + 1, wide_grid)
        if len(right_boxes) == 0:
            return []
        else:
            all_boxes.extend(right_boxes)

    return all_boxes
    
def get_boxes_down(l_box, wide_grid):
    if wide_grid[l_box + 1j] == EMPTY and wide_grid[l_box + 1 + 1j] == EMPTY:
        return [l_box]
    elif wide_grid[l_box + 1j] == WALL or wide_grid[l_box + 1 + 1j] == WALL:
        return []
    elif wide_grid[l_box + 1j] == LEFT_BOX and wide_grid[l_box + 1 + 1j] == RIGHT_BOX:
        if boxes_above := get_boxes_down(l_box + 1j, wide_grid):
            boxes_above.append(l_box)
            return boxes_above
        else:
            return []
     
    all_boxes = [l_box]
    if wide_grid[l_box + 1j] == RIGHT_BOX:
        left_boxes = get_boxes_down(l_box +1j -1, wide_grid)
        if len(left_boxes) == 0:
            return []
        else:
            all_boxes.extend(left_boxes)

    if wide_grid[l_box + 1j + 1] == LEFT_BOX:
        right_boxes = get_boxes_down(l_box +1j + 1, wide_grid)
        if len(right_boxes) == 0:
            return []
        else:
            all_boxes.extend(right_boxes)

    return all_boxes
    
def run() -> (int, int):

    grid = {}
    wide_grid = {}
    groups = read_as.groups("input/day15.txt")

    height = len(groups[0])
    width = len(groups[0][0])

    height = len(groups[0])
    wide_width = len(groups[0][0]) * 2

    p1 = p2 = 0
    for r, row in enumerate(groups[0]):
        for c, cell in enumerate(row):
            if cell == '#':
                grid[r*1j + c] = WALL
                wide_grid[r*1j + 2*c] = WALL
                wide_grid[r*1j + 2*c+1] = WALL
            elif cell == '@':
                starting_pos = r*1j + c
                wide_starting_pos = r*1j + 2*c
                grid[r*1j + c] = EMPTY
                wide_grid[r*1j + 2*c] = EMPTY
                wide_grid[r*1j + 2*c+1] = EMPTY
            elif cell == 'O':
                grid[r*1j + c] = BOX
                wide_grid[r*1j + 2*c] = LEFT_BOX
                wide_grid[r*1j + 2*c+1] = RIGHT_BOX
            elif cell == '.':
                grid[r*1j + c] = EMPTY
                wide_grid[r*1j + 2*c] = EMPTY
                wide_grid[r*1j + 2*c+1] = EMPTY
            else:
                print("AAAAHHH GRID")
                exit(1)

    instrs = "".join(groups[1])

    robut_pos = starting_pos
    wide_robut_pos = wide_starting_pos
    for instr in instrs:

        dirr = 0
        if instr == '^':
            dirr = -1j
        elif instr == 'v':
            dirr = 1j
        elif instr == '>':
            dirr = 1
        elif instr == '<':
            dirr = -1
        else:
            print(f"AAAAHHH INSTR '{instr}'")
            exit(1)

        next_pos = robut_pos + dirr
        nextt = grid[next_pos]
        if nextt == EMPTY:
            robut_pos = next_pos
            continue
        elif nextt == WALL:
            continue
        elif nextt == BOX:
            num_boxes = 1
            nextt_boxes = nextt
            while grid[robut_pos + ((num_boxes + 1) * dirr)] == BOX:
                num_boxes += 1

            if grid[robut_pos + ((num_boxes + 1) * dirr)] == WALL:
                continue
            elif grid[robut_pos + ((num_boxes + 1) * dirr)] == EMPTY:
                for j in range(1, num_boxes + 1):
                    grid[robut_pos + ((j+1)*dirr)] = BOX
                grid[robut_pos + dirr] = EMPTY
                robut_pos = robut_pos + dirr
            else:
                print("AAAAHH P1 check", robut_pos + ((num_boxes + 1) * dirr), )


    num_bbb = 0
    for r in range(height):
        for c in range(wide_width):
            if wide_grid[r*1j + c] == LEFT_BOX:
                num_bbb += 1

    # P2
    for instr in instrs:

        # PRINT
        # for r in range(height):
        #     for c in range(wide_width):
        #         pics = "_#O@."
        #         if wide_robut_pos == r*1j + c:
        #             print("@", end='')
        #         else:
        #             print(wide_grid[r*1j + c], end='')
        #     print()
        # print()
        # print()

        # print("DIR == ", instr)
        dirr = 0
        if instr == '^':
            dirr = -1j
        elif instr == 'v':
            dirr = 1j
        elif instr == '>':
            dirr = 1
        elif instr == '<':
            dirr = -1
        else:
            print(f"AAAAHHH INSTR '{instr}'")
            exit(1)

        next_pos = wide_robut_pos + dirr
        nextt = wide_grid[next_pos]
        if nextt == EMPTY:
            wide_robut_pos = next_pos
            continue
        elif nextt == WALL:
            continue
        elif nextt in [LEFT_BOX, RIGHT_BOX]:
            if nextt == LEFT_BOX:
                l_box = next_pos
                r_box = next_pos + 1
            else:
                l_box = next_pos - 1
                r_box = next_pos

            num_boxes = 1

            if instr == '^':
                can_move = get_boxes_up(l_box, wide_grid)
                if can_move:
                    can_move = sorted(can_move, key= lambda b: b.imag)
                    for l_box in can_move:
                        wide_grid[l_box] = EMPTY
                        wide_grid[l_box+1] = EMPTY
                        wide_grid[l_box - 1j] = LEFT_BOX
                        wide_grid[l_box+1 - 1j] = RIGHT_BOX
                    wide_robut_pos -= 1j
            elif instr == 'v':
                can_move = get_boxes_down(l_box, wide_grid)
                if can_move:
                    can_move = sorted(can_move, key= lambda b: -b.imag)
                    for l_box in can_move:
                        wide_grid[l_box] = EMPTY
                        wide_grid[l_box+1] = EMPTY
                        wide_grid[l_box + 1j] = LEFT_BOX
                        wide_grid[l_box+1 + 1j] = RIGHT_BOX
                    wide_robut_pos += 1j
            elif instr == '>':

                while wide_grid[wide_robut_pos + (((2 * num_boxes) + 1) * dirr)] == LEFT_BOX:
                    num_boxes += 1

                if wide_grid[wide_robut_pos + (((2 * num_boxes) + 1) * dirr)] == WALL:
                    continue
                elif wide_grid[wide_robut_pos + (((2 * num_boxes) + 1) * dirr)] == EMPTY:
                    for j in range(1, 2*num_boxes + 1):
                        forward_pos = wide_robut_pos + ((j+1)*dirr)
                        wide_grid[forward_pos] = LEFT_BOX if j % 2 == 1 else RIGHT_BOX
                    wide_grid[wide_robut_pos + dirr] = EMPTY
                    wide_robut_pos = wide_robut_pos + dirr
                else:
                    print("AAAAHH P2 right", wide_robut_pos + (((2 * num_boxes) + 1) * dirr), )

            elif instr == '<':
                while wide_grid[wide_robut_pos + (((2 * num_boxes) + 1) * dirr)] == RIGHT_BOX:
                    num_boxes += 1

                if wide_grid[wide_robut_pos + (((2 * num_boxes) + 1) * dirr)] == WALL:
                    continue
                elif wide_grid[wide_robut_pos + (((2 * num_boxes) + 1) * dirr)] == EMPTY:
                    for j in range(1, 2*num_boxes + 1):
                        forward_pos = wide_robut_pos + ((j+1)*dirr)
                        wide_grid[forward_pos] = RIGHT_BOX if j % 2 == 1 else LEFT_BOX
                    wide_grid[wide_robut_pos + dirr] = EMPTY
                    wide_robut_pos = wide_robut_pos + dirr
                else:
                    print("AAAAHH P2 left", wide_robut_pos + (((2 * num_boxes) + 1) * dirr), )

    # for r in range(height):
    #     for c in range(wide_width):
    #         pics = "_#O@."
    #         if wide_robut_pos == r*1j + c:
    #             print("@", end='')
    #         else:
    #             print(wide_grid[r*1j + c], end='')
    #     print()
    # print()
    # print()


    for r in range(height):
        for c in range(width):
            if grid[r*1j + c] == BOX:
                p1 += r*100 + c


    for r in range(height):
        for c in range(wide_width):
            if wide_grid[r*1j + c] == LEFT_BOX:
                from_left = c
                from_right = 9999999
                from_top = r
                from_bottom = 99999999

                # print(f"pos = {r,c}", from_top, from_bottom, from_left, from_right)
                # print("    ", min(from_top, from_bottom), min(from_left, from_right))
                p2 += min(from_top, from_bottom)*100 + min(from_left, from_right)

    return (p1, p2)