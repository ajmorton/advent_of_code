from datetime import datetime
import day_1,  day_2,  day_3,  day_4,  day_5,  day_6,  day_7,  day_8,  day_9,  day_10
import day_11, day_12, day_13, day_14, day_15, day_16, day_17, day_18, day_19, day_20
import day_21, day_22, day_23, day_24, day_25

GREY = '\033[90m'
GREEN = '\033[32m'
RED = '\033[91m'
END = '\033[0m'

def run_test(module, expected_output):
    start = datetime.now()
    result = module.run()
    exec_time = (datetime.now() - start).total_seconds()

    test_result = f"{GREEN} OK{END}"
    if result != expected_output:
        test_result = f"{RED}NOK{END}"

    if exec_time < 0.001:
        (time, unit, color) = (exec_time * 1e6, "us", GREY)
    elif exec_time < 1:
        (time, unit, color) = (exec_time * 1e3, "ms", "")
    else:
        (time, unit, color) = (exec_time, "s", RED)

    print(f"{module.__name__:6}  {test_result} {color} {round(time, 1): >5} {unit} {END}")

    if result != expected_output:
        offset = len(str(expected_output[0]))
        print(f"    expected: {expected_output[0]: >{offset}}, {expected_output[1]}")
        print(f"    actual:   {result[0]: >{offset}}, {result[1]}")

    return exec_time


if __name__ == "__main__":

    tests = [
        (day_1 , (436404,          274879808)),
        (day_2 , (477,             686)),
        (day_3 , (270,             2122848000)),
        (day_4 , (247,             145)),
        (day_5 , (888,             522)),
        (day_6 , (6742,            3447)),
        (day_7 , (224,             1488)),
        (day_8 , (1818,            631)),
        (day_9 , (20874512,        3012420)),
        (day_10, (2232,            173625106649344)),
        (day_11, (2093,            1862)),
        (day_12, (759,             45763)),
        (day_13, (370,             894954360381385)),
        (day_14, (14839536808842,  4215284199669)),
        (day_15, (289,             1505722)),
        (day_16, (20091,           2325343130651)),
        (day_17, (336,             2620)),
        (day_18, (24650385570008,  158183007916215)),
        (day_19, (203,             304)),
        (day_20, (32287787075651,  1939)),
        (day_21, (2436,            'dhfng,pgblcd,xhkdc,ghlzj,dstct,nqbnmzx,ntggc,znrzgs')),
        (day_22, (34566,           31854)),
        (day_23, (82635947,        157047826689)),
        (day_24, (282,             3445)),
        (day_25, (6421487,         False))
    ]

    total_time = 0
    for (day, expected_output) in tests:
        total_time += run_test(day, expected_output)

    print(f"\ntotal time = {round(total_time, 2)} s")
