#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict
from functools import cmp_to_key

def run() -> (int, int):
    p1 = p2 = 0
    ordering, books = read_as.groups("input/day05.txt")

    follows = [[False for _ in range(100)] for _ in range(100)]
    for o in ordering:
        a,b = o.split("|")
        follows[int(a)][int(b)] = True

    for book in books:
        pages = [*map(int, book.split(','))]
        ordered = sorted(pages, key=lambda page: -sum(follows[page][other] for other in pages))

        if pages == ordered:
            p1 += ordered[len(ordered)//2]
        else:
            p2 += ordered[len(ordered)//2]

    return (p1, p2)
