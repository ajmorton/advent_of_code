import read_as
import re
from collections import Counter

def run() -> (int, int):
    lines = read_as.lines("input/25.txt")
    pub_1 = int(lines[0])
    pub_2 = int(lines[1])

    base = 7
    
    i = 1
    val = 1
    found = 0
    encr_1 , encr_2 = 0, 0
    while found < 2:
        val *= 7
        val %= 20201227

        if val == pub_1:
            encr_1 = i
            found += 1
        elif val == pub_2:
            encr_2 = i
            found += 1

        i+=1

    val_2 = 1
    for i in range(encr_2):
        val_2 *= pub_1
        val_2 %= 20201227

    return (val_2, False)


if __name__ == "__main__":
    print(run())