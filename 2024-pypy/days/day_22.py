#! /usr/bin/env pypy3
from . import read_as
from collections import defaultdict

def run() -> (int, int):
    p1 = p2 = 0

    seen_by_monkey = [0] * 19**4 # Generational array
    total_bananas_for_seq = [0] * 19**4

    for i, line in enumerate(read_as.lines("input/day22.txt")):
        secret = int(line)

        prev_price = secret % 10
        total_bananas = prev_price
        last_4 = last_3 = last_2 = last_1 = None
        for _ in range(0, 2000):
            secret = (secret ^ (secret << 6 )) & ((1 << 24) - 1)
            secret = (secret ^ (secret >> 5 )) & ((1 << 24) - 1)
            secret = (secret ^ (secret << 11)) & ((1 << 24) - 1)

            new_price = secret % 10
            delta = new_price - prev_price

            last_4, last_3, last_2, last_1 = last_3, last_2, last_1, delta
            total_bananas += delta

            if last_4 is not None:
                idx = (last_4 + 9) * 19**3 + (last_3 + 9) * 19**2 + (last_2 + 9) * 19**1 + (last_1 + 9)
                if seen_by_monkey[idx] < i:
                    total_bananas_for_seq[idx] += total_bananas
                    seen_by_monkey[idx] = i

            prev_price = new_price
        p1 += secret

    return p1, max(total_bananas_for_seq)