#! /usr/bin/env pypy3
from . import read_as
import re

score_muls = lambda l: sum(int(m[0]) * int(m[1]) for m in re.findall(r"mul\((\d+),(\d+)\)", l))

def run() -> (int, int):
    line         = read_as.one_line("input/day03.txt")
    split_dos    = line.split("do()")
    # For each section following do() discard all content after the first don't()
    scoring_muls = map(lambda substr: substr.split("don't()")[0], split_dos)

    return (score_muls(line), sum(map(score_muls, scoring_muls)))
