import aoc_prelude
import hashes

const RoundRock = 'O'
const FlatRock = '#'
const Empty = '.'

type Grid = seq[string]

proc tiltNorth(grid: var Grid) = 
    for x in 0 ..< grid[0].len:
        var furthestRollIndex = 0
        for y in 0 ..< grid.len:
            let c = grid[y][x]
            if c == RoundRock and furthestRollIndex != y:
                    grid[y][x] = Empty
                    grid[furthestRollIndex][x] = c
                    furthestRollIndex = furthestRollIndex + 1
            elif c != Empty:
                furthestRollIndex = y + 1

proc tiltSouth(grid: var Grid) = 

    for x in 0 ..< grid[0].len:
        var furthestRollIndex = grid.len - 1
        for y in countdown(grid.len - 1, 0):
            let c = grid[y][x]
            if c == RoundRock and furthestRollIndex != y:
                    grid[y][x] = Empty
                    grid[furthestRollIndex][x] = c
                    furthestRollIndex = furthestRollIndex - 1
            elif c != Empty:
                furthestRollIndex = y - 1

proc tiltWest(grid: var Grid) = 
    for y in 0 ..< grid.len:
        var furthestRollIndex = 0
        for x in 0 ..< grid[0].len:
            let c = grid[y][x]
            if c == RoundRock and furthestRollIndex != x:
                    grid[y][x] = Empty
                    grid[y][furthestRollIndex] = c
                    furthestRollIndex = furthestRollIndex + 1
            elif c != Empty:
                furthestRollIndex = x + 1

proc tiltEast(grid: var Grid) = 
    for y in 0 ..< grid.len:
        var furthestRollIndex = grid[0].len - 1
        for x in countdown(grid[0].len - 1, 0):
            let c = grid[y][x]
            if c == RoundRock and furthestRollIndex != x:
                    grid[y][x] = Empty
                    grid[y][furthestRollIndex] = c
                    furthestRollIndex = furthestRollIndex - 1
            elif c != Empty:
                furthestRollIndex = x - 1

proc northWeight(grid: Grid): int = 
    var totalWeight = 0
    let height = grid.len
    for y, r in grid:
        let rowWeight = r.count(RoundRock) * (height - y)
        totalWeight += rowWeight

    return totalWeight

proc cycle(grid: var Grid) =
    grid.tiltNorth
    grid.tiltWest
    grid.tiltSouth
    grid.tiltEast

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines

    var gridP1 = grid
    gridP1.tiltNorth

    # Cycle is deterministic. If we've seen a grid state before we must be in a loop
    var prevSeen = Table[Hash, int]()
    var gridP2 = grid
    for i in 0 ..< 1000000000:
        gridP2.cycle

        let hash = gridP2.hash
        if hash in prevSeen:
            let cycleSize = i - prevSeen[hash]
            var targetIter = (1000000000 - i).mod(cycleSize)

            for j in 0 ..< targetIter - 1:
                gridP2.cycle

            break
        else:
            prevSeen[hash] = i

    return (gridP1.northWeight, gridP2.northWeight)