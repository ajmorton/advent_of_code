import aoc_prelude

func buildDeltas(s: seq[int]): seq[int] =
    var newSeq = newSeq[int]()
    for i in 0 ..< s.len - 1:
        newSeq.add(s[i + 1] - s[i])
    return newSeq

func nextNums(s: seq[int]): tuple[left: int, right: int] =
    if s.all(n => n == 0):
        return (0, 0)

    let nextDeltas = nextNums(buildDeltas(s))
    return (left: s[0] - nextDeltas[0], right: s[^1] + nextDeltas[1])

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let sequences = lines.mapIt(it.splitWhitespace.map(parseInt))

    let nextNums = sequences.map(nextNums)
    let sumNextNums = nextNums.foldl((left: a.left + b.left, right: a.right + b.right))
    return (sumNextNums.right, sumNextNums.left)