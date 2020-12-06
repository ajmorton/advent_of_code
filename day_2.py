import re
import read_as

def split(line: str) -> (int, int, str, str):
    (left, right, char, password) = re.search(r"(\d+)-(\d+) ([a-z]): ([a-z]+)", line).groups()
    return (int(left), int(right), char, password)

def freq_policy(line: str) -> bool:
    (min_freq, max_freq, char, password) = split(line)
    return min_freq <= password.count(char) <= max_freq

def xor_policy(line: str) -> bool:
    (pos_a, pos_b, char, password) = split(line)
    return (password[pos_a - 1] == char) ^ (password[pos_b - 1] == char)

def run() -> (int, int):
    lines = read_as.lines("input/2.txt")
    num_freq = len([password for password in lines if freq_policy(password)])
    num_xor = len([password for password in lines if xor_policy(password)])
    return num_freq, num_xor

if __name__ == "__main__":
    print(run())