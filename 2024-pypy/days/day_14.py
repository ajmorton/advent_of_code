#! /usr/bin/env pypy3
from . import read_as

from time import sleep

def run() -> (int, int):
    p1, p2 = 0, 0

    robuts = []

    for line in read_as.lines("input/day14.txt"):
        pos, vel = line.split()
        posX, posY = pos.split(",")
        posX, posY = int(posX[2:]), int(posY)

        velX, velY = vel.split(",")
        velX, velY = int(velX[2:]), int(velY)

        robuts.append(((posX, posY), (velX, velY)))

    width = 101
    height = 103


    time = 100

    newRobuts = []
    # print(robuts)
    for (pos, vel) in robuts:
        newPos = ((pos[0] + time*vel[0]) % (width), (pos[1] + time*vel[1]) % (height))
        newRobuts.append(newPos)

    # print(newRobuts)/./

    quads = [0,0,0,0]
    for (x, y) in newRobuts:
        # print(x, y)
        if 0 <= x < width//2 and 0 <= y < height //2:
            quads[0] += 1
        elif 0 <= x < width//2 and y >= (height //2) + 1:
            quads[1] += 1
        elif x >= (width//2 + 1) and 0 <= y < height //2:
            quads[2] += 1
        elif x >= (width//2 + 1) and y >= (height //2) + 1:
            quads[3] += 1


    # for x in range(0, 101):

    mult = 1
    for quad in quads:
        # print(quad)
        mult *= quad

    p1 = mult
    # sleep(0.15)

    for time in range(0, 101*103 + 1):
        newRobuts = []
        for (pos, vel) in robuts:
            newPos = ((pos[0] + time*vel[0]) % (width), (pos[1] + time*vel[1]) % (height))
            newRobuts.append(newPos)

        line = False
        for robut in newRobuts:
            if (robut[0], robut[1] + 1) in newRobuts:
                if (robut[0], robut[1] + 2) in newRobuts:
                    if (robut[0], robut[1] + 3) in newRobuts:
                        if (robut[0], robut[1] + 4) in newRobuts:
                            line = True
                            break
        if line:
            for x in range(0, width):
                for y in range(0, height):
                    if (x, y) in newRobuts:
                        print(".", end='')
                    else:
                        print(" ", end='')
                print()

            print("===== ", time, "=======")
            # sleep(0.5)
            import os
            import sys
            os.system('clear')
            sys.stdout.flush()


    return (p1, 7383)