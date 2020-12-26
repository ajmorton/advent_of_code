import read_as
from typing import Set

def pair(nums: Set[int], target: int) -> int:
    return {n * (target - n) for n in nums if (target - n) in nums}

def trips(nums: Set[int], target: int) -> int:
    return {n * pair(nums, target - n).pop() for n in nums if pair(nums, target - n)}

def run() -> (int, int):
    nums = set(int(line) for line in read_as.lines("input/1.txt"))
    return pair(nums, 2020).pop(), trips(nums, 2020).pop()

if __name__ == "__main__":
    print(run())