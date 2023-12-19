import aoc_prelude

type Workflow = string
type Comparison = enum AutoAccept GreaterThan LessThan
type Field = enum X M A S
type Check = tuple[field: Field, comparison: Comparison, val: int]
type Rule = tuple[check: Check, dest: Workflow]

type Range = tuple[min: int, max: int]
type PartRange = array[4, Range]

# Returns (Passes, Fails)
proc eval(check: Check, partRange: PartRange): (Option[PartRange], Option[PartRange]) =
    
    # Convert to ord so we can index into the PartRange array
    let field = check.field.ord
    case check.comparison
        of AutoAccept: return (some(partRange), none(PartRange))
        of GreaterThan:
            if partRange[field].min > check.val:
                return (some(partRange), none(PartRange)) 
            elif partRange[field].max <= check.val:
                return (none(PartRange), some(partRange))
            else:
                var passes, fails = partRange
                passes[field] = (min: check.val + 1, max: partRange[field].max)
                fails[field] = (min: partRange[field].min, max: check.val)
                return ( some(passes), some(fails) )

        of LessThan:
            if partRange[field].max < check.val:
                return (some(partRange), none(PartRange)) 
            elif partRange[field].min >= check.val:
                return (none(PartRange), some(partRange))
            else: 
                var passes, fails = partRange
                passes[field] = (min: partRange[field].min, max: check.val - 1)
                fails[field] = (min: check.val, max: partRange[field].max)
                return ( some(passes), some(fails) )

proc acceptedPartRanges(partRanges: seq[PartRange], workflows: Table[Workflow, seq[Rule]]): seq[PartRange] = 

    var accepted = newSeq[PartRange]()
    var queue = partRanges.map(partRange => (partRange, "in"))

    while queue.len > 0:
        let (partRange, workflow) = queue.pop
        case workflow
        of "A": accepted.add(partRange)
        of "R": continue
        else:
            var curRange = partRange
            for rule in workflows[workflow]:
                let (passes, fails) = eval(rule.check, curRange)

                if passes.isSome:
                    queue.add((partRange: passes.get, workflow: rule.dest))

                if fails.isNone:
                    break

                curRange = fails.get

    return accepted

proc parseRule(ruleStr: string): Rule =

    let colonIndex = ruleStr.find(':')
    if colonIndex != -1:
        let field = case ruleStr[0]
            of 'x': X
            of 'm': M
            of 'a': A
            of 's': S
            else: quit fmt"Unexpected field {ruleStr[0]}"

        let comparator = case ruleStr[1]
            of '>': GreaterThan
            of '<': LessThan
            else: quit fmt"Unexpected comparator {ruleStr[1]}"

        let val = ruleStr[2 ..< colonIndex].parseInt

        let check = (field: field, comparison: comparator, val: val)
        return(check: check, dest: ruleStr[colonIndex + 1 .. ^1])

    else: # entire string is the destination workflow
        let check = (field: X, comparison: AutoAccept, val: 0)
        return(check: check, dest: ruleStr)

proc buildWorkflows(ruleStrings: string): Table[Workflow, seq[Rule]] =
    var workflows: Table[Workflow, seq[Rule]]
    for ruleStr in ruleStrings.splitLines:
        let firstBrack = ruleStr.find('{')
        let (name, ruleSet) = (ruleStr[0..<firstBrack], ruleStr[firstBrack+1 ..< ^1])  

        workflows[name] = ruleSet.split(",").map(parseRule)
    return workflows

proc run*(input_file: string): (int, int) =
    [@ruleStrings, @partStrs] := readFile(input_file).strip(leading = false).split("\n\n")
    let workflows = buildWorkflows(ruleStrings)

    # P1
    var parts = newSeq[PartRange]()
    for partStr in partStrs.splitLines:
        [@x, @m, @a, @s] := partStr[1 ..< ^1].split(",").mapIt(it.split("=")[^1].parseInt)
        parts.add([(min: x, max: x), (min: m, max: m), (min: a, max: a), (min: s, max: s)])
    var p1 = acceptedPartRanges(parts, workflows).mapIt(it.mapIt(it.max).sum).sum

    # P2
    var p2Parts = [[(min: 1, max: 4000), (min: 1, max: 4000), (min: 1, max: 4000), (min: 1, max: 4000)]].toSeq
    var p2Accepted = acceptedPartRanges(p2Parts, workflows)
    var p2 = p2Accepted.mapIt(it.mapIt(it.max - it.min + 1).prod).sum
 
    return (p1, p2)