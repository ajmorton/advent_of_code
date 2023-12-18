import unittest

import days/[day01, day02, day03, day04, day05, day06, day07, day08, day09, day10,
             day11, day12, day13, day14, day15, day16, day17, day18]

test "day01":
  let (part1, part2) = day01.run("./input/day01.txt")
  check part1 == 55538
  check part2 == 54875

test "day02":
  let (part1, part2) = day02.run("./input/day02.txt")
  check part1 == 2331
  check part2 == 71585

test "day03":
  let (part1, part2) = day03.run("./input/day03.txt")
  check part1 == 522726
  check part2 == 81721933

test "day04":
  let (part1, part2) = day04.run("./input/day04.txt")
  check part1 == 27059
  check part2 == 5744979

test "day05":
  let (part1, part2) = day05.run("./input/day05.txt")
  check part1 == 403695602
  check part2 == 219529182

test "day06":
  let (part1, part2) = day06.run("./input/day06.txt")
  check part1 == 2756160
  check part2 == 34788142

test "day07":
  let (part1, part2) = day07.run("./input/day07.txt")
  check part1 == 250370104
  check part2 == 251735672

test "day08":
  let (part1, part2) = day08.run("./input/day08.txt")
  check part1 == 19631
  check part2 == 21003205388413

test "day09":
  let (part1, part2) = day09.run("./input/day09.txt")
  check part1 == 1887980197
  check part2 == 990

test "day10":
  let (part1, part2) = day10.run("./input/day10.txt")
  check part1 == 6951
  check part2 == 563

test "day11":
  let (part1, part2) = day11.run("./input/day11.txt")
  check part1 == 9734203
  check part2 == 568914596391

test "day12":
  let (part1, part2) = day12.run("./input/day12.txt")
  check part1 == 6958
  check part2 == 6555315065024

test "day13":
  let (part1, part2) = day13.run("./input/day13.txt")
  check part1 == 34772
  check part2 == 35554

test "day14":
  let (part1, part2) = day14.run("./input/day14.txt")
  check part1 == 108857
  check part2 == 95273

test "day15":
  let (part1, part2) = day15.run("./input/day15.txt")
  check part1 == 521434
  check part2 == 248279

test "day16":
  let (part1, part2) = day16.run("./input/day16.txt")
  check part1 == 6902
  check part2 == 7697

test "day17":
  let (part1, part2) = day17.run("./input/day17.txt")
  check part1 == 1001
  check part2 == 1197

test "day18":
  let (part1, part2) = day18.run("./input/day18.txt")
  check part1 == 31171
  check part2 == 131431655002266
