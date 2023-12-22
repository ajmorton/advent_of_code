import aoc_prelude

type Pos = tuple[z: int, y: int, x: int]
type Offset = Pos
type Brick = tuple[start: Pos, offsets: seq[Offset], num: int]
type Chimney = Table[Pos, int]

proc add(a, b: Pos): Pos =
    return (a.z + b.z, a.y + b.y, a.x + b.x)

proc `<`(a, b: Brick): bool =
    a.start <= b.start

proc parseBrick(str: string, num: int): Brick =
    [@start, @endd] := str.split('~')
    [@sx,@sy,@sz] := start.split(',').map(parseInt)
    [@ex,@ey,@ez] := endd.split(',').map(parseInt)

    var shape: Brick
    shape.num = num
    shape.start = (sz, sy, sx)

    case (sz == ez, sy == ey, sx == ex)
    of (true, true, false):
        for x in min(sx, ex) .. max(sx, ex):
            shape.offsets.add((0, 0, x - sx))
    of (true, false, true):
        for y in min(sy, ey) .. max(sy, ey):
            shape.offsets.add((0, y - sy, 0))
    of (false, true, true):
        for z in min(sz, ez) .. max(sz, ez):
            shape.offsets.add((z - sz, 0, 0))
    of (true, true, true):
        shape.offsets.add((0, 0, 0))
    else:
        quit fmt"not a line {str}"

    return shape

proc hasBelow(brick: Brick, chimney: Chimney, ignore: HashSet[int]): HashSet[int] =
    var belowSet: HashSet[int]
    for off in brick.offsets:
        let point = brick.start.add(off)
        let below = (z: point.z - 1, y: point.y, x: point.x)
        if below.z == 0:
            belowSet.incl(-1)
        elif below in chimney and chimney[below] != 0 and chimney[below] != brick.num:
            belowSet.incl(chimney[below])
    belowSet.excl(ignore)
    return belowSet

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var bricks: Table[int, Brick]
    for i, line in lines:
        bricks[i + 1] = line.parseBrick(i + 1)

    let baseNum = -1
    var chimney: Chimney
    for x in 0..10:
        for y in 0..1:
            chimney[(0, y, x)] = baseNum

    for (num, brick) in bricks.pairs:
        for off in brick.offsets:
            chimney[brick.start.add(off)] = num

    # Fall
    for brick in bricks.values.toSeq.sorted:
        var bbrick = brick
        while bbrick.hasBelow(chimney, HashSet[int]()).len == 0:
            for off in bbrick.offsets:
                let point = bbrick.start.add(off)
                let pointBelow = bbrick.start.add(off).add((-1,0,0))
                chimney[point] = 0
                chimney[pointBelow] = bbrick.num
            bbrick.start.z -= 1
            bricks[brick.num] = bbrick

    var supports: Table[int, HashSet[int]]
    for b in bricks.keys:
        let brick = bricks[b]
        supports[b] = brick.hasBelow(chimney, HashSet[int]())

    var p1 = 0
    for b in bricks.keys:
        let ignoreSet = [b].toHashSet

        if supports.keys.toSeq.allIt((supports[it] - ignoreSet).len > 0):
            p1 += 1

    var p2 = 0
    for b in bricks.keys:
        var ignoreSet = [b].toHashSet

        var processing = true
        while processing:
            processing = false

            for c in supports.keys:
                if c in ignoreSet:
                    continue
                if (supports[c] - ignoreSet).len == 0:
                    processing = true
                    p2 += 1
                    ignoreSet.incl(c)

    return (p1, p2)