module Day21
  extend self

  alias Input = Array(Eq) | Int64 | String

  class Eq
    property op : String
    property input : Input

    def initialize(@op : String, @input : Input)
    end

    def eval : Int64
      case @op
      when "Val" then return @input.as(Int64)
      when "*"   then return input.as(Array(Eq)).map(&.eval).product
      when "+"   then return input.as(Array(Eq)).map(&.eval).sum
      when "-"   then return input.as(Array(Eq)).map(&.eval).reduce { |x, y| x - y }
      when "/"   then return input.as(Array(Eq)).map(&.eval).reduce { |x, y| x // y }
      else            raise "Trying to eval Var!"
      end
    end

    def contains_var? : Bool
      case @op
      when "Var" then true
      when "Val" then false
      else            input.as(Array(Eq)).any?(&.contains_var?)
      end
    end
  end

  def solve_for_p2(eq : Eq) : Int64
    # Pop the root equation. Assume only one side contains a var
    var_eq, other_eq = eq.input.as(Array(Eq))
    if other_eq.contains_var?
      var_eq, other_eq = other_eq, var_eq
    end

    while var_eq.op != "Var"
      l, r = var_eq.input.as(Array(Eq))
      if l.contains_var?
        case var_eq.op
        when "*" then other_eq = Eq.new("/", [other_eq, r])
        when "+" then other_eq = Eq.new("-", [other_eq, r])
        when "-" then other_eq = Eq.new("+", [other_eq, r])
        when "/" then other_eq = Eq.new("*", [other_eq, r])
        else          raise "Unreachable"
        end
        var_eq = l
      else # r.contains_var
        case var_eq.op
        when "*" then other_eq = Eq.new("/", [other_eq, l])
        when "+" then other_eq = Eq.new("-", [other_eq, l])
          # Non-commutative!!
        when "-" then other_eq = Eq.new("-", [l, other_eq])
        when "/" then other_eq = Eq.new("/", [l, other_eq])
        else          raise "Unreachable"
        end
        var_eq = r
      end
    end

    return other_eq.eval
  end

  def build_eq(monkey : String, equations : Hash(String, String), p2 : Bool) : Eq
    equation = equations[monkey]
    case
    when p2 && monkey == "humn" then return Eq.new("Var", "humn")
    when num = equation.to_i64? then return Eq.new("Val", num)
    else
      l, op, r = equation.split(' ')
      return Eq.new(op, [build_eq(l, equations, p2), build_eq(r, equations, p2)])
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
