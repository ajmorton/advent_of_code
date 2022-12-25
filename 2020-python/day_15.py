def run() -> (int, int):
    nums = [0,8,15,2,12,1]
    nums_map = {v: i + 1 for (i, v) in enumerate(nums)}

    next_val = 4
    p1 = 0

    for i in range(len(nums) + 1, 30000000):
        nums_map[next_val], next_val = i, i - nums_map[next_val] if next_val in nums_map else 0
        if i == 2019:
            p1 = next_val
    p2 = next_val

    return (p1, p2)

if __name__ == "__main__":
    print(run())
