import aoc_prelude

type Grid = seq[string] 

# Determine where a grid is mirrored. Assumed mirrors exist in between rows and not on rows. i.e.
#     # # # #
#        #   
#     # # # #
# is not a valid mirror on row 1
proc isMirroredAtRow(grid: Grid): int =

    for i in 1 ..< grid.len:
        if grid[i] == grid[i-1]:
            # try walking both directions
            var (above, below) = (i - 1, i)
            var isMirror = true
            while above >= 0 and below < grid.len:
                if grid[above] != grid[below]:
                    isMirror = false
                    break
                above -= 1
                below += 1
            
            if isMirror:
                return i

    return -1 

proc deltaCount(a: string, b: string): int =
    var dist = 0
    for (c_a, c_b) in a.zip(b):
        if c_a != c_b:
            dist += 1
    return dist

proc isSmudgeMirroredAtRow(grid: Grid): int =

    for i in 1 ..< grid.len:
        var smudgeFixed = false
        let delta = deltaCount(grid[i], grid[i-1])
        if delta < 2:
            if delta == 1:
                smudgeFixed = true
            # try walking both directions
            var (above, below) = (i - 2, i + 1)
            var isMirror = true
            while above >= 0 and below < grid.len:
                let delta2 = deltaCount(grid[above], grid[below])
                if delta2 == 0:
                    # nothing to do
                    discard
                elif delta2 == 1:
                    if not smudgeFixed:
                        smudgeFixed = true
                        # fix smudge and continue
                    else:
                        isMirror = false
                        break
                else:
                    isMirror = false
                    break
                above -= 1
                below += 1
            
            if isMirror and smudgeFixed:
                return i

    return -1 

proc transpose(grid: seq[string]): seq[string] = 

    var transposed = newSeq[string]()

    for i in 0 ..< grid[0].len:
        transposed.add("")

    for row in grid:
        for i, c in row:
            transposed[i].add(c)

    return transposed

proc run*(input_file: string): (int, int) =
    let grids = readFile(input_file).strip(leading = false).split("\n\n").mapIt(it.splitLines)

    var sum, sum2 = 0

    for grid in grids:
        let colMirror = grid.transpose.isMirroredAtRow
        if colMirror == -1:
            let rowMirror = grid.isMirroredAtRow
            if rowMirror == -1:
                quit "No mirror!"
            sum += 100 * rowMirror            
        else:
            sum += colMirror

    for grid in grids:
        let colMirror = grid.transpose.isSmudgeMirroredAtRow
        if colMirror == -1:
            let rowMirror = grid.isSmudgeMirroredAtRow
            if rowMirror == -1:
                quit "No mirror!"
            sum2 += 100 * rowMirror            
        else:
            sum2 += colMirror

    return (sum, sum2)