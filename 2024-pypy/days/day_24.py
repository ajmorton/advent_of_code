#! /usr/bin/env pypy3
from . import read_as

def compute(circuits, largest_z):
    p1 = 0
    for bit in reversed(range(0, largest_z + 1)):
        p1 *= 2
        p1 += resolve(f"z{bit:02}", circuits)
    return p1

def resolve(output, circuits):
    match circuits[output]:
        case 1, r1, r2: return resolve(r1, circuits) & resolve(r2, circuits)
        case 2, r1, r2: return resolve(r1, circuits) | resolve(r2, circuits)
        case 3, r1, r2: return resolve(r1, circuits) ^ resolve(r2, circuits)
        case 4, r1, r2: return r1

def find_bad_circuits(circuits, largest_z):
    bad_circuits = []
    for out in circuits:
        # z(N) outputs must be a xor of (x(N) xor y(N)) XOR (X(N-1) AND (y(N-1))).
        # Exceptions are 
        # - z00 (just x00 xor y00), and
        # - z(max) as there's not x(max) or y(max) bits to take
        if out[0] == 'z' and out != f"z{largest_z:02}" and out != "z00":
            opcode, r1, r2 = circuits[out]
            if opcode != 3:
                bad_circuits.append(out)
                continue

        # Ignore circuits and outputs (Z = A xor B, X = 1)
        if out[0] not in "xyz":
            opcode, r1, r2 = circuits[out]

            # XORs only happen in exterior circuits: "z(N) = A XOR B' or "Z = x(N) XOR y(N)"
            if opcode == 3 and r1[0] not in "xy" and r2[0] not in "xy":
                bad_circuits.append(out)
                continue

            # Depth 2 circuits
            if r1[0] not in "xy" and r2[0] not in "xy":
                subopcode_1, r1_1, r1_2 = circuits[r1]
                subopcode_2, r2_1, r2_2 = circuits[r2]

                # Inspection. AND circuits are always comprised of XOR or OR circuits
                if opcode == 1:
                    if subopcode_1 == 1 and r1_1 not in ("x00", "y00"):
                        bad_circuits.append(r1)
                    if subopcode_2 == 1 and r2_1 not in ("x00", "y00"):
                        bad_circuits.append(r2)

                # Inspection. OR circuits never have ANDs
                if opcode == 2:
                    if subopcode_1 != 1:
                        bad_circuits.append(r1)
                    if subopcode_2 != 1:
                        bad_circuits.append(r2)

    return ",".join(sorted(set(bad_circuits)))

def run() -> (int, int):
    p1 = p2 = 0
    init_vals, connections = read_as.groups("input/day24.txt")

    circuits = {}
    largest_z = 0

    for line in init_vals:
        reg, val = line.split(':')
        circuits[reg] = (4, val.strip() == "1", None)

    for line in connections:
        r1, op, r2, _, output = line.split(" ")
        match op:
            case 'AND': opcode = 1
            case 'OR': opcode = 2
            case 'XOR': opcode = 3
            case _: print("AAAA"); exit(0)

        circuits[output] = (opcode, r1, r2)

        if output.startswith('z'):
            largest_z = max(largest_z, int(reg[1:]))

    largest_z += 1
    return compute(circuits, largest_z), find_bad_circuits(circuits, largest_z)