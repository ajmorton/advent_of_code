#! /usr/bin/env pypy3
from . import read_as

import re
def run() -> (int, int):

    p1 = p2 = 0
    groups = read_as.groups("input/day13.txt")
    for group in groups:

        button_regex = r".*?: X\+(\d+), Y\+(\d+)"
        (_,aX,aY) = re.match(button_regex, group[0])
        (_,bX,bY) = re.match(button_regex, group[1])

        prize_regex = r".*?: X=(\d+), Y=(\d+)"
        (_,prizeX,prizeY) = re.match(prize_regex, group[2])

        a = (int(aX), int(aY))
        b = (int(bX), int(bY))
        prize = (int(prizeX), int(prizeY))

        def num_presses(prize, a, b):
            numB = ((prize[1] * a[0]) - (prize[0] * a[1])) / ((b[1] * a[0]) - (b[0] * a[1]))
            numA = (prize[0] - (numB * b[0])) / (a[0])
            numA_alt = (prize[1] - (numB * b[1])) / (a[1])

            if int(round(numB,3)) == numB and int(round(numA,3)) == numA:
                return numA, numB
            else:
                return 0, 0

        numA, numB = num_presses(prize, a, b)
        p1 += int(3*numA + numB)

        bigPrize = (prize[0] + 10000000000000, prize[1] + 10000000000000)
        numA2, numB2 = num_presses(bigPrize, a, b)
        p2 += int(3*numA2 + numB2)

    return (p1, p2)