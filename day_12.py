import read_as
import copy
from itertools import *

class Ship():
    def __init__(self):
        self.heading = 1 # NESW == {0,1,2,3}
        self.posx = 0
        self.posy = 0

    def move(self, command, val):
        if command == "N":
            self.posy += val
        elif command == "E":
            self.posx += val
        elif command == "S":
            self.posy -= val
        elif command == 'W':
            self.posx -= val
        elif command == "L":
            to_turn = val // 90
            self.heading -= to_turn
            if self.heading < 0:
                self.heading = 4 + self.heading
        elif command == "R":
            to_turn = val // 90
            self.heading = (self.heading + to_turn) % 4
        elif command == "F":
            direction = {0:"N", 1:"E", 2:"S", 3:"W"}[self.heading]
            self.move(direction, val)
        else:
            print("ERROR")

class ShipWP():
    def __init__(self):
        self.heading = 1 # NESW == {0,1,2,3}
        self.posx = 0
        self.posy = 0
        self.wpx = 10
        self.wpy = 1

    def move(self, command, val):
        if command == "N":
            self.wpy += val
        elif command == "E":
            self.wpx += val
        elif command == "S":
            self.wpy -= val
        elif command == 'W':
            self.wpx -= val
        elif command == "L":
            for i in range(val // 90):
                tmpx = self.wpx
                self.wpx = -self.wpy
                self.wpy = tmpx
        elif command == "R":
            for i in range(val // 90):
                tmpx = self.wpx
                self.wpx = self.wpy
                self.wpy = -tmpx
        elif command == "F":
            self.posx += val * self.wpx
            self.posy += val * self.wpy
        else:
            print("ERROR")

def run() -> (int, int):
    lines = read_as.lines("input/12.txt")
    ship = Ship()
    ship_wp = ShipWP()
    for instr in lines:
        command, val = instr[0], int(instr[1:])
        ship.move(command, val) 
        ship_wp.move(command, val)
    return (abs(ship.posx) + abs(ship.posy), abs(ship_wp.posx) + abs(ship_wp.posy))

if __name__ == "__main__":
    print(run())