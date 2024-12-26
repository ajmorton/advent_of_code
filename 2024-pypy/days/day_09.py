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

    # P1 - Single pass swap sort
    left_pos, right_pos = 0, len(mapp) - 1
    checksum1 = 0
    while left_pos < right_pos:
        if mapp[left_pos] != EMPTY:
            checksum1 += left_pos * mapp[left_pos]
            left_pos += 1
        elif mapp[right_pos] != EMPTY:
            checksum1 += left_pos * mapp[right_pos]
            left_pos += 1
            right_pos -= 1
        else:
            right_pos -= 1

    first_hole_of_size = [0] * 10 # Technically position where no holes of size are before
    checksum2 = 0
    # P2 - Extent lists
    for (start_pos, lenn_data, val) in reversed(exts):
        new_data = (start_pos, lenn_data, val)
        for hole_idx in range(first_hole_of_size[lenn_data], len(holes)):
            (start_pos_hole, lenn_hole) = holes[hole_idx]

            if start_pos < start_pos_hole:
                first_hole_of_size[lenn_data] = 99999999
                break

            if lenn_data <= lenn_hole:
                first_hole_of_size[lenn_data] = hole_idx
                holes[hole_idx] = (start_pos_hole + lenn_data, lenn_hole - lenn_data)
                new_data = (start_pos_hole, lenn_data, val)
                break
    
        checksum2 += sum(range(new_data[0], new_data[0] + new_data[1])) * new_data[2]

    return (checksum1, checksum2)
