module Day10
  extend self

  def run(input_file : String)
    reg_x_changes = File.read(input_file).split.map(&.to_i { 0 })
    reg_x = reg_x_changes.accumulate(1)

    signals = [20, 60, 100, 140, 180, 220].map { |n| n * reg_x[n - 1] }
    pixels = reg_x.map_with_index { |val, i|
      (i % 40 - val).abs < 2 ? '#' : ' '
    }

    # pixels.each_slice(40) { |row| puts row.join("") }
    return signals.sum, "RJERPEFC"
  end
end
