import aoc_prelude

type Pos = tuple[r: int, c: int]

proc shortestPaths(grid: seq[seq[char]], stars: seq[Pos], emptyRowsAbove: seq[int], emptyColsLeft: seq[int]): (int, int) =
    var (manhattanSum, interimRowsSum, interimColsSum) = (0, 0, 0)

    for i in 0 ..< stars.len:
        for j in i + 1 ..< stars.len:
            let starA = stars[i]
            let starB = stars[j]

            let (minY, maxY) = if starA.r > starB.r: (starB.r, starA.r) else: (starA.r, starB.r)
            let (minX, maxX) = if starA.c > starB.c: (starB.c, starA.c) else: (starA.c, starB.c)

            let interimEmptyRows = emptyRowsAbove[maxY] - emptyRowsAbove[minY]
            let interimEmptyCols = emptyColsLeft[maxX]  - emptyColsLeft[minX]

            let manhattan = (starA.r.abs - starB.r.abs).abs + (starA.c.abs - starB.c.abs).abs 

            manhattanSum += manhattan
            interimRowsSum += interimEmptyRows
            interimColsSum += interimEmptyCols

    return (
        manhattanSum + interimRowsSum           + interimColsSum,
        manhattanSum + interimRowsSum * 999_999 + interimColsSum * 999_999
    )

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines.map(l => l.toSeq)
    var grid = lines
    var stars = newSeq[Pos]()

    var emptyRows = repeat(1, grid.len)
    var emptyCols = repeat(1, grid[0].len)
    
    for y, r in grid:
        for x, c in r:
            if c == '#':
                stars.add((r: y, c: x))
                emptyRows[y] = 0
                emptyCols[x] = 0

    let emptyRowsAbove = emptyRows.cumsummed
    let emptyColsLeft  = emptyCols.cumsummed

    return shortestPaths(grid, stars, emptyRowsAbove, emptyColsLeft)
