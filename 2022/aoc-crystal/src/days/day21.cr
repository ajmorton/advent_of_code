module Day21
  extend self

  enum Op
    Mul
    Add
    Sub
    Div
    Val
    Var
  end

  alias Input = Array(Eq) | Int64 | String

  class Eq
    property op : Op
    property input : Input

    def initialize(@op : Op, @input : Input)
    end

    def eval : Int64
      case @op
      in Op::Val then return @input.as(Int64)
      in Op::Mul then return input.as(Array(Eq)).map(&.eval).product
      in Op::Add then return input.as(Array(Eq)).map(&.eval).sum
      in Op::Sub then return input.as(Array(Eq)).map(&.eval).reduce { |x, y| x - y }
      in Op::Div then return input.as(Array(Eq)).map(&.eval).reduce { |x, y| x // y }
      in Op::Var then raise "Trying to eval Var!"
      end
    end

    def contains_var? : Bool
      case @op
      when Op::Var then true
      when Op::Val then false
      else              input.as(Array(Eq)).any?(&.contains_var?)
      end
    end
  end

  def solve_for_p2(eq : Eq) : Int64
    # Pop the root equation. Assume only one side contains a var
    var_eq, other_eq = eq.input.as(Array(Eq))
    if other_eq.contains_var?
      var_eq, other_eq = other_eq, var_eq
    end

    while var_eq.op != Op::Var
      l, r = var_eq.input.as(Array(Eq))
      if l.contains_var?
        case var_eq.op
        when Op::Mul then other_eq = Eq.new(Op::Div, [other_eq, r])
        when Op::Add then other_eq = Eq.new(Op::Sub, [other_eq, r])
        when Op::Sub then other_eq = Eq.new(Op::Add, [other_eq, r])
        when Op::Div then other_eq = Eq.new(Op::Mul, [other_eq, r])
        else              raise "Unreachable"
        end
        var_eq = l
      else # r.contains_var
        case var_eq.op
        when Op::Mul then other_eq = Eq.new(Op::Div, [other_eq, l])
        when Op::Add then other_eq = Eq.new(Op::Sub, [other_eq, l])
          # Non-commutative!!
        when Op::Sub then other_eq = Eq.new(Op::Sub, [l, other_eq])
        when Op::Div then other_eq = Eq.new(Op::Div, [l, other_eq])
        else              raise "Unreachable"
        end
        var_eq = r
      end
    end

    return other_eq.eval
  end

  def build_eq(monkey : String, equations : Hash(String, String), p2 : Bool) : Eq
    equation = equations[monkey]

    if p2 && monkey == "humn"
      return Eq.new(Op::Var, "humn")
    end

    if num = equation.to_i64?
      return Eq.new(Op::Val, num)
    else
      l, op_string, r = equation.split(' ')
      op = {"*" => Op::Mul, "+" => Op::Add, "-" => Op::Sub, "/" => Op::Div}[op_string]
      return Eq.new(op, [l, r].map { |subeq| build_eq(subeq, equations, p2) })
    end
  end

  def run(input_file : String)
    equations = Hash(String, String).new

    File.read(input_file).lines.each { |line|
      regex = /(\w+): (.*)/.match(line).not_nil!
      equations[regex[1]] = regex[2]
    }

    eq = build_eq("root", equations, false)
    eq_p2 = build_eq("root", equations, true)

    return eq.eval, solve_for_p2(eq_p2)
  end
end
