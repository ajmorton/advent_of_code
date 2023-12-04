import unittest

import days/[day01, day02, day03, day04]

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