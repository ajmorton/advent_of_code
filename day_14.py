import read_as
import re

def all_perms(ls):
    if len(ls) == 0:
        return [[]]
    if ls[0] == '1':
        return [['1'] + sub for sub in all_perms(ls[1:])]
    elif ls[0] == '0':
        return [['0'] + sub for sub in all_perms(ls[1:])]
    else:
        subs = [['0'] + sub for sub in all_perms(ls[1:])]
        subs.extend([['1'] + sub for sub in all_perms(ls[1:])])
        return subs
        
def run() -> (int, int):
    lines = read_as.lines("input/14.txt")

    vals_p1 = {}
    vals_p2 = {}

    mask_vals_p1 = []
    mask_vals_p2 = []
    for line in lines:
        if line[0:7] == "mask = ":
            mask_vals_p1 = []
            mask_vals_p2 = []
            new_mask = line[7:]
            for i in range(len(new_mask)):
                if new_mask[i] != "X":
                    mask_vals_p1.append((i, new_mask[i]))
                if new_mask[i] != "0":
                    mask_vals_p2.append((i, new_mask[i]))

        else:
            assign, val = line.split("=")

            # P1
            index_p1 = int(re.search("mem\[([0-9]+)\]", assign).groups()[0])
            bitstring = list("{0:b}".format(int(val)).zfill(36))
            for (i, m) in mask_vals_p1:
                bitstring[i] = m

            vals_p1[index_p1] = int("".join(bitstring), 2)

            # P2
            val = int(val)
            index = int(re.search("mem\[([0-9]+)\]", assign).groups()[0])
            indexstring = list("{0:b}".format(index).zfill(36))
            for (i, m) in mask_vals_p2:
                indexstring[i] = m

            adresses = all_perms(indexstring)

            for addr in adresses:
                vals_p2[int("".join(addr), 2)] = val

    return (sum(vals_p1.values()), sum(vals_p2.values()))

if __name__ == "__main__":
    print(run())




















# import read_as
# import re

# def run() -> (int, int):
#     lines = read_as.lines("input/14.txt")

#     vals = {}

#     nums = []
#     mask_vals = []
#     for line in lines:
#         if line[0:7] == "mask = ":
#             mask_vals = []
#             new_mask = line[7:]
#             print(f"\n\n\nmask =\t{list(new_mask)}")
#             for i in range(len(new_mask)):
#                 if new_mask[i] != "X":
#                     mask_vals.append((i, new_mask[i]))


#         else:
#             assign, val = line.split("=")
#             index = int(re.search("mem\[([0-9]+)\]", assign).groups()[0])
#             bitstring = list("{0:b}".format(int(val)).zfill(36))
#             print(f"\n\n{val}")
#             print(f"\t {bitstring}")
#             for (i, m) in mask_vals:
#                 bitstring[i] = m
#             print(f"\t {bitstring}")
#             print(f"{index=}")

#             vals[index] = int("".join(bitstring), 2)

#     print(sum(vals.values()))

#     return (False, False)

# if __name__ == "__main__":
#     print(run())