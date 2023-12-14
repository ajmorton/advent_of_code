import aoc_prelude
import hashes

type Cell = enum RoundRock, FlatRock, Empty
type Grid = seq[seq[Cell]]

proc parseCell(c: char): Cell =
    return case c
    of '.': Empty
    of 'O': RoundRock
    of '#': FlatRock
    else: quit fmt"unexpected char {c}"

proc tiltNorth(grid: var Grid): bool = 
    var movementMade = false
    for y, r in grid:
        for x, c in r:
            if c == RoundRock:
                if y - 1 >= 0 and grid[y-1][x] == Empty:
                    movementMade = true
                    grid[y-1][x] = c
                    grid[y][x] = Empty
    return movementMade

proc tiltSouth(grid: var Grid): bool = 
    var movementMade = false
    for y in countdown(grid.len - 1, 0):
        let r = grid[y]
        for x, c in r:
            if c == RoundRock:
                if y + 1 < grid.len and grid[y+1][x] == Empty:
                    movementMade = true
                    grid[y+1][x] = c
                    grid[y][x] = Empty
    return movementMade

proc tiltWest(grid: var Grid): bool = 
    var movementMade = false
    for x in 0 ..< grid[0].len:
        for y in 0 ..< grid.len:
            let c = grid[y][x]
            if c == RoundRock:
                if x - 1 >= 0 and grid[y][x-1] == Empty:
                    movementMade = true
                    grid[y][x-1] = c
                    grid[y][x] = Empty
    return movementMade

proc tiltEast(grid: var Grid): bool = 
    var movementMade = false
    for x in countdown(grid[0].len - 1, 0):
        for y in 0 ..< grid.len:
            let c = grid[y][x]
            if c == RoundRock:
                if x + 1 < grid[0].len and grid[y][x+1] == Empty:
                    movementMade = true
                    grid[y][x+1] = c
                    grid[y][x] = Empty
    return movementMade

proc northWeight(grid: Grid): int = 

    var totalWeight = 0
    let height = grid.len
    for y, r in grid:
        let rowWeight = r.count(RoundRock) * (height - y)
        totalWeight += rowWeight

    return totalWeight

proc cycle(grid: var Grid): bool =
    while grid.tiltNorth: discard
    while grid.tiltWest:  discard
    while grid.tiltSouth: discard
    while grid.tiltEast:  discard

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines.mapIt(it.map(parseCell))
    var gridP1 = grid

    while gridP1.tiltNorth: discard

    var seenScore = Table[Hash, int]()

    var gridP2 = grid
    for i in 0 ..< 1000000000:
        discard gridP2.cycle
        let hash = gridP2.hash
        if hash in seenScore:

            let cycleSize = i - seenScore[hash]
            var foo = i
            while foo + cycleSize < 1000000000:
                foo += cycleSize
            let numIters = 1000000000 - foo

            for j in 0 ..< numIters - 1:
                discard gridP2.cycle

            break
        else:
            seenScore[hash] = i

    return (gridP1.northWeight, gridP2.northWeight)