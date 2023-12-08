import math, sequtils, strutils, sugar, system, tables, options
import fusion/matching
import std/nre except toSeq

type LinkTable = Table[string, tuple[l: string, r: string]]

proc getDistTo(start: string, endCond: proc(pos: string): bool, path: string, links: LinkTable): int =
    var curPos = start
    var pathDist = 0
    while not endCond(curPos):
        let turn = path[pathDist.mod(path.len)]
        if turn == 'L':
            curPos = links[curPos].l
        elif turn == 'R':
            curPos = links[curPos].r
        else:
            quit "aaah"

        pathDist += 1
    return pathDist

proc run*(input_file: string): (int, int) =
    [@path, @linksList] := readFile(input_file).strip(leading = false).split("\n\n")

    var links = LinkTable()
    for link in linksList.splitLines:
        let match = link.match(re"(\w+) = \((\w+), (\w+)\)").get.captures.toSeq.map(x => x.get)
        [@entry, @left, @right] := match
        links[entry] = (l: left, r: right)

    # Part 1
    let isZZZ = proc (p: string): bool = p == "ZZZ"
    var pathDist = getDistTo("AAA", isZZZ, path, links)

    # Part 2
    var aPosses = links.keys.toSeq.filter(e => e.endsWith("A"))
    let endsInZ = proc (p: string): bool = p[^1] == 'Z'
    let distances = aPosses.map(aPos => getDistTo(aPos, endsInZ, path, links))

    return (pathDist, distances.lcm)