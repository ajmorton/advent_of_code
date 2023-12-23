import aoc_prelude
import bitops

type Chain = tuple[resetCount: uint, len: int]

# The circuit is a button that feeds via the broadcaster into N chains, which finally 
# feed into a conjunction that is inverted before passing into rx.
# All chains in the circuit represent an incrementing counters that reset every N steps.
# Determine the resetCount and the length of each chain.
proc parseChains(input_file: string): seq[Chain] =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var children = Table[string, seq[string]]()
    var conjunctions: HashSet[string]

    for line in lines:
        [@name, @outputsStr] := line.split(" -> ")

        let outputs = outputsStr.split(",").mapIt(it.strip())
        children[name[1..^1]] = outputs
        if name[0] == '&':
            conjunctions.incl(name[1..^1])

    var nums = newSeq[Chain]()
    for comp in children["roadcaster"]:
        var (curComp, bitVal) = (comp, 0.uint)
        var i = -1
        while true:
            i += 1

            if children[curComp].filterIt(it in conjunctions).len == 1:
                # Feeds back into conjunction
                bitVal.setBit(i)

            let nextFlipFlop = children[curComp].filterIt(it notin conjunctions)
            if nextFlipFlop.len == 0:
                break
            else:
                curComp = nextFlipFlop[0]

        nums.add((resetCount: bitVal, len: i + 2)) # +2 for the entry and exit from the chain
    return nums

proc computePulses(nums: seq[Chain], steps: uint): int =
    var (highPulse, lowPulse) = (0, 0)

    # This logic only works if all chains reset at values greater than the stepCount
    assert nums.allIt(it.resetCount > steps)

    # Num flip flops that that receive input from the chain's conjunctor
    let feedbacks = nums.mapIt((it.resetCount, it.len - it.resetCount.countSetBits()))
    let numChains = nums.len

    for n in 0 ..< steps:
        lowPulse += 1         # The button always send a low pulse to the broadcaster
        lowPulse += numChains # Which forwards the low pulse to all chains

        # The chains are just counters that reset when they reach value n
        # Since all chains have resetCount > steps we can treat them as incrementing counters. 
        let risingEdges = not(n) and (n+1)
        let fallingEdges = n and not(n+1)
        highPulse += numChains * risingEdges.countSetBits
        lowPulse  += numChains * fallingEdges.countSetBits
        
        # Having handled the counting aspect of the chains, handle the rest
        for (resetCount, feedback) in feedbacks:
            let activeRisingFlipFlops = (risingEdges and resetCount).countSetBits
            highPulse += activeRisingFlipFlops            # Active components representing a 1 in the resetCount send a 
                                                          # high signal to the conjunction.
            highPulse += activeRisingFlipFlops * feedback # In return the conjunction sends high pulses to all `feedback` 
                                                          # components it connects to. It'll only send low pulses on a reset 
                                                          # which won't happen while stepCount < resetCount
            highPulse += activeRisingFlipFlops            # It also sends high pulses to the conjunction combining all chains 
            highPulse += activeRisingFlipFlops            # Which sends a high pulse to the inverter. It'll only send a low 
                                                          # pulse when all chains reset at the same time (part 2) 
            lowPulse += activeRisingFlipFlops             # Which will in turn sends low pulses to the final component `rx`

            # A similar process happens for the components representing 0 in resetCount.
            let activeFallingFlipFlops = (fallingEdges and resetCount).countSetBits
            lowPulse  += activeFallingFlipFlops            # They send a low pulse to the conjunction.
            highPulse += activeFallingFlipFlops * feedback # Which triggers high pulses to all `feedback` flip flops
            highPulse += activeFallingFlipFlops            # Also forwarding high pulses to the collating conjunction
            lowPulse  += activeFallingFlipFlops            # Which sends low to the converter
            highPulse += activeFallingFlipFlops            # Which sends high to `rx`

    return highPulse * lowPulse

proc run*(input_file: string): (int, int) =
    let chains = parseChains(input_file)
    let p1 = computePulses(chains, 1000)
    let p2 = chains.mapIt(it.resetCount).lcm

    return (p1, p2.int)