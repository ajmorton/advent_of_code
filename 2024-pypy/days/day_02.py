#! /usr/bin/env pypy3
from . import read_as

def good_rule(nums) -> bool:
    jumps = [nums[i + 1] - nums[i] for i in range(0, len(nums) - 1)]
    return all(j in [1,2,3] for j in jumps) or all(j in [-1,-2,-3] for j in jumps)

def good_rule_lax(nums) -> bool:
    return any(good_rule(nums[:i] + nums[i + 1 :]) for i in range(len(nums)))

def run() -> (int, int):
    int_lines = [[*map(int, l.split())] for l in read_as.lines("input/day02.txt")]
    p1 = sum(good_rule(l) for l in int_lines)
    p2 = sum(good_rule_lax(l) for l in int_lines)
    return (p1, p2)