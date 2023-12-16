import aoc_prelude

type Pos = tuple[y: int, x:int]
type Dir = enum Up, Down, Left, Right
type State = (Pos, Dir)

proc energise(grid: seq[string], startState: State): int =
    var explored = HashSet[State]()
    var queue = newSeq[State]()

    let (minX, maxX, minY, maxY) = (0, grid[0].len - 1, 0, grid.len - 1)

    let outsideGrid = proc(p: Pos): bool = p.y < minY or p.y > maxY or p.x < minX or p.x > maxX

    queue.add(startState)

    while queue.len > 0:
        let state = queue.pop
        let (pos, dir) = (state[0], state[1])

        if state in explored:
            continue

        if pos.outsideGrid:
            continue

        explored.incl(state)

        case grid[pos.y][pos.x]
        of '.':
            let nextPos = case dir
            of Up:    (y: pos.y - 1, x: pos.x)
            of Down:  (y: pos.y + 1, x: pos.x)
            of Left:  (y: pos.y, x: pos.x - 1)
            of Right: (y: pos.y, x: pos.x + 1)
            queue.add((nextPos, dir))
        
        of '/':
            let nextDir = case dir
            of Up:    Right
            of Down:  Left
            of Left:  Down
            of Right: Up

            let nextPos = case nextDir
            of Up:    (y: pos.y - 1, x: pos.x)
            of Down:  (y: pos.y + 1, x: pos.x)
            of Left:  (y: pos.y, x: pos.x - 1)
            of Right: (y: pos.y, x: pos.x + 1)

            queue.add((nextPos, nextDir))

        of '\\':
            let nextDir = case dir
            of Up:    Left
            of Down:  Right
            of Left:  Up
            of Right: Down

            let nextPos = case nextDir
            of Up:    (y: pos.y - 1, x: pos.x)
            of Down:  (y: pos.y + 1, x: pos.x)
            of Left:  (y: pos.y, x: pos.x - 1)
            of Right: (y: pos.y, x: pos.x + 1)

            queue.add((nextPos, nextDir))

        of '-':
            if dir in [Left, Right]:
                let nextPos = case dir
                of Up:    (y: pos.y - 1, x: pos.x)
                of Down:  (y: pos.y + 1, x: pos.x)
                of Left:  (y: pos.y, x: pos.x - 1)
                of Right: (y: pos.y, x: pos.x + 1)
                queue.add((nextPos, dir))
            else:
                let splitStates = [((y: pos.y, x: pos.x - 1), Left), ((y: pos.y, x: pos.x + 1), Right)]
                for s in splitStates:
                    queue.add(s)

        of '|':
            if dir in [Up, Down]:
                let nextPos = case dir
                of Up:    (y: pos.y - 1, x: pos.x)
                of Down:  (y: pos.y + 1, x: pos.x)
                of Left:  (y: pos.y, x: pos.x - 1)
                of Right: (y: pos.y, x: pos.x + 1)
                queue.add((nextPos, dir))
            else:
                let splitStates = [((y: pos.y - 1, x: pos.x), Up), ((y: pos.y + 1, x: pos.x), Down)]
                for s in splitStates:
                    queue.add(s)


        else: 
            quit "aaahhh"

    let energised = explored.map(state => state[0])
    return energised.len    

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

    let p2 = startStatesP2.mapIt(energise(grid, it)).max

    return (energise(grid, startStateP1), p2)