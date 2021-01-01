import read_as
import itertools as it
from collections import defaultdict
import re

class Links():
    def __init__(self):
        self.internal = {}

    def get(self, n):
        return self.internal.get(n, n+1)

    def set(self, m, n):
        self.internal[m] = n

    def run(self, steps, max_cup, starting_cup):
        cur_cup = starting_cup
        for i in range(steps):
            next_1 = self.get(cur_cup)
            next_2 = self.get(next_1)
            next_3 = self.get(next_2)
            next_4 = self.get(next_3)

            dest_cup = cur_cup - 1 if cur_cup != 1 else max_cup
            while dest_cup in {next_1, next_2, next_3}:
                dest_cup = dest_cup - 1 if dest_cup != 1 else max_cup

            self.set(cur_cup, next_4)
            after = self.get(dest_cup)
            self.set(dest_cup, next_1)
            self.set(next_3, after)

            cur_cup = self.get(cur_cup)

def run() -> (int, int):
    cups = [int(c) for c in read_as.lines("input/23.txt")[0]]

    links_p1, links_p2 = Links(), Links()

    for i in range(len(cups) - 1):
        links_p1.set(cups[i], cups[i+1])
        links_p2.set(cups[i], cups[i+1])

    links_p1.set(cups[-1], cups[0])

    links_p2.set(cups[-1], 10)
    links_p2.set(1000000, cups[0])

    links_p1.run(100, 9, cups[0])
    links_p2.run(10000000, 1000000, cups[0])

    p1 = 0
    next_cup = links_p1.get(1)
    while next_cup != 1:
        p1 = (10 * p1) + next_cup
        next_cup = links_p1.get(next_cup)

    p2 = links_p2.get(1) * links_p2.get(links_p2.get(1))

    return (p1, p2)

if __name__ == "__main__":
    print(run())