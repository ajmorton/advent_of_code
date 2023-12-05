import sequtils, strutils, sugar, system, tables
import fusion/matching

type Range = (int, int)

# ret (origType, newType)
proc overlaps(a: Range, b: Range, delta: int): (seq[Range], seq[Range]) =

    # no overlaps
    if a[1] < b[0]:
        return ([a].toSeq, newSeq[Range]())
    if a[0] > b[1]:
        return ([a].toSeq, newSeq[Range]())

    # else some overlap
    if a[0] >= b[0] and a[1] <= b[1]:
        # b encompasses
        return (newSeq[Range](), [(a[0] + delta, a[1] + delta)].toSeq)
    elif a[0] < b[0] and a[1] > b[1]:
        # b contained
        var outside = newSeq[Range]()
        outside.insert((a[0], b[0] - 1))
        outside.insert((b[1] + 1, a[1]))

        var inside = (b[0] + delta, b[1] + delta)
        return (outside, [inside].toSeq)
    elif b[0] <= a[0] and b[1] < a[1]:
        # b left
        let origType = (b[1] + 1, a[1])
        let newType = (a[0] + delta, b[1] + delta)
        return ([origType].toSeq, [newType].toSeq)
    elif a[0] < b[0] and a[1] <= b[1]:
        # b right
        let origType = (a[0], b[0] - 1)
        let newType = (b[0] + delta, a[1] + delta)
        return ([origType].toSeq, [newType].toSeq)
    else:
        quit "Unhandled!"

    return 

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false)
    [@seedsLine, all @conversions] := lines.split("\n\n")
    let seeds = seedsLine["seeds: ".len .. ^1].strip().splitWhitespace().map(parseInt)

    var convTable = Table[(string), (string, seq[(int, int, int)])]()

    for conv in conversions:
        [@convType, all @convNumbers] := conv.strip().splitLines()
        [@origType, _, @newType] := convType.split(' ')[0].split('-')

        convTable[origType] = (newType, newSeq[(int, int, int)]())

        for convNumber in convNumbers:
            [@destRangeStart, @sourceRangeStart, @rangeLen] := convNumber.splitWhitespace.map(parseInt)
            convTable[origType][1].insert((destRangeStart, sourceRangeStart, rangeLen))

    # part 1 
    var minLocationP1 = high(int)
    for seed in seeds:
        var numType = "seed"
        var num = seed
        while numType != "location":
            var foundConv = false
            for (destRangeStart, sourceRangeStart, rangeLen) in convTable[numType][1]:
                if num >= sourceRangeStart and num < sourceRangeStart + rangeLen:
                    foundConv = true
                    num += (destRangeStart - sourceRangeStart)
                    break
            numType = convTable[numType][0]
            # else if no conversion found num is unchanged

        minLocationP1 = min(minLocationP1, num)

    # part 2
    var ranges = newSeq[(int, int)]()
    var seedsCopy = seeds
    while seedsCopy.len() != 0:
        ranges.insert((seedsCopy[0], seedsCopy[0] + seedsCopy[1] - 1))
        seedsCopy = seedsCopy[2..^1]

    var minLocationP2 = high(int)
    for r in ranges:
        var rangeType = "seed"
        var rrange = [r].toSeq
        while rangeType != "location":
            var newRanges = newSeq[Range]()
            for (destRangeStart, sourceRangeStart, rangeLen) in convTable[rangeType][1]:
                let origLen = rrange.len
                for _ in 0..<origLen:
                    let delta = destRangeStart - sourceRangeStart

                    let convRange = (sourceRangeStart, sourceRangeStart + rangeLen - 1)
                    let (origTypes, newTypes) = overlaps(rrange[0], convRange, delta)
                    rrange = rrange[1..^1]

                    newRanges.insert(newTypes)
                    rrange.add(origTypes)

            rrange.insert(newRanges)
            rangeType = convTable[rangeType][0]
            # else if no conversion found num is unchanged

        let smallest = rrange.map(x => x[0]).min
        minLocationP2 = min(minLocationP2, smallest)

    return (minLocationP1, minLocationP2)