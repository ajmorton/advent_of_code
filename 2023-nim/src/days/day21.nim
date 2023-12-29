import aoc_prelude
import deques

type Pos = tuple[y: int, x: int]

proc startPoint(grid: seq[string]): Pos =
    for y, r in grid:
        for x, c in r:
            if c == 'S':
                return (y: y, x: x)

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines
    var startPos = startPoint(grid)
    let (minY, maxY, minX, maxX) = ( 0, grid.len - 1, 0, grid[0].len - 1)

    var queue = [(pos: startPos, dist: 0)].toDeque
    var reachedIn: array[131, array[131, int]]

    while queue.len > 0:
        # Never pop items from the queue. Saves us an O(n) operation on each iteration at the expense of a small mem leak.
        let ((y, x), dist) = queue.popFirst
        
        for neighbour in [(y: y - 1, x: x), (y: y + 1, x: x), (y: y, x: x - 1), (y: y, x: x + 1)]:
            if neighbour.y >= minY and neighbour.y <= maxY and neighbour.x >= minX and neighbour.x <= maxX: 
                if grid[neighbour.y][neighbour.x] != '#':
                    if reachedIn[neighbour.y][neighbour.x] == 0:
                        reachedIn[neighbour.y][neighbour.x] = dist + 1
                        queue.addLast((pos: neighbour, dist: dist + 1))

    let reachedOnStep = proc(dist: int, step: int): bool = (dist != 0 and dist.mod(2) == step.mod(2) and dist <= step)
    let p1 = reachedIn.mapIt(it.countIt(reachedOnStep(it, 64))).sum

    # This is some mathematical magic courtesy of villuna 
    # https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21 
    let manhattan = proc(a, b:Pos): int = (a.y.abs - b.y.abs).abs + (a.x.abs - b.x.abs).abs 

    let (gridWidth, halfWidth) = (grid[0].len, grid[0].len div 2)
    let centerPoint = (halfWidth, halfWidth)

    var evenCorners, oddCorners, evenFull, oddFull = 0
    for y, r in reachedIn:
        for x, c in r:
            if c != 0:
                if c.mod(2) == 0:
                    evenFull += 1
                    if (y: y, x: x).manhattan(centerPoint) > halfWidth:
                        evenCorners += 1
                else:
                    oddFull += 1
                    if (y: y, x: x).manhattan(centerPoint) > halfWidth:
                        oddCorners += 1
    
    assert (26501365 - halfWidth).mod(gridWidth) == 0
    let n = (26501365 - halfWidth) div gridWidth
    let p2 = (n+1)^2 * odd_full + n^2 * even_full - (n+1) * oddCorners + n * evenCorners;

    return(p1, p2)
