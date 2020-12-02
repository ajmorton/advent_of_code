
# O(n)
def pair(nums: [int], target: int) -> int:
    prev_vals = set()
    for num in nums:
        if (target - num) in prev_vals:
            return num * (target - num)
        else:
            prev_vals.add(num)
    return -1

#O(n^2)
def trips(nums: [int], target: int) -> int:
    for i in range(0, len(nums)):
        num = nums[i]
        rem = target - num
        pairs = pair(nums[i+1:], rem)
        if pairs != -1:
            return num * pairs
    return -1

def run(file) -> (int, int):
    nums = [int(line) for line in file]
    return pair(nums, 2020), trips(nums, 2020)
