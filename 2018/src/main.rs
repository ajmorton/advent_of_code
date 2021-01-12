#![warn(clippy::all)]

use std::env;
#[macro_use]
extern crate lazy_static;

mod computer;

mod day_01;
mod day_02;
mod day_03;
mod day_04;
mod day_05;
mod day_06;
mod day_07;
mod day_08;
mod day_09;
mod day_10;
mod day_11;
mod day_12;
mod day_13;
mod day_14;
mod day_15;
mod day_16;
mod day_17;
mod day_18;
mod day_19;
mod day_20;
mod day_21;
mod day_22;
mod day_23;
mod day_24;
mod day_25;

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
            1 => println!("{:?}", day_01::run()),
            2 => println!("{:?}", day_02::run()),
            3 => println!("{:?}", day_03::run()),
            4 => println!("{:?}", day_04::run()),
            5 => println!("{:?}", day_05::run()),
            6 => println!("{:?}", day_06::run()),
            7 => println!("{:?}", day_07::run()),
            8 => println!("{:?}", day_08::run()),
            9 => println!("{:?}", day_09::run()),
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

#[test]
fn day_01() {
    assert_eq!(day_01::run(), (437, 655));
}
#[test]
fn day_02() {
    assert_eq!(day_02::run(), (6175, String::from("asgwjcmzredihqoutcylvzinx")));
}

#[test]
fn day_03() {
    assert_eq!(day_03::run(), (111630, 724));
}
#[test]
fn day_04() {
    assert_eq!(day_04::run(), (14346, 5705));
}

#[test]
fn day_05() {
    assert_eq!(day_05::run(), (11540, 6918));
}

#[test]
fn day_06() {
    assert_eq!(day_06::run(), (3894, 39398));
}

#[test]
fn day_07() {
    assert_eq!(day_07::run(), (String::from("BFKEGNOVATIHXYZRMCJDLSUPWQ"), 1020));
}

#[test]
fn day_08() {
    assert_eq!(day_08::run(), (45210, 22793));
}

#[test]
fn day_09() {
    assert_eq!(day_09::run(), (398242, 3273842452));
}

#[test]
fn day_10() {
    let stars = concat!(
        "  ##    #    #  ######  #       #        ####     ##    #     \n",
        " #  #   #    #       #  #       #       #    #   #  #   #     \n",
        "#    #  #    #       #  #       #       #       #    #  #     \n",
        "#    #  #    #      #   #       #       #       #    #  #     \n",
        "#    #  ######     #    #       #       #       #    #  #     \n",
        "######  #    #    #     #       #       #       ######  #     \n",
        "#    #  #    #   #      #       #       #       #    #  #     \n",
        "#    #  #    #  #       #       #       #       #    #  #     \n",
        "#    #  #    #  #       #       #       #    #  #    #  #     \n",
        "#    #  #    #  ######  ######  ######   ####   #    #  ######\n"
    )
    .to_string();
    assert_eq!(day_10::run(), (stars, 10333));
}

#[test]
fn day_11() {
    assert_eq!(day_11::run(), ((33, 54), (232, 289, 8)));
}

#[test]
fn day_12() {
    assert_eq!(day_12::run(), (3793, 4300000002414));
}

#[test]
fn day_13() {
    assert_eq!(day_13::run(), ((118, 66), (70, 129)));
}

#[test]
fn day_14() {
    assert_eq!(day_14::run(), (6107101544, 20291131));
}

#[test]
fn day_15() {
    assert_eq!(day_15::run(), (206720, 37992));
}

#[test]
fn day_16() {
    assert_eq!(day_16::run(), (646, 681));
}

#[test]
fn day_17() {
    assert_eq!(day_17::run(), (40879, 34693));
}

#[test]
fn day_18() {
    assert_eq!(day_18::run(), (384416, 195776));
}

#[test]
fn day_19() {
    assert_eq!(day_19::run(), (2520, 27941760));
}

#[test]
fn day_20() {
    assert_eq!(day_20::run(), (3885, 8677));
}

#[test]
fn day_21() {
    assert_eq!(day_21::run(), (3941014, 13775890));
}

#[test]
fn day_22() {
    assert_eq!(day_22::run(), (6208, 1039));
}

#[test]
fn day_23() {
    assert_eq!(day_23::run(), (248, 124623002));
}

#[test]
fn day_24() {
    assert_eq!(day_24::run(), (21765, 5522));
}

