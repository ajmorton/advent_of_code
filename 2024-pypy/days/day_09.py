#! /usr/bin/env pypy3
from . import read_as

def run() -> (int, int):
    p1 = p2 = 0
    line = read_as.one_line("input/day09.txt")
    
    is_block = True
    block_id = 0
    mapp = []
    for ch in line:
        lenn = int(ch)
        if is_block:
            for _ in range(0, lenn):
                mapp.append(block_id)

            block_id += 1
            is_block = False
        else:
            for _ in range(0, lenn):
                mapp.append(-1)
            is_block = True

    mapp2 = mapp.copy()

    left_pos = 0
    right_pos = len(mapp) - 1
    while left_pos < right_pos:
        if mapp[left_pos] != -1:
            left_pos += 1
        elif mapp[right_pos] != -1:
            mapp[left_pos] = mapp[right_pos]
            mapp[right_pos] = -1
        else:
            right_pos -= 1



    checksum = 0
    for pos, val in enumerate(mapp):
        if val != -1:
            checksum += pos * val


    # P2
    prev_val = -2
    start_pos = -1
    lenn = 0
    extents = []
    for i, val in enumerate(mapp2):
        if val != prev_val:
            if prev_val != -2:
                extents.append((start_pos, lenn + 1, prev_val))
            prev_val = val
            start_pos = i
            lenn = 0
        else:
            lenn += 1

    extents.append((start_pos, lenn + 1, prev_val))

    smallest_seen = 9999999999
    for k in reversed(range(0, len(extents))):
        (start_pos, lenn, val) = extents[k]
        if val != -1 and val <= smallest_seen:
            # Try move earlier
            for j in range(0, k):
                (start_pos_empty, lenn_empty, val_empty) = extents[j]
                if val_empty == -1:
                    # Try insert
                    if lenn <= lenn_empty:
                        # Insert
                        for i in range(0, lenn):
                            mapp2[start_pos_empty + i] = mapp2[start_pos + i]
                            mapp2[start_pos + i] = -1
                            extents[j] = (start_pos_empty + lenn, lenn_empty - lenn, -1)
                        break

    checksum2 = 0
    for pos, val in enumerate(mapp2):
        if val != -1:
            checksum2 += pos * val


    return (checksum, checksum2)
