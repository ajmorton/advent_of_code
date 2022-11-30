# A common interface for all days.
# Each day must implement the solutions for part1 and part2
module DayInterface
  abstract def part1(input_file : String)
  abstract def part2(input_file : String)

  def both_days(input_file f : String)
    return {part1(f), part2(f)}
  end
end

# Parse the input file as a list of ints
def parse_int_list(file_path : String) : Array(Int64)
  File.read_lines(file_path).map(&.to_i64)
end
