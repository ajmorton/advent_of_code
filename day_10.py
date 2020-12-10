import read_as
from collections import defaultdict
import itertools

def paths_to_target(adaptors, cur_volt, target, memo) -> bool:

    state = (len(adaptors), cur_volt)
    if state in memo:
        return memo[state]

    paths = 0
    if abs(cur_volt - target) <= 3:
        paths += 1
    if len(adaptors) == 0:
        return paths
    if abs(adaptors[0] - cur_volt) <= 3:
        paths += paths_to_target(adaptors[1:], adaptors[0], target, memo)
    paths += paths_to_target(adaptors[1:], cur_volt, target, memo)

    memo[state] = paths
    return paths

def run() -> (int, int):

    adaptors = [int(line) for line in read_as.lines("input/10.txt")]
    adaptors.sort()

    diffs = defaultdict(int)
    for i in range(1, len(adaptors)):
        diffs[adaptors[i] - adaptors[i-1]] += 1

    diffs[adaptors[0]] += 1
    diffs[3] += 1
    
    return(diffs[1] * diffs[3], paths_to_target(adaptors, 0, adaptors[-1] + 3, {}))

if __name__ == "__main__":
    print(run())