#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict
from functools import cmp_to_key

def run() -> (int, int):
    p1 = p2 = 0
    groups = read_as.groups("input/day05.txt")
    page_orders_str = groups[0]
    pages = groups[1]

    page_orders = defaultdict(set)
    for line in page_orders_str:
        (before_str, after_str) = line.split("|")
        bef, after = before_str, after_str
        page_orders[bef].add(after)

    def compare(a, b):
        if b in page_orders[a]:
            return -1
        if a in page_orders[b]:
            return 1
        return 0

    for page in pages:
        ps = page.split(',')
        ordered = sorted(ps, key=cmp_to_key(compare))

        if ps == ordered:
            p1 += int(ps[len(ps)//2])
        else:
            p2 += int(ordered[len(ordered)//2])

    return (p1, p2)
