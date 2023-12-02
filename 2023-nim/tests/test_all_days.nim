import unittest

import days/day01
import days/day02
import days/day03

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
  check part1 == 1264
  check part2 == 37390