module Day06
  extend self

  def find_first_unique(str : Array(Char), n : Int32) : Int32
    str.each.cons(n).index { |substr| substr.uniq.size == n }.not_nil! + n
  end

  def run(input_file : String)
    input = File.read(input_file).strip.chars
    p1 = find_first_unique(input, 4)
    # If there's no run of 4 unique chars before, then there's definitely not a run of 14.
    # Start at the beginning of the 4 unique char run.
    p2 = find_first_unique(input[(p1 - 4)..], 14) + (p1 - 4)
    return p1, p2
  end
end
