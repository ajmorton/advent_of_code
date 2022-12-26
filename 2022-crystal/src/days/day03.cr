module Day03
  extend self

  def score(group : Enumerable(Array(Char))) : Int32
    common_char = group.reduce { |l, r| l & r }[0]
    " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".index(common_char).not_nil!
  end

  def run(input_file : String)
    groups = File.read(input_file).lines.map(&.chars)
    p1 = groups.map { |group| score(group.each_slice(group.size // 2)) }.sum
    p2 = groups.each_slice(3).map { |group| score(group) }.sum
    return p1, p2
  end
end
