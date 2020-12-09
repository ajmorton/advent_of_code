import read_as
from collections import defaultdict
import re
import queue

def sum_of_window(n, prev_nums):
    for i in range(0, len(prev_nums)):
        for j in range(i+1, len(prev_nums)):
            if prev_nums[i] + prev_nums[j] == n:
                return True

    return False

def subseq_sum(target, nums) -> (int, int):
    for i in range(0, len(nums)):
        end_ptr = i
        summ = nums[i]
        for j in reversed(range(0, i)):
            summ += nums[j]
            if summ == target:
                subseq = nums[j:i+1]
                return min(subseq) + max(subseq)

    return -1, -1


def run() -> (int, int):

    nums = [int(num) for num in read_as.lines("input/9.txt")]
    window = 25
    prev_nums = []

    for i in range(0, len(nums)):
        num = nums[i]
        if i >= window:
            if sum_of_window(nums[i], prev_nums) == False:
                p1 = nums[i]
                break

            # remove
            prev_nums = prev_nums[1:]

        # insert
        prev_nums.append(num)


    p2 = subseq_sum(p1, nums)


    return(p1, p2)

if __name__ == "__main__":
    print(run())