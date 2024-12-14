#! /usr/bin/env pypy3
from . import read_as

from time import sleep
import re

def run() -> (int, int):
    p1, p2 = 0, 0

    robuts = []
    line_regex = re.compile(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)")
    for line in read_as.lines("input/day14.txt"):
        (_, posX, posY, velX, velY) = line_regex.match(line)
        robuts.append(((int(posX), int(posY)), (int(velX), int(velY))))

    height, width = 103, 101

    seen = [[0 for _ in range(width)] for _ in range(height)]

    for time in range(0, height*width + 1):
        quadrant = [[0,0],[0,0]]
        no_overlaps = True
        for (pos, vel) in robuts:
            newPos = ((pos[0] + time*vel[0]) % (width), (pos[1] + time*vel[1]) % (height))
            if seen[newPos[1]][newPos[0]] == time:
                no_overlaps = False
                if time != 100:
                    break
            else:
                seen[newPos[1]][newPos[0]] = time
        
            # P1
            if time == 100:
                x, y = newPos
                if x == width // 2 or y == height // 2:
                    # Ignore the center lines
                    continue
                else:
                    quadrant[x > width // 2][y > height // 2] += 1

        # P1
        if time == 100:
            p1 = quadrant[0][0] * quadrant[0][1] * quadrant[1][0] * quadrant[1][1]

        # P2
        # **Heavy** assumption: The pattern appears the first time no robuts overlap.
        if no_overlaps:
            p2 = time

        if p1 and p2:
            break

    return (p1, p2)