import read_as
import re
from collections import defaultdict

def contains_shiny_gold(bag: str, bag_map: dict) -> int:
    # faster without memo ¯\_(ツ)_/¯
    return bag == "shiny gold" or any([contains_shiny_gold(sub_bag[1], bag_map) for sub_bag in bag_map[bag]])
    
def contains(bag: str, bag_map: dict) -> int:
    return 1 + sum([int(num) * contains(bag, bag_map) for (num, bag) in bag_map[bag]])

def run() -> (int, int):
    bag_map = defaultdict(list)
    for line in read_as.lines("input/7.txt"):
        (container, contents) = line.split(" bags contain ")
        contents = re.findall(r"([0-9]+) ([a-z ]+) bags?[,.]", contents)
        bag_map[container].extend(contents)

    bags_containing = [bag for bag in bag_map if bag != "shiny gold" and contains_shiny_gold(bag, bag_map)]
    return(len(bags_containing), contains("shiny gold", bag_map) - 1)

if __name__ == "__main__":
    print(run())