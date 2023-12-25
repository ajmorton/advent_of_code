import aoc_prelude

type Dir = enum Up Down Left Right
type Pos = tuple[y: int, x: int]
type HeatLoss = int
type State = (HeatLoss, Pos, Dir)

proc manhattan(a, b: Pos): int =
    (a.y.abs - a.x.abs).abs + (a.x.abs - a.x.abs).abs

proc move(pos: Pos, dir: Dir): Pos =
    return case dir
    of Up:    ((y: pos.y - 1, x: pos.x))
    of Down:  ((y: pos.y + 1, x: pos.x))
    of Left:  ((y: pos.y, x: pos.x - 1))
    of Right: ((y: pos.y, x: pos.x + 1))

proc findPath(grid: seq[seq[int]], minDistForward: int, maxDistForward: int): int =
    let (minX, maxX, minY, maxY) = (0, grid[0].len - 1, 0, grid.len - 1)
    let outsideGrid = proc(p: Pos): bool = p.y < minY or p.y > maxY or p.x < minX or p.x > maxX

    let startPos = (0, 0)
    let targetPos = (maxY, maxX)


    # explored[y][x][entryOrientation] == lowestHeatLossSeen. Defaults to MAXINT
    var explored = newSeqWith(grid.len, newSeqWith(grid[0].len, [high(HeatLoss), high(HeatLoss)]))

    var bucketQueue = newSeqWith(grid.len * 2 * 9, newSeq[State]())
    let startEstimatedCost = manhattan(startPos, targetPos) 

    bucketQueue[startEstimatedCost].add((0, (y:0, x:0), Right))
    bucketQueue[startEstimatedCost].add((0, (y:0, x:0), Down))

    var minScore = 0
    while true:
        var found = false
        var nextState: State
        for score in minScore ..< bucketQueue.len:
            if bucketQueue[score].len > 0:
                nextState = bucketQueue[score].pop
                minScore = score
                found = true
                break

        if not found:
            break

        let (curHeatLoss, curPos, curDir) = nextState

        if curPos == targetPos:
            return curHeatLoss

        # Move forward and turn in both directions for all legal distances
        var cumHeatLoss = 0
        var nextPos = curPos
        for i in 1 .. maxDistForward:
            nextPos = nextPos.move(curDir)
            if nextPos.outsideGrid:
                break
            cumHeatLoss += grid[nextPos.y][nextPos.x]

            if i >= minDistForward:
                let nextHeatLoss = curHeatLoss + cumHeatLoss
                let leftTurnDir = [Left, Right, Down, Up][curDir.ord]
                let rightTurnDir = [Right, Left, Up, Down][curDir.ord]

                # Approaching a cell from opposite directions (Left and Right, Up and Down) results in 
                # the same two search nodes after turning. As such we can filter on direction orientation 
                # (horizontal, vertical) rather than actual direction.
                let entryDirOrientation = curDir.ord div 2
                if explored[nextPos.y][nextPos.x][entryDirOrientation] > nextHeatLoss:
                    explored[nextPos.y][nextPos.x][entryDirOrientation] = nextHeatLoss
                    let nextEstimatedCost = nextHeatLoss + manhattan(nextPos, targetPos) 
                    bucketQueue[nextEstimatedCost].add((nextHeatLoss, nextPos, leftTurnDir))
                    bucketQueue[nextEstimatedCost].add((nextHeatLoss, nextPos, rightTurnDir))

    quit "No path found!"

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines.mapIt(it.map(c => c.ord - '0'.ord))
    return (findPath(grid, 1, 3), findPath(grid, 4, 10))
