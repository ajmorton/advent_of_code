import re
import read_as

def seat_to_index(seat: str) -> int:
    binary_str = re.sub(r"[FL]", "0", re.sub(r"[BR]", "1", seat))
    return int(binary_str,2)

def run() -> (int, int):

    seat_indices = [seat_to_index(seat) for seat in read_as.lines("input/5.txt")]

    max_seat = max(seat_indices)
    min_seat = min(seat_indices)
    seat_sum = sum(seat_indices)
    missing_seat = sum(range(min_seat, max_seat+1)) - seat_sum

    return(max_seat, missing_seat)

if __name__ == "__main__":
    print(run())