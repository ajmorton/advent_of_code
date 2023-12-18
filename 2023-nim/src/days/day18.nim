import aoc_prelude

type Pos = tuple[y: int, x: int]
type Instr = tuple[dir: char, dist: int, colour: string]

proc computeArea(points: seq[Pos], perimeterLength: int): int =

    # Shoelace theorem to compute area of the polygon 
    var area = 0
    let pointsClosed = points & points[0]
    for i in 0 ..< pointsClosed.len - 1:
        let a = pointsClosed[i]
        let b = pointsClosed[i+1]
        area += a.y * b.x - a.x * b.y
    area = area.abs div 2

    # Pick's theorem to compute points fully contained by the polygon
    let fullyContained = (area - (perimeterLength div 2)) + 1

    # Fully contained points + points along the perimeter == area
    return fullyContained + perimeterLength

proc p1(instrs: seq[Instr]): int = 
    var curPos = (y: 0, x: 0)
    var points = newSeq[Pos]()

    var perimeterLength = 0
    for instr in instrs:

        perimeterLength += instr.dist

        case instr.dir
        of 'U': curPos.y -= instr.dist
        of 'D': curPos.y += instr.dist
        of 'L': curPos.x -= instr.dist
        of 'R': curPos.x += instr.dist
        else: quit fmt"Unrecognised direction '{instr.dir}'"

        points.add(curPos)

    return computeArea(points, perimeterLength)

proc p2(instrs: seq[Instr]): int = 

    var curPos = (y: 0, x: 0)
    var points = newSeq[Pos]()

    var perimeterLength = 0
    for instr in instrs:

        let dist = instr.colour[0..^2].parseHexInt

        perimeterLength += dist
        case instr.colour[^1]
        of '0': curPos.x += dist # Right
        of '1': curPos.y += dist # Down
        of '2': curPos.x -= dist # Left
        of '3': curPos.y -= dist # Up
        else: quit fmt"Unrecognised direction '{instr.colour[^1]}'"

        points.add(curPos)

    return computeArea(points, perimeterLength)

proc parseInstr(instr: string): Instr =
    [@dir, @dist, @colourStr] := instr.splitWhitespace
    return (dir: dir[0], dist: dist.parseInt, colour: colourStr[2..^2])

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let instrs = lines.map(parseInstr)
    return (p1(instrs), p2(instrs))
