import aoc_prelude

type Workflow = string
type Comparison = enum AutoAccept GreaterThan LessThan
type Field = enum X M A S
type Rule = tuple[field: Field, comparison: Comparison, val: int, dest: Workflow]
type PartRange = array[4, tuple[min: int, max: int]]

# Returns (Passes, Fails)
proc eval(rule: Rule, partRange: PartRange): (Option[PartRange], Option[PartRange]) =
    
    # Convert to ord so we can index into the PartRange array
    let field = rule.field.ord
    case rule.comparison
        of AutoAccept: return (some(partRange), none(PartRange))
        of GreaterThan:
            if partRange[field].min > rule.val:
                return (some(partRange), none(PartRange)) 
            elif partRange[field].max <= rule.val:
                return (none(PartRange), some(partRange))
            else:
                var passes, fails = partRange
                passes[field].min = rule.val + 1
                fails[field].max = rule.val
                return ( some(passes), some(fails) )

        of LessThan:
            if partRange[field].max < rule.val:
                return (some(partRange), none(PartRange)) 
            elif partRange[field].min >= rule.val:
                return (none(PartRange), some(partRange))
            else: 
                var passes, fails = partRange
                passes[field].max = rule.val - 1
                fails[field].min = rule.val
                return ( some(passes), some(fails) )

proc acceptedPartRangesScore(partRanges: seq[PartRange], workflows: Table[Workflow, seq[Rule]], score: proc(partRange: PartRange): int): int = 
    var partsScore = 0
    var queue = partRanges.map(partRange => (partRange, "in"))

    while queue.len > 0:
        var (curRange, workflow) = queue.pop
        for rule in workflows[workflow]:
            let (passes, fails) = eval(rule, curRange)

            if passes.isSome:
                case rule.dest:
                of "A": partsScore += score(passes.get)
                of "R": discard
                else:   queue.add((partRange: passes.get, workflow: rule.dest))

            if fails.isNone:
                break

            curRange = fails.get
    return partsScore

proc parseRule(ruleStr: string): Rule =

    let colonIndex = ruleStr.find(':')
    if colonIndex != -1:
        # Abuse the fact that enums start at zero
        let field      = "xmas".find(ruleStr[0]).Field
        let comparator =  " ><".find(ruleStr[1]).Comparison
        let val        = ruleStr[2 ..< colonIndex].parseInt

        return(field: field, comparison: comparator, val: val, dest: ruleStr[colonIndex + 1 .. ^1])

    else: # entire string is the destination workflow
        return(field: X, comparison: AutoAccept, val: 0, dest: ruleStr)

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
    var p1Parts = newSeq[PartRange]()
    for partStr in partStrs.splitLines:
        [@x, @m, @a, @s] := partStr[1 ..< ^1].split(",").mapIt(it.split("=")[^1].parseInt)
        p1Parts.add([(min: x, max: x), (min: m, max: m), (min: a, max: a), (min: s, max: s)])
    let p1ScoringFunc = proc(pr: PartRange): int = pr.mapIt(it.max).sum
    var p1 = acceptedPartRangesScore(p1Parts, workflows, p1ScoringFunc)

    # P2
    var p2Parts = [[(min: 1, max: 4000), (min: 1, max: 4000), (min: 1, max: 4000), (min: 1, max: 4000)]].toSeq
    let p2ScoringFunc = proc(pr: PartRange): int = pr.mapIt(it.max - it.min + 1).prod
    var p2 = acceptedPartRangesScore(p2Parts, workflows, p2ScoringFunc)
 
    return (p1, p2)