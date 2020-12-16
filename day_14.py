import read_as
import re

def all_perms(ls):
    if len(ls) == 0:
        return [[]]
    elif ls[0] in {'0', '1'}:
        return [[ls[0]] + sub for sub in all_perms(ls[1:])]
    else:
        return [['0'] + sub for sub in all_perms(ls[1:])] + [['1'] + sub for sub in all_perms(ls[1:])]
        
def run() -> (int, int):
    lines = read_as.lines("input/14.txt")

    results_p1, results_p2 = {}, {}
    mask_bits_p1, mask_bits_p2 = [], []

    for line in lines:
        op, arg = line.split(" = ")
        if op == "mask":
            mask_bits_p1 = [(i, char) for (i, char) in enumerate(arg) if char != "X"]
            mask_bits_p2 = [(i, char) for (i, char) in enumerate(arg) if char != "0"]

        else:
            index = int(op[4:-1])

            # P1
            bitstring = list("{0:036b}".format(int(arg)))
            for (i, m) in mask_bits_p1:
                bitstring[i] = m
            results_p1[index] = int("".join(bitstring), 2)

            # P2
            indexstring = list("{0:036b}".format(index))
            for (i, m) in mask_bits_p2:
                indexstring[i] = m

            for addr in all_perms(indexstring):
                results_p2[int("".join(addr), 2)] = int(arg)

    return (sum(results_p1.values()), sum(results_p2.values()))

if __name__ == "__main__":
    print(run())
