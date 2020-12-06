def run() -> (int, int):

    with open("input/6.txt") as file:
        groups = [line.split('\n') for line in file.read().rstrip('\n').split("\n\n")]

        sum_any = 0
        sum_all = 0
        for group in groups:
            answer_set = [set(answer) for answer in group]

            any_answers = answer_set[0]
            common_answers = answer_set[0]
            for i in range(1, len(answer_set)):
                any_answers = any_answers.union(answer_set[i])
                common_answers = common_answers.intersection(answer_set[i])

            sum_any += len(any_answers)
            sum_all += len(common_answers)


        return(sum_any, sum_all)

if __name__ == "__main__":
    print(run())