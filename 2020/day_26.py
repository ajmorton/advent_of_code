import read_as
import re
from collections import defaultdict
import itertools as it

def run() -> (int, int):
    claims = defaultdict(set)
    all_claims = set()
    for req in read_as.lines("./input/foo.txt"):
        id, c, r, width, height = map(int, re.search(r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)", req).groups())
        all_claims.add(id)
        for (rr, cc) in it.product(range(c, c + width), range(r, r + height)):
            claims[(rr,cc)].add(id)

    multi_claims = {k:v for k,v in claims.items() if len(v) > 1}
    unique = set.union(*multi_claims.values()).symmetric_difference(all_claims)

    return ( len(multi_claims), unique.pop())

if __name__ == "__main__":
    print(run())