import aoc_prelude

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var symbolPositions = Table[(int, int), char]()
    for y, line in lines:
        for x, c in line:
            if not (c in "0123456789."):
                symbolPositions[(y, x)] = c

    var symbolParts = Table[(int, int), seq[int]]()
    for y, line in lines:
        for num in line.findIter(re"[0-9]+"):
            let startX = num.matchBounds.a - 1
            let endX = num.matchBounds.b + 1
            for x in startX .. endX:
                for yy in [y - 1, y, y + 1]:
                    if symbolPositions.contains((yy, x)):
                        symbolParts.mgetOrPut((yy, x), newSeq[int]()).insert(num.match.parseInt)

    let sumOfParts = symbolParts.values.toSeq.map(x => x.sum).sum
    let gears = symbolParts.pairs.toSeq.filter(pair => symbolPositions[pair[0]] == '*' and pair[1].len == 2)
    let prodSumOfGears = gears.map(pair => pair[1].prod).sum
    
    return (sumOfParts, prodSumOfGears)