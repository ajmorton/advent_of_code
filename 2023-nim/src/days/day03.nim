import strutils, std/tables, system

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    var numPositions = Table[int, seq[(int, int, int)]]()
    var symbolPositions = Table[char, seq[(int, int)]]()
    var (startX, len) = (0, 0)

    for y, line in lines:
        var isNum = false
        var num = 0
        for x, c in line:
            if c in '0'..'9':
                if isNum == false:
                    num = 0
                    startX = x
                    isNum = true
                    len = 0
                num = num * 10 + c.ord - '0'.ord
                len += 1
            else:
                if c != '.':
                    if not symbolPositions.contains(c):
                        symbolPositions[c] = newSeq[(int, int)]()
                    symbolPositions[c].insert((y, x))
                if isNum == true:
                    if not numPositions.contains(num):
                        numPositions[num] = newSeq[(int, int, int)]()
                    numPositions[num].insert((y, startX, len))
                    num = 0
                    startX = 0
                    len = 0
                    isNum = false

        if isNum == true:
            if not numPositions.contains(num):
                numPositions[num] = newSeq[(int, int, int)]()
            numPositions[num].insert((y, startX, len))
            num = 0
            startX = 0
            len = 0
            isNum = false


    var count = 0
    var posGears = Table[(int, int), seq[int]]()
    for num, positions in numPositions:
        for (y, startX, len) in positions:
            for xx in startX - 1 .. startX + len:
                for symbol, pp in symbolPositions:
                    for (y3,x3) in pp:
                        if (y3, x3) in [(y - 1, xx), (y, xx), (y+1, xx)]:
                            count += num
                            if symbol == '*':
                                if not posGears.contains((y3, x3)):
                                    posGears[(y3, x3)] = newSeq[(int)]()
                                posGears[(y3, x3)].insert(num)

    var gearSum = 0
    for k, v in posGears:
        if v.len == 2:
            gearSum += v[0] * v[1]

    return (count, gearSum)