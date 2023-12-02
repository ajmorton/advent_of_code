import strutils, sequtils, sugar

proc colourAndCount(str: string): (int, string) =
    let split = str.strip().split(' ')
    let count = split[0].parseInt
    let colour = split[1]
    return (count, colour)

proc run*(input_file: string): (int, int) =
    let input = readFile(input_file).strip(leading = false)
    var lines = input.splitLines()
    var legalGames = 0
    var p2Sum = 0

    for l in lines:
        let split = l.split(':')
        let (gameId, phases) = (split[0], split[1])
        let ps = phases.split(";")
        let gameNum = gameId["Game ".len..^1].parseInt
        var isLegal = true

        var (nred, ngreen, nblue) = (0, 0, 0)
        for p in ps:

            # Part 1
            let colourCounts = p.strip().split(',').map(colourAndCount)
            for (count, colour) in colourCounts:
                if colour == "red" and count > 12:
                    isLegal = false
                    break
                elif colour == "green" and count > 13:
                    isLegal = false
                    break
                elif colour == "blue" and count > 14:
                    isLegal = false
                    break

            # Part 2
            for (count, colour) in colourCounts:
                if colour == "red":
                    nred = max(nred, count)
                elif colour == "green":
                    ngreen = max(ngreen, count)
                elif colour == "blue":
                    nblue = max(nblue, count)
        p2Sum += (nred * ngreen * nblue)
            
        if isLegal:
            legalGames += gameNum

    return (legalGames, p2Sum)