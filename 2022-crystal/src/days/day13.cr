module Day13
  extend self

  def left_smaller?(left : String, right : String) : Bool
    # Skip common chars
    i = (0..).index { |i| left[i] != right[i] }
    left, right = left[i..], right[i..]

    # Not pictured: What happens when strings are identical
    case {left[0], right[0]}
    when {']', _} then true
    when {_, ']'} then false
    when {'[', _} then left_smaller?(left[1..], right.insert(1, "]"))
    when {_, '['} then left_smaller?(left.insert(1, "]"), right[1..])
    else               left[0] < right[0]
    end
  end

  def run(input_file : String)
    packets = File.read(input_file).gsub("\n\n", "\n").gsub("10", "A").lines

    p1 = packets.each_slice(2).map_with_index { |slice, i|
      left_smaller?(slice[0], slice[1]) ? (i + 1) : 0
    }.sum

    packets.push("[[2]]", "[[6]]")
    packets = packets.sort { |l, r| left_smaller?(l, r) ? -1 : 1 }
    p2 = ["[[2]]", "[[6]]"].map { |x| packets.index!(x) + 1 }.product

    return p1, p2
  end
end
