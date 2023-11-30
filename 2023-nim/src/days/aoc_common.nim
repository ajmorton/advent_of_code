# Common functions to use across days.

import sequtils, strutils

# Helper funcs to parse and process the input
proc inputAsInts*(input_file: string): seq[int] =
    let input = readFile(input_file).strip(leading = false)
    return input.splitLines.map(parseInt)
