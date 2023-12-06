import math, sequtils, sets, strformat, strutils, sugar, system, tables, options
import fusion/matching
import std/nre except toSeq

proc run*(input_file: string): (int, int) =
    [@timesStr, @distancesStr] := readFile(input_file).strip(leading = false).splitLines
    let times = timesStr.splitWhitespace[1..^1].map(parseInt)
    let distances = distancesStr.splitWhitespace[1..^1].map(parseInt)

    let p2Time = timesStr["Time:".len..^1].replace(" ", "").parseInt
    let p2Distance = distancesStr["Distance:".len..^1].replace(" ", "").parseInt

    var p1 = 1
    for i in 0..<times.len:
        var numWinningCombos = 0
        let (t, d) = (times[i], distances[i])
        for holdTime in 0..t:
            let finalDist = (holdTime) * (t - holdTime)
            # echo fmt"holdTime: {holdTime}, speed: {}"
            if finalDist > d:
                numWinningCombos += 1

        echo "numWinning ", numWinningCombos
        p1 *= numWinningCombos

    var p2 = 1
    var numWinningCombos = 0
    let (t, d) = (p2Time, p2Distance)
    for holdTime in 0..t:
        let finalDist = (holdTime) * (t - holdTime)
        if finalDist > d:
            numWinningCombos += 1

    p2 = numWinningCombos

    return (p1, p2)