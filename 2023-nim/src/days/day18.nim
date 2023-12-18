import aoc_prelude

# FIXME - Work out how {.experimental: "views".} works with string slices and drop this custom impl
proc parseHexInt(str: string, startIndex: int, endIndex: int): int =
    var num = 0
    for i in startIndex .. endIndex:
        let foo = case str[i]
        of '0'..'9': str[i].ord - '0'.ord
        of 'a'..'f': str[i].ord - 'a'.ord + 10
        else: quit "aaaa"
        num = (num * 16) + foo
    return num

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    # Green's theorem to compute polygon area
    var p1Area, p2Area = 0
    var p1Perimeter, p2Perimeter = 0
    var (p1X, p1dY) = (0, 0)
    var (p2X, p2dY) = (0, 0)

    for line in lines:

        # Sometimes p1Dist is two digits long which changes the offsets of each field in the line
        let (p1Dir, p1Dist, p2Dist, p2Dir) = 
            if line.len == 13:
                (line[0], line[2].ord - '0'.ord, parseHexInt(line, 6, 10), line[11])
            else:
                (line[0], line[2..3].parseInt,   parseHexInt(line, 7, 11), line[12])

        (p1X, p1dY) = case p1Dir
            of 'R': (p1X + p1Dist,  0     )
            of 'D': (p1X,           p1Dist)
            of 'L': (p1X - p1Dist,  0     )
            of 'U': (p1X,          -p1Dist)
            else: quit fmt"Unrecognised P1 dir! {p1Dir}"
        p1Perimeter += p1Dist
        p1Area += p1X * p1dY

        (p2X, p2dY) = case p2Dir
            of '0': (p2X + p2Dist,  0     ) # Right
            of '1': (p2X,           p2Dist) # Down
            of '2': (p2X - p2Dist,  0     ) # Left
            of '3': (p2X,          -p2Dist) # Up
            else: quit fmt"Unrecognised P2 dir! {p2Dir}"
        p2Perimeter += p2Dist
        p2Area += p2X * p2dY

    # Areas are computed from the center of each point (i.e. (0.5, 0.5) instead of (1, 1))
    # Add the perimeter to offset this
    let p1 = p1Area + (p1Perimeter div 2) + 1
    let p2 = p2Area + (p2Perimeter div 2) + 1
    return (p1, p2)
