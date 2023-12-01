import strutils, sequtils, math

proc numFromStr(str: string): int = 
    let nums = filter(str.toSeq(), isDigit)
    return parseInt(nums[0] & nums[^1])

proc toNumbers(str: string): seq[int] = 
    var nums: seq[int]
    var localStr = str

    while localStr.len() > 0:
        if localStr.startsWith("one"):
            nums.add(1)
        elif localStr.startsWith("two"):
            nums.add(2)
        elif localStr.startsWith("three"):
            nums.add(3)
        elif localStr.startsWith("four"):
            nums.add(4)
        elif localStr.startsWith("five"):
            nums.add(5)
        elif localStr.startsWith("six"):
            nums.add(6)
        elif localStr.startsWith("seven"):
            nums.add(7)
        elif localStr.startsWith("eight"):
            nums.add(8)
        elif localStr.startsWith("nine"):
            nums.add(9)
        elif localStr[0] == '1':
            nums.add(1)
        elif localStr[0] == '2':
            nums.add(2)
        elif localStr[0] == '3':
            nums.add(3)
        elif localStr[0] == '4':
            nums.add(4)
        elif localStr[0] == '5':
            nums.add(5)
        elif localStr[0] == '6':
            nums.add(6)
        elif localStr[0] == '7':
            nums.add(7)
        elif localStr[0] == '8':
            nums.add(8)
        elif localStr[0] == '9':
            nums.add(9)

        localStr = localStr[1..^1]

    return nums

proc numOrNumStrFromStr(str: string): int = 
    let nums = toNumbers(str)
    return 10 * nums[0] + nums[^1]

proc run*(inputFile: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines()
    let nums = lines.map(numFromStr)

    return (sum(nums), lines.map(numOrNumStrFromStr).sum)
