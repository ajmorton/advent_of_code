use crate::ascii_code::AsciiComputer;
use std::io;

fn run_text_adventure(prog: &Vec<isize>, input: &str) {
    let mut ascii_comp = AsciiComputer::new(prog, &input);

    let mut user_input = String::new();
    loop {
        let (_, description) = ascii_comp.run();
        println!("{description}");

        io::stdin().read_line(&mut user_input).expect("Failed to read line");

        if user_input.starts_with("take ")
            || user_input.starts_with("north")
            || user_input.starts_with("east")
            || user_input.starts_with("west")
            || user_input.starts_with("south")
            || user_input.starts_with("in")
            || user_input.starts_with("drop")
        {
            println!("{user_input:?}");
            ascii_comp.input(&user_input);
            user_input.clear();
        } else {
            println!("invalid command");
            user_input.clear();
        }
    }
}

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> = include_str!("../input/day25.txt")
        .trim_ascii()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let input = "south\ntake fuel cell\nnorth\nwest\ntake mutex\nsouth\nsouth\ntake coin\nnorth\neast\ntake cake\nnorth\nwest\nsouth\nwest\n";

    if false {
        run_text_adventure(&prog, input);
    }
    (278664, 0)
}

//               X
//               |        X
//       X --- obsv --- arcd X
//               X       |
//               X       |      X        X        X          X
//           X warp ---- | --- stab X X kitc X X navi ----- eng X
//               |       |      |        |        |          X
//        ??? - sec  X choc --- | ------ | ----- hull X
//               X       |      |        |        |
//                   X crew -- labb -- holo X  X sick X
//               X       |      X        X        |
//            X hall -- corr -- gift X         X stor X
//               |       X      X                 X
//            X pass X
//               X

// arcd ------
// choc mutex
// corr coin
// crew ------
// eng  ------
// gift infinite loop       !!!DEATH!!!
// hall dehydrated water
// holo giant electromagner !!!DEATH!!!
// hull ------
// kitc escape pod          !!!DEATH!!!
// labb cake
// navi candy cane
// obsv ------
// pass prime number
// sec                      exit
// sick fuel cell
// stab photons             !!!DEATH!!!!
// stor manifold
// warp molten lava         !!!DEATH!!!
