import aoc_prelude

type Vec = tuple[x: float, y: float, z: float, vx: float, vy: float, vz: float]
type Pos = tuple[x: float, y: float, z: float]

proc parseVec(str: string): Vec = 
    [@pos, @vel] := str.split(" @ ")
    [@x, @y, @z] := pos.split(',').mapIt(it.strip).map(parseFloat)
    [@vx, @vy, @vz] := vel.split(',').mapIt(it.strip).map(parseFloat)

    return (x: x, y: y, z: z, vx: vx, vy: vy, vz: vz)

proc addSpeed(vec: Vec, vel: Pos): Vec =
    (x: vec.x, y: vec.y, z: vec.z, vx: vec.vx + vel.x, vy: vec.vy + vel.y, vz: vec.vz + vel.z)

proc intersection3D(a: Vec, b: Vec, forwardInTime: bool): Option[Pos] =
    # To find the intersect solve for t1 and t2 in:
    # a.x + a.vx * t1 == b.x + b.vx * t2
    # a.y + a.vy * t1 == b.y + b.vy * t2
    
    # (a.vx / b.vx) t + ((a.x - b.x)/b.vx) == u == (a.vy / b.vy) t + ((a.y - b.y)/b.vy)
    #             m t + n                  == u ==             o t + p
    let m = a.vx / b.vx
    let n = (a.x - b.x)/b.vx
    let o = a.vy / b.vy
    let p = (a.y - b.y)/b.vy

    # This float math is fuzzy. Not sure that rounding to the nearest .1 is perfect, but it works for the input.
    # Nim reports two cases where rounding to the nearest 0,1 causes a difference of 0.25(?) and when I print the 
    # rounded and unrounded vals they're identical(??). You should never blame the compiler, but I don't think this 
    # is an issue on my end
    let t = ((p - n) / (m - o)).round(1)
    let u = (m * t + n).round(1)

    # # Reports the two rounding issues descibed above
    # let tUnrounded = (p - n) / (m - o)
    # if (tUnrounded.abs - t.abs).abs >= 0.1:
    #     echo fmt"Rounding error!"
    #     echo fmt"rounded = {t}, unRounded = {tUnrounded}, reported delta == {(tUnrounded.abs - t.abs).abs}"

    # With t and u solved find the point of intersection
    let xIntersect = a.x + (a.vx * t)
    let yIntersect = a.y + (a.vy * t)

    # Make sure the intersection isn't behind either vector
    if forwardInTime and (t < 0 or u < 0): 
        return none(Pos)

    if (a.z + a.vz * t) == (b.z + b.vz * u):
        let zIntersect = a.z + (a.vz * t)
        return some((xIntersect, yIntersect, zIntersect))

    return none(Pos)

proc factors(n: int): HashSet[int] =
    var facs: HashSet[int]
    for x in 1 .. n.float.sqrt.int + 2:
        if n.mod(x) == 0:
            facs.incl(x)
            facs.incl(n div x)

    return facs

proc findParallelVectors(vecs: seq[Vec], getP: proc(h: Vec): float, getV: proc(h: Vec): float): seq[(int, int)] =
    var commonVecs = newSeq[(int, int)]()
    var seenVec: Table[int, seq[int]]

    for h in vecs:
        seenVec.mgetOrPut(h.getV.int, newSeq[int]()).add(h.getP.int)

    for vel in seenVec.keys:
        for i in 0 ..< seenVec[vel].len:
            for j in i + 1 ..< seenVec[vel].len:
                let delta = (seenVec[vel][i].abs - seenVec[vel][j].abs).abs
                commonVecs.add((vel, delta))

    return commonVecs

proc findSpeeds(parallelDeltas: seq[(int, int)]): seq[int] =
    # Pick the smallest delta as computing factors is expensive
    let smallestDelta = parallelDeltas.sorted[0]
    let firstSpeed = smallestDelta[0]

    var validSpeeds: seq[int]
    for f in smallestDelta[1].factors:
        validSpeeds.add(firstSpeed + f)
        validSpeeds.add(firstSpeed - f)

    for (vx, delta) in parallelDeltas:
        validSpeeds = validSpeeds.filterIt((delta.mod(it - vx).abs) == 0)

    # negative speeds will also work
    validSpeeds = validSpeeds & validSpeeds.mapIt(it * -1)
    return validSpeeds

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let vecs = lines.map(parseVec)

    # P1
    let vecsIgnoreZ = vecs.mapIt((x: it.x, y: it.y, z: 0.0, vx: it.vx, vy: it.vy, vz: 0.0))
    var p1 = 0
    for a in 0 ..< vecsIgnoreZ.len:
        for b in a + 1 ..< vecsIgnoreZ.len:
            let intersect = intersection3D(vecsIgnoreZ[a], vecsIgnoreZ[b], true)
            if intersect.isSome:
                let (xInt, yInt, _) = intersect.get
                if xInt in 200000000000000.0 .. 400000000000000.0:
                    if yInt in 200000000000000.0 .. 400000000000000.0:
                        p1 += 1

    # P2
    var p2 = 0

    let getX = proc(h: Vec): float = h.x
    let getVx = proc(h: Vec): float = h.vx
    let getY = proc(h: Vec): float = h.y
    let getVy = proc(h: Vec): float = h.vy
    let getZ = proc(h: Vec): float = h.z
    let getVz = proc(h: Vec): float = h.vz
    let parallelDeltasX = findParallelVectors(vecs, getX, getVx)
    let parallelDeltasY = findParallelVectors(vecs, getY, getVy)
    let parallelDeltasZ = findParallelVectors(vecs, getZ, getVz)

    let commonXFacs = findSpeeds(parallelDeltasX)
    let commonYFacs = findSpeeds(parallelDeltasY)
    let commonZFacs = findSpeeds(parallelDeltasZ)

    # Use the stone as the reference frame. Apply its velocity onto all other hailstone vecs
    for vx in commonXFacs:
        for vy in commonYFacs.toSeq:
            for vz in commonZFacs.toSeq:
                let firstVec = vecs[0]
                var normalisedFirstVec = firstVec.addSpeed((x: vx.float, y: vy.float, z: vz.float))

                var intPoint: Option[Pos]
                var found = true
                for otherVec in vecs[1..^1]:
                    var normalisedOtherVec = otherVec.addSpeed((x: vx.float, y: vy.float, z: vz.float))
                    let newIntPoint = intersection3D(normalisedFirstVec, normalisedOtherVec, false)
    
                    if newIntPoint.isNone:
                        found = false
                        break

                    if intPoint.isNone:
                        intPoint = newIntPoint
                        continue

                    if intPoint.get != newIntPoint.get:
                        found = false
                        break  

                if found:
                    p2 = intPoint.get[0].int + intPoint.get[1].int + intPoint.get[2].int
                    return (p1, p2)

    # No p2 found
    quit "unreachable"
