def groups(filepath: str) -> [str]:
    with open(filepath) as f:
        file_str = f.read().rstrip('\n')
        return [line.split('\n') for line in file_str.split("\n\n")]

def flat_groups(filepath: str) -> [str]:
    with open(filepath) as f:
        file_str = f.read().rstrip('\n')
        return file_str.split("\n\n")

def lines(filepath: str) -> [str]:
    with open(filepath) as f:
        return [line.rstrip('\n') for line in f]

def grid(filepath: str) -> [[str]]:
    with open(filepath) as f:
        return [[x for x in line.rstrip('\n')] for line in f]

def one_line(filepath: str) -> str:
    return "".join(lines(filepath))