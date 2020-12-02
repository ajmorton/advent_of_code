import re

def split(line: str) -> (int, int, str, str):
    (left, right, char, password) = re.search(r"(\d+)-(\d+) ([a-z]): ([a-z]+)", line).groups()
    return (int(left), int(right), char, password)

def freq_policy(line: str) -> bool:
    (min_freq, max_freq, char, password) = split(line)
    return min_freq <= password.count(char) <= max_freq

def xor_policy(line: str) -> bool:
    (pos_a, pos_b, char, password) = split(line)
    return (password[pos_a - 1] == char) ^ (password[pos_b - 1] == char)

def run(file, part_2: bool = False) -> int:
    if part_2:
        return len([line for line in file if xor_policy(line)])
    else:
        return len([line for line in file if freq_policy(line)])
