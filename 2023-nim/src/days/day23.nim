import aoc_prelude

type Pos = tuple[y: int, x: int]
type State = tuple[pos: Pos, explored: HashSet[Pos], len: int]

proc neighbours(pos: Pos): array[4, Pos] =
    return [
        (y: pos.y - 1, x: pos.x    ),
        (y: pos.y + 1, x: pos.x    ),
        (y: pos.y,     x: pos.x - 1),
        (y: pos.y,     x: pos.x + 1)
    ]

type Connections = Table[Pos, seq[(Pos, int)]]

proc `+=`(a: var Pos, b: Pos) =
    a.y += b.y
    a.x += b.x

proc `+`(a: Pos, b: Pos): Pos =
    return (a.y + b.y, a.x + b.x)

proc buildConnections(grid: seq[string]): Connections = 
    var connections: Connections
    let startPos = (y: 0, x: grid[0].find('.'))

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
            while inGrid(nextPos + dir) and notWall(nextPos + dir):
                i += 1
                nextPos += dir

                if dir.y != 0:
                    let left = nextPos + (0, -1)
                    let right = nextPos + (0, 1)
                    if (inGrid(left) and notWall(left)) or (inGrid(right) and notWall(right)):
                        break

                elif dir.x != 0:
                    let up = nextPos + (-1, 0)
                    let down = nextPos + (1, 0)
                    if (inGrid(up) and notWall(up)) or (inGrid(down) and notWall(down)):
                        break

            if nextPos != curPos and nextPos notin explored:
                connections.mgetOrPut(curPos, newSeq[(Pos, int)]()).add((nextPos, i))
                connections.mgetOrPut(nextPos, newSeq[(Pos, int)]()).add((curPos, i))
                queue.add(nextPos)

    var progress = true
    while progress:
        let canPrune = connections.keys.toSeq.filterIt(connections[it].len == 2)
        progress = false
        for c in canPrune:
            let copyC = c
            if connections[c].len == 2:
                progress = true
                let (posA, distA) = connections[copyC][0]
                let (posB, distB) = connections[copyC][1]

                connections[posA] = connections[posA].filter(a => a[0] != copyC)
                connections[posB] = connections[posB].filter(a => a[0] != copyC)
                connections[posA].add((posB, distA + distB))
                connections[posB].add((posA, distA + distB))
                connections.del(copyC)

    return connections

proc p2(input_file: string): int =
    let grid = readFile(input_file).strip(leading = false).splitLines
    let startPos = (y: 0, x: grid[0].find('.'))
    let endPos = (y: grid.len - 1, x: grid[^1].find('.'))

    let connections = buildConnections(grid)

    var queue: seq[State]
    queue.add((pos: startPos, explored: HashSet[Pos](), len: 0))

    var maxPath = low(int)

    while queue.len > 0:
        let curState = queue.pop

        if curState.pos in curState.explored:
            # probably slopes causing issues
            continue

        if grid[curState.pos.y][curState.pos.x] == '#':
            quit "in wall!"

        if curState.pos == endPos:
            maxPath = max(maxPath, curState.len)
            continue

        var nextState = curState
        nextState.explored.incl(curState.pos)

        for (nextPos, dist) in connections[curState.pos]:
            if nextPos notin nextState.explored:
                var moveTo = nextState
                moveTo.pos = nextPos
                moveTo.len += dist
                queue.add(moveTo)

    return maxPath

proc p1(input_file: string): int =
    let grid = readFile(input_file).strip(leading = false).splitLines
    let startPos = (y: 0, x: grid[0].find('.'))
    let endPos = (y: grid.len - 1, x: grid[^1].find('.'))

    var queue: seq[State]
    queue.add((pos: startPos, explored: HashSet[Pos](), len: 0))

    var maxPath = low(int)

    while queue.len > 0:
        let curState = queue.pop
        var nextState = curState

        if curState.pos in curState.explored:
            # probably slope causing issue
            continue

        nextState.explored.incl(curState.pos)

        if curState.pos == endPos:
            maxPath = max(maxPath, curState.len)
            continue

        if grid[curState.pos.y][curState.pos.x] == '#':
            quit "in wall!"

        if grid[curState.pos.y][curState.pos.x] == '>':
            nextState.pos.x += 1
            nextState.len += 1
            queue.add(nextState)
            continue

        if grid[curState.pos.y][curState.pos.x] == '<':
            nextState.pos.x -= 1
            nextState.len += 1
            queue.add(nextState)
            continue

        if grid[curState.pos.y][curState.pos.x] == '^':
            nextState.pos.y -= 1
            nextState.len += 1
            queue.add(nextState)
            continue

        if grid[curState.pos.y][curState.pos.x] == 'v':
            nextState.pos.y += 1
            nextState.len += 1
            queue.add(nextState)
            continue

        for n in neighbours(curState.pos):
            if n.y >= 0 and n.y < grid.len and n.x >= 0 and n.x < grid[0].len:
                if grid[n.y][n.x] != '#' and n notin nextState.explored:
                    var moveTo = nextState
                    moveTo.pos = n
                    moveTo.len += 1
                    queue.add(moveTo) 

    return maxPath

proc run*(input_file: string): (int, int) =
    return (p1(input_file), p2(input_file))
