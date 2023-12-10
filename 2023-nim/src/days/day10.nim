import aoc_prelude

type Tile = enum Vert Hori UpRight UpLeft DownLeft DownRight Empty Start
type Dir  = enum Up Down Left Right
type Pos  = tuple[r: int, c: int]
type Map  = seq[seq[Tile]]

proc up(pos: Pos): Pos    = (r: pos.r - 1, c: pos.c    )
proc down(pos: Pos): Pos  = (r: pos.r + 1, c: pos.c    )
proc left(pos: Pos): Pos  = (r: pos.r,     c: pos.c - 1)
proc right(pos: Pos): Pos = (r: pos.r,     c: pos.c + 1)

proc contains(map: Map, pos: Pos): bool = 
    return pos.r >= 0 or pos.r <= map.len - 1 and pos.c >= 0 and pos.c <= map[0].len - 1

proc nextTile(pos: Pos, tile: Tile, entryDir: Dir): Option[(Pos, Dir)] =
    case (tile, entryDir)
    of (Vert,      Up   ): return some((pos.up,    Up   ))
    of (Vert,      Down ): return some((pos.down,  Down ))
    of (Hori,      Left ): return some((pos.left,  Left ))
    of (Hori,      Right): return some((pos.right, Right))
    of (UpRight,   Down ): return some((pos.right, Right))
    of (UpRight,   Left ): return some((pos.up,    Up   ))
    of (UpLeft,    Down ): return some((pos.left,  Left ))
    of (UpLeft,    Right): return some((pos.up,    Up   )) 
    of (DownRight, Up   ): return some((pos.right, Right))
    of (DownRight, Left ): return some((pos.down,  Down )) 
    of (DownLeft,  Up   ): return some((pos.left,  Left ))
    of (DownLeft,  Right): return some((pos.down,  Down ))
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

proc move(pos: Pos, dir: Dir): Pos =
    case dir
    of Up:    return (r: pos.r - 1, c: pos.c    )
    of Down:  return (r: pos.r + 1, c: pos.c    )
    of Left:  return (r: pos.r,     c: pos.c - 1)
    of Right: return (r: pos.r,     c: pos.c + 1)

proc connector(dirA: Dir, dirB: Dir): Tile =
    case [dirA, dirB].sorted
    of [Up,   Down ]: return Vert
    of [Left, Right]: return Hori
    of [Up,   Left ]: return UpLeft
    of [Up,   Right]: return UpRight
    of [Down, Left ]: return DownLeft
    of [Down, Right]: return DownRight
    else:
        quit "invalid connection"

# We know the loop is enclosed we can ignore horizontal barriers and just track when we 
# cross a vertical boundary in or out of the loop. We could also use [Vert, DownLeft, DownRight] 
# as we just need to pair corners with a vertical component.
proc countContained(map: Map): int =
    var count = 0
    var isInside = false
    for r in map:
        for c in r:
            if c in [Vert, UpLeft, UpRight]:
                isInside = not isInside
            else:
                if isInside and c == Empty:
                    count += 1
    return count

proc walk(startPos: Pos, startDir: Dir, map: var Map): Option[(int, int)] =

    if not map.contains(startPos):
        return none((int, int))

    var (pos, dir) = (startPos, startDir)
    var tile = map[pos.r][pos.c] 

    var distMap: seq[seq[int]]
    for i in 0..map.len - 1:
        distMap.add(newSeq[int]())
        for j in 0..map[0].len - 1:
            distMap[i].add(-1)

    if tile == Empty:
        return none((int, int))

    var dist = 1
    while true:
        distMap[pos.r][pos.c] = dist
        let next = nextTile(pos, tile, dir)
        if next.isNone:
            return none((int, int))
        let (nextPos, nextDir) = next.get
        let nextTile = map[nextPos.r][nextPos.c]
        if nextTile == Start:
            distMap[nextPos.r][nextPos.c] = 0

            var revDir = { Up: Down, Down: Up, Left: Right, Right: Left }.toTable[nextDir]

            let startConnector = connector(startDir, revDir)
            map[nextPos.r][nextPos.c] = startConnector

            # Ignore all pipes other than the loop
            for y, r in map:
                for x, c in r:
                    if distMap[y][x] == -1:
                        map[y][x] = Empty

            # for r in map:
            #     for c in r:
            #         stdout.write tileToChar(c)
            #     stdout.write "\n"

            let containedCells = countContained(map)
            return some(((dist + 1) div 2, containedCells))
        else:
            (pos, tile, dir) = (nextPos, nextTile, nextDir)
            dist += 1

    return none((int, int))

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    var map = lines.mapIt(it.map(parseTile))

    var startPos = (r: -1, c: -1)
    for r, row in map:
        for c, tile in row:
            if tile == Start:
                startPos = (r, c)

    assert startPos != (-1, -1)

    for (pos, dir) in [ (startPos.up, Up), (startPos.down, Down), (startPos.left, Left), (startPos.right, Right)]:
        let res = walk(pos, dir, map)
        if res.isSome:
            return res.get

    quit "unreachable"