import read_as
import re

def contains_shiny_gold(colour: str, bags: dict) -> int:
    return colour == "shiny gold" or any(contains_shiny_gold(colour, bags) for _, colour in bags[colour])
    
def num_contents(colour: str, bags: dict) -> int:
    return 1 + sum([int(num) * num_contents(colour, bags) for (num, colour) in bags[colour]])

def run() -> (int, int):
    bags = {}
    for line in read_as.lines("input/7.txt"):
        (colour, contents) = line.split(" bags contain ")
        bags[colour] = re.findall(r"([0-9]+) ([a-z ]+) bags?[,.]", contents)

    bags_containing = sum([contains_shiny_gold(colour, bags) for colour in bags if colour != "shiny gold"])
    return(bags_containing, num_contents("shiny gold", bags) - 1)

if __name__ == "__main__":
    print(run())