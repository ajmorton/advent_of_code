from functools import reduce

def run() -> (int, int):

    with open("input/6.txt") as file:
        groups = [line.split('\n') for line in file.read().rstrip('\n').split("\n\n")]
        answer_sets = [[set(answer) for answer in group] for group in groups]

        sum_any = sum([len(reduce(lambda x, y: x.union(y), answer_set)) for answer_set in answer_sets])
        sum_all = sum([len(reduce(lambda x, y: x.intersection(y), answer_set)) for answer_set in answer_sets])
        return(sum_any, sum_all)

if __name__ == "__main__":
    print(run())