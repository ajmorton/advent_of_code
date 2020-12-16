import read_as
import re

def run() -> (int, int):
    groups = read_as.groups("input/16.txt")
    rules, my_ticket, other_tickets = groups

    ruleset = {}

    for rule in rules:
        rule_name = rule.split(":")[0]
        ranges = re.findall(r"[0-9]+", rule)
        min_1, max_1, min_2, max_2 = int(ranges[0]), int(ranges[1]), int(ranges[2]), int(ranges[3])

        ruleset[rule_name] = (min_1, max_1, min_2, max_2)

    scanning_rate = 0
    valid_other_tickets = []
    for other_ticket in other_tickets[1:]:
        all_valid = True
        for value in other_ticket.split(","):
            val = int(value)
            is_valid = False
            for rule in ruleset:
                (min_1, max_1, min_2, max_2) = ruleset[rule]
                if min_1 <= val <= max_1 or min_2 <= val <= max_2:
                    is_valid = True
                    break
            if not is_valid:
                scanning_rate += val
                all_valid = False

        if all_valid:
            valid_other_tickets.append(other_ticket)

    
    # P2
    rule_indices = {}
    for rule in ruleset:
        rule_indices[rule] = set(i for i in range(len(rules)))

    for valid_ticket in valid_other_tickets:
        for (index, field) in enumerate(valid_ticket.split(",")):
            field = int(field)

            for rule in ruleset:
                (min_1, max_1, min_2, max_2) = ruleset[rule]
                if not (min_1 <= field <= max_1 or min_2 <= field <= max_2):
                    rule_indices[rule].remove(index)

    ordered_indices = {}
    while len(rule_indices) > 0:
        next_rule = None
        correct_index = -1
        for (rule, indices) in rule_indices.items():
            if len(indices) == 1:
                correct_index = list(indices)[0]
                ordered_indices[rule] = correct_index
                break
        
        rule_indices.pop(rule)
        for rule in rule_indices:
            try:
                rule_indices[rule].remove(correct_index)
            except:
                pass


    prod_of_fields = 1
    my_fields = [int(field) for field in my_ticket[1].split(",")]
    for (rule, index) in ordered_indices.items():
        if rule.startswith("departure"):
            prod_of_fields *= my_fields[index]


    return (scanning_rate, prod_of_fields)

if __name__ == "__main__":
    print(run())