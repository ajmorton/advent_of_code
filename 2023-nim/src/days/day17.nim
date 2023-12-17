import aoc_prelude
import heapqueue

type Dir = enum Up Down Left Right
type Pos = tuple[y: int, x: int]
# predHeatLoss, running heatLossScore, Pos, dir, consecutive forwards 
type State = (int, int, Pos, Dir, int, seq[Pos])

proc move(pos: Pos, dir: Dir): Pos =
    return case dir
    of Up:    ((y: pos.y - 1, x: pos.x))
    of Down:  ((y: pos.y + 1, x: pos.x))
    of Left:  ((y: pos.y, x: pos.x - 1))
    of Right: ((y: pos.y, x: pos.x + 1))

proc turnLeft(dir: Dir): Dir =
    return case dir
    of Up: Left
    of Left: Down
    of Down: Right
    of Right: Up

proc turnRight(dir: Dir): Dir =
    return case dir
    of Up: Right
    of Left: Up
    of Down: Left
    of Right: Down

proc manhattan(a: Pos, b: Pos): int = 
    return (a.y.abs - b.y.abs).abs + (a.x.abs - b.x.abs).abs 

proc `<`(a, b: State): bool = 
    return (a[0], a[1]) < (b[0], b[1])

proc findPath(grid: seq[seq[int]], minDistForward: int, maxDistForward: int): int =
    let (minX, maxX, minY, maxY) = (0, grid[0].len - 1, 0, grid.len - 1)
    let outsideGrid = proc(p: Pos): bool = p.y < minY or p.y > maxY or p.x < minX or p.x > maxX

    let targetPos = (maxY, maxX)
    let predHeatLoss = (0, 0).manhattan(targetPos)

    var queue: HeapQueue[State] = [(predHeatLoss, 0, (y:0, x:0), Right, 0, newSeq[Pos]())].toHeapQueue
    queue.push((predHeatLoss, 0, (y:0, x:0), Down, 0, newSeq[Pos]()))

    var explored: Table[(Pos, Dir, int), int]

    while queue.len > 0:
        let (curPredHeatLoss, curHeatLoss, curPos, curDir, curForwardCount, curPath) = queue.pop

        if explored.getOrDefault((curPos, curDir, curForwardCount), high(int)) <= curHeatLoss:
            continue

        explored[(curPos, curDir, curForwardCount)] = curHeatLoss

        if curPos == targetPos and curForwardCount >= minDistForward:
            return curHeatLoss

        # Move forward
        if curForwardCount < maxDistForward:
            let nextPos = curPos.move(curDir)
            if not nextPos.outsideGrid:
                let nextHeatLoss = curHeatLoss + grid[nextPos.y][nextPos.x]
                let nextPredHeatLoss = nextHeatLoss + nextPos.manhattan(targetPos)
                var nextPath = curPath
                nextPath.add(nextPos)
                queue.push( (nextPredHeatLoss, nextHeatLoss, nextPos, curDir, curForwardCount + 1, nextPath) )
        
        # Try left
        if curForwardCount >= minDistForward:
            block:
                let nextDir = curDir.turnLeft
                let nextPos = curPos.move(nextDir)
                if not nextPos.outsideGrid:
                    let nextHeatLoss = curHeatLoss + grid[nextPos.y][nextPos.x]
                    let nextPredHeatLoss = nextHeatLoss + nextPos.manhattan(targetPos)
                    var nextPath = curPath
                    nextPath.add(nextPos)
                    queue.push( (nextPredHeatLoss, nextHeatLoss, nextPos, nextDir, 1, nextPath) )

            # Try right
            block:
                let nextDir = curDir.turnRight
                let nextPos = curPos.move(nextDir)
                if not nextPos.outsideGrid:
                    let nextHeatLoss = curHeatLoss + grid[nextPos.y][nextPos.x]
                    let nextPredHeatLoss = nextHeatLoss + nextPos.manhattan(targetPos)
                    var nextPath = curPath
                    nextPath.add(nextPos)
                    queue.push( (nextPredHeatLoss, nextHeatLoss, nextPos, nextDir, 1, nextPath) )

    quit "No path found!"

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines.mapIt(it.map(c => c.ord - '0'.ord))

    let p1 = findPath(grid, 0, 3)
    let p2 = findPath(grid, 4, 10)

    return (p1, p2)
