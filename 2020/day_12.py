import read_as

class Ship():
    def __init__(self, ref_pt, use_wp):
        self.pos = 0 + 0j
        self.reference = ref_pt
        self.use_wp = use_wp

    def move(self, command, val):
        if command in "NSEW":
            if self.use_wp:
                self.reference += {"N": 1j, "S": -1j, "E": 1, "W": -1}[command] * val
            else:
                self.pos += {"N": 1j, "S": -1j, "E": 1, "W": -1}[command] * val
        elif command in "LR":
            self.reference *= {"L": 1j, "R": -1j}[command] ** (val // 90)
        elif command == "F":
            self.pos += self.reference * val

    def manhattan(self):
        return int(abs(self.pos.real) + abs(self.pos.imag))

def run() -> (int, int):
    ship = Ship(1 + 0j, False)
    ship_wp = Ship(10 + 1j, True)
    for instr in read_as.lines("input/12.txt"):
        command, val = instr[0], int(instr[1:])
        ship.move(command, val) 
        ship_wp.move(command, val)
    return (ship.manhattan(), ship_wp.manhattan())

if __name__ == "__main__":
    print(run())