import days/[day01, day02, day03, day04]
import ./benchmark

import strutils

# Run a day
proc runDay(day: int, bench: bool) =
  # zero pad if needed
  let dayStr = align(intToStr(day), 2, '0')
  let inputFileStr = "./input/day" & dayStr & ".txt"
  
  let dayFun = case day 
  of 01: day01.run
  of 02: day02.run
  of 03: day03.run
  of 04: day04.run
  of 05..25: return # Day not implemented
  else:
    echo "\t\x1b[1;31mInvalid day ", dayStr, " received\x1b[1;0m"
    quit 1

  let (part1, part2) = dayFun(inputFileStr)

  echo "Running day", dayStr
  echo "    Part1:   ", part1
  echo "    Part2:   ", part2
  if bench:
    benchmark(dayFun, inputFileStr)
  echo ""

proc aoc_2023_nim(day: int = 0, bench: bool = false): int =
  if day == 0:
    for i in 1..25:
      runDay(i, bench)
  else:
    runDay(day, bench)

when isMainModule:
  # cligen handles all our argparsing for us! 
  # Uses reflection to generate cli args from the arguments in aoc_2023_nim()'s signature.
  import cligen
  dispatch aoc_2023_nim
