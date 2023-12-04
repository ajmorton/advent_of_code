import math, sequtils, strutils, sugar

# Find the first and last number in a string and return them as a concatenated int. The numbers can be digits (0, 1)
# or optionally words ("eight", "two"). Important! Number strings can overlap: "eightwo" returns 82
proc firstAndLastNumber(str: string, includeStrs: bool): int = 
    var (firstNum, lastNum) = (-1, -1)

    for i in 0 ..< str.len():
        for n, numStr in ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]:
            if (includeStrs and str.continuesWith(numStr, i)) or (str[i].ord == ('0'.ord + n + 1)): 
                if firstNum == -1:
                    firstNum = n + 1
                lastNum = n + 1

    return 10 * firstNum + lastNum

proc run*(inputFile: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines()
    let p1 = lines.map(x => firstAndLastNumber(x, false)).sum
    let p2 = lines.map(x => firstAndLastNumber(x, true)).sum
    return (p1, p2)
