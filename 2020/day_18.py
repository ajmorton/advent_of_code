import read_as

def to_int(equation: str, part_2: bool) -> str:
    elems = equation.split(" ")
    while len(elems) > 1:
        
        if part_2 and len(elems) >= 5 and elems[3] == "+":
            _, _, val_2, oper_2, val_3 = elems[:5]
            if oper_2 == "+":
                elems = elems[:2] + [str(int(val_2) + int(val_3))] + elems[5:] 
        else:
            val, oper, val_2 = elems[:3]
            if oper == "*":
                elems = [str(int(val) * int(val_2))] + elems[3:]
            elif oper == "+":
                elems = [str(int(val) + int(val_2))] + elems[3:]

    return elems[0]

def compute(equation: str, part_2: bool) -> str:
    while '(' in equation:
        last_open = equation.rfind("(")
        next_close = equation[last_open:].find(")") + last_open
        equation = equation[:last_open] + compute(equation[last_open+1:next_close], part_2) + equation[next_close+1:]

    return to_int(equation, part_2)

def run() -> (int, int):
    lines = read_as.lines("input/18.txt")
    total_p1 = sum(int(compute(line, False)) for line in lines)
    total_p2 = sum(int(compute(line, True)) for line in lines)
    return (total_p1, total_p2)

if __name__ == "__main__":
    print(run())