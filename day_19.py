import read_as
import re
from copy import deepcopy

def run() -> (int, int):
    groups = read_as.groups("input/19.txt")
    rules = {}
    for line in groups[0]:
        rule_id, rule_contents = line.split(':')

        base_rule = re.search(r"\"(.*)\"", rule_contents)
        if base_rule:
            letter = base_rule.groups()[0]
            rules[rule_id] = letter
        else:
            rules[rule_id] = "( " + rule_contents.strip() + " )"

    rules_p2 = deepcopy(rules)        

    no_nums = False
    while no_nums == False:
        no_nums = True
        for (rule_id, rule_contents) in rules.items():
            if re.search(r"[0-9]+", rule_contents):
                no_nums = False
            else:
                for other_rule in rules:
                    rules[other_rule] = re.sub(" " + rule_id + " ", " " + rule_contents + " ", rules[other_rule])


    rules_p2["8"] = "( 42 | ( 42 )+ )"
    # dirty hack
    rules_p2["11"] = "( 42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31 | 42 42 42 42 42 31 31 31 31 31 | 42 42 42 42 42 42 31 31 31 31 31 31 | 42 42 42 42 42 42 42 31 31 31 31 31 31 31 | 42 42 42 42 42 42 42 42 31 31 31 31 31 31 31 31 | 42 42 42 42 42 42 42 42 42 31 31 31 31 31 31 31 31 31 | 42 42 42 42 42 42 42 42 42 42 31 31 31 31 31 31 31 31 31 31 )"

    no_nums = False
    while no_nums == False:
        no_nums = True
        for (rule_id, rule_contents) in rules_p2.items():
            if re.search(r"[0-9]+", rule_contents):
                no_nums = False
            else:
                for other_rule in rules_p2:
                    rules_p2[other_rule] = re.sub(" " + rule_id + " ", " " + rule_contents + " ", rules_p2[other_rule])



    p1 = sum([re.fullmatch(rules["0"].replace(" ", ''), message) is not None for message in groups[1]])
    p2 = sum([re.fullmatch(rules_p2["0"].replace(" ", ''), message) is not None for message in groups[1]])

    return (p1, p2)

if __name__ == "__main__":
    print(run())