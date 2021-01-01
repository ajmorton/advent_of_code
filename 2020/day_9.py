import read_as

def sum_of_window(n: int, prev_nums: [int]) -> bool:
    return any(n - prev_nums[i] in prev_nums[:i] for i in range(len(prev_nums)))

def subseq_sum(target: int, nums: [int]) -> int:
    for i in range(0, len(nums)):
        for j in range(0, i):
            subseq = nums[j:i]
            summ = sum(subseq)
            if summ == target:
                return min(subseq) + max(subseq)
            elif summ < target:
                break
    return -1

def run() -> (int, int):
    nums = [int(num) for num in read_as.lines("input/9.txt")]
    window = 25

    for i in range(window, len(nums)):
        num = nums[i]
        if sum_of_window(num, nums[i - window : i]) == False:
            break

    return(num, subseq_sum(num, nums))

if __name__ == "__main__":
    print(run())