module Day25
  extend self

  def from_snaf(str : String) : Int64
    str.chars.reverse.map_with_index { |d, index|
      ("=-012".index(d).not_nil! - 2).to_i64 * (5_i64 ** index)
    }.sum
  end

  def to_snaf(num : Int64) : String
    return "" if num == 0
    to_snaf((num + 2) // 5) + "=-012"[(num + 2) % 5]
  end

  def run(input_file : String)
    input = File.read(input_file).lines
    sum = input.map { |l| from_snaf(l) }.sum
    return to_snaf(sum), nil
  end
end
