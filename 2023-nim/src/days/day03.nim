# FIXME - This is 2019 Day 03

import strutils, sequtils, std/tables, std/sets, sugar

type Direction = enum Up, Down, Left, Right

type Command = ref object
    dir: Direction
    dist: int

type Pos = (int, int)

proc `+`(p1: Pos, p2: Pos): Pos = 
    return (p1[0] + p2[0], p1[1] + p2[1])

proc `+=`(p1: var Pos, p2: Pos) = 
    p1 = (p1[0] + p2[0], p1[1] + p2[1])

proc parseCommand(str: string): Command =
    let dirStr = str[0]
    let distStr = str[1..^1]

    let dir = case dirStr
    of 'U': Up
    of 'D': Down
    of 'L': Left
    of 'R': Right
    else: quit "Invalid dirStr"

    let dist = parseInt(distStr)

    return Command(dir: dir, dist: dist)

proc parseWire(str: string): seq[Command] =
    let commandStrs = str.split(',')
    return commandStrs.map(parseCommand)

proc wireCells(wire: seq[Command]): Table[Pos, int] = 
    var explored = Table[Pos, int]()
    var pos = (0, 0)
    var distTraveled = 0
    for command in wire:
        case command.dir
        of Up: 
            for i in 0 ..< command.dist:
                pos += (1, 0)
                distTraveled += 1
                explored[pos] = distTraveled
        of Down: 
            for i in 0 ..< command.dist:
                pos += (-1, 0)
                distTraveled += 1
                explored[pos] = distTraveled
        of Left: 
            for i in 0 ..< command.dist:
                pos += (0, -1)
                distTraveled += 1
                explored[pos] = distTraveled
        of Right: 
            for i in 0 ..< command.dist:
                pos += (0, 1)
                distTraveled += 1
                explored[pos] = distTraveled
    return explored

proc run*(input_file: string): (int, int) =
    let input = readFile(input_file).strip(leading = false).splitLines
    let wires = input.map(parseWire)

    let explored1 = wireCells(wires[0])
    let explored2 = wireCells(wires[1])

    let e1 = toHashSet(explored1.keys.toSeq())
    let e2 = toHashSet(explored2.keys.toSeq())

    let intersections = e1.intersection(e2)
    let dists = intersections.map((inter) => abs(inter[0]) + abs(inter[1]))
    let minDist = dists.toSeq.min

    let dists2 = intersections.map((inter) => explored1[inter] + explored2[inter])
    let minDist2 = dists2.toSeq.min

    return (minDist, minDist2)