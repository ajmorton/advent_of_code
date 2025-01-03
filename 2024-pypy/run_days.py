#! /usr/bin/env pypy3 -u

from datetime import datetime
from days import day_01, day_02, day_03, day_04, day_05, day_06, day_07, day_08, day_09, day_10
from days import day_11, day_12, day_13, day_14, day_15, day_16, day_17, day_18, day_19, day_20
from days import day_21, day_22, day_23, day_24, day_25

import argparse

(GREEN, GREY, RED, END) = ('\033[32m',  '\033[90m', '\033[91m', '\033[0m')

def format_time(runtime):
    if runtime < 0.000001:
        (time, unit, colour) = (runtime * 1e9, "ns", GREY)
    elif runtime < 0.001:
        (time, unit, colour) = (runtime * 1e6, "µs", GREEN)
    elif runtime < 1:
        (time, unit, colour) = (runtime * 1e3, "ms", "")
    else:
        (time, unit, colour) = (runtime, "s", RED)
    # Over 10ms
    if runtime > 0.01:
        colour = RED
    return f"{colour}  {round(time, 2): >5} {unit} {END}"


def run_test(module, expected_output, benchmark: bool) -> (bool, int):
    start = datetime.now()
    test_result = module.run()
    single_run_time = (datetime.now() - start).total_seconds()

    if test_result != expected_output:
        result_text = f"{RED}NOK{END}"
    else:
        result_text = f"{GREEN} OK{END} {expected_output}"

    print(f"{module.__name__:6}  {result_text} {END}", end='', flush=True)

    if test_result != expected_output:
        offset = len(str(expected_output[0]))
        print()
        print(f"    expected: {expected_output[0]: >{offset}}, {expected_output[1]}")
        print(f"    actual:   {test_result[0]: >{offset}}, {test_result[1]}")
        return (False, 0)

    if(benchmark):
        if(single_run_time < 2.5):
            print(" ... Benchmarking. Running for 5 seconds", end='', flush=True)
            start = datetime.now()
            num_runs = 0
            while ((end := datetime.now()) - start).total_seconds() < 5:
                module.run()
                num_runs += 1

            # Clear "... Benchmarking" text
            print('\b' * 40 + ' ' * 40 + '\b' * 40, end='', flush=True)
            avg_runtime = (end - start).total_seconds() / num_runs
        else:
            avg_runtime = single_run_time

        print(f"{format_time(avg_runtime)}")

        return (True, avg_runtime)
    return (True, 0)

def parse_args():
    parser = argparse.ArgumentParser(description="Greet a user with their name and age.")

    parser.add_argument('-d', '--day', required=True, type=int, help='The day to run. (Use 0 for all days)')
    parser.add_argument('-b', '--benchmark', action='store_true', help='Run benchmark on the test')
    return parser.parse_args()

if __name__ == "__main__":

    args = parse_args()
    day_to_run = args.day
    benchmark = args.benchmark

    all_days = [
        (day_01 , (2166959, 23741109)),
        (day_02 , (686, 717)),
        (day_03 , (187833789, 94455185)),
        (day_04 , (2662, 2034)),
        (day_05 , (6498, 5017)),
        (day_06 , (4883, 1655)),
        (day_07 , (4364915411363, 38322057216320)),
        (day_08 , (256, 1005)),
        (day_09 , (6446899523367, 6478232739671)),
        (day_10 , (489, 1086)),
        (day_11 , (183484, 218817038947400)),
        (day_12 , (1467094, 881182)),
        (day_13 , (29436, 103729094227877)),
        (day_14 , (229069152, 7383)),
        (day_15 , (1412971, 1429299)),
        (day_16 , (94436, 481)),
        (day_17 , ("2,0,7,3,0,3,1,3,7", 247839539763386)),
        (day_18 , (306, (38, 63))),
        (day_19 , (300, 624802218898092)),
        (day_20 , (1438, 1026446)),
        (day_21 , (157230, 195969155897936)),
        (day_22 , (20506453102, 2423)),
        (day_23 , (1154, "aj,ds,gg,id,im,jx,kq,nj,ql,qr,ua,yh,zn")),
        (day_24 , (56278503604006, "bhd,brk,dhg,dpd,nbf,z06,z23,z38")),
        (day_25 , (3495, 0)),
    ]

    to_run = []
    if day_to_run == 0:
        to_run = all_days
    else:
        if (day_to_run < 1) or (day_to_run > len(all_days)):
            print(f"Day {day_to_run} not implemented!")
            exit(1)
        to_run = [all_days[day_to_run - 1]] # -1 due to 0 indexing

    total_time = 0
    num_success = 0
    total_runtime = 0
    for (day, expected_output) in to_run:
        (success, runtime) = run_test(day, expected_output, benchmark)
        if success:
            num_success += 1
        if runtime:
            total_runtime += runtime

    print("")
    if(benchmark):
        print('---------------------------------------')
        print(f"Total   time (passing tests) = {format_time(total_runtime)}")
        print(f"Average time (passing tests) = {format_time(total_runtime / num_success)}")
