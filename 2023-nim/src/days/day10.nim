import aoc_prelude

type Tile = enum
    Vert
    Hori
    UpRight
    UpLeft
    DownLeft
    DownRight
    Empty
    Start
    InBetween
    Blocked
    Flooded

type Dir = enum
    Up
    Down
    Left
    Right

type Pos = tuple[r: int, c: int]

proc nextTile(pos: Pos, tile: Tile, entryDir: Dir): Option[(Pos, Dir)] =

    let up = (r: pos.r - 1, c: pos.c)
    let down = (r: pos.r + 1, c: pos.c)
    let left = (r: pos.r, c: pos.c - 1)
    let right = (r: pos.r, c: pos.c + 1)

    case (tile, entryDir)
    of (Vert, Up):          return some((up, Up))
    of (Vert, Down):        return some((down, Down))
    of (Hori, Left):        return some((left, Left))
    of (Hori, Right):       return some((right, Right))
    of (UpRight, Down):       return some((right, Right))
    of (UpRight, Left):     return some((up, Up))
    of (UpLeft, Down):        return some((left, Left))
    of (UpLeft, Right):     return some((up, Up)) 
    of (DownRight, Up):     return some((right, Right))
    of (DownRight, Left):   return some((down, Down)) 
    of (DownLeft, Up):      return some((left, Left))
    of (DownLeft, Right):   return some((down, Down))
    else: return none((Pos, Dir))
    
proc parseTile(c: char): Tile =
    case c
    of '|': return Vert 
    of '-': return Hori 
    of 'L': return UpRight
    of 'J': return UpLeft
    of '7': return DownLeft
    of 'F': return DownRight
    of '.': return Empty
    of 'S': return Start
    else: quit "AAAHHH"

proc tileToChar(t: Tile): char =
    case t
    of Vert: return '|'  
    of Hori: return '-'  
    of UpRight: return 'L' 
    of UpLeft: return 'J' 
    of DownLeft: return '7' 
    of DownRight: return 'F' 
    of Empty: return '.' 
    of Start: return 'S' 
    of InBetween: return ' ' 
    of Blocked: return '*'
    of Flooded: return '~'

proc move(pos: Pos, dir: Dir): Pos =
    case dir
    of Up: return (r: pos.r - 1, c: pos.c)
    of Down: return (r: pos.r + 1, c: pos.c)
    of Left: return (r: pos.r, c: pos.c - 1)
    of Right: return (r: pos.r, c: pos.c + 1)

proc reverse(dir: Dir): Dir =
    case dir
    of Up: return Down
    of Down: return Up    
    of Left: return Right    
    of Right: return Left

proc connPosToMapPos(pos: Pos): Pos = 
    if pos.r mod 2 == 0 and pos.c mod 2 == 0:
        echo pos
        quit "Attempting to convert inBetween pos"
    else:
        return (r: (pos.r - 1) div 2, c: (pos.c - 1) div 2)

proc isBlocked(pos: Pos, map: seq[seq[Tile]], explored: seq[seq[int]], connectionsMap: seq[seq[Tile]]): bool =
        
    if pos.r.mod(2) == 0 and pos.c.mod(2) == 0:
        # can't be blocked, surrounded by InBetween cells
        return false

    # echo fmt"Trying {pos}"

    let (up, down, left, right) = (pos.move(Up), pos.move(Down), pos.move(Left), pos.move(Right))
    let (upConnTile, downConnTile, leftConnTile, rightConnTile) = 
        (connectionsMap[up.r][up.c], 
        connectionsMap[down.r][down.c], 
        connectionsMap[left.r][left.c], 
        connectionsMap[right.r][right.c])
    
    if upConnTile != InBetween:
        let mapPosUp = connPosToMapPos(up)
        let upIsExplored = explored[mapPosUp.r][mapPosUp.c] != -1
        if upIsExplored:
            if upConnTile in [Vert, DownLeft, DownRight]:
                if downConnTile != InBetween:
                    let mapPosDown = connPosToMapPos(down)
                    let downIsExplored = explored[mapPosDown.r][mapPosDown.c] != -1
                    if downIsExplored:
                        if downConnTile in [Vert, UpLeft, UpRight]:
                            return true

    if leftConnTile != InBetween:
        let mapPosleft = connPosToMapPos(left)
        let leftIsExplored = explored[mapPosleft.r][mapPosleft.c] != -1
        if leftIsExplored:
            if leftConnTile in [Hori, DownRight, UpRight]:
                if rightConnTile != InBetween:
                    let mapPosright = connPosToMapPos(right)
                    let rightIsExplored = explored[mapPosright.r][mapPosright.c] != -1
                    if rightIsExplored:
                        if rightConnTile in [Hori, DownLeft, UpLeft]:
                            return true

    return false

import system

proc floodFillCount(map: seq[seq[Tile]]): int =

    var localMap = map

    var explored = newSeq[seq[bool]]()
    for i in 0 ..< localMap.len:
        explored.add(newSeq[bool]())
        for j in 0 ..< localMap[i].len:
            explored[i].add(false)

    var queue = newSeq[Pos]()
    # Fk it, start from all edges
    for i in 0 ..< localMap.len:
        queue.add((r: i, c: 0))
        queue.add((r: i, c: localMap[0].len - 1))

    for j in 0 ..< localMap[0].len:
        queue.add((r: 0, c: j))
        queue.add((r: localMap.len - 1, c: j))

    while queue.len != 0:
        let curPos = queue.pop
        if explored[curPos.r][curPos.c]:
            continue

        explored[curPos.r][curPos.c] = true

        if localMap[curPos.r][curPos.c] == Empty:
            localMap[curPos.r][curPos.c] = Flooded

        if curPos.r != 0:
            let nextPos = curPos.move(Up)
            if localMap[nextPos.r][nextPos.c] in [Empty, InBetween]:
                queue.add(nextPos)

        if curPos.r != localMap.len - 1:
            let nextPos = curPos.move(Down)
            if localMap[nextPos.r][nextPos.c] in [Empty, InBetween]:
                queue.add(nextPos)

        if curPos.c != 0:
            let nextPos = curPos.move(Left)
            if localMap[nextPos.r][nextPos.c] in [Empty, InBetween]:
                queue.add(nextPos)

        if curPos.c != localMap[0].len - 1:
            let nextPos = curPos.move(Right)
            if localMap[nextPos.r][nextPos.c] in [Empty, InBetween]:
                queue.add(nextPos)

    # for r in localMap:
    #     for c in r:
    #         stdout.write tileToChar(c)
    #     stdout.write "\n"

    # map and count not working??
    var count = 0
    for r in localMap:
        for c in r:
            if c == Empty:
                count += 1

    return count

# using distMap as exploredMap
proc prepAndFlood(map: seq[seq[Tile]], dist: seq[seq[int]]): int = 

    # build connectionsMap
    var connectionsMap: seq[seq[Tile]]
    for i in 0 .. (2*map.len):
        connectionsMap.add(newSeq[Tile]())
        for j in 0 .. (2*map[0].len):
            if i.mod(2) == 0:
                connectionsMap[i].add(InBetween)
            elif j.mod(2) == 0:
                connectionsMap[i].add(InBetween)
            else:
                connectionsMap[i].add(map[(i - 1) div 2][(j - 1) div 2])

    # Fill in InBetween cells
    for y, r in connectionsMap:
        for x, c in r:
            if y != 0 and y != connectionsMap.len - 1 and x != 0 and x != connectionsMap[y].len - 1:
                if c == InBetween:
                    if isBlocked((r: y, c: x), map, dist, connectionsMap):
                        connectionsMap[y][x] = Blocked

    # finally flood fill
    return floodFillCount(connectionsMap)

proc connector(dirA: Dir, dirB: Dir): Tile =
    case [dirA, dirB].sorted
    of [Up, Down]:    return Vert
    of [Left, Right]: return Hori
    of [Up, Left]: return UpLeft
    of [Up, Right]: return UpRight
    of [Down, Left]: return DownLeft
    of [Down, Right]: return DownRight
    else:
        quit "invalid connection"

proc walk(startPos: Pos, startDir: Dir, map: var seq[seq[Tile]]): (int, int) =

    if startPos.r < 0 or startPos.r > map.len - 1:
        return (-1, -1)

    if startPos.c < 0 or startPos.c > map[0].len - 1:
        return (-1, -1)

    var (pos, dir) = (startPos, startDir)
    var tile = map[pos.r][pos.c] 

    var distMap: seq[seq[int]]
    for i in 0..map.len - 1:
        distMap.add(newSeq[int]())
        for j in 0..map[0].len - 1:
            distMap[i].add(-1)

    if tile == Empty:
        return (-1, -1)

    var dist = 1
    while true:
        distMap[pos.r][pos.c] = dist
        let next = nextTile(pos, tile, dir)
        if next.isNone:
            return (-1, -1)
        let (nextPos, nextDir) = next.get
        let nextTile = map[nextPos.r][nextPos.c]
        if nextTile == Start:
            distMap[nextPos.r][nextPos.c] = 0

            var revDist = 1
            var revDir = nextDir.reverse
            var revPos = nextPos.move(revDir)
            var revTile = map[revPos.r][revPos.c]

            let startConnector = connector(startDir, revDir)
            map[nextPos.r][nextPos.c] = startConnector

            while revDist < distMap[revPos.r][revPos.c]:
                let next = nextTile(revPos, revTile, revDir)
                if next.isNone:
                    return (-1, -1)
                let (nextPos, nextDir) = next.get
                let nextTile = map[nextPos.r][nextPos.c]
                (revPos, revDir, revTile) = (nextPos, nextDir, nextTile)
                revDist += 1
            
            # Ignore all pipes other than the loop
            for y, r in map:
                for x, c in r:
                    if distMap[y][x] == -1:
                        map[y][x] = Empty

            let containedCells = prepAndFlood(map, distMap)

            return (revDist, containedCells)
        else:
            (pos, tile, dir) = (nextPos, nextTile, nextDir)
            dist += 1


    return (-1, -1)

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    var map = lines.mapIt(it.map(parseTile))

    var startPos = (r: -1, c: -1)
    for r, row in map:
        for c, tile in row:
            if tile == Start:
                startPos = (r, c)

    assert startPos != (-1, -1)

    var p1 = -1
    for (pos, dir) in [
        ((r: startPos.r - 1, c: startPos.c    ), Up), 
        ((r: startPos.r + 1, c: startPos.c    ), Down), 
        ((r: startPos.r    , c: startPos.c - 1), Left), 
        ((r: startPos.r    , c: startPos.c + 1), Right)
    ]:
        let foundDist = walk(pos, dir, map)
        if foundDist != (-1, -1):
            return foundDist

    return (p1, 0)