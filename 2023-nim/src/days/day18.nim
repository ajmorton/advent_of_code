import aoc_prelude

type Dir = enum Up Down Left Right
type Pos = tuple[y: int, x: int]

proc p1(input_file: string): int = 
    let lines = readFile(input_file).strip(leading = false).splitLines

    var dug: HashSet[Pos]
    var curPos = (y: 0, x: 0)

    dug.incl(curPos)
    for line in lines:
        [@dirStr, @distStr, @colourStr] := line.splitWhitespace

        let dir = case dirStr[0]
        of 'R': Right
        of 'U': Up
        of 'L': Left
        of 'D': Down
        else: quit "bad dir"

        let dist = distStr.parseInt

        # Ignore colour for now
        case dir
        of Up: 
            for _ in 0 ..< dist:
                curPos.y -= 1
                dug.incl(curPos)
        of Down:
            for _ in 0 ..< dist:
                curPos.y += 1
                dug.incl(curPos)
        of Left:
            for _ in 0 ..< dist:
                 curPos.x -= 1
                 dug.incl(curPos)
        of Right:
            for _ in 0 ..< dist:
                 curPos.x += 1
                 dug.incl(curPos)

    var minX, maxX, minY, maxY = 0
    for pos in dug:
        if pos.y < minY: minY = pos.y
        if pos.y > maxY: maxY = pos.y
        if pos.x < minX: minX = pos.x
        if pos.x > maxX: maxX = pos.x

    var unreached: HashSet[Pos]
    for y in minY - 2 .. maxY + 2:
        for x in minX - 2 .. maxX + 2:
            unreached.incl((y:y, x:x))

    var explored: HashSet[Pos]
    var queue = newSeq[Pos]()
    queue.add((y: minY - 2, x: minX - 2))
    while queue.len != 0:
        let nextPos = queue.pop
        unreached.excl(nextPos)
        for y in nextPos.y - 1 .. nextPos.y + 1:
            for x in nextPos.x - 1 .. nextPos.x + 1:
                let neighbour = (y: y, x: x)
                if neighbour.y >= minY - 2 and neighbour.y <= maxY + 2 and
                   neighbour.x >= minX - 2 and neighbour.x <= maxX + 2 and
                   neighbour notin explored and neighbour notin dug:
                    queue.add(neighbour)
                    explored.incl(neighbour)

    return unreached.len

proc p2(input_file: string): int = 
    let lines = readFile(input_file).strip(leading = false).splitLines

    var dug: HashSet[Pos]
    var curPos = (y: 0, x: 0)

    var corners = newSeq[Pos]()
    dug.incl(curPos)

    var numPointsAlongPerimeter = 0
    for line in lines:
        [@dirStr, @distStr, @colourStr] := line.splitWhitespace

        let colourNumsStr = colourStr[2..^2]
        let dist = colourNumsStr[0..^2].parseHexInt

        let dir = case colourNumsStr[^1]
        of '0': Right
        of '1': Down
        of '2': Left
        of '3': Up
        else: quit "inval dir!"

        numPointsAlongPerimeter += dist
        case dir
        of Up:   curPos.y -= dist
        of Down: curPos.y += dist
        of Left: curPos.x -= dist
        of Right: curPos.x += dist

        corners.add(curPos)


    type Matrix = array[2, array[2, int]]
    var matrices = newSeq[Matrix]()
    for i in 0 ..< corners.len - 1:
        let a = corners[i]
        let b = corners[i+1]
        matrices.add([[a.y, b.y], [a.x, b.x]])

    # close the loop
    let a = corners[^1]
    let b = corners[0]
    matrices.add([[a.x, b.x], [a.y, b.y]])

    let determinant = proc(m: Matrix): int = m[0][0] * m[1][1] - m[0][1] * m[1][0]

    let area = matrices.map(determinant).sum.abs div 2

    let numPointFullyInsidePolygon = (area - (numPointsAlongPerimeter div 2)) + 1

    return numPointFullyInsidePolygon + numPointsAlongPerimeter

proc run*(input_file: string): (int, int) =
    return (p1(input_file), p2(input_file))
