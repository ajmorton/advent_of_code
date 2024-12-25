#! /usr/bin/env pypy3
from . import read_as

# All jumps from n to n + 1 are in {1,2,3} or {-1,-2,-3}. Bit manip to get execution under 1ms.
def good_rule(nums) -> bool:
    bits2 = bits2_neg = 0
    for i in range(0, len(nums) - 1):
        jump = nums[i+1] - nums[i]
        if jump == 0: return False
        bits2 |= jump
        bits2_neg |= -jump
       
    return bits2_neg & 3 == bits2_neg or bits2 & 3 == bits2

def good_rule_lax(nums) -> bool:
    return any(good_rule(nums[:i] + nums[i + 1 :]) for i in range(len(nums)))

def run() -> (int, int):
    int_lines = [[*map(int, l.split())] for l in read_as.lines("input/day02.txt")]
    p1 = sum(good_rule(l) for l in int_lines)
    p2 = sum(good_rule_lax(l) for l in int_lines)
    return (p1, p2)