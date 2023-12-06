import math, sequtils, strutils, sugar, system
import fusion/matching

# Determine the number of whole numbers of n for which `n * (t - n) > d`
# Use quadratic equation to find the solutions for n * (t - n) == d, convert to ints, and return the range
proc getNumWinning(t: int, d: int): int =
        # n * (t - n)   == d
        # -n^2 + tn - d == 0
        let (a, b, c) = (-1.float64, t.float64, -d.float64)

        # x = (-b (+/-) sqrt(b^2 - 4ac)) / 2a
        let sqrt_discriminant = sqrt(b.pow(2) - (4*a*c))
        let root1 = (-b + sqrt_discriminant) / (2*a)
        let root2 = (-b - sqrt_discriminant) / (2*a)

        # We want whole numbers for which `n * (t - n) > d` is true. Round up the smaller root and round down the larger
        let start = (min(root1, root2) + 1).floor.int
        let endd  = (max(root1, root2) - 1).ceil.int

        return endd - start + 1

proc run*(input_file: string): (int, int) =
    [@timesStr, @distancesStr] := readFile(input_file).strip(leading = false).splitLines
    let times = timesStr.splitWhitespace[1..^1].map(parseInt)
    let distances = distancesStr.splitWhitespace[1..^1].map(parseInt)

    let p2Time = timesStr["Time:".len..^1].replace(" ", "").parseInt
    let p2Distance = distancesStr["Distance:".len..^1].replace(" ", "").parseInt

    let tdPairs = times.zip(distances)
    let p1 = tdPairs.map(pair => getNumWinning(pair[0], pair[1])).prod
    var p2 = getNumWinning(p2Time, p2Distance)
    return (p1, p2)