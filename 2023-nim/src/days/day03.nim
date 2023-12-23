import aoc_prelude

proc findNumBounds(line: string): seq[(int, int)] =
    var numBounds: seq[(int, int)]
    var start = -1
    for x, c in line:
        if c.isDigit and start == -1:
            start = x
        elif not c.isDigit and start != -1:
            numBounds.add((start, x - 1))
            start = -1

    if start != -1:
        numBounds.add((start, line.len - 1))

    return numBounds

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines

    let inGrid = proc(y: int, x: int): bool = y >= 0 and y < grid.len and x >= 0 and x < grid[0].len
    let isPart = proc(y: int, x: int): bool = grid[y][x] notin "0123456789."

    var symbolParts = Table[(int, int), seq[int]]()
    for y, row in grid:
        for (startX, endX) in findNumBounds(row):
            for x in startX - 1 .. endX + 1:
                for yy in [y - 1, y, y + 1]:
                    if inGrid(yy, x) and isPart(yy, x):
                        symbolParts.mgetOrPut((yy, x), newSeq[int]()).insert(row[startX .. endX].parseInt)

    let sumOfParts = symbolParts.values.toSeq.map(x => x.sum).sum
    let gears = symbolParts.pairs.toSeq.filter(pair => grid[pair[0][0]][pair[0][1]] == '*' and pair[1].len == 2)
    let prodSumOfGears = gears.map(pair => pair[1].prod).sum
    
    return (sumOfParts, prodSumOfGears)