from functools import reduce

def run() -> (int, int):

    with open("input/6.txt") as file:
        groups = [line.rstrip('\n').split('\n') for line in file.read().split("\n\n")]
        answer_sets = [list(map(set, group)) for group in groups]

        sum_any, sum_all = 0, 0
        for answer_set in answer_sets:
            sum_any += len(reduce(set.union, answer_set))
            sum_all += len(reduce(set.intersection, answer_set))

        return(sum_any, sum_all)

if __name__ == "__main__":
    print(run())