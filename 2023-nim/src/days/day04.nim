import strutils, sets, sugar, sequtils, math, tables

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    var score = 0
    var numCards = Table[int, int]()

    for line in lines:
        let split = line.split(':')
        let cardNum = split[0]["Card ".len .. ^1].strip.parseInt
        numCards.mgetOrPut(cardNum, 0) += 1
        let numbers = split[1]
        let nn = numbers.split('|')
        let winningNums = nn[0]
        let yourNums = nn[1]
        let winningNumsSet = winningNums.strip().split(' ').toSeq.filter(x => x != "").map(x => x.parseInt).toHashSet
        let yourNumsSet = yourNums.strip().split(' ').toSeq.filter(x => x != "").map(x => x.parseInt).toHashSet
        
        let numMatches = intersection(winningNumsSet, yourNumsSet).len

        for i in cardNum + 1 .. cardNum + numMatches:
            numCards.mgetOrPut(i, 0) += numCards[cardNum]

        let rowScore = pow(2.float32, numMatches.float32 - 1).int
        score += rowScore

    let p2 = numCards.values.toSeq.sum

    return (score, p2)