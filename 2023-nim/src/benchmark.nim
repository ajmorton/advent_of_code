import strutils, strformat, times

const SECOND = 1
const MILLISECOND = 1e-3
const MICROSECOND = 1e-6

# ANSI Escape codes
const GREEN* = "\e[32m"
const RED* = "\e[91m"
const WHITE* = ""
const END* = "\e[0m"
const CLEAR_LINE* = "\e[2K\r"

# Pretty print a time. Colour code for slow and fast times
proc prettyPrintTime*(seconds: float): string = 
  var unitString: string
  var timeConverted: float
  var colour: string = WHITE

  (timeConverted, unitString, colour) =
    if seconds < MICROSECOND:
      (seconds * 1e9, "ns", GREEN)
    elif seconds < MILLISECOND:
      (seconds * 1e6, "µs", GREEN)
    elif seconds < SECOND:
      (seconds * 1e3, "ms", WHITE)
    else:
      (seconds, "s", RED)

  let timeString = fmt"{timeConverted.formatFloat(format = ffDecimal, precision = 3)} {unitString}"

  return colour & timeString & END

# Run a function for 5 seconds. Determine average runtime with a warm cache.
proc benchmark*(fun: proc (inputFile: string): (int, int), inputFileStr: string) =
  stdout.write "    Benchmarking for 5 seconds..."
  stdout.flushFile()

  let startTimeSingle = epochTime()
  discard fun(inputFileStr)
  let runTimeSingle = epochTime() - startTimeSingle

  let numRuns = (5.0 / runTimeSingle).int
  stdout.write fmt"{CLEAR_LINE}    Single run took {prettyPrintTime(runTimeSingle)}. Running {numRuns} iterations (~5 seconds)"
  stdout.flushFile()

  let startTimeMulti = epochTime()
  for _ in 0 .. numRuns:
    discard fun(inputFileStr)
  let runTimeMulti = epochTime() - startTimeMulti
  let avgRunTime = runTimeMulti / numRuns.float

  echo fmt"{CLEAR_LINE}    runtime: {prettyPrintTime(avgRuntime)}"
