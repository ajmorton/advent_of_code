#! /usr/bin/env pypy3

from . import read_as

def run() -> (int, int):
    l, r = [], []
    for line in read_as.lines("input/day01.txt"):
        (left, right) = line.split()
        l.append(int(left))
        r.append(int(right))

    l.sort()
    r.sort()

    p1 = 0
    for i in range(0, len(l)):
        p1 += abs(abs(l[i]) - abs(r[i]))

    p2 = 0
    for n in l:
        if n in r:            
            p2 += n * len([x for x in r if x == n])

    return (p1, p2)

if __name__ == "__main__":
    print(run())