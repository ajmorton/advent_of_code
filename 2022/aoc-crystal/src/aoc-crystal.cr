require "benchmark"
require "option_parser"

require "./days/*"

main()

def main
  day_to_run = nil
  benchmark = false

  OptionParser.parse do |parser|
    parser.banner = "Usage: aoc-crystal [arguments]"
    parser.on("-d TEST", "The day to run (defaults to all)") { |_day| day_to_run = _day.to_i }
    parser.on("-b", "Run in benchmark mode") { benchmark = true }
    parser.on("-h", "Show this help") { puts parser; exit }
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end

  run_day(day_to_run, benchmark)
end

def run_day(n : Number?, benchmark : Bool)
  days = [Day01, Day02, Day03, Day04, Day05, Day06, Day07, Day08, Day09, Day10,
          Day11]

  if n && days[n - 1]?
    run_day(days[n - 1], benchmark)
  else
    puts "Running all days:"
    days.each { |day| run_day(day, benchmark) }
  end
end

def run_day(day : Class, benchmark : Bool)
  func = ->{ day.run("./src/inputs/#{day.to_s.downcase}.txt") }
  if benchmark
    Benchmark.ips { |x| x.report(day.to_s) { func.call } }
  else
    puts "#{day}: #{func.call}"
  end
end
