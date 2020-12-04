import re

def valid(fields):
    to_find = ["byr", "iyr", "eyr", "hgt", 'hcl', "ecl", "pid", "cid"]
    for key in fields.keys():
        to_find.remove(key)

    return len(to_find) == 0 or (len(to_find) == 1 and to_find[0] == "cid")

def valid_and_fields(fields):
    to_find = ["byr", "iyr", "eyr", "hgt", 'hcl', "ecl", "pid", "cid"]
    for key in fields.keys():
        to_find.remove(key)

    if len(to_find) == 0 or (len(to_find) == 1 and to_find[0] == "cid"):
        for key in fields:
            val = fields[key]
            if key == "byr" and not ((len(val) == 4) and (1920 <= int(val) <= 2002)):
                return False
            if key == "iyr" and not ((len(val) == 4) and (2010 <= int(val) <= 2020)):
                return False
            if key == "eyr" and not ((len(val) == 4) and (2020 <= int(val) <= 2030)):
                return False
            if key == "hgt":
                if val[-2:] == "in" and (59 <= int(val[:-2]) <= 76):
                    pass
                elif val[-2:] == "cm" and (150 <= int(val[:-2]) <= 193):
                    pass
                else:
                    return False
            if key == "hcl" and not re.fullmatch(r"#[0-9a-f]{6}", val):
                return False
            if key == "ecl" and val not in ["amb", "blu", "brn", "gry" ,"grn", "hzl", "oth"]:
                return False
            if key == "pid" and not re.fullmatch(r"[0-9]{9}", val):
                return False

        return True
    else:
        return False        
                


def run() -> (int, int):
    with open("input/4.txt") as file:
        lines = [line.strip() for line in file]

        fields = {}
        count_p1 = 0
        count_p2 = 0

        for line in lines:
            # print(line)
            if len(line) == 0:
                
                # print(fields)
                to_find = ["byr", "iyr", "eyr", "hgt", 'hcl', "ecl", "pid", "cid"]
                for key in fields.keys():
                    to_find.remove(key)

                count_p1 += valid(fields)
                count_p2 += valid_and_fields(fields)
                fields = {}
            else:
                entries = line.split(' ')
                for entry in entries:
                    # print(f"\t{entry}")
                    [key, val] = entry.split(':')
                    fields[key] = val

        to_find = ["byr", "iyr", "eyr", "hgt", 'hcl', "ecl", "pid", "cid"]
        for key in fields.keys():
            to_find.remove(key)

        count_p1 += valid(fields)
        count_p2 += valid_and_fields(fields)

        return (count_p1, count_p2)

if __name__ == "__main__":
    print(run())