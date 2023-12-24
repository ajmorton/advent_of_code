import aoc_prelude
import bitops

# When pruned both maps have fewer than 64 nodes so an int64 can track all explored nodes
type BitMap = int64
type PosId = int

const StartPosID = 1
const EndPosId = 2

type Pos = tuple[y: int, x: int]
type State = tuple[posId: PosId, explored: BitMap, len: int]
type ConnInterim = tuple[pos: Pos, dist: int, canTraverse: bool]
type ConnectionsInterim = Table[Pos, seq[ConnInterim]]
type Conn = tuple[pos: PosId, dist: int]
type Connections = array[64, array[4, Conn]]

proc `+=`(a: var Pos, b: Pos) =
    a.y += b.y
    a.x += b.x

proc `+`(a: Pos, b: Pos): Pos =
    return (a.y + b.y, a.x + b.x)

proc buildConnections(grid: seq[string], considerSlopes: bool): Connections = 
    var connections: ConnectionsInterim
    let startPos = (y: 0, x: grid[0].find('.'))
    let endPos = (y: grid.len - 1, x: grid[^1].find('.'))

    var explored: HashSet[Pos]
    var queue = newSeq[Pos]()
    queue.add(startPos)
    explored.incl(startPos)

    while queue.len > 0:
        let curPos = queue.pop
        explored.incl(curPos)

        for dir in [(y: 1, x: 0), (y: -1, x: 0), (y: 0, x: 1), (y: 0, x: -1)]:
            var nextPos = curPos
            let inGrid = proc(p: Pos): bool = p.y >= 0 and p.y < grid.len and p.x >= 0 and p.x < grid[0].len
            let notWall = proc(p: Pos): bool = grid[p.y][p.x] != '#'
            
            var i = 0
            var canReturn = true
            var canReach = true
            while inGrid(nextPos + dir) and notWall(nextPos + dir):

                if considerSlopes:
                    let allowedSlope = case dir
                    of (y: 1, x: 0): 'v'
                    of (y: -1, x: 0): '^'
                    of (y: 0, x: 1): '>'
                    of (y: 0, x: -1): '<'
                    else: quit "aaaaahhhhh"

                    if grid[(nextPos + dir).y][(nextPos + dir).x] == allowedSlope:
                        canReturn = false
                    if grid[(nextPos + dir).y][(nextPos + dir).x] notin ['.', allowedSlope]:
                        # Bit of a hack. This only works because we don't encounter perpendicular slopes
                        canReach = false

                i += 1
                nextPos += dir

                let sides = if dir.y != 0:
                    [(0, -1), (0, 1)]   # left and right
                else:
                    [((-1, 0)), (1, 0)] # below and above

                if sides.anyIt(inGrid(nextPos + it) and notWall(nextPos + it)):
                    break

            if nextPos != curPos and nextPos notin explored:
                connections.mgetOrPut(curPos, newSeq[ConnInterim]()).add((pos: nextPos, dist: i, canTraverse: canReach))
                connections.mgetOrPut(nextPos, newSeq[ConnInterim]()).add((pos: curPos, dist: i, canTraverse: canReturn))
                queue.add(nextPos)

    # Prune connections. If they just connect two other nodes then drop them in favour of a direct connection 
    var progress = true
    while progress:
        let canPrune = connections.keys.toSeq.filterIt(connections[it].len == 2)
        progress = false
        for c in canPrune:
            let copyC = c
            if connections[c].len == 2 and connections[c].allIt(it.canTraverse):
                progress = true
                let (posA, distA, canTraverseA) = connections[copyC][0]
                let (posB, distB, canTraverseB) = connections[copyC][1]

                if canTraverseA and canTraverseB:
                    connections[posA] = connections[posA].filter(a => a[0] != copyC)
                    connections[posB] = connections[posB].filter(a => a[0] != copyC)
                    connections[posA].add((posB, distA + distB, true))
                    connections[posB].add((posA, distA + distB, true))
                    connections.del(copyC)


        let oneWayConnectors = connections.keys.toSeq.filterIt(connections[it].len == 2 and connections[it].countIt(it.canTraverse) == 1)
        for oneWay in oneWayConnectors:
            progress = true
            let copyOneWay = oneWay
            let (posA, distA, _) = connections[copyOneWay].filterIt(not it.canTraverse)[0]
            let (posB, distB, _) = connections[copyOneWay].filterIt(it.canTraverse)[0]
            let aCanInto = connections[posA].filterIt(it.pos == copyOneWay)[0].canTraverse

            connections[posA] = connections[posA].filter(a => a.pos != copyOneWay)
            connections[posA].add((posB, distA + distB, aCanInto))
            connections[posB] = connections[posB].filter(a => a.pos != copyOneWay)
            connections[posB].add((posA, distA + distB, false))
            connections.del(copyOneWay)

    # If the endPos has a single node that reaches it then that node must head directly to the end, otherwise 
    # there's no way to return to the node and we can never reach the end pos.
    if connections[endPos].len == 1:
        let penultimate = connections[endPos][0].pos
        connections[penultimate] = connections[penultimate].filterIt(it.pos == endPos)

    var idCounter = 3
    var posIds: Table[Pos, int]
    posIds[startPos] = StartPosID
    posIds[endPos] = EndPosId

    for pos in connections.keys:
        if pos notin posIds:
            posIds[pos] = idCounter
            idCounter += 1

    # Prune nodes that can't be traversed
    var connectionsReal: Connections
    for c in connections.keys:
        for i, conn in connections[c].filterIt(it.canTraverse).mapIt((pos: posIds[it.pos], dist: it.dist)):
            connectionsReal[posIds[c]][i] = conn

    return connectionsReal

proc findLongestPath(connections: Connections, initState: State): int =
    var queue = [initState].toSeq
    var maxPath = low(int)

    while queue.len > 0:
        let (curPosId, curExplored, curLen) = queue.pop

        var nextExplored = curExplored
        nextExplored.setBit(curPosId)

        for (nextPosId, dist) in connections[curPosId]:
            if nextPosId != 0 and not nextExplored.testBit(nextPosId):
                if nextPosId == EndPosId:
                    maxPath = max(maxPath, curLen + dist)
                    continue

                queue.add((posId: nextPosId, explored: nextExplored, len: curLen + dist))

    return maxPath

# Find the first N paths while exploring the graph. 
# Note this is BFS unlike findLongestPath so that each path will have roughly the same amount of work to do.
proc getFirstNPaths(connections: Connections, initState: State, numPaths: int): seq[State] =
    var queue = [initState].toSeq
    var maxPath = low(int)

    while queue.len > 0:
        if queue.len >= numPaths:
            return queue

        let curState = queue.pop
        if curState.posId == EndPosId:
            maxPath = max(maxPath, curState.len)
            continue

        var nextExplored = curState.explored
        nextExplored.setBit(curState.posId)

        for (nextPosId, dist) in connections[curState.posId]:
            if nextPosId != 0 and not nextExplored.testBit(nextPosId):
                queue.insert((posId: nextPosId, explored: nextExplored, len: curState.len + dist), 0)

    quit "Couldn't find numPaths"

import std/threadpool
{.experimental: "parallel".}
proc findLongestPathParallel(connections: Connections, initState: State): int =
    # std/cpuinfo::countProcessors tells me I have zero cores :| 
    # Hardcoded to 64 as this is the fastest result experimentally 
    # even though I have 8 cores on this machine and no evidence of hyperthreading. 
    # Probably due to uneven workloads leaving some threads with nothing to do.
    let initPaths = getFirstNPaths(connections, initState, 64)

    var results = newSeq[int](initPaths.len)
    parallel:
        for i in 0 ..< initPaths.len:
            results[i] = spawn findLongestPath(connections, initPaths[i])

    return results.max

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines
    let connectionsP1 = buildConnections(grid, true)
    let connectionsP2 = buildConnections(grid, false)

    let initState: State = (posId: StartPosId, explored: 0, len: 0)
    let p1 = findLongestPath(connectionsP1, initState) 
    let p2 = findLongestPathParallel(connectionsP2, initState)
    return (p1, p2)
