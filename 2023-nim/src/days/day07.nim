import algorithm, math, sequtils, strutils, sugar, system
import fusion/matching

# Most frequent card count, second most frequent card count, score of each of the five cards in the hand
type HandScore = (int, int, (int, int, int, int, int))

proc score(hand: string): HandScore =
    let cardValues = "23456789TJQKA"
    let mostFreq = cardValues.map(card => hand.count(card)).sorted

    [@a, @b, @c, @d, @e] := hand.map(card => cardValues.find(card))
    return (mostFreq[^1], mostFreq[^2], (a,b,c,d,e))

proc score2(hand: string): HandScore =
    let cardValues2 = "J23456789TQKA"
    let mostFreq = cardValues2[1..^1].map(card => hand.count(card)).sorted
    let jokers = hand.count('J')

    [@a, @b, @c, @d, @e] := hand.map(card => cardValues2.find(card))
    return (mostFreq[^1] + jokers, mostFreq[^2], (a,b,c,d,e))

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let handsAndBets = lines.map(line => line.splitWhitespace).map(x => (hand: x[0], bet: x[1].parseInt))

    let scoresAndBets = handsAndBets.map(x => (score: score(x.hand), bet: x.bet))
    let scoresAndBets2 = handsAndBets.map(x => (score: score2(x.hand), bet: x.bet))

    var sortedBets = scoresAndBets.sorted(SortOrder.Descending).map(x => x.bet)
    var sortedBets2 = scoresAndBets2.sorted(SortOrder.Descending).map(x => x.bet)

    return (sortedBets.cumsummed.sum, sortedBets2.cumsummed.sum)