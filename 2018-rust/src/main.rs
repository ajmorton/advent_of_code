use std::env;
use aoc_2018::*;

fn main() {
    let args: Vec<String> = env::args().collect();
    let to_run = &args
        .get(1)
        .expect("No day provided! Call using cargo run {DAY}. e.g. cargo run 2")
        .parse::<usize>()
        .unwrap();
    run(*to_run);
}

fn run(day: usize) {
    if day == 0 {
        for d in 1..25 {
            run(d);
        }
    } else {
        match day {
            1 => println!("{:?}",  day_01::run()),
            2 => println!("{:?}",  day_02::run()),
            3 => println!("{:?}",  day_03::run()),
            4 => println!("{:?}",  day_04::run()),
            5 => println!("{:?}",  day_05::run()),
            6 => println!("{:?}",  day_06::run()),
            7 => println!("{:?}",  day_07::run()),
            8 => println!("{:?}",  day_08::run()),
            9 => println!("{:?}",  day_09::run()),
            10 => println!("{:?}", day_10::run()),
            11 => println!("{:?}", day_11::run()),
            12 => println!("{:?}", day_12::run()),
            13 => println!("{:?}", day_13::run()),
            14 => println!("{:?}", day_14::run()),
            15 => println!("{:?}", day_15::run()),
            16 => println!("{:?}", day_16::run()),
            17 => println!("{:?}", day_17::run()),
            18 => println!("{:?}", day_18::run()),
            19 => println!("{:?}", day_19::run()),
            20 => println!("{:?}", day_20::run()),
            21 => println!("{:?}", day_21::run()),
            22 => println!("{:?}", day_22::run()),
            23 => println!("{:?}", day_23::run()),
            24 => println!("{:?}", day_24::run()),
            25 => println!("{:?}", day_25::run()),
            _ => println!("Unrecognised number {}", day),
        }
    }
}