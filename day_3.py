from math import prod

def run(file) -> (int, int):

    right = [1, 3, 5, 7, 1]
    down  = [1, 1, 1, 1, 2]
    trees = [0, 0, 0, 0, 0]

    r = 0
    for row in file:
        row = row.strip()
        for i in range(0, len(trees)):
            if r % down[i] == 0:
                trees[i] += row[(r * right[i] // down[i]) % len(row)] == "#"
        r += 1
    return (trees[1], prod(trees))

