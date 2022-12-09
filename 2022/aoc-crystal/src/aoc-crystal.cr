require "benchmark"
require "option_parser"

require "./days/*"

main()

def main
  day_to_run = "0"
  benchmark = false

  OptionParser.parse do |parser|
    parser.banner = "Usage: aoc-crystal [arguments]"
    parser.on("-d TEST", "The day to run (defaults to all)") { |_day| day_to_run = _day }
    parser.on("-b", "Run in benchmark mode") { benchmark = true }
    parser.on("-h", "Show this help") { puts parser; exit }
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end

  run_day(day_to_run.to_i, benchmark)
end

def run_day(n : Number, benchmark : Bool)
  case n
  when 1 then run_day("Day01", ->{ Day01.run("./src/inputs/day01.txt") }, benchmark)
  when 2 then run_day("Day02", ->{ Day02.run("./src/inputs/day02.txt") }, benchmark)
  when 3 then run_day("Day03", ->{ Day03.run("./src/inputs/day03.txt") }, benchmark)
  when 4 then run_day("Day04", ->{ Day04.run("./src/inputs/day04.txt") }, benchmark)
  when 5 then run_day("Day05", ->{ Day05.run("./src/inputs/day05.txt") }, benchmark)
  when 6 then run_day("Day06", ->{ Day06.run("./src/inputs/day06.txt") }, benchmark)
  when 7 then run_day("Day07", ->{ Day07.run("./src/inputs/day07.txt") }, benchmark)
  when 8 then run_day("Day08", ->{ Day08.run("./src/inputs/day08.txt") }, benchmark)
  when 9 then run_day("Day09", ->{ Day09.run("./src/inputs/day09.txt") }, benchmark)
  else
    puts "Running all days:"
    (1..9).each { |n| run_day(n, benchmark) }
  end
end

def run_day(day_name : String, func : Proc, benchmark : Bool)
  case benchmark
  in true  then Benchmark.ips { |x| x.report(day_name) { func.call } }
  in false then puts "#{day_name}: #{func.call}"
  end
end
