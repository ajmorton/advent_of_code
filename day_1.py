
def pair(nums: [int]) -> int:
    for i in range(0, len(nums)):
        for j in range(i+1, len(nums)):
            if nums[i] + nums[j] == 2020:
                return nums[i] * nums[j]
    return -1

def trips(nums: [int]) -> int:
    for i in range(0, len(nums)):
        for j in range(i+1, len(nums)):
            for k in range(j+1, len(nums)):
                if nums[i] + nums[j] + nums[k] == 2020:
                    return nums[i] * nums[j] * nums[k]
    
    return -1



def run(file, part_2: bool = False) -> int:
    nums = [int(line) for line in file]
    return trips(nums) if part_2 else pair(nums)
