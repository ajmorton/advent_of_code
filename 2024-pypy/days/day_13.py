#! /usr/bin/env pypy3
from . import read_as

# MAX_SCORE = 999999999999999999999

# import functools

# @functools.cache
# def cost(target, cur_pos, a, b) -> int:
#     if cur_pos[0] > target[0] or cur_pos[1] > target[1]:
#         return MAX_SCORE
#     if target == cur_pos:
#         return 0

#     tryA = cost(target, (cur_pos[0] + a[0], cur_pos[1] + a[1]), a, b)
#     tryB = cost(target, (cur_pos[0] + b[0], cur_pos[1] + b[1]), a, b)

#     if tryA < tryB:
#         return tryA + 3
#     elif tryB < tryA:
#         return tryB + 1
#     else:
#         if tryB == MAX_SCORE:
#             return MAX_SCORE
#         else:
#             return tryB + 1

def run() -> (int, int):

    p1 = p2 = 0
    groups = read_as.groups("input/day13.txt")
    for group in groups:
        buttonA = group[0]
        buttonA = buttonA.split(", ")
        buttonAX = int(buttonA[0].split(" ")[-1][2:])
        buttonAY = int(buttonA[1][2:])

        buttonB = group[1]
        buttonB = buttonB.split(", ")
        buttonBX = int(buttonB[0].split(" ")[-1][2:])
        buttonBY = int(buttonB[1][2:])

        prize = group[2]
        prize = prize.split(" ")
        prizeX = int(prize[1][2:-1])
        prizeY = int(prize[2][2:])

        # min_cost = cost((prizeX, prizeY), (0, 0), (buttonAX, buttonAY), (buttonBX, buttonBY))

        # P2 linear equations
        # (3 * numA * Ax) + (num_B * Bx) == targetX
        # (3 * numA * Ay) + (num_B * By) == targetY
     
        # (3 * numA * Ax) == targetX - (num_B * Bx) 
        # (3 * numA * Ay) == targetY - (num_B * By)

        # numA = (targetX - (num_B * Bx)) / (3 * Ax)
        # numA = (targetY - (num_B * By)) / (3 * Ay)

        # (targetX - (num_B * Bx)) / (3 * Ax) == (targetY - (num_B * By)) / (3 * Ay)

        # (targetX - (num_B * Bx)) * (3 * Ay) == (targetY - (num_B * By)) * (3 * Ax)

        # (targetX(3 * Ay) - (num_B * Bx)(3 * Ay)) == (targetY(3 * Ax) - (num_B * By)(3 * Ax))

        # (num_B * By)(3 * Ax)) - (num_B * Bx)(3 * Ay)) == (targetY(3 * Ax) - (targetX(3 * Ay)

        # (By * 3 * Ax)num_B - (Bx * 3 * Ay)numB == (targetY(3 * Ax) - (targetX(3 * Ay)

        # ((By * 3 * Ax) - (Bx * 3 * Ay))numB == (targetY(3 * Ax) - (targetX(3 * Ay)

        # numB == ((targetY(3 * Ax) - (targetX(3 * Ay)) / (((By * 3 * Ax) - (Bx * 3 * Ay)))

        def cost(prize, a, b):
            numB = ((prize[1] * a[0]) - (prize[0] * a[1])) / ((b[1] * a[0]) - (b[0] * a[1]))
            numA = (prize[0] - (numB * b[0])) / (a[0])
            numA_alt = (prize[1] - (numB * b[1])) / (a[1])

            return numA, numB

        numA, numB = cost((prizeX, prizeY), (buttonAX, buttonAY), (buttonBX, buttonBY))
        if int(round(numB,3)) == numB and int(round(numA,3)) == numA:
            p1 += int(3*numA + numB)

        numA2, numB2 = cost((prizeX + 10000000000000, prizeY + 10000000000000), (buttonAX, buttonAY), (buttonBX, buttonBY))
        if int(round(numB2,3)) == numB2 and int(round(numA2,3)) == numA2:
            p2 += int(3*numA2 + numB2)

    return (p1, p2)