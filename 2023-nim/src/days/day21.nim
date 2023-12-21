import aoc_prelude

type Pos = tuple[y: int, x: int]
type State = tuple[pos: Pos, dist: int]

proc run*(input_file: string): (int, int) =
    let grid = readFile(input_file).strip(leading = false).splitLines
    let (height, width) = (grid.len, grid[0].len)

    var startPos = (y: 0, x: 0)
    for y, r in grid:
        for x, c in r:
            if c == 'S':
                startPos = (y: y, x: x)
                break

    var queue = newSeq[State]()
    queue.insert((pos: startPos, dist: 0), 0)

    var explored: Table[Pos, int]
    var seen = 0
    var p1 = 0
    var p2Points = newSeq[int]()

    while queue.len > 0:
        let (pos, dist) = queue.pop

        if dist == 64 and seen != 64:
            p1 = explored.values.toSeq.countIt(it.mod(2) == 0)
            seen = dist

        if (dist).mod(131) == 65 and seen < dist:
            p2Points.add(explored.values.toSeq.countIt(it.mod(2) == dist.mod(2)))
            if p2Points.len >= 3:
                break
            seen = dist

        for neighbour in [(y: pos.y - 1, x: pos.x), (y: pos.y + 1, x: pos.x), (y: pos.y, x: pos.x - 1), (y: pos.y, x: pos.x + 1)]:
                if grid[neighbour.y.euclMod(height)][neighbour.x.euclMod(width)] != '#':
                    if neighbour in explored:
                        discard
                    else:
                        explored[neighbour] = dist + 1
                        queue.insert((pos: neighbour, dist: dist + 1), 0)

    # Compute the polynomial
    # y    = a(x)^2 + b(x) + c
    # y[0] = a(0)^2 + b(0) + c   =>             c = y[0]    (eq1)
    # y[1] = a(1)^2 + b(1) + c   =>    a +  b + c = y[1]    (eq2)
    # y[2] = a(2)^2 + b(2) + c   =>   4a + 2b + c = y[2]    (eq3)

    # c == y[0]
    let c = p2Points[0]

    # (eq3) - 2*(eq2)
    # 2a - c =  y[2] - 2*y[1]
    #  a     = (y[2] - 2*y[1] + c) / 2
    let a = (p2Points[2] - (2 * p2Points[1]) + c) div 2

    # a + b + c = y[1]
    # b = y[1] - a - c
    let b = p2Points[1] - a - c
    
    let x = 202300
    let p2 = a * x^2 + b * x + c

    return (p1, p2)
