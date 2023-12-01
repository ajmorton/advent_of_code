import math, sequtils, strutils, sugar

# Find the first and last number in a string and return them as a concatenated int. The numbers can be digits (0, 1)
# or words ("eight", "two"). Important! Number strings can overlap. "eightwo" returns 82
proc firstAndLastDigitOrNumber(str: string, includeStrs: bool): int = 
    # Local copy of str we can mutate. 
    var localStr = str
    var (firstNum, lastNum) = (-1, -1)

    while localStr.len() > 0:
        for i, numStr in ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]:
            if (includeStrs and localStr.startsWith(numStr)) or (localStr[0].ord == ('0'.ord + i + 1)): 
                if firstNum == -1:
                    firstNum = i + 1
                lastNum = i + 1
        localStr = localStr[1..^1]

    return 10 * firstNum + lastNum

proc firstAndLastDigit(line: string): int =
    let digits = line.filterIt(it in Digits)
    return parseInt(digits[0] & digits[^1])

proc run*(inputFile: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines()
    let p1 = lines.map(firstAndLastDigit).sum
    let p2 = lines.map(l => firstAndLastDigitOrNumber(l, true)).sum
    return (p1, p2)
