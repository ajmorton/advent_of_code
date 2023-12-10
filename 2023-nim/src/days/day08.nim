import aoc_prelude

const NUM_POSSIBLE_LINKS = 17576
type LinkTable = array[0..NUM_POSSIBLE_LINKS, tuple[l: int16, r: int16]]

# Convert each string into a unique int for faster equality checks.
# Strings are always length 3 so 26^3 == 17,576 fits inside an int16, allowing use Nim's native set type
proc strToInt(str: string): int16 =
    assert str.len == 3
    return (((str[0].ord - 'A'.ord) * 26^2) + ((str[1].ord - 'A'.ord) * 26) + (str[2].ord - 'A'.ord)).int16 

proc getDistance(start: int16, endPosses: set[int16], path: string, links: LinkTable): int =
    var (curPos, pathDist) = (start, 0)
    while curPos notin endPosses:
        let turn = path[pathDist.mod(path.len)]
        case turn
        of 'L': curPos = links[curPos].l 
        of 'R': curPos = links[curPos].r
        else: quit "invalid turn"

        pathDist += 1
    return pathDist

proc run*(input_file: string): (int, int) =
    [@path, @linksList] := readFile(input_file).strip(leading = false).split("\n\n")

    var aPosses = newSeq[int16]()
    var zPosses = newSeq[int16]()
    var links: LinkTable

    for link in linksList.splitLines:
        # string format: `EEE = (LLL, RRR)`
        let (entry, left, right) = (link[0..2], link[7..9], link[12..14])
        let (entryNum, leftNum, rightNum) = (strToInt(entry), strToInt(left), strToInt(right))

        if entry.endsWith('A'): aPosses.add(entryNum)
        if entry.endsWith('Z'): zPosses.add(entryNum)

        links[entryNum] = (l: leftNum, r: rightNum)

    let p1 = getDistance(strToInt("AAA"), {strToInt("ZZZ")}, path, links)
    let p2 = aPosses.map(aPos => getDistance(aPos, zPosses.toSet, path, links)).lcm

    return (p1, p2)