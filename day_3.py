from math import prod

def run(file) -> (int, int):

    right = [1, 3, 5, 7, 1]
    down  = [1, 1, 1, 1, 2]
    positions = [0, 0, 0, 0, 0]
    r = 0
    trees = [0, 0, 0, 0, 0]
    for row in file:
        if len(row) != 0:
            for i in range(0, len(positions)):
                if (r % down[i] ) == 0:
                    if row[positions[i]] == "#":
                        trees[i] += 1
                    positions[i] = (positions[i] + right[i]) % (len(row) - 1)

            r += 1

    print(trees)

    return (trees[1], prod(trees))

