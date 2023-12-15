import aoc_prelude

proc hash(str: string): int =
    var hash = 0
    for c in str:
        let asciiVal = c.ord
        hash += asciiVal
        hash *= 17
        hash = hash.mod(256)
    return hash

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    
    var p1 = 0
    var boxes = [newSeq[(string, int)]()].cycle(256)

    for line in lines:
        let instrs = line.split(",")
        let scores = instrs.map(hash)
        p1 += scores.sum

        # P2
        for instr in instrs:
            var label = ""
            if instr[^1] == '-':
                label = instr[0 ..< ^1]
                let boxIndex = label.hash
                for i, (lensLabel, size) in boxes[boxIndex]:
                    if lensLabel == label:
                        boxes[boxIndex].delete(i)
            else:
                label = instr[0 ..< ^2]
                let lensSize = instr[^1].ord - '0'.ord
                let boxIndex = label.hash
                var replaced = false
                for i, (lensLabel, size) in boxes[boxIndex]:
                    if lensLabel == label:
                        boxes[boxIndex][i] = (lensLabel, lensSize)
                        replaced = true
                        break

                if not replaced:
                    boxes[boxIndex].add((label, lensSize))

    var focusingPower = 0
    for b, box in boxes:
        let boxScore = b + 1
        for l, (label, size) in box:
            let indexScore = l + 1
            let focalLength = size
            let score = boxScore * indexScore * focalLength
            focusingPower += score

    return (p1, focusingPower)