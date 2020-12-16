import read_as
import re
from math import inf

def run() -> (int, int):
    rules, my_ticket, other_tickets = read_as.groups("input/16.txt")

    ruleset = {}
    for rule in rules:
        name, a, b, c, d = re.search(r"([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)", rule).groups()
        ruleset[name] = (int(a), int(b), int(c), int(d))

    field_val = lambda field: any(a <= int(field) <= b or c <= int(field) <= d for (a,b,c,d) in ruleset.values())
    ticket_val = lambda ticket: all(field_val(field) for field in ticket.split(","))

    scanning_rate = sum(int(field) for ticket in other_tickets[1:] for field in ticket.split(",") if not field_val(field))
    valid_other_tickets = [ticket for ticket in other_tickets[1:] if ticket_val(ticket)]
    
    # P2
    rule_indices = {rule: set(i for i in range(len(ruleset))) for rule in ruleset}

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