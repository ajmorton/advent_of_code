import aoc_prelude
import bitops

type Pos = tuple[y: int, x:int]
type Dir = uint8
const EnteredFromMask : uint8 = 0b1111 
const Up    : uint8 = 0b0001 
const Right : uint8 = 0b0010 
const Down  : uint8 = 0b0100 
const Left  : uint8 = 0b1000

type State = (Pos, Dir)

proc move(pos: Pos, dir: Dir): State =
    return case dir
    of Up:    ((y: pos.y - 1, x: pos.x), Up)
    of Down:  ((y: pos.y + 1, x: pos.x), Down)
    of Left:  ((y: pos.y, x: pos.x - 1), Left)
    of Right: ((y: pos.y, x: pos.x + 1), Right)
    else: quit "inval dir!"

proc energise(grid: seq[string], startState: State, explored: var seq[seq[uint8]]): int =
    let (minX, maxX, minY, maxY) = (0, grid[0].len - 1, 0, grid.len - 1)
    let outsideGrid = proc(p: Pos): bool = p.y < minY or p.y > maxY or p.x < minX or p.x > maxX

    var curState = startState
    var energised = 0
    while true:
        let (pos, dir) = (curState[0], curState[1])

        if pos.outsideGrid or explored[pos.y][pos.x].bitand(dir) == dir:
            break

        if explored[pos.y][pos.x].masked(EnteredFromMask) == 0:
            energised += 1
        explored[pos.y][pos.x] += dir

        case (grid[pos.y][pos.x], dir)
        of ('.', _), ('-', Left), ('-', Right), ('|', Up), ('|', Down):
            curState = pos.move(dir)
        of ('/', _):  
            let nextDir = [Right, Up, Left, Down][dir.firstSetBit - 1]
            curState = pos.move(nextDir)
        of ('\\', _): 
            let nextDir = [Left, Down, Right, Up][dir.firstSetBit - 1]
            curState = pos.move(nextDir)
        of ('-', _):  
            energised += energise(grid, pos.move(Left), explored)
            curState = pos.move(Right)
        of ('|', _):  
            energised += energise(grid, pos.move(Up), explored)
            curState = pos.move(Down)
        else:
            quit "aaahhh"

    return energised

proc energise2(grid: seq[string], startState: State): int =
    var explored = newSeqWith(grid.len, newSeq[uint8](grid[0].len))
    return energise(grid, startState, explored)

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines

    let startStateP1 = ((y: 0, x: 0), Right)

    var startStatesP2 = newSeq[State]()
    for y in 0 ..< grid.len:
        startStatesP2.add(((y: y, x: 0), Right))
        startStatesP2.add(((y: y, x: grid[0].len - 1), Left))
    for x in 0 ..< grid[0].len:
        startStatesP2.add(((y: 0, x: x), Down))
        startStatesP2.add(((y: grid.len - 1, x: x), Up))

    var explored = newSeqWith(grid.len, newSeq[uint8](grid[0].len))
    let p2 = startStatesP2.mapIt(energise2(grid, it)).max

    return (energise(grid, startStateP1, explored), p2)