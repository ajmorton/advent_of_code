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
            let copyOneWay = oneWay
            let (posA, distA, _) = connections[copyOneWay].filterIt(not it.canTraverse)[0]
            let (posB, distB, _) = connections[copyOneWay].filterIt(it.canTraverse)[0]
            let aCanInto = connections[posA].filterIt(it.pos == copyOneWay)[0].canTraverse

            connections[posA] = connections[posA].filter(a => a.pos != copyOneWay)
            connections[posA].add((posB, distA + distB, aCanInto))
            connections[posB] = connections[posB].filter(a => a.pos != copyOneWay)
            connections[posB].add((posA, distA + distB, false))
            connections.del(copyOneWay)

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

proc findLongestPath(input_file: string, considerSlopes: bool): int =
    let grid = readFile(input_file).strip(leading = false).splitLines
    let connections = buildConnections(grid, considerSlopes)

    var queue: seq[State]
    var bmap: BitMap
    queue.add((posId: StartPosId, explored: bmap, len: 0))

    var maxPath = low(int)

    while queue.len > 0:
        let curState = queue.pop

        if curState.posId == EndPosId:
            maxPath = max(maxPath, curState.len)
            continue

        var nextExplored = curState.explored
        nextExplored.setBit(curState.posId)

        for (nextPosId, dist) in connections[curState.posId]:
            if nextPosId != 0 and not nextExplored.testBit(nextPosId):
                queue.add((posId: nextPosId, explored: nextExplored, len: curState.len + dist))

    return maxPath

proc run*(input_file: string): (int, int) =
    let p1 = findLongestPath(input_file, true) 
    let p2 = findLongestPath(input_file, false) 
    return (p1, p2)
