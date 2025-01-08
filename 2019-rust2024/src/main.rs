use aoc_2019::*;
use std::env;

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
    match day {
        1 => println!("{:?}", day_01::run()),
        2 => println!("{:?}", day_02::run()),
        3 => println!("{:?}", day_03::run()),
        4 => println!("{:?}", day_04::run()),
        5 => println!("{:?}", day_05::run()),
        6 => println!("{:?}", day_06::run()),
        7 => println!("{:?}", day_07::run()),
        8 => {
            let (p1, p2) = day_08::run();
            println!("{}\n{}", p1, p2)
        }
        9 => println!("{:?}", day_09::run()),
        10 => println!("{:?}", day_10::run()),
        11 => {
            let (p1, p2) = day_11::run();
            println!("{}\n{}", p1, p2)
        }
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
        _ => println!("Unrecognised number {}", day),
    }
}
