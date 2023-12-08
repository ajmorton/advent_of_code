import unittest

import days/[day01, day02, day03, day04, day05, day06, day07, day08]

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
