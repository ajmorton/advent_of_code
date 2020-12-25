import read_as

def run() -> (int, int):
    pub_1, pub_2 = [int(line) for line in read_as.lines("input/25.txt")]
    m = 20201227

    loop, n = 1, 1
    while (n := (n*7) % m) not in {pub_1, pub_2}:
        loop += 1

    pub = pub_1 if n != pub_1 else pub_2
    return ( pow(pub, loop, mod=m), False)

if __name__ == "__main__":
    print(run())