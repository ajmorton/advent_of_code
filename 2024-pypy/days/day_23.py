#! /usr/bin/env pypy3
from . import read_as

from collections import defaultdict

def run() -> (int, int):
    p1 = p2 = 0
    connections = defaultdict(set)
    largest = set()

    for line in read_as.lines("input/day23.txt"):
        l,r  = line.split('-')
        connections[l].add(r)
        connections[r].add(l)

    for l in connections.keys():
        others = list(connections[l])
        if len(others) >= 2:
            for i in range(0, len(others)):
                for j in range(i+1, len(others)):
                    other_1, other_2 = others[i], others[j]
                    if l in connections[other_1] and other_2 in connections[other_1] and l in connections[other_2] and other_1 in connections[other_2]:
                        if l.startswith("t") or other_1.startswith("t") or other_2.startswith("t"):
                            p1 += 1
    
            # No need to check potential groups that are already smaller than our largest group
            if len(others) <= len(largest):
                continue

            all_comps = [l] + others
            not_connected = True
            while not_connected:
                not_connected = False
                weakest_conn = set(all_comps)
                weakest_comp = ""
                for comp in all_comps:
                    try_conn = set(connections[comp])
                    try_conn.add(comp)

                    overlap = try_conn.intersection(set(all_comps))
                    if len(overlap) < len(weakest_conn):
                        weakest_conn = overlap
                        weakest_comp = comp

                if len(weakest_conn) < len(all_comps):
                    # remove
                    all_comps.remove(weakest_comp)
                    not_connected = True

            if len(all_comps) > len(largest):
                largest = all_comps

    return (p1//3, ",".join(sorted(largest)))