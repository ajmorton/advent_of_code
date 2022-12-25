module Day20
  extend self

  alias Num = {n: Int64, orig_index: Int64}

  def mix(numbers : Array(Num))
    (0...numbers.size).each { |orig_index|
      cur_index = numbers.index! { |n| n[:orig_index] == orig_index }.to_i64
      to_move = numbers[cur_index]

      numbers.delete_at(cur_index)
      new_index = (cur_index + to_move[:n]) % numbers.size
      numbers.insert(new_index, to_move)
    }
  end

  def score(numbers : Array(Num)) : Int64
    zero_index = numbers.index! { |num| num[:n] == 0 }
    return [1000, 2000, 3000].map { |offset| numbers[(zero_index + offset) % numbers.size][:n] }.sum
  end

  def run(input_file : String)
    numbers = File.read(input_file).lines.map_with_index { |n, i| {n: n.to_i64, orig_index: i.to_i64} }
    numbers_p2 = numbers.map { |num| {n: num[:n] * 811589153, orig_index: num[:orig_index]} }

    mix(numbers)
    10.times { mix(numbers_p2) }

    return score(numbers), score(numbers_p2)
  end
end
