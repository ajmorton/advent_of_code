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
        _ => println!("Unrecognised number {}", day),
    }
}
