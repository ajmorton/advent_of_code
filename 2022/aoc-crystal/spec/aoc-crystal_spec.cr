require "./spec_helper"

describe Day01 do
  it { Day01.run("./src/inputs/day01.txt").should eq({69795, 208437}) }
end

describe Day02 do
  it { Day02.run("./src/inputs/day02.txt").should eq({10595, 9541}) }
end

describe Day03 do
  it { Day03.run("./src/inputs/day03.txt").should eq({8153, 2342}) }
end

describe Day04 do
  it { Day04.run("./src/inputs/day04.txt").should eq({459, 779}) }
end

describe Day05 do
  it { Day05.run("./src/inputs/day05.txt").should eq({"VRWBSFZWM", "RBTWJWMCF"}) }
end

describe Day06 do
  it { Day06.run("./src/inputs/day06.txt").should eq({1802, 3551}) }
end

describe Day07 do
  it { Day07.run("./src/inputs/day07.txt").should eq({1543140, 1117448}) }
end

describe Day08 do
  it { Day08.run("./src/inputs/day08.txt").should eq({1859, 332640}) }
end

describe Day09 do
  it { Day09.run("./src/inputs/day09.txt").should eq({6037, 2485}) }
end

describe Day10 do
  it { Day10.run("./src/inputs/day10.txt").should eq({14160, "RJERPEFC"}) }
end

describe Day11 do
  it { Day11.run("./src/inputs/day11.txt").should eq({117624, 16792940265}) }
end
