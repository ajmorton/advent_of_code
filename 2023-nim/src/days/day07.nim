import algorithm, sequtils, strutils, sugar, system
import fusion/matching

let scores  = "23456789TJQKA"
let scores2 = "J23456789TQKA"

proc handScore(hand: string): (int, int, int, int, int, int, int) =

    [@a, @b, @c, @d, @e] := hand.map(card => scores.find(card))

    let occurrences = scores.map(card => hand.count(card)).sorted

    [@mostFreq, @secondMostFreq] := occurrences[^2..^1].reversed
    return (mostFreq, secondMostFreq, a,b,c,d,e)

proc handScore2(hand: string): (int, int, int, int, int, int, int) =

    [@a, @b, @c, @d, @e] := hand.map(card => scores2.find(card))

    let occurrences = scores2[1..^1].map(card => hand.count(card)).sorted
    let jokers = hand.count('J')

    [@mostFreq, @secondMostFreq] := occurrences[^2..^1].reversed
    return (mostFreq + jokers, secondMostFreq, a,b,c,d,e)

proc compareHands(handA, handB: (string, string)): int =

    let (scoreA, scoreB) = (handA[0].handScore, handB[0].handScore)
    if scoreA > scoreB:
        return 1
    else:
        return -1

proc compareHands2(handA, handB: (string, string)): int =

    let (scoreA, scoreB) = (handA[0].handScore2, handB[0].handScore2)
    if scoreA > scoreB:
        return 1
    else:
        return -1

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let cardsAndBet = lines.map(line => line.splitWhitespace).map(arr => (arr[0], arr[1]))

    let sortedCardsAndBets = cardsAndBet.sorted(compareHands)
    let sortedCardsAndBets2 = cardsAndBet.sorted(compareHands2)

    var scoreSum = 0
    for i, (hand, bidStr) in sortedCardsAndBets:
        scoreSum += bidStr.parseInt * (i + 1)

    var scoreSum2 = 0
    for i, (hand, bidStr) in sortedCardsAndBets2:
        scoreSum2 += bidStr.parseInt * (i + 1)

    return (scoreSum, scoreSum2)