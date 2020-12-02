
def freq_policy(min_freq: int, max_freq: int, char: str, password: str) -> bool:
    num_occurences = len([c for c in password if c == char])
    return num_occurences >= int(min_freq) and num_occurences <= int(max_freq)

def xor_policy(pos_a: int, pos_b: int, char: str, password: str) -> bool:
    return (password[int(pos_a) - 1] == char) != (password[int(pos_b) - 1] == char)

def check_pass(entries: [str], use_xor_policy: bool) -> int:
    num_valid = 0
    for entry in entries:
        (policy, password) = entry.split(':')
        password = password.strip()

        (ranges, char) = policy.split(' ')
        (left, right) = ranges.split('-')

        if use_xor_policy:
            if xor_policy(left, right, char, password):
                num_valid += 1
        else:
            if freq_policy(left, right, char, password):
                num_valid += 1

    return num_valid

def run(file, part_2: bool = False) -> int:
    entries = [entry for entry in file]
    return check_pass(entries, part_2)