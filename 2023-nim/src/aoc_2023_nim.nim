import days/[day01, day02, day03, day04, day05, day06, day07, day08, day09, day10, 
             day11, day12, day13, day14, day15, day16, day17, day18, day19, day20,
             day21, day22, day23, day24, day25]
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
  of 13: day13.run
  of 14: day14.run
  of 15: day15.run
  of 16: day16.run
  of 17: day17.run
  of 18: day18.run
  of 19: day19.run
  of 20: day20.run
  of 21: day21.run
  of 22: day22.run
  of 23: day23.run
  of 24: day24.run
  of 25: day25.run
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
