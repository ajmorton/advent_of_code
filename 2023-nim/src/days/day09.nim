import math, sequtils, sets, strformat, strutils, sugar, system, tables, options
import fusion/matching
import std/nre except toSeq

proc buildDeltas(s: seq[int]): seq[int] =
    var newSeq = newSeq[int]()
    for i in 0 ..< s.len - 1:
        newSeq.add(s[i + 1] - s[i])
    return newSeq

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines
    let sequences = lines.map(l => l.splitWhitespace.map(parseInt))

    var p1, p2 = 0
    for s in sequences:
        var seqStack = newSeq[seq[int]]()
        var newSeq = s
        seqStack.add(newSeq)
        
        while true:
            newSeq = buildDeltas(newSeq)
            if newSeq.all(n => n == 0):
                # end of pattern
                newSeq.add(0)

                # start popping
                var lowerSeq = newSeq
                while seqStack.len != 0:
                    var upperSeq = seqStack.pop
                    let delta = lowerSeq[^1]
                    let delta2 = lowerSeq[0]
                    upperSeq.add(upperSeq[^1] + delta)
                    upperSeq.insert(upperSeq[0] - delta2, 0)
                    lowerSeq = upperSeq
                                
                p1 += lowerSeq[^1]
                p2 += lowerSeq[0]
                break
            else:
                seqStack.add(newSeq)

    return (p1, p2)