import aoc_prelude

type Name = string
type ComponentType = enum Broadcaster FlipFlop Conjunction Untyped
type State = enum Off On
type Pulse = enum Low High
type Component = tuple[componentType: ComponentType, outputs: seq[Name], state: State, inputs: Table[Name, Pulse]]
type Signal = tuple[to: Name, fromm: Name, pulse: Pulse]

proc run*(input_file: string): (int, int) =
    let lines = readFile(input_file).strip(leading = false).splitLines

    var components = Table[Name, Component]()

    for line in lines:
        [@name, @outputsStr] := line.split(" -> ")
        let outputs = outputsStr.split(",").mapIt(it.strip(chars = {' '}))
        case name[0]
        of 'b':
            components[name] = (componentType: Broadcaster, outputs: outputs, state: Off, inputs: Table[Name, Pulse]())
        of '%':
            # flip flop
            components[name[1..^1]] = (componentType: FlipFlop, outputs: outputs, state: Off, inputs: Table[Name, Pulse]())
        of '&':
            # conjunction
            components[name[1..^1]] = (componentType: Conjunction, outputs: outputs, state: Off, inputs: Table[Name, Pulse]())
        else: quit "unknown prefix"

    var untypedComponents = newSeq[Name]()
    for (name, component) in components.pairs:
        for output in component.outputs:
            if output in components:
                components[output].inputs[name] = Low
            else:
                untypedComponents.add(output)

    for component in untypedComponents:
        components[component] = (componentType: Untyped, outputs: newSeq[Name](), state: Off, inputs: Table[Name, Pulse]())


    var signalsQueue = newSeq[Signal]()

    var counts = [0, 0] # [LowCount, HighCount]
    var i = 0
    var p1, p2 = 0
    var precursors: Table[Name, int] = {"ph": 0, "vn": 0, "kt": 0, "hn": 0}.toTable
    while true:
        if i == 1000:
            p1 = counts.prod

        if p2 != 0:
            break

        signalsQueue.insert((to: "broadcaster", fromm: "button", pulse: Low), 0)
        while signalsQueue.len > 0:
            let signal = signalsQueue.pop

            # The input looks like
            # rx
            #  \-- &kc
            #       |-- &ph
            #       |-- &vn
            #       |-- &kt
            #       \-- &hn
            # so we need all of ph, vn, kt, hn to send a high signal, which is flipped by kc, 
            # to send a low signal to rx. Assuming all of these gates run on a loop then the 
            # lowest common multiple of all cycles will be the answer.

            if signal.fromm == "ph" and signal.pulse == High:
                precursors["ph"] = i + 1
            if signal.fromm == "vn" and signal.pulse == High:
                precursors["vn"] = i + 1
            if signal.fromm == "kt" and signal.pulse == High:
                precursors["kt"] = i + 1
            if signal.fromm == "hn" and signal.pulse == High:
                precursors["hn"] = i + 1

            if precursors.values.toSeq.allIt(it != 0):
                p2 = precursors.values.toSeq.lcm
                break

            counts[signal.pulse.ord] += 1

            let curComponentName = signal.to
            let curComponent = components[signal.to]
            case curComponent.componentType
            of Broadcaster:
                for output in curComponent.outputs:
                    signalsQueue.insert((to: output, fromm: curComponentName, pulse: signal.pulse), 0)
            of FlipFlop:
                if signal.pulse == Low:
                    case curComponent.state
                    of Off: 
                        components[signal.to].state = On
                        for output in curComponent.outputs:
                            signalsQueue.insert((to: output, fromm: curComponentName, pulse: High), 0)
                    of On:
                        components[signal.to].state = Off
                        for output in curComponent.outputs:
                            signalsQueue.insert((to: output, fromm: curComponentName, pulse: Low), 0)
            of Conjunction:
                components[signal.to].inputs[signal.fromm] = signal.pulse
                if components[signal.to].inputs.values.toSeq.allIt(it == High):
                    for output in curComponent.outputs:
                        signalsQueue.insert((to: output, fromm: curComponentName, pulse: Low), 0)
                else:
                    for output in curComponent.outputs:
                        signalsQueue.insert((to: output, fromm: curComponentName, pulse: High), 0)
            of Untyped:
                discard

        i += 1

    return (p1, p2)