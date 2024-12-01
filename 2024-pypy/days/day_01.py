#! /usr/bin/env pypy3

from . import read_as

def run() -> (int, int):
    left_list, right_list = [], []
    for line in read_as.lines("input/day01.txt"):
        (l, r) = line.split()
        left_list.append(int(l))
        right_list.append(int(r))

    left_list.sort()
    right_list.sort()

    p1 = sum(abs(left_list[i] - right_list[i]) for i in range(0, len(left_list)))
    p2 = sum(n * right_list.count(n) for n in left_list)
    return (p1, p2)
