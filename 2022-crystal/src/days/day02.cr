module Day02
  extend self

  def score(round : String) : {Int32, Int32}
    case round
    when "A X" then {3 + 1, 0 + 3}
    when "A Y" then {6 + 2, 3 + 1}
    when "A Z" then {0 + 3, 6 + 2}
    when "B X" then {0 + 1, 0 + 1}
    when "B Y" then {3 + 2, 3 + 2}
    when "B Z" then {6 + 3, 6 + 3}
    when "C X" then {6 + 1, 0 + 2}
    when "C Y" then {0 + 2, 3 + 3}
    when "C Z" then {3 + 3, 6 + 1}
    else
      raise "Invalid round '#{round}'!"
    end
  end

  def run(input_file : String)
    rounds = File.read(input_file).lines
    return rounds.map { |r| score(r) }.reduce { |l, r| {l[0] + r[0], l[1] + r[1]} }
  end
end
