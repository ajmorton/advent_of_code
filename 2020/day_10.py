import read_as
from collections import Counter, defaultdict

def paths_to_target(adapters) -> int:
    paths_to = defaultdict(int)
    paths_to[0] = 1
    for adapter in adapters:
        paths_to[adapter] = paths_to[adapter - 1] + paths_to[adapter - 2] + paths_to[adapter - 3]
    return paths_to[adapters[-1]]

def run() -> (int, int):
    adapters = sorted([int(line) for line in read_as.lines("input/10.txt")])

    jumps = Counter([adapters[i] - adapters[i-1] for i in range(1, len(adapters))])
    jumps[adapters[0]] += 1
    jumps[3] += 1
    
    return(jumps[1] * jumps[3], paths_to_target(adapters))

if __name__ == "__main__":
    print(run())