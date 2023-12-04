import math, sequtils, sets, strutils, tables
import fusion/matching

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    var score = 0
    var numCards = Table[int, int]()

    for line in lines:
        [@cardId, @numbers] := line.split(':')
        let cardNum = cardId["Card ".len .. ^1].strip.parseInt

        [@winningNums, @yourNums] := numbers.split('|')
        let winningNumsSet = winningNums.splitWhitespace.map(parseInt).toHashSet
        let yourNumsSet = yourNums.splitWhitespace.map(parseInt).toHashSet
        
        let numMatches = intersection(winningNumsSet, yourNumsSet).len

        for i in cardNum + 1 .. cardNum + numMatches:
            numCards.mgetOrPut(i, 1) += numCards.mgetOrPut(cardNum, 1)

        if numMatches > 0: 
            score += 2^(numMatches-1)

    return (score, numCards.values.toSeq.sum)