from math import prod
import read_as

def run() -> (int, int):
    right = [1, 3, 5, 7, 1]
    down  = [1, 1, 1, 1, 2]
    trees = [0, 0, 0, 0, 0]

    r = 0
    for row in read_as.lines("input/3.txt"):
        for i in range(0, len(trees)):
            if r % down[i] == 0:
                trees[i] += row[(r * right[i] // down[i]) % len(row)] == "#"
        r += 1
    return (trees[1], prod(trees))


if __name__ == "__main__":
    print(run())
