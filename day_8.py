import read_as

def execute(prog):
    ptr, acc = 0, 0
    visited = set()

    while True:
        if ptr == len(prog):
            return True, acc
        elif ptr < 0 or ptr > len(prog) or ptr in visited:
            return False, acc
        else:
            cur_instr, val = prog[ptr]
            visited.add(ptr)
            if cur_instr == "nop":
                ptr += 1
            elif cur_instr == "jmp":
                ptr += val
            elif cur_instr == "acc":
                acc += val
                ptr += 1
            else:
                print("ERROR")


def run() -> (int, int):

    to_instr = lambda x: (x[0], int(x[1]))
    prog = [to_instr(line.split(' ')) for line in read_as.lines("input/8.txt")]

    _, p1 = execute(prog)

    for i in range(0, len(prog)):
        new_instr = None
        if prog[i][0] == "jmp":
            new_instr = ("nop", prog[i][1])
        elif prog[i][0] == "nop":
            new_instr = ("jmp", prog[i][1])

        if new_instr:
            new_prog = prog.copy()
            new_prog[i] = new_instr

            result = execute(new_prog)
            if result[0] == True:
                p2 = result[1]
                break

    return(p1, p2)

if __name__ == "__main__":
    print(run())