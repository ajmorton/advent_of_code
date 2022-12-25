module Day04
  extend self

  def run(input_file : String)
    input = File.read(input_file).lines

    p1 = p2 = 0
    input.each { |line|
      regex = /^(\d+)-(\d+),(\d+)-(\d+)$/.match(line).not_nil!
      l1, r1 = regex[1].to_i, regex[2].to_i
      l2, r2 = regex[3].to_i, regex[4].to_i

      p1 += (l1 <= l2 && r2 <= r1) || (l2 <= l1 && r1 <= r2) ? 1 : 0
      p2 += !(l1 > r2 || l2 > r1) ? 1 : 0
    }

    return p1, p2
  end
end
