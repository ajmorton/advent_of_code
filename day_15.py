import read_as
import re

def run() -> (int, int):
    lines = read_as.lines("input/15.txt")

    nums = [0,8,15,2,12,1]
    nums_map = {v: i +1 for (i, v) in enumerate(nums)}

    cur_index = len(nums) + 1
    next_val = 4

    while cur_index < 2020:
        if next_val not in nums_map:
            new_val = 0
        else:
            new_val = cur_index - nums_map[next_val]

        nums_map[next_val] = cur_index

        cur_index += 1
        next_val = new_val

    p1 = next_val

    while cur_index < 30000000:
        if next_val not in nums_map:
            new_val = 0
        else:
            new_val = cur_index - nums_map[next_val]

        nums_map[next_val] = cur_index

        cur_index += 1
        next_val = new_val

    p2 = next_val

    return (p1, p2)

if __name__ == "__main__":
    print(run())
