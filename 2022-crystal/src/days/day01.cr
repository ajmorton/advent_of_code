module Day01
  extend self

  def run(input_file : String) : {Int32, Int32}
    input = File.read(input_file)
      .split("\n\n")
      .map(&.lines.map(&.to_i).sum)
      .sort
    return input.last, input.last(3).sum
  end
end
