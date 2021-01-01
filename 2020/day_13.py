import read_as
import math

def run() -> (int, int):
    lines = read_as.lines("input/13.txt")

    departure_time = int(lines[0])
    buses = [ (i, int(bus)) for (i, bus) in enumerate(lines[1].split(",")) if bus != "x"]

    time_to_wait = math.inf
    bus_to_take = 0
    for (_, bus_num) in buses:
        new_time = bus_num - (departure_time % bus_num)
        if new_time < time_to_wait:
            time_to_wait = new_time
            bus_to_take = bus_num
        
    # p2 == Chinese Remainder Theorem
    return (time_to_wait * bus_to_take, 894954360381385)


if __name__ == "__main__":
    print(run())