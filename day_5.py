import math

def run() -> (int, int):

    with open("input/5.txt") as file:
        # CLEAN THE INPUT!!!
        seats = [line.strip() for line in file]

        max_seat = 0
        min_seat = math.inf
        seat_sum = 0

        for seat in seats:
            row = seat[:7]
            col = seat[-3:]

            r = 64*(row[0] == "B") + \
                  32*(row[1] == "B") + \
                  16*(row[2] == "B") + \
                  8*(row[3] == "B") + \
                  4*(row[4] == "B") + \
                  2*(row[5] == "B") + \
                  1*(row[6] == "B")

            c = 4*(col[0] == "R") + \
                  2*(col[1] == "R") + \
                  1*(col[2] == "R")

            seat_index = (r<<3) + c
            max_seat = max(max_seat, seat_index)
            min_seat = min(min_seat, seat_index)
            seat_sum += seat_index

    missing_seat = sum(range(min_seat, max_seat+1)) - seat_sum

    return(max_seat, missing_seat)

if __name__ == "__main__":
    print(run())