import unittest
import sequtils

import days/day01
import days/day02
import days/day03

test "day01":
  let (part1, part2) = day01.run("./input/day01.txt")
  check part1 == 3125750
  check part2 == 4685788

  check day01.part1(toSeq([12])) == 2
  check day01.part1(toSeq([14])) == 2
  check day01.part1(toSeq([1969])) == 654
  check day01.part1(toSeq([100756])) == 33583

  check day01.part2(toSeq([14])) == 2
  check day01.part2(toSeq([1969])) == 966
  check day01.part2(toSeq([100756])) == 50346

test "day02":
  let (part1, part2) = day02.run("./input/day02.txt")
  check part1 == 4930687
  check part2 == 5335

test "day03":
  let (part1, part2) = day03.run("./input/day03.txt")
  check part1 == 1264
  check part2 == 37390