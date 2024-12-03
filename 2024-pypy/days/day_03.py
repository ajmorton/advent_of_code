#! /usr/bin/env pypy3
from . import read_as
import functools as ft

import re

def run() -> (int, int):
    p1 = p2 = 0
    do_add = True
    for line in read_as.lines("input/day03.txt"):
        for match in re.finditer(r"mul\((\d+),(\d+)\)", line):
            p1 += int(match.group(1)) * int(match.group(2))

        do = dont = 0
        for match in re.finditer(r"(mul\((\d+),(\d+)\)|do\(\)|don't\(\))", line):
            if match.group(0).startswith("don't"):
                dont += 1
                do_add = False
            elif match.group(0).startswith("do"):
                do += 1
                do_add = True
            else:
                mull = int(match.group(2)) * int(match.group(3))
                if do_add:
                    p2 += mull

    return (p1, p2)