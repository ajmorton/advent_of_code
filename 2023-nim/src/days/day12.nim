import aoc_prelude

proc countLinear(lineIndex: int, lengthsIndex: int, springs: string, lengths: seq[int]): int =
    var supportsSpringsUpToLen = newSeq[int](springs.len)
    var supportsUpToLen = 0
    for i, spr in springs:
        case spr
        of '.': supportsUpToLen = 0
        else:   supportsUpToLen += 1

        supportsSpringsUpToLen[i] = supportsUpToLen

    var cur = newSeq[int](springs.len + 1) 
    var prev = newSeq[int](springs.len + 1)

    for i in 0 ..< springs.len:
        prev[i] = 1
        if springs[i] == '#':
            break

    for lenIndex, len in lengths:
        cur[0] = 0
        for i, spr in springs:
            var count = 0
    
            if spr in ".?":
                # Treat as . and continue
                count += cur[i]

            if spr in "#?":
                # Try insert spring that ends at position i
                let nextIsDamaged = i < springs.len - 1 and springs[i + 1] == '#'
                let correctCount = supportsSpringsUpToLen[i] >= len
                let runStartsWithEmpty = i - len < 0 or springs[i - len] != '#'
                if not nextIsDamaged and correctCount and runStartsWithEmpty:
                    if i - len >= 0:
                        count += prev[i - len]
                    elif lenIndex == 0:
                        count += 1

            if i < cur.len - 1:
                cur[i + 1] = count

        # Reuse old array to save on malloc calls
        let tmp = prev
        prev = cur
        cur = tmp

    return prev[^1]

proc countCombos(springs: string, lengths: seq[int]): (int, int) =
    let p1 = countLinear(0, 0, springs, lengths)

    var springsUnfolded = (springs & "?").repeat(5)[0..^2]
    var lengthsUnfolded = lengths.cycle(5)
    let p2 = countLinear(0, 0, springsUnfolded, lengthsUnfolded)

    return (p1, p2)

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let rows = lines.mapIt(it.splitWhitespace)
    let springsAndLengths = rows.mapIt((line: it[0], lengths: it[1].split(',').map(parseInt)))
    
    let res = springsAndLengths.mapIt(countCombos(it[0], it[1]))
    return res.foldl((a[0] + b[0], a[1] + b[1]))