import read_as

def run() -> (int, int):
    answer_sets = [list(map(set, group)) for group in read_as.groups("input/6.txt")]

    sum_any, sum_all = 0, 0
    for answer_set in answer_sets:
        sum_any += len(set.union(*answer_set))
        sum_all += len(set.intersection(*answer_set))

    return(sum_any, sum_all)

if __name__ == "__main__":
    print(run())