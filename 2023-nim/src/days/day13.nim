import aoc_prelude

type Grid = seq[string] 

proc differenceCount(a: string, b: string): int =
    return a.zip(b).countIt(it[0] != it[1])

# Determine the horiziontal line where a grid is mirrored. Assumed mirrors exist in between rows and not on rows. i.e.
#     # # # #
#        #   
#     # # # #
# is not a valid mirror on row 1.
# The mirror must have exactly `allowedDiff` differences. `allowedDiff` == 1 means one cell must be changed for a mirror to exist
proc isMirroredAtRowWithDifferences(grid: Grid, allowedDiff: int): int =

    for i in 1 ..< grid.len:
        var delta = 0
        delta += differenceCount(grid[i], grid[i-1])
        if delta <= allowedDiff:
            # try walking both directions
            var (above, below) = (i - 2, i + 1)
            var isMirror = true
            while above >= 0 and below < grid.len:
                delta += differenceCount(grid[above], grid[below])
                if delta > allowedDiff:
                    isMirror = false
                    break
                above -= 1
                below += 1
            
            if isMirror and delta == allowedDiff:
                return i

    return -1 

proc transpose(grid: Grid): Grid = 
    var transposed = [""].cycle(grid[0].len)
    for row in grid:
        for i, c in row:
            transposed[i].add(c)

    return transposed

proc scoreGrid(grid: Grid, allowedDiffs: int): int =
    # According to the spec cols should be checked first, but each grid has exactly one solution so we can check 
    # rows first and if a rowMirror exists skip the work required to transpose the grid.
    let rowMirror = grid.isMirroredAtRowWithDifferences(allowedDiffs)
    if rowMirror != -1:
        return 100 * rowMirror            

    let colMirror = grid.transpose.isMirroredAtRowWithDifferences(allowedDiffs)
    if colMirror != -1:
        return colMirror

    quit "No mirrors found!"

proc run*(input_file: string): (int, int) =
    let grids = readFile(input_file).strip(leading = false).split("\n\n").mapIt(it.splitLines)

    return (
        grids.mapIt(it.scoreGrid(0)).sum,
        grids.mapIt(it.scoreGrid(1)).sum
    )