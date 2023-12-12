import aoc_prelude

type LineAndLengths = tuple[line: string, lengths: seq[int]]

proc countRec(lineIndex: int, lengthsIndex: int, lineAndLengths: LineAndLengths, memo: var Table[(int, int), int]): int =

    var combos = 0

    if (lineIndex, lengthsIndex) in memo:
        return memo[(lineIndex, lengthsIndex)]

    let line = lineAndLengths.line
    let lengths = lineAndLengths.lengths

    if lineIndex >= line.len:
        if lengthsIndex >= lengths.len:
            # All springs inserted
            return 1
        else:
            # Can't insert springs
            return 0

    # Try skipping a lineIndex
    if line[lineIndex] != '#':
        combos += countRec(lineIndex + 1, lengthsIndex, lineAndLengths, memo)

    if lengthsIndex < lengths.len:

        # Try insert spring
        var springLen = lengths[lengthsIndex]

        let canFit = lineIndex + springLen - 1 < line.len
        let notAdjacentToMust = lineIndex + springLen >= line.len or line[lineIndex + springLen] != '#'

        if canFit and notAdjacentToMust:

            var hasSpace = true
            for i in lineIndex ..< lineIndex + springLen:
                if line[i] == '.':
                    hasSpace = false
                    break

            if hasSpace:
                # lineIndex + springLen + 1 == plus 1 for a gap between springs
                combos += countRec(lineIndex + springLen + 1, lengthsIndex + 1, lineAndLengths, memo)
    
    memo[(lineIndex, lengthsIndex)] = combos
    return combos

proc countCombos(lineAndLengths: LineAndLengths): (int, int) =
    var memo = Table[(int, int), int]()
    var p1 = countRec(0, 0, lineAndLengths, memo)

    var memo2 = Table[(int, int), int]()
    var lineUnfolded = ""
    for _ in 0..<5:
        lineUnfolded &= lineAndLengths.line
        lineUnfolded &= "?"
    lineUnfolded = lineUnfolded[0..^2]

    var lengthsUnfolded = newSeq[int]()
    for i in 0..<5:
        lengthsUnfolded.add(lineAndLengths.lengths)

    var lineAndLengthsUnfolded = (line: lineUnfolded, lengths: lengthsUnfolded)
    var p2 = countRec(0, 0, lineAndLengthsUnfolded, memo2)

    return (p1, p2)

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let rows = lines.mapIt(it.splitWhitespace)
    let rowsAndLengths = rows.mapIt((line: it[0], lengths: it[1].split(',').map(parseInt)))
    
    let res = rowsAndLengths.map(countCombos)
    let p1 = res.mapIt(it[0]).sum
    let p2 = res.mapIt(it[1]).sum

    return (p1, p2)