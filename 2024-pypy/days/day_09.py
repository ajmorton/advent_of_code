#! /usr/bin/env pypy3
from . import read_as

EMPTY = -1

def run() -> (int, int):
    lengths = [int(ch) for ch in read_as.one_line("input/day09.txt")]
    
    mapp, exts, holes = [], [], []
    cur_offset = 0
    for i, lenn in enumerate(lengths):
        block_id = i // 2 if i % 2 == 0 else EMPTY 

        mapp.extend([block_id] * lenn)
        if block_id != EMPTY:
            exts.append((cur_offset, lenn, block_id))
        else:
            holes.append((cur_offset, lenn))

        cur_offset += lenn

    mapp2 = mapp.copy()

    # P1 - Single pass swap sort
    left_pos, right_pos = 0, len(mapp) - 1
    while left_pos < right_pos:
        if mapp[left_pos] != EMPTY:
            left_pos += 1
        elif mapp[right_pos] != EMPTY:
            mapp[left_pos] = mapp[right_pos]
            mapp[right_pos] = EMPTY
        else:
            right_pos -= 1

    # P2 - Extent lists
    for (start_pos, lenn_data, val) in reversed(exts):
        for hole_idx, (start_pos_hole, lenn_hole) in enumerate(holes):
            if start_pos < start_pos_hole:
                break

            if lenn_data <= lenn_hole:
                for i in range(0, lenn_data):
                    mapp2[start_pos_hole + i] = val
                    mapp2[start_pos + i] = EMPTY

                if lenn_hole == lenn_data:
                    del holes[hole_idx]
                else:
                    holes[hole_idx] = (start_pos_hole + lenn_data, lenn_hole - lenn_data)

                break

    checksum = lambda mapp: sum(pos * val for (pos, val) in enumerate(mapp) if val != EMPTY)
    return (checksum(mapp), checksum(mapp2))
