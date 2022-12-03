module Day03
  extend self

  def char_score(c : Char) : Int32
    " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".index(c).not_nil!
  end

  def run(input_file : String)
    groups = File.read(input_file).lines

    score = score2 = 0
    groups.each do |group|
      left = group[...(group.size // 2)]
      right = group[(group.size // 2)..]
      common_char = (left.chars & right.chars)[0]
      score += char_score(common_char)
    end

    groups.each_slice(3) do |group|
      common_char = (group[0].chars & group[1].chars & group[2].chars)[0]
      score2 += char_score(common_char)
    end

    return score, score2
  end
end
