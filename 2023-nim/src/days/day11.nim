import aoc_prelude

proc shortestPaths(grid: seq[seq[char]], emptyRows: seq[int], emptyCols: seq[int]): (int, int) =
    var i = 0
    var positions = Table[int, (int, int)]()

    for y, r in grid:
        for x, c in r:
            if c == '#':
                positions[i] = (y, x)
                i += 1

    var p1, p2: int = 0

    for i in 0 ..< positions.len:
        for j in i + 1 ..< positions.len:
            let iPos = positions[i]
            let jPos = positions[j]

            let minY = min(iPos[0], jPos[0])
            let maxY = max(iPos[0], jPos[0])
            let minX = min(iPos[1], jPos[1])
            let maxX = max(iPos[1], jPos[1])

            let interimEmptyRows = emptyRows.countIt(minY < it and it < maxY)
            let interimEmptyCols = emptyCols.countIt(minX < it and it < maxX)
            let manhattan = (iPos[0].abs - jPos[0].abs).abs + (iPos[1].abs - jPos[1].abs).abs 

            p1 += manhattan + interimEmptyCols + interimEmptyRows
            p2 += manhattan + (interimEmptyCols * 999_999) + (interimEmptyRows * 999_999)

    return (p1, p2)

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines.map(l => l.toSeq)
    var grid = lines

    var emptyRows = newSeq[int]()
    for y, r in grid:
        if r.all(x => x == '.'):
            emptyRows.add(y)

    var emptyCols = newSeq[int]()
    for x in 0 ..< grid[0].len:
        var allEmpty = true
        for y in 0 ..< grid.len:
            if grid[y][x] != '.':
                allEmpty = false

        if allEmpty:
            emptyCols.add(x)

    return shortestPaths(grid, emptyRows, emptyCols)
