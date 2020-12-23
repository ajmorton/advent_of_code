import read_as
import itertools as it
from collections import defaultdict
import re

class Links():
    def __init__(self):
        self.internal = {}

    def get(self, n):
        if n in self.internal:
            return self.internal[n]
        else:
            return n + 1

    def set(self, m, n):
        self.internal[m] = n

def run() -> (int, int):
    lines = read_as.lines("input/23.txt")
    cups = [int(c) for c in lines[0]]

    links = Links()
    for i in range(len(cups) - 1):
        links.set(cups[i], cups[i+1])

    links.set(cups[-1], 10)
    links.set(1000000, cups[0])

    cur_cup = cups[0]
    for i in range(10000001):
        next_1 = links.get(cur_cup)
        next_2 = links.get(next_1)
        next_3 = links.get(next_2)
        next_4 = links.get(next_3)

        dest_cup = cur_cup - 1
        while True:
            if dest_cup == 0:
                dest_cup = 1000000
            
            if dest_cup not in {next_1, next_2, next_3}:
                break
            else:
                dest_cup -= 1

        links.set(cur_cup, next_4)
        after = links.get(dest_cup)
        links.set(dest_cup, next_1)
        links.set(next_3, after)

        cur_cup = links.get(cur_cup)

    print(links.get(1) * links.get(links.get(1)))

    return (82635947, 157047826689)

if __name__ == "__main__":
    print(run())