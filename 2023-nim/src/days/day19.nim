import aoc_prelude
import std/nre except toSeq

type Workflow = string
type Comparison = enum GreaterThan LessThan AutoAccept
type Field = enum X M A S
type Check = tuple[field: Field, comparison: Comparison, val: int]
type Rule = tuple[check: Check, dest: Workflow]
type Part = tuple[x: int, m: int, a: int, s: int]

type Range = tuple[min: int, max: int]
type PartRange = tuple[x: Range, m: Range, a: Range, s: Range]
type State = tuple[partRange: PartRange, workflow: Workflow]

const Accept: Workflow = "A"
const Reject: Workflow = "R"

proc eval(check: Check, part: Part): bool =
    
    return case check.comparison
        of AutoAccept: true
        of GreaterThan:
            case check.field:
                of X: part.x > check.val
                of M: part.m > check.val
                of A: part.a > check.val
                of S: part.s > check.val
        of LessThan:
            case check.field:
                of X: part.x < check.val
                of M: part.m < check.val
                of A: part.a < check.val
                of S: part.s < check.val

# Returns (Passes, Fails)
proc eval(check: Check, partRange: PartRange): (Option[PartRange], Option[PartRange]) =
    
    return case check.comparison
        of AutoAccept: (some(partRange), none(PartRange))
        of GreaterThan:
            case check.field:
                of X: 
                    if partRange.x.min > check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.x.max <= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: (min: check.val + 1, max: partRange.x.max), m: partRange.m, a: partRange.a, s: partRange.s)),
                            some((x: (min: partRange.x.min, max: check.val), m: partRange.m, a: partRange.a, s: partRange.s))
                        )
                of M: 
                    if partRange.m.min > check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.m.max <= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: partRange.x, m: (min: check.val + 1, max: partRange.m.max), a: partRange.a, s: partRange.s)),
                            some((x: partRange.x, m: (min: partRange.m.min, max: check.val), a: partRange.a, s: partRange.s))
                        )
                of A: 
                    if partRange.a.min > check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.a.max <= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: partRange.x, m: partRange.m, a: (min: check.val + 1, max: partRange.a.max), s: partRange.s)),
                            some((x: partRange.x, m: partRange.m, a: (min: partRange.a.min, max: check.val), s: partRange.s))
                        )
                of S: 
                    if partRange.s.min > check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.s.max <= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: partRange.x, m: partRange.m, a: partRange.a, s: (min: check.val + 1, max: partRange.s.max))),
                            some((x: partRange.x, m: partRange.m, a: partRange.a, s: (min: partRange.s.min, max: check.val)))
                        )
        of LessThan:
            case check.field:
                of X: 
                    if partRange.x.max < check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.x.min >= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: (min: partRange.x.min, max: check.val - 1), m: partRange.m, a: partRange.a, s: partRange.s)),
                            some((x: (min: check.val, max: partRange.x.max), m: partRange.m, a: partRange.a, s: partRange.s))
                        )
                of M: 
                    if partRange.m.max < check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.m.min >= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: partRange.x, m: (min: partRange.m.min, max: check.val - 1), a: partRange.a, s: partRange.s)),
                            some((x: partRange.x, m: (min: check.val, max: partRange.m.max), a: partRange.a, s: partRange.s))
                        )
                of A: 
                    if partRange.a.max < check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.a.min >= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: partRange.x, m: partRange.m, a: (min: partRange.a.min, max: check.val - 1), s: partRange.s)),
                            some((x: partRange.x, m: partRange.m, a: (min: check.val, max: partRange.a.max), s: partRange.s))
                        )
                of S: 
                    if partRange.s.max < check.val:
                        (some(partRange), none(PartRange)) 
                    elif partRange.s.min >= check.val:
                        (none(PartRange), some(partRange))
                    else: 
                        (
                            some((x: partRange.x, m: partRange.m, a: partRange.a, s: (min: partRange.s.min, max: check.val - 1))),
                            some((x: partRange.x, m: partRange.m, a: partRange.a, s: (min: check.val, max: partRange.s.max)))
                        )

proc run*(input_file: string): (int, int) =
    [@ruleStrings, @parts] := readFile(input_file).strip(leading = false).split("\n\n")

    # parse ruleStrings
    var workflows: Table[Workflow, seq[Rule]]
    for ruleStr in ruleStrings.splitLines:
        [@name, @ruleSet] := ruleStr.match(re"([\w]+)\{(.*)\}").get.captures.toSeq.mapIt(it.get)
        workflows[name] = newSeq[Rule]()
        for rule in ruleSet.split(","):
            if rule.contains(":"):
                [@condStr, @workflow] := rule.split(":")

                let field = case condStr[0]
                    of 'x': X
                    of 'm': M
                    of 'a': A
                    of 's': S
                    else: quit fmt"Unexpected field {condStr[0]}"

                let comparator = case condStr[1]
                    of '>': GreaterThan
                    of '<': LessThan
                    else: quit fmt"Unexpected comparator {condStr[1]}"

                let val = condStr[2..^1].parseInt

                let check = (field:field, comparison: comparator, val: val)
                workflows[name].add((check: check, dest: workflow))

            else:
                let check = (field:X, comparison: AutoAccept, val: 0)
                let workflow = rule
                workflows[name].add((check: check, dest: workflow))

    var p1 = 0
    for partStr in parts.splitLines:
        [@x, @m, @a, @s] := partStr[1 ..< ^1].split(",").mapIt(it.split("=")[^1].parseInt)
        let part = (x: x, m: m, a: a, s: s)

        var curWorkflow = "in"
        while curWorkflow notin [Accept, Reject]:
            var matchedRule = false
            for rule in workflows[curWorkflow]:
                if eval(rule.check, part):
                    curWorkflow = rule.dest
                    matchedRule = true
                    break

        if curWorkflow == Accept:
            p1 += part.x + part.m + part.a + part.s

    # P2
    var p2 = 0
    let startPartRange = (x:(min: 1, max: 4000), m:(min: 1, max: 4000), a:(min: 1, max: 4000), s:(min: 1, max: 4000))
    let startState = (partRange: startPartRange, workflow: "in")
    var queue = newSeq[State]()
    queue.add(startState)

    while queue.len > 0:
        let curState = queue.pop
        if curState.workflow == Accept:
            let partRange = curState.partRange
            p2 += (partRange.x.max - partRange.x.min + 1) * 
                  (partRange.m.max - partRange.m.min + 1) * 
                  (partRange.a.max - partRange.a.min + 1) * 
                  (partRange.s.max - partRange.s.min + 1)
        elif curState.workflow == Reject:
            continue
        else:
            var curRange = curState.partRange
            for rule in workflows[curState.workflow]:
                let (passes, fails) = eval(rule.check, curRange)

                if passes.isSome:
                    queue.add((partRange: passes.get, workflow: rule.dest))

                if fails.isSome:
                    curRange = fails.get
                else:
                    break
                
    return (p1, p2)