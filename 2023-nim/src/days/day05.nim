import aoc_prelude

type ConvTable = Table[(string), (string, seq[(int, int, int)])]
type Range = tuple[min: int, max: int]

# Given two ranges a and b, return the ranges (a left of b, a overlaps b, a right of b)
proc splitRange(a: Range, b: Range): (Option[Range], Option[Range], Option[Range]) =
    if a.min > b.max:
        # No overlap. a is to the right
        return (none(Range), none(Range), some(a))
    elif a.max < b.min:
        # No overlap. a is to the left
        return (some(a), none(Range), none(Range))
    elif a.min < b.min and a.max > b.max:
        # a encompasses b
        return (some((a.min, b.min - 1)), some(b), some((b.max + 1, a.max))) 
    elif a.min >= b.min and a.max <= b.max:
        # a encompassed by b
        return (none(Range), some(a), none(Range))
    elif a.min < b.min:
        # b to the right
        return (some((a.min, b.min - 1)), some((b.min, a.max)), none(Range))
    elif a.max > b.max:
        # b to the left
        return (none(Range), some((a.min, b.max)), some((b.max + 1, a.max)))

    quit "Unreachable"

proc getMinLocation(ranges: seq[(int, int)], convTable: ConvTable): int =
    var rangeType = "seed"
    var curTypeRanges = ranges
    while rangeType != "location":
        var nextTypeRanges = newSeq[Range]()
        var convRanges: seq[(int, int, int)]
        (rangeType, convRanges) = convTable[rangeType]

        for (destRangeStart, sourceRangeStart, rangeLen) in convRanges:
            let convRange = (sourceRangeStart, sourceRangeStart + rangeLen - 1)
            let delta = destRangeStart - sourceRangeStart
            var nonOverlap = newSeq[Range]()

            for r in curTypeRanges:
                let (left, overlap, right) = splitRange(r, convRange)
                let conv = overlap.map(r => (r.min + delta, r.max + delta))

                if  left.isSome: nonOverlap.add(left.get)
                if right.isSome: nonOverlap.add(right.get)
                if  conv.isSome: nextTypeRanges.insert(conv.get) 
            curTypeRanges = nonOverlap

        # else if no conversion found num is unchanged
        curTypeRanges.insert(nextTypeRanges)

    let smallestLocation = curTypeRanges.map(x => x[0]).min
    return smallestLocation

proc buildConvTable(conversions: seq[string]): ConvTable =
    var convTable = ConvTable()
    for conv in conversions:
        [@convType, all @convNumbers] := conv.strip().splitLines()
        [@origType, _, @newType] := convType.split(' ')[0].split('-')

        convTable[origType] = (newType, newSeq[(int, int, int)]())

        for convNumber in convNumbers:
            [@destRangeStart, @sourceRangeStart, @rangeLen] := convNumber.splitWhitespace.map(parseInt)
            convTable[origType][1].add((destRangeStart, sourceRangeStart, rangeLen))
    return convTable

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false)
    [@seedsLine, all @conversions] := lines.split("\n\n")
    let convTable = buildConvTable(conversions)

    let seedNums = seedsLine["seeds: ".len .. ^1].strip().splitWhitespace().map(parseInt)
    let seeds = seedNums.map(x => (x, x))
    let ranges = seedNums.distribute((seedNums.len / 2).int).map(x => (x[0], x[0] + x[1] - 1))

    return (getMinLocation(seeds, convTable), getMinLocation(ranges, convTable))