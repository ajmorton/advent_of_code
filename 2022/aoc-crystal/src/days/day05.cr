module Day05
  extend self

  def move_and_report_top_boxes(stacks : Array(Array(Char)), moves : Array(String), p1 : Bool) : String
    moves.each do |move|
      regex = /^move (\d+) from (\d) to (\d)$/.match(move).not_nil!
      num_boxes, from, to = regex[1].to_i, regex[2].to_i - 1, regex[3].to_i - 1

      moved_boxes = stacks[from].pop(num_boxes)
      stacks[to] += p1 ? moved_boxes.reverse : moved_boxes
    end

    return stacks.map(&.last).join("")
  end

  def run(input_file : String)
    init_state, moves = File.read(input_file).split("\n\n").map(&.lines)

    stacks = init_state
      .map(&.chars).transpose           # It's easier to parse the input as rows
      .skip(1).each.step(4)             # We only want the rows with boxes, skip [ ] and whitespace
      .map(&.select(&.letter?).reverse) # Drop row number and whitespace. Reverse so top box is last in the array
      .to_a

    return {
      move_and_report_top_boxes(stacks.clone, moves, true),
      move_and_report_top_boxes(stacks.clone, moves, false),
    }
  end
end
