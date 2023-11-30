# FIXME - This is 2019 Day 01

import aoc_common
import math, sequtils

proc calcFuelNeeded(n: int): int =
    return (n div 3) - 2

proc calcFuelNeededRecursive(n: int): int =
    let fuelNeeded = calcFuelNeeded(n)
    if fuelNeeded <= 0:
        return 0
    else:
        return fuelNeeded + calcFuelNeededRecursive(fuelNeeded)

proc part1*(weights: seq[int]): int =
    return sum(weights.map(calcFuelNeeded))

proc part2*(weights: seq[int]): int =
    return sum(weights.map(calcFuelNeededRecursive))

proc run*(inputFile: string): (int, int) =
    let weights = inputAsInts(input_file)
    return (part1(weights), part2(weights))
