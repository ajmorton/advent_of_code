def groups(filepath: str) -> [str]:
    with open(filepath) as f:
        file_str = f.read().rstrip('\n')
        return [line.split('\n') for line in file_str.split("\n\n")]

def lines(filepath: str) -> [str]:
    with open(filepath) as f:
        return [line.rstrip('\n') for line in f]
