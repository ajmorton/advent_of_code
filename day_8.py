import read_as

def execute(cur_instr, ptr, instrs, acc, visited) -> (True, int):
    command, val = cur_instr
    
    try:
        if ptr > len(instrs):
            return True, acc
        if visited[ptr] == True:
            return False, acc
        else:
            visited[ptr] = True
            if command == "nop":
                if ptr == len(instrs) - 1:
                    return True, acc
                return execute(instrs[ptr + 1], ptr + 1, instrs, acc, visited)
            elif command == "acc":
                if ptr == len(instrs) - 1:
                    return True, acc + val
                return execute(instrs[ptr + 1], ptr + 1, instrs, acc + val, visited)
            elif command == "jmp":
                if ptr + val < 0 or ptr + val >= len(instrs):
                    return False, acc
                return execute(instrs[ptr + val], ptr + val, instrs, acc, visited)
    except:
        return False, 0


def run_to_end(instrs):
    ptr = 0
    acc = 0
    visited = [False] * len(instrs)

    instr_count = 0

    while instr_count < 100000:
        instr_count += 1
        if ptr < 0 or ptr > len(instrs):
            return False, -1
        elif ptr == len(instrs):
            return True, acc
        else:
            cur_instr, val = instrs[ptr]
            if cur_instr == "nop":
                ptr += 1
            elif cur_instr == "jmp":
                ptr += val
            elif cur_instr == "acc":
                acc +=  val
                ptr += 1
            else:
                print("ERROR")

    return False, "-2"




def run() -> (int, int):
    lines = read_as.lines("input/8.txt")

    instrs = []
    for line in lines:
        instr, val = line.split(' ')
        val = int(val)
        instrs.append((instr, val))


    acc = 0
    ptr = 0

    visited = [False] * len(instrs)

    p1 = execute(instrs[0], ptr, instrs, acc, visited)[1]

    for i in range(0, len(instrs)):
        if instrs[i][0] == "jmp":
            new_instrs = instrs.copy()
            new_instrs[i] = ("nop", instrs[i][1])
            result = run_to_end(new_instrs)
            if result[0] == True:
                p2 = result[1]
                break

        elif instrs[i][0] == "nop":
            new_instrs = instrs.copy()
            new_instrs[i] = ("jmp", instrs[i][1])
            result = run_to_end(new_instrs)
            if result[0] == True:
                p2 = result[1]
                break


    return(p1, p2)

if __name__ == "__main__":
    print(run())