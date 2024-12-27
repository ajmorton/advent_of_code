#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    p1 = p2 = 0

    seen_by_monkey = [0] * 19**4 # Generational array
    total_bananas_for_seq = [0] * 19**4

    for i, line in enumerate(read_as.lines("input/day22.txt")):
        secret = int(line)

        prev_price = secret % 10
        total_bananas = prev_price
        deltas = 0 # integer encoding of last 4 deltas: (n-3)*19^3 + (n-2)*19^2 + (n-1)*19^1 + (n)*19^0 
        for loop in range(0, 2000):
            secret = (secret ^ (secret << 6 )) & ((1 << 24) - 1)
            secret = (secret ^ (secret >> 5 )) & ((1 << 24) - 1)
            secret = (secret ^ (secret << 11)) & ((1 << 24) - 1)

            new_price = secret % 10
            delta = new_price - prev_price

            total_bananas += delta
            deltas %= 19**3
            deltas *= 19
            deltas += (delta + 9)

            if loop >= 3:
                if seen_by_monkey[deltas] < i:
                    total_bananas_for_seq[deltas] += total_bananas
                    seen_by_monkey[deltas] = i

            prev_price = new_price
        p1 += secret

    return p1, max(total_bananas_for_seq)