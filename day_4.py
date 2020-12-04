import re

def has_valid_fields(p: dict) -> bool:
    try:
        val_byr = len(p["byr"]) == 4 and 1920 <= int(p["byr"]) <= 2002
        val_iyr = len(p["iyr"]) == 4 and 2010 <= int(p["iyr"]) <= 2020
        val_eyr = len(p["eyr"]) == 4 and 2020 <= int(p["eyr"]) <= 2030
        val_hgt = (p["hgt"].endswith("in") and  59 <= int(p['hgt'][:-2]) <=  76) or \
                  (p["hgt"].endswith("cm") and 150 <= int(p['hgt'][:-2]) <= 193)
        val_hcl = re.fullmatch(r"#[0-9a-f]{6}", p["hcl"])
        val_ecl = p["ecl"] in ["amb", "blu", "brn", "gry" ,"grn", "hzl", "oth"]
        val_pid = re.fullmatch(r"[0-9]{9}", p["pid"])

        return all([val_byr, val_iyr, val_eyr, val_hgt, val_hcl, val_ecl, val_pid])
    except:
        return False

def has_fields(passport: dict) -> bool:
    sym_diff = set(passport.keys()).symmetric_difference({"byr", "iyr", "eyr", "hgt", 'hcl', "ecl", "pid", "cid"})
    return sym_diff <= {"cid"}

def run() -> (int, int):

    with open("input/4.txt") as file:
        lines = [line.replace('\n', ' ') for line in file.read().split("\n\n")]
        passports = [ dict(val.split(":") for val in line.split()) 
                     for line in lines ]
        all_fields = [p for p in passports if has_fields(p)]
        valid_fields = [p for p in passports if has_valid_fields(p)] 

        return len(all_fields), len(valid_fields)

if __name__ == "__main__":
    print(run())