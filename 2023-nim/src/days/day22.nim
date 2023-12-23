import aoc_prelude
import std/intsets

type Pos = tuple[z: int, y: int, x: int]
type Offset = Pos
type Brick = tuple[start: Pos, offsets: seq[Offset], num: int]
type Chimney = seq[seq[seq[int]]]

proc add(a, b: Pos): Pos =
    return (a.z + b.z, a.y + b.y, a.x + b.x)

proc `<`(a, b: Brick): bool =
    a.start <= b.start

proc parseBrick(str: string, num: int): (Brick, Pos) =
    [@start, @endd] := str.split('~')
    [@sx, @sy, @sz] := start.split(',').map(parseInt)
    [@ex, @ey, @ez] := endd.split(',').map(parseInt)

    var shape: Brick
    shape.num = num
    shape.start = (sz, sy, sx)

    # Conveniently in the input the end values are always larger than the start values
    for x in sx .. ex:
        for y in sy .. ey:
            for z in sz .. ez:
                shape.offsets.add((z - sz, y - sy, x - sx))

    return (shape, (ez, ey, ex))

proc hasBelow(brick: Brick, chimney: Chimney, n: int): IntSet =
    var belowSet: IntSet
    for off in brick.offsets:
        let point = brick.start.add(off)
        let below = (z: point.z - n, y: point.y, x: point.x)
        if below.z <= 0:
            belowSet.incl(-1) # The floor
        else:
            let existingBrick = chimney[below.z][below.y][below.x]
            if existingBrick != 0 and existingBrick != brick.num:
                belowSet.incl(existingBrick)
    return belowSet

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var (maxZ, maxY, maxX) = (low(int), low(int), low(int))
    var bricks: Table[int, Brick]
    for i, line in lines:
        let (brick, maxPos) = line.parseBrick(i + 1)
        maxZ = max(maxZ, maxPos.z + 1)
        maxY = max(maxY, maxPos.y + 1)
        maxX = max(maxX, maxPos.x + 1)
        bricks[i + 1] = brick

    var chimney = newSeqWith(maxZ, newSeqWith(maxY, newSeqWith(maxX, 0)))
    for (num, brick) in bricks.pairs:
        for off in brick.offsets:
            let point = brick.start.add(off)
            chimney[point.z][point.y][point.x] = num

    # Fall
    for brick in bricks.values.toSeq.sorted:
        var fallDist = 0
        while brick.hasBelow(chimney, fallDist + 1).len == 0:
            fallDist += 1

        if fallDist != 0:
            for off in brick.offsets:
                let point = brick.start.add(off)
                let pointBelow = brick.start.add(off).add((-fallDist,0,0))
                chimney[point.z][point.y][point.x] = 0
                chimney[pointBelow.z][pointBelow.y][pointBelow.x] = brick.num

            bricks[brick.num].start.z -= fallDist

    let allBricks = bricks.keys.toSeq
    var below = allBricks.mapIt( (it, bricks[it].hasBelow(chimney,  1)) ).toTable
    var above = allBricks.mapIt( (it, bricks[it].hasBelow(chimney, -1)) ).toTable

    # The standard lib uses the deprecated `assign` in packedsets. Suppress it
    {.warning[Deprecated]:off.}
    var solitarySupports = below.values.toSeq.filterIt(it.len == 1).foldl(a + b)
    {.warning[Deprecated]:on.}
    solitarySupports.excl(-1) # Ignore the floor when counting bricks
    let p1 = allBricks.len - solitarySupports.len

    var p2 = 0
    var memo: Table[int, IntSet]
    for brick in bricks.values.toSeq.sorted(order = SortOrder.Descending):
        let b = brick.num
        var fallSet = [b].toIntSet
        var newFalls = [b].toSeq

        var i = 0
        while i < newFalls.len:
            for c in above[newFalls[i]]:
                if c in fallSet:
                    continue
                if (below[c] - fallSet).len == 0:
                    # There's always a memo-ised result since we process higher bricks first.
                    let falls = memo[c]
                    newFalls.add(falls.toSeq)
                    fallSet.incl(falls)
            i += 1

        p2 += fallSet.len - 1 # - 1 so we don't include the destroyed brick
        memo[b] = fallSet

    return (p1, p2)