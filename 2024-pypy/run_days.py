#! /usr/bin/env pypy3

from datetime import datetime
from days import day_01, day_02, day_03

import argparse

(GREEN, GREY, RED, END) = ('\033[32m',  '\033[90m', '\033[91m', '\033[0m')

def format_time(runtime):
    if runtime < 0.000001:
        (time, unit, colour) = (runtime * 1e9, "ns", GREEN)
    elif runtime < 0.001:
        (time, unit, colour) = (runtime * 1e6, "µs", GREY)
    elif runtime < 1:
        (time, unit, colour) = (runtime * 1e3, "ms", "")
    else:
        (time, unit, colour) = (runtime, "s", RED)
    return f"  {round(time, 2): >5} {unit} {END}"


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

        print(format_time(avg_runtime))

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
