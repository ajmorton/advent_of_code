import read_as
import re
from copy import deepcopy
from collections import defaultdict

def run() -> (int, int):
    lines = read_as.lines("input/21.txt")

    possible = defaultdict(list)

    all_ingreds = []

    for line in lines:
        ingredients = None
        allergens = None
        if "(" in line:
            ingredients, allergens = line.split("(contains")
            ingredients = ingredients.strip().split(' ')
            if allergens:
                allergens = allergens.strip(' )').split(", ")
        else:
            ingredients = line.strip().split(' ')            

        all_ingreds.extend(ingredients)

        ingredients = set(ingredients)
        allergens = set(allergens)

        for allergen in allergens:
            possible[allergen].append(ingredients)


    reduced = {}
    for p in possible:
        can_be = set.intersection(*possible[p])
        reduced[p] = can_be

    answers = {}
    while len(reduced) > 0:
        choice, aller_choice = None, None
        for (ingred, aller) in reduced.items():
            if len(aller) == 1:
                choice, aller_choice = ingred, aller
                break
        
        if choice is not None:
            answers[choice] = aller_choice
            for r, r_aller in reduced.items():
                reduced[r] = {a for a in r_aller if a not in aller_choice}
            reduced.pop(choice)
        else:
            print("F")

    ingreds = set.union(*answers.values())

    total_non_allergens = len([i for i in all_ingreds if i not in ingreds])

    answers = {a: i.pop() for (a,i) in answers.items()}
    canonical_danger_list = [a for (i, a) in sorted(answers.items(), key=lambda x: x[0])]
    print(canonical_danger_list)

    return (total_non_allergens, ",".join(canonical_danger_list))

if __name__ == "__main__":
    print(run())