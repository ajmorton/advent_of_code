import read_as

def contains_shiny_gold(bag: str, bag_map: dict, memo: dict) -> int:

    result = False

    if bag[1] in memo:
        return memo[bag[1]]
    elif bag == "shiny gold":
        result = True
    else:
        result = any([contains_shiny_gold(sub_bag[1], bag_map, memo) for sub_bag in bag_map[bag]])

    memo[bag] = result
    return result

def contains(bag: str, bag_map: dict) -> int:
    return 1 + sum([num * contains(bag, bag_map) for (num, bag) in bag_map[bag]])

    
def run() -> (int, int):
    lines = read_as.lines("input/7.txt")
    bag_map = {}
    for line in lines:
        (container, contents) = line.split(" bags contain ")

        if contents == "no other bags.":
            bag_map[container] = []
        else:
            # "fuschia bags".rstrip(" bags") == "fuschi", not "fuschia" !!!
            contents = [bag.strip().rstrip("bags").rstrip() for bag in contents.rstrip('.').split(',')]
            for bag in contents:
                (num, bag) = bag.split(' ', 1)
                num = int(num)
                if container in bag_map:
                    bag_map[container].append((num, bag))
                else:
                    bag_map[container] = [(num, bag)]

    memo = {}
    bags_containing = [bag for bag in bag_map if bag != "shiny gold" and contains_shiny_gold(bag, bag_map, {})]

    return(len(bags_containing), contains("shiny gold", bag_map) - 1)

if __name__ == "__main__":
    print(run())