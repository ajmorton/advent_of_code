import read_as

def execute(prog):
    ptr, acc, visited = 0, 0, set()

    while 0 <= ptr < len(prog) and ptr not in visited: 
        cur_instr, val = prog[ptr]
        visited.add(ptr)

        acc, ptr = {
            "nop" : (acc,       ptr + 1),
            "jmp" : (acc,       ptr + val),
            "acc" : (acc + val, ptr + 1)
        }[cur_instr]

    return ptr == len(prog), acc

def run() -> (int, int):

    to_instr = lambda x: (x[0], int(x[1]))
    prog = [to_instr(line.split(' ')) for line in read_as.lines("input/8.txt")]

    _, p1 = execute(prog)

    for i in range(len(prog)):
        new_instr = None
        if prog[i][0] == "jmp":
            new_instr = ("nop", prog[i][1])
        elif prog[i][0] == "nop":
            new_instr = ("jmp", prog[i][1])

        if new_instr:
            new_prog = prog.copy()
            new_prog[i] = new_instr

            success, p2 = execute(new_prog)
            if success == True:
                break

    return(p1, p2)

if __name__ == "__main__":
    print(run())