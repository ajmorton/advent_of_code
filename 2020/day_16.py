import read_as
import re
from math import inf, prod

def run() -> (int, int):
    rules, my_ticket, other_tickets = read_as.groups("input/16.txt")

    ruleset = {}
    for rule in rules:
        name, a, b, c, d = re.search(r"([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)", rule).groups()
        ruleset[name] = [ range(int(a), int(b) + 1), range(int(c), int(d) + 1)]

    matches_rule = lambda field, ranges: int(field) in ranges[0] or int(field) in ranges[1]
    field_valid = lambda field: any(matches_rule(field, ranges) for ranges in ruleset.values())
    ticket_valid = lambda ticket: all(field_valid(field) for field in ticket.split(","))

    scanning_rate = sum(int(field) for ticket in other_tickets[1:] for field in ticket.split(",") if not field_valid(field))
    
    # P2
    valid_other_tickets = [ticket for ticket in other_tickets[1:] if ticket_valid(ticket)]

    rule_indices = {rule: set(i for i in range(len(ruleset))) for rule in ruleset}
    for valid_ticket in valid_other_tickets:
        for (index, field) in enumerate(valid_ticket.split(",")):
            for rule in ruleset:
                if not ( matches_rule(field, ruleset[rule]) ):
                    rule_indices[rule].remove(index)

    known_indices = {}
    for r, v in sorted(rule_indices.items(), key=lambda x: len(x[1])):
        known_indices[r] = {x for x in v if x not in known_indices.values()}.pop()

    my_fields = [int(field) for field in my_ticket[1].split(",")]
    prod_of_fields = prod([my_fields[index] for rule, index in known_indices.items() if rule.startswith("departure")])

    return (scanning_rate, prod_of_fields)

if __name__ == "__main__":
    print(run())