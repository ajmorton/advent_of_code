import read_as
import re
from copy import deepcopy
from collections import defaultdict

def run() -> (int, int):
    lines = read_as.lines("input/21.txt")

    possible = defaultdict(list)
    all_ingreds = []

    for line in lines:
        ingredients, allergens = line.split("(contains")

        ingredients = ingredients.strip().split(' ')
        allergens = allergens.strip(' )').split(", ")

        all_ingreds.extend(ingredients)

        for allergen in allergens:
            possible[allergen].append(set(ingredients))

    possible = {a: set.intersection(*i) for (a,i) in possible.items()}
    
    known_allergens = {}
    while len(possible) > 0:
        known = [(i, deepcopy(a).pop()) for (i, a) in possible.items() if len(a) == 1]
        for (known_a, known_i) in known:
            known_allergens[known_a] = known_i
            possible = {a: {x for x in i if x != known_i} for (a, i) in possible.items() if a != known_a}

    total_non_allergens = len([i for i in all_ingreds if i not in known_allergens.values()])
    canonical_danger_list = [i for (a, i) in sorted(known_allergens.items(), key=lambda x: x[0])]

    return (total_non_allergens, ",".join(canonical_danger_list))

if __name__ == "__main__":
    print(run())