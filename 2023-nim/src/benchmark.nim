import strutils

const SECOND = 1
const MILLISECOND = 1e-3
const MICROSECOND = 1e-6

# ANSI Escape codes
const GREEN = "\e[32m"
const RED = "\e[91m"
const WHITE = ""
const END = "\e[0m"

proc formatTimeStr*(runtime: float): string = 
  var unitString: string
  var timeConverted: float
  var colour: string = WHITE

  (timeConverted, unitString, colour) =
    if runtime < MICROSECOND:
      (runtime * 1e9, "ns", GREEN)
    elif runtime < MILLISECOND:
      (runtime * 1e6, "µs", GREEN)
    elif runtime < SECOND:
      (runtime * 1e3, "ms", WHITE)
    else:
      (runtime, "s", RED)

  let timeString = timeConverted.formatFloat(format = ffDecimal, precision = 3) & " " & unitString

  return colour & timeString & END