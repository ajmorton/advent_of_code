#! /usr/bin/env pypy3
from . import read_as

AND = 1
OR = 2
XOR = 3

def find_replacements(inputs, xs, ys, zs, sol=[], depth=0, smallest_solved=0):

    # print(f"find rep: {depth=}, {smallest_solved=}, {sol=}")

    if depth > 4:
        # print("          too deep")
        return False

    import math
    for x_pow in range(0, 45):
        x = 1 << x_pow
        # if (x != 0) and (x & (x-1) == 0):
        #     print("new power of 2: ", x_pow)

        for y_pow in range(0, x_pow + 1):
            y = 1 << y_pow
            z = x + y
            # print()
            copy = inputs.copy()

            # copy["fhd"] = inputs["kkp"]
            # copy["kkp"] = inputs["fhd"]

            setup(copy, xs, ys, x, y)
            num_bits = 1 if x == 0 else int(math.log(x, 2)) + 1
            num_bits += 1 # z large than x and y
            # print(f"{num_bits=}")
            comp_z = compute(copy, zs[-num_bits:])
            # print("COMP_Z = ", comp_z)
            if z != comp_z:
                if z <= smallest_solved:
                    # print(f"{'  '*depth} broke earlier circuit")
                    # We must've broken a smaller number. Give up
                    return False
                # print(f"{'  ' * depth}mismatch! {x} + {y} != {comp_z}")
                # exit(0)
                circuits = list(copy.keys())
                for a_i in range(0, len(circuits)):
                    a = circuits[a_i]
                    if a.startswith('x') or a.startswith('y'): continue
                    for b_i in range(a_i + 1, len(circuits)):
                        b = circuits[b_i]
                        if b.startswith('x') or b.startswith('y'): continue
                        if a == b: continue

                        try:
                            copyy = copy.copy()
                            copyy[a] = copy[b]
                            copyy[b] = copy[a]
                            if z == compute(copyy, zs[-num_bits:]):
                                # print(f"{'  ' * depth}SOL: a,b", a, b)
                                if find_replacements(copyy, xs, ys, zs, sol=sol+[a,b], depth=depth+1, smallest_solved=z):
                                    # print("AAA")
                                    # return True
                                    pass
                                else:
                                    # continue trying sols
                                    pass
                        except RecursionError as r:
                            continue

                # print(f"{'  '*depth}no sols found!")
                return False

            else:
                pass
                # if comp_z % 64 == 0:
                #     print(f"{x} + {y} == {comp_z}")

    print("solved all vals? ", sol)
    return True

def setup(copy, xs, ys, x, y):
    for xx in xs:
        copy[xx] = False
    for yy in ys:
        copy[yy] = False

    for i in range(0, len(xs)):
        if (x >> i) & 1:
            copy[xs[-i - 1]] = True

    for i in range(0, len(ys)):
        if (y >> i) & 1:
            copy[ys[-i - 1]] = True

def compute(inputs, zs):
    res = []
    # print("zs = ", sorted(zs))
    # xs =  inputs["x05"], inputs["x04"], inputs["x03"], inputs["x02"], inputs["x01"], inputs["x00"]
    # print(f"xs = {xs}")
    # ys =  inputs["y05"], inputs["y04"], inputs["y03"], inputs["y02"], inputs["y01"], inputs["y00"]
    # print(f"ys = {ys}")

    for output in zs: 
        v = resolve(output, inputs)
        res.append(v)

    # for out in sorted(inputs):
    #     print(f"{out}: ", resolve(out, inputs))

    p1 = 0
    # print("RES", res)
    for bit in res:
        p1 *= 2
        p1 += bit

    # zs =  resolve("z06", inputs), resolve("z05", inputs), resolve("z04", inputs), resolve("z03", inputs), resolve("z02", inputs), resolve("z01", inputs), resolve("z00", inputs)
    # print(f"zs = {zs}")
    return p1

def resolve(output, inputs, depth=0):
    inp = inputs[output]
    if depth > 1000:
        raise RecursionError

    if type(inp) == bool:
        # print(f"{output} = {inp}")
        return inp
    else:
        opcode, r1, r2 = inp
        # print(f"{output} = {r1} {opcode} {r2}")
        if opcode == AND: 
            ret = resolve(r1, inputs, depth=depth+1) and resolve(r2, inputs, depth=depth+1)
        if opcode == OR: 
            ret = resolve(r1, inputs, depth=depth+1) or resolve(r2, inputs, depth=depth+1)
        if opcode == XOR: 
            ret = resolve(r1, inputs, depth=depth+1) != resolve(r2, inputs, depth=depth+1)

        # print("    ", f"{r1} {opcode} {r2} ", ret)
        # print("    ", f"{resolve(r1, inputs)} {opcode} {resolve(r2, inputs)} ", ret)
        return ret

        print("ASDASDSA")
    exit(1)

def run() -> (int, int):
    p1 = p2 = 0
    init_vals, connections = read_as.groups("input/day24.txt")

    inputs = {}

    # ans = ['z06', 'dhg', 'dpd', 'brk', 'z23', 'bhd', 'z38', 'hvf']
    # print(",".join(sorted(ans)))
    # exit(0)

    zs = []
    xs, ys = [], []

    for line in init_vals:
        reg, vall    = line.split(':')
        val = vall.strip() == "1"
        # print("'" + vall + "'")

        inputs[reg] = val

        if reg.startswith('x'):
            xs.append(reg)

        if reg.startswith('y'):
            ys.append(reg)



    for line in connections:
        # x00 AND y00 -> z00
        left, right = line.split(" -> ")
        r1, op, r2 = left.split(" ")
        match op:
            case 'AND': opcode = AND
            case 'OR': opcode = OR
            case 'XOR': opcode = XOR
            case _: print("AAAA"); exit(0)

        inputs[right] = (opcode, r1, r2)
        # print(f"{right} = {r1}, {opcode}, {r2}")

        if right.startswith('z'):
            zs.append(right)

    xs = sorted(xs,reverse=True)
    ys = sorted(ys,reverse=True)
    zs = sorted(zs,reverse=True)

    p1 = compute(inputs, zs)

    copy = inputs.copy()
    copy["z06"] = inputs["dhg"]
    copy["dhg"] = inputs["z06"]

    copy["brk"] = inputs["dpd"]
    copy["dpd"] = inputs["brk"]

    copy["z23"] = inputs["bhd"]
    copy["bhd"] = inputs["z23"]

    copy["z38"] = inputs["nbf"]
    copy["nbf"] = inputs["z38"]

    # print(",".join(sorted(["dhg","z06","brk","dpd","bhd","z23","nbf","z38"])))

    max_pow = 45
    for i in range(0, max_pow):
        poww = 1 << i
        setup(copy, xs, ys, poww, poww)
        comp_z = compute(copy, zs)
        if comp_z != poww << 1:
            print("BAD ", i)
            print("found:  ", bin(comp_z))
            print("expect: ", bin(poww << 1))
            exit(0)

    res = find_replacements(inputs, xs, ys, zs)
    # print(res)
    return (p1, ",".join(sorted(["dhg","z06","brk","dpd","bhd","z23","nbf","z38"])))