import aoc_prelude

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines()
    var (p1, p2) = (0, 0)

    for line in lines:
        [@gameId, all @allPulls] := line.split({':', ';', ','})
        let gameNum = gameId["Game ".len..^1].parseInt

        var counts = {"red": 0, "green": 0, "blue": 0}.toTable
        for pull in allPulls:
            [@count, @colour] := pull.strip.split(' ')
            counts[colour] = max(counts[colour], count.parseInt)

        if (counts["red"] <= 12 and counts["green"] <= 13 and counts["blue"] <= 14):
            p1 += gameNum
        p2 += (counts["red"] * counts["green"] * counts["blue"])
            
    return (p1, p2)