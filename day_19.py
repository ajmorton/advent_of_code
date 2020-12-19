import read_as
import re
from copy import deepcopy

def rules_to_regex(rules: dict) -> dict:
    no_nums = False
    while no_nums == False:
        no_nums = True
        for (rule_id, rule_contents) in rules.items():
            if re.search(r"[0-9]+", rule_contents):
                no_nums = False
            else:
                for other_rule in rules:
                    rules[other_rule] = re.sub(" " + rule_id + " ", " " + rule_contents + " ", rules[other_rule])
    return rules

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


    rules_p1 = rules_to_regex(deepcopy(rules))

    rules_p2 = deepcopy(rules)        
    rules_p2["8"] = "( 42 )+"
    # dirty hack
    rules_p2["11"] = "( 42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31 | 42 42 42 42 42 31 31 31 31 31 | 42 42 42 42 42 42 31 31 31 31 31 31 | 42 42 42 42 42 42 42 31 31 31 31 31 31 31 | 42 42 42 42 42 42 42 42 31 31 31 31 31 31 31 31 | 42 42 42 42 42 42 42 42 42 31 31 31 31 31 31 31 31 31 | 42 42 42 42 42 42 42 42 42 42 31 31 31 31 31 31 31 31 31 31 )"
    rules_p2 = rules_to_regex(rules_p2)

    p1 = sum([re.fullmatch(rules_p1["0"].replace(" ", ''), message) is not None for message in groups[1]])
    p2 = sum([re.fullmatch(rules_p2["0"].replace(" ", ''), message) is not None for message in groups[1]])

    return (p1, p2)

if __name__ == "__main__":
    print(run())