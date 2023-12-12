import days/[day01, day02, day03, day04, day05, day06, day07, day08, day09, day10, 
             day11, day12]
import ./benchmark

import strformat, strutils

# Run a day
proc runDay(day: int, bench: bool) =
  # zero pad if needed
  let dayStr = align(intToStr(day), 2, '0')
  let inputFileStr = fmt"./input/day{dayStr}.txt"
  
  let dayFun = case day 
  of 01: day01.run
  of 02: day02.run
  of 03: day03.run
  of 04: day04.run
  of 05: day05.run
  of 06: day06.run
  of 07: day07.run
  of 08: day08.run
  of 09: day09.run
  of 10: day10.run
  of 11: day11.run
  of 12: day12.run
  of 13..25: return # Day not implemented
  else:
    echo fmt"{RED}Invalid day {dayStr} received{END}"
    quit 1

  let (part1, part2) = dayFun(inputFileStr)

  echo fmt"Running day{dayStr}"
  echo fmt"    Part1:   {part1}"
  echo fmt"    Part2:   {part2}"
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
