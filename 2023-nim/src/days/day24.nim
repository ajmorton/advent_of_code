import aoc_prelude

type HailStone = tuple[x: float, y: float, z: float, vx: float, vy: float, vz: float]

proc parseHailstone(str: string): Hailstone = 
    [@pos, @vel] := str.split(" @ ")
    [@x, @y, @z] := pos.split(',').mapIt(it.strip).map(parseFloat)
    [@vx, @vy, @vz] := vel.split(',').mapIt(it.strip).map(parseFloat)

    return (x: x, y: y, z: z, vx: vx, vy: vy, vz: vz)

proc pathsIntersect2D(hailA, hailB: Hailstone): (float, float) =
    # a.x + a.vx * t == b.x + b.vx * u
    # a.vx * t + (a.x - b.x) == b.vx * u
    # (a.vx / b.vx) t + ((a.x - b.x)/b.vx) == u
    let m = (hailA.vx / hailB.vx)
    let n = ((hailA.x - hailB.x)/hailB.vx)
    # m t + n == u

    # (a.vy / b.vy) t + ((a.y - b.y)/b.vy) == u
    let o = (hailA.vy / hailB.vy)
    let p = ((hailA.y - hailB.y)/hailB.vy)
    # o t + p == u

    # m t + n == o t + p
    # (m - o) t == p - n
    let t = (p - n) / (m - o)
    let u = m * t + n

    let xIntersect = hailA.x + (hailA.vx * t)
    let yIntersect = hailA.y + (hailA.vy * t)

    if xIntersect notin [Inf, -Inf] and yIntersect notin [Inf, -Inf]:
        if t >= 0 and u >= 0:
            return (xIntersect, yIntersect)
    
    return (-Inf, -Inf)

# The world's loosest equality check because I have floating point inaccuracies 
# that are compounding and I don't want to deal with it. The fact this function 
# exists is an insult to mathematics. 
# TODO - Clean this up and hide my shame.
proc `~~=`(a: float, b: float): bool =
    const epsilon = 10.0
    return (a - b).abs <= epsilon

proc pathsIntersect3D(hailA, hailB: Hailstone): (float, float, float) =
    # a.x + a.vx * t == b.x + b.vx * u
    # a.vx * t + (a.x - b.x) == b.vx * u
    # (a.vx / b.vx) t + ((a.x - b.x)/b.vx) == u
    let m = (hailA.vx / hailB.vx)
    let n = ((hailA.x - hailB.x)/hailB.vx)
    # m t + n == u

    # (a.vy / b.vy) t + ((a.y - b.y)/b.vy) == u
    let o = (hailA.vy / hailB.vy)
    let p = ((hailA.y - hailB.y)/hailB.vy)
    # o t + p == u

    # m t + n == o t + p
    # (m - o) t == p - n
    let t = (p - n) / (m - o)
    let u = m * t + n

    let xIntersect = hailA.x + (hailA.vx * t)
    let yIntersect = hailA.y + (hailA.vy * t)

    if xIntersect notin [Inf, -Inf] and yIntersect notin [Inf, -Inf]:
        # if t >= 0 and u >= 0:
        # FIXME - floating point error -> numbers are drifting
        if (hailA.z + hailA.vz * t) ~~= (hailB.z + hailB.vz * u):
            let zIntersect = hailA.z + (hailA.vz * t)
            return (xIntersect, yIntersect, zIntersect)
    return (-Inf, -Inf, -Inf)


proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let hailstones = lines.map(parseHailstone)

    var p1 = 0
    for a in 0 ..< hailstones.len:
        for b in a + 1 ..< hailstones.len:
            let hailA = hailstones[a]
            let hailB = hailstones[b]

            let (xInt, yInt) = pathsIntersect2D(hailA, hailB)
            if (xInt, yInt) != (-Inf, -Inf):
                if 200000000000000.0 <= xInt and xInt <= 400000000000000.0:
                    if 200000000000000.0 <= yInt and yInt <= 400000000000000.0:
                        p1 += 1
    # P2
    var p2 = 0

    # Use the stone as the reference frame. Apply its velocity onto all other hail
    for vx in -300 .. 300:
        echo vx
        if p2 != 0:
            break
        for vy in -300 .. 300:
            if p2 != 0:
                break
            for vz in -300 .. 300:
                let firstHail = hailstones[0]
                var modifiedFirstHail = firstHail
                modifiedFirstHail.vx += vx.float
                modifiedFirstHail.vy += vy.float
                modifiedFirstHail.vz += vz.float


                var intPoint = (-Inf, -Inf, -Inf)
                var found = true
                var count = 0
                for otherHail in hailstones[1..^1]:
                    count += 1
                    var modifiedOtherHail = otherHail
                    modifiedOtherHail.vx += vx.float
                    modifiedOtherHail.vy += vy.float
                    modifiedOtherHail.vz += vz.float

                    var newIntPoint: (float, float, float)
                    newIntPoint = pathsIntersect3D(modifiedFirstHail, modifiedOtherHail)
    
                    if newIntPoint == (-Inf, -Inf, -Inf):
                        found = false
                        break

                    if intPoint == (-Inf, -Inf, -Inf):
                        intPoint = newIntPoint
                        continue

                    if intPoint[0] ~~= newIntPoint[0] and intPoint[1] ~~= newIntPoint[1] and intPoint[2] ~~= newIntPoint[2]:
                        # same
                        continue
                    else:
                        found = false
                        break  

                if found:
                    p2 = intPoint[0].int + intPoint[1].int + intPoint[2].int
                    break

    return (p1, p2)