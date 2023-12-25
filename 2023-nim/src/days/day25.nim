import aoc_prelude
import heapqueue

type CompId = int32
type State = tuple[dist: int, pos: CompId, path: seq[(CompId, CompId)]]

proc `<`(a, b: State): bool = 
    a.dist < b.dist

proc dijkstra(start, dest: CompId, conns: Table[CompId, seq[CompId]]): (Option[seq[(CompId, CompId)]], int) =
    var queue: HeapQueue[State]
    queue.push((dist: 0, pos: start, path: newSeq[(CompId, CompId)]()))

    var seen = newSeqWith(conns.len, high(int))

    while queue.len > 0:
        var (dist, pos, path) = queue.pop
        for next in conns[pos]:
            if next == dest:
                return (some(path), conns.len)

            if seen[next] <= dist:
                continue
            else:
                seen[next] = dist

            let newEdge = ((min(pos, next), max(pos, next)))
            queue.push((dist: dist + 1, pos: next, path: path & [newEdge].toSeq))

    let exploredNodes = conns.len - seen.count(high(int))
    return (none(seq[(CompId, CompId)]), exploredNodes)

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var conns: Table[CompId, seq[CompId]]

    var componentIds : Table[string, CompId]
    var compId: CompId = 0

    for line in lines:
        let splitIndex = line.find(':')
        let (inputStr, outputsStr) = (line[0 ..< splitIndex], line[splitIndex + 1 .. ^1])
        let input = inputStr.strip
        let outputs = outputsStr.splitWhitespace

        if input notin componentIds:
            componentIds[input] = compId
            compId += 1

        for output in outputs:
            if output notin componentIds:
                componentIds[output] = compId
                compId += 1

            let inputId = componentIds[input]
            let outputId = componentIds[output]

            if inputId notin conns.mgetOrPut(outputId, newSeq[CompId]()):
                conns[outputId].add(inputId)

            if outputId notin conns.mgetOrPut(inputId, newSeq[CompId]()):
                conns[inputId].add(outputId)

    for a in 0 ..< conns.len:
        # This could be `for b in a + 1 ..< conns.len`, but because of the way we generate componentIDs 
        # it's highly likely that adjacent ID belong to neighbouring nodes. This in turn makes them less 
        # likely to cross the minCut. Since this logic keeps trying until it finds two points that cross 
        # the minCut iterating b in reverse makes it more likely to fimd a cross-minCut pair quickly.
        for b in countdown(conns.len - 1, a + 1):
            var connsCopy = conns
            let posA = connsCopy.keys.toSeq[a]
            let posB = connsCopy.keys.toSeq[b]

            # Find and remove 3 paths. If it crosses the minCut this will remove all 3 edges 
            # connecting the two groups and a fourth search will fail.
            for _ in 1 .. 3:
                let (path, _) = dijkstra(posA, posB, connsCopy)
                for (edgeA, edgeB) in path.get:
                    connsCopy[edgeA].del(connsCopy[edgeA].find(edgeB))
                    connsCopy[edgeB].del(connsCopy[edgeB].find(edgeA))

            let (path, exploredCount) = dijkstra(posA, posB, connsCopy)
            if path.isNone:
                return (exploredCount * (conns.len - exploredCount), 0)
