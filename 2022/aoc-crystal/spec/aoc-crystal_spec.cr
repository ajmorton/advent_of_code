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
