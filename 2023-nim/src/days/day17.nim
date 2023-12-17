import aoc_prelude
import heapqueue

type Dir = enum Up Down Left Right
type Pos = tuple[y: int, x: int]
# predHeatLoss, running heatLossScore, Pos, dir, consecutive forwards 
type State = (int, int, Pos, Dir, int)

proc move(pos: Pos, dir: Dir): Pos =
    return case dir
    of Up:    ((y: pos.y - 1, x: pos.x))
    of Down:  ((y: pos.y + 1, x: pos.x))
    of Left:  ((y: pos.y, x: pos.x - 1))
    of Right: ((y: pos.y, x: pos.x + 1))

proc manhattan(a: Pos, b: Pos): int = 
    return (a.y.abs - b.y.abs).abs + (a.x.abs - b.x.abs).abs 

proc `<`(a, b: State): bool = 
    return a[0] < b[0]

proc findPath(grid: seq[seq[int]], minDistForward: int, maxDistForward: int): int =
    let (minX, maxX, minY, maxY) = (0, grid[0].len - 1, 0, grid.len - 1)
    let outsideGrid = proc(p: Pos): bool = p.y < minY or p.y > maxY or p.x < minX or p.x > maxX

    let targetPos = (maxY, maxX)

    var queue: HeapQueue[State]
    let initPredHeatLoss = (0, 0).manhattan(targetPos)
    queue.push((initPredHeatLoss, 0, (y:0, x:0), Right, 0))
    queue.push((initPredHeatLoss, 0, (y:0, x:0), Down,  0))

    var explored: Table[(Pos, Dir, int), int]

    while queue.len > 0:
        let (curPredHeatLoss, curHeatLoss, curPos, curDir, curForwardCount) = queue.pop

        if explored.getOrDefault((curPos, curDir, curForwardCount), high(int)) <= curHeatLoss:
            continue

        explored[(curPos, curDir, curForwardCount)] = curHeatLoss

        if curPos == targetPos and curForwardCount >= minDistForward:
            return curHeatLoss

        if curForwardCount == 0:
            # Move forward
            var cumHeatLoss = 0
            var nextPos = curPos

            for i in 1 .. maxDistForward:
                nextPos = nextPos.move(curDir)
                if nextPos.outsideGrid:
                    break
                cumHeatLoss += grid[nextPos.y][nextPos.x]

                if i >= minDistForward:
                    let nextHeatLoss = curHeatLoss + cumHeatLoss
                    let nextPredHeatLoss = nextHeatLoss + nextPos.manhattan(targetPos)
                    queue.push( (nextPredHeatLoss, nextHeatLoss, nextPos, curDir, i) )

        else: # curForwardCount != 0
            # Try left and right
            let leftTurnDir = [Left, Right, Down, Up][curDir.ord]
            let rightTurnDir = [Right, Left, Up, Down][curDir.ord]
            queue.push( (curPredHeatLoss, curHeatLoss, curPos, leftTurnDir, 0) )
            queue.push( (curPredHeatLoss, curHeatLoss, curPos, rightTurnDir, 0) )

    quit "No path found!"

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines.mapIt(it.map(c => c.ord - '0'.ord))
    return (findPath(grid, 1, 3), findPath(grid, 4, 10))
