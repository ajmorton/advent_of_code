import aoc_prelude

import heapqueue
import random

type State = tuple[dist: int, pos: string, path: HashSet[(string, string)]]

proc flood(start: string, conns: Table[string, HashSet[string]]): int =
    var queue = newSeq[string]()
    queue.insert(start, 0)
    var explored: HashSet[string]        
    explored.incl(start)

    while queue.len > 0:
        let curNode = queue.pop
        for outp in conns[curNode]:
            if outp notin explored:
                explored.incl(outp)
                queue.insert(outp, 0)

    return explored.len


proc dijkstra(start, dest: string, conns: Table[string, HashSet[string]]): Option[HashSet[(string, string)]] =

    var queue: HeapQueue[(int, string, HashSet[(string, string)])]
    queue.push((dist: 0, pos: start, path: HashSet[(string, string)]()))

    var seen: Table[string, int]

    while queue.len > 0:
        var (dist, pos, path) = queue.pop

        if pos == dest:
            return some(path)

        if seen.getOrDefault(pos, high(int)) <= dist:
            continue
        else:
            seen[pos] = dist

        for next in conns[pos]:
            let newEdge = ((min(pos, next), max(pos, next)))
            queue.push((dist: dist + 1, pos: next, path: path + [newEdge].toHashSet))

    return none(HashSet[(string, string)])

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var conns: Table[string, HashSet[string]]

    for line in lines:
        [@inputStr, @outputsStr] := line.split(':')
        let input = inputStr.strip
        let outputs = outputsStr.splitWhitespace.mapIt(it.strip)

        for outp in outputs:
            conns.mgetOrPut(input, HashSet[string]()).incl(outp)
            conns.mgetOrPut(outp, HashSet[string]()).incl(input)

    var allPrunedOrig: HashSet[(string, string)]
    for conn in conns.keys:
        for conn2 in conns.keys:
            allPrunedOrig.incl((conn, conn2))

    # Init random
    randomize()

    var allPrunedCorrect: HashSet[(string, string)]
    while true:
        var dijkstrad: HashSet[(string, string)]
        var allPruned = allPrunedOrig
        while allPruned.len > 3:
            echo fmt"loop, allPruned len == {allPruned.len}"
            let options = allPruned - dijkstrad
            if options.len == 0:
                break
            var (posA, posB) = options.toSeq[rand(0 ..< options.len)]
            dijkstrad.incl((posA, posB))
            block:
                var connsLocal = conns
                var allPrunedLocal: HashSet[(string, string)]

                for _ in 1 .. 3:
                    # Find and remove 3 paths. If it crosses the minCut this must include all 3 of the minCut edges
                    let path = dijkstra(posA, posB, connsLocal)
                    if path.isNone:
                        break
                    allPrunedLocal.incl(path.get)
                    for (edgeA, edgeB) in path.get:
                        connsLocal[edgeA].excl(edgeB)
                        connsLocal[edgeB].excl(edgeA)

                allPruned = allPruned.intersection(allPrunedLocal)

        if allPruned.len == 3:
            echo "found!!"
            allPrunedCorrect = allPruned

            for (edgeA, edgeB) in allPrunedCorrect:
                conns[edgeA].excl(edgeB)
                conns[edgeB].excl(edgeA)

            let group1Size = flood(conns.keys.toSeq[0], conns)

            var p1 = group1Size * (conns.len - group1Size)
            if p1 > 0:
                return (p1, 0)
    return (0, 0)

