import aoc_prelude

# Most frequent card count, second most frequent card count, score of each of the five cards in the hand
type HandScore = (int, int, (int, int, int, int, int))

proc highestTwoFreqs(freqs: seq[int]): (int, int) = 
    var most, second = low(int)
    for f in freqs:
        if f > most:
            (most, second) = (f, most)
        elif f > second:
            second = f
    return (most, second)

proc score(hand: string): HandScore =
    let cardValues = "23456789TJQKA"
    let freqs = cardValues.map(card => hand.count(card))
    let (most, second) = highestTwoFreqs(freqs)

    [@a, @b, @c, @d, @e] := hand.map(card => cardValues.find(card))
    return (most, second, (a,b,c,d,e))

proc score2(hand: string): HandScore =
    let cardValues2 = "J23456789TQKA"
    let freqs = cardValues2[1..^1].map(card => hand.count(card))
    let (most, second) = highestTwoFreqs(freqs)
    let jokers = hand.count('J')

    [@a, @b, @c, @d, @e] := hand.map(card => cardValues2.find(card))
    return (most + jokers, second, (a,b,c,d,e))

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let handsAndBets = lines.map(line => line.splitWhitespace).map(x => (hand: x[0], bet: x[1].parseInt))

    let scoresAndBets = handsAndBets.map(x => (score: score(x.hand), bet: x.bet))
    let scoresAndBets2 = handsAndBets.map(x => (score: score2(x.hand), bet: x.bet))

    var sortedBets = scoresAndBets.sorted(SortOrder.Descending).map(x => x.bet)
    var sortedBets2 = scoresAndBets2.sorted(SortOrder.Descending).map(x => x.bet)

    return (sortedBets.cumsummed.sum, sortedBets2.cumsummed.sum)