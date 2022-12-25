module Day11
  extend self

  class Monkey
    property holding : Array(Int64)
    property oper : Array(String)
    property div_by : Int64
    property target_true : Int64
    property target_false : Int64
    property inspected : Int64 = 0

    def initialize(str : Array(String))
      @holding = str[1].lchop("  Starting items: ").split(", ").map(&.to_i64)
      @oper = str[2].lchop("  Operation: new = old ").split
      @div_by = str[3].lchop("  Test: divisible by ").to_i64
      @target_true = str[4].lchop("    If true: throw to monkey ").to_i64
      @target_false = str[5].lchop("    If false: throw to monkey ").to_i64
    end
  end

  def run_for(monkeys : Array(Monkey), num_rounds : Int32, part_1 : Bool) : Int64
    mod_base = monkeys.map(&.div_by).product

    num_rounds.times {
      monkeys.each { |m|
        items = m.holding.pop(m.holding.size)
        items.each { |i|
          m.inspected += 1

          num = m.oper[1].to_i64 { i }
          i %= mod_base
          if m.oper[0] == "*"
            i *= num
          else # m.oper[0] == "+"
            i += num
          end

          if part_1
            i //= 3
          end

          target = (i % m.div_by == 0) ? m.target_true : m.target_false
          monkeys[target].holding.push(i)
        }
      }
    }

    return monkeys.map(&.inspected).sort.last(2).product
  end

  def run(input_file : String)
    # Parse twice cause cloning is annoying
    monkeys_p1 = File.read(input_file).split("\n\n").map { |stats| Monkey.new(stats.lines) }
    monkeys_p2 = File.read(input_file).split("\n\n").map { |stats| Monkey.new(stats.lines) }

    return {
      run_for(monkeys_p1, 20, true),
      run_for(monkeys_p2, 10_000, false),
    }
  end
end
