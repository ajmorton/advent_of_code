import aoc_prelude

proc hash(str: string): int = 
    return str.foldl(((a + b.ord) * 17).mod(256), 0)

proc run*(input_file: string): (int, int) =
    let line = readFile(input_file).strip(leading = false)
    
    let instrs = line.split(",")
    let p1 = instrs.map(hash).sum

    var boxes: array[0..255, OrderedTable[string, int]]
    for instr in instrs:
        if instr[^1] == '-':
            let label = instr[0 ..< ^1]
            boxes[label.hash].del(label)
        else:
            let (label, focalLength) = (instr[0 ..< ^2], instr[^1].ord - '0'.ord)
            boxes[label.hash][label] = focalLength

    var p2 = 0
    for b, box in boxes:
        for l, focalLength in box.values.toSeq:
            p2 += (b + 1) * (l + 1) * focalLength
            
    return (p1, p2)