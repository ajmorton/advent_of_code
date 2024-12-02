#! /usr/bin/env pypy3

from . import read_as

def run() -> (int, int):
    p1 = p2 = 0
    for line in read_as.lines("input/day02.txt"):
        print(line)

        nums = [int(n) for n in line.split()]
        if nums == sorted(nums) or nums == sorted(nums, reverse=True):
            pass
        else:
            continue

        too_big = False
        for i in range(0, len(nums) - 1):
            if 1 <= abs(nums[i] - nums[i + 1]) <= 3:
                pass
            else:
                too_big = True
        
        if too_big:
            continue

        p1 += 1


    for line in read_as.lines("input/day02.txt"):
        nums = [int(n) for n in line.split()]
        p2_scores = False
        for i in range(0, len(nums)):
            new_nums = nums[0:i] + nums[i+1:]

            if new_nums == sorted(new_nums) or new_nums == sorted(new_nums, reverse=True):
                pass
            else:
                continue

            too_big = False
            for i in range(0, len(new_nums) - 1):
                if 1 <= abs(new_nums[i] - new_nums[i + 1]) <= 3:
                    pass
                else:
                    too_big = True
            
            if too_big:
                continue

            p2 += 1
            break


    return (p1, p2)
