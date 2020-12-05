import re

def seat_to_index(seat: str) -> int:
    binary_str = re.sub(r"[FL]", "0", re.sub(r"[BR]", "1", seat))
    return int(binary_str,2)

def run() -> (int, int):

    with open("input/5.txt") as file:
        # CLEAN THE INPUT!!!
        seats = [line.strip() for line in file]
        seat_indices = [seat_to_index(seat) for seat in seats]

        max_seat = max(seat_indices)
        min_seat = min(seat_indices)
        seat_sum = sum(seat_indices)
        missing_seat = sum(range(min_seat, max_seat+1)) - seat_sum

        return(max_seat, missing_seat)

if __name__ == "__main__":
    print(run())