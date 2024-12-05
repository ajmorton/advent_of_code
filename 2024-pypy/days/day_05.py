#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict
from functools import cmp_to_key

def run() -> (int, int):
    p1 = p2 = 0
    ordering, books = read_as.groups("input/day05.txt")
    ordering_set = set(ordering)

    def compare(a, b):
        return -1 if f"{a}|{b}" in ordering_set else 1

    for book in books:
        pages = book.split(',')
        ordered = sorted(pages, key=cmp_to_key(compare))

        if pages == ordered:
            p1 += int(pages[len(pages)//2])
        else:
            p2 += int(ordered[len(ordered)//2])

    return (p1, p2)
