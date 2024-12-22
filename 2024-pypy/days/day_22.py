#! /usr/bin/env pypy3
from . import read_as

from collections import defaultdict

def run() -> (int, int):
    p1 = p2 = 0

    combo_sum = defaultdict(int)

    for line in read_as.lines("input/day22.txt"):
        secret = int(line)

        prev_price = secret % 10
        deltas = []
        total_bananas = prev_price
        seen_this_monkey = set()
        for _ in range(0, 2000):
            secret = (secret ^ int(secret *  64)) % 16777216
            secret = (secret ^ int(secret // 32)) % 16777216
            secret = (secret ^ (secret * 2048)) % 16777216
            new_price = secret % 10
            delta = new_price - prev_price
            deltas.append(delta)
            total_bananas += delta

            if len(deltas) >= 4:
                seq = (deltas[-4], deltas[-3], deltas[-2], deltas[-1])

                if seq not in seen_this_monkey:
                    combo_sum[seq] += total_bananas
                    seen_this_monkey.add(seq)

            prev_price = new_price

        p1 += secret

    return (p1, sorted(combo_sum.items(), key=lambda kv: kv[1])[-1][1])