use crate::intcode::{IntComputer, RetCode};
use itertools::Itertools;

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> =
        include_str!("../input/day07.txt").trim_ascii().split(',').map(|n| n.parse().unwrap()).collect();

    let config_p1 = [0, 1, 2, 3, 4];
    let permutations_p1: Vec<Vec<_>> = config_p1.iter().permutations(5).collect();
    let mut p1 = 0;

    for perm in permutations_p1 {
        let mut output = 0;
        for param in perm.iter().take(5) {
            let mut intcomp = IntComputer::new(&prog, vec![**param, output]);
            let res = intcomp.run();
            let RetCode::Output(out) = res else {
                panic!("Unexpected item in the intcode area: {res:?}");
            };
            output = out;
        }
        p1 = std::cmp::max(p1, output);
    }

    let config_p2 = [5, 6, 7, 8, 9];
    let permutations_p2: Vec<Vec<_>> = config_p2.iter().permutations(5).collect();
    let mut p2 = 0;

    for perm in permutations_p2 {
        let mut chain = [
            IntComputer::new(&prog, vec![*perm[0]]),
            IntComputer::new(&prog, vec![*perm[1]]),
            IntComputer::new(&prog, vec![*perm[2]]),
            IntComputer::new(&prog, vec![*perm[3]]),
            IntComputer::new(&prog, vec![*perm[4]]),
        ];

        let mut signal = 0;
        let mut last_ext_sig = 0;
        'feedback: loop {
            for (i, computer) in chain.iter_mut().enumerate() {
                computer.input(signal);
                let res = computer.run();

                match res {
                    RetCode::Output(out) => {
                        signal = out;
                        if i == 4 {
                            last_ext_sig = signal;
                        }
                    }
                    RetCode::Done(_) => break 'feedback,
                    _ => panic!("Unexpected item in the intcode area: {res:?}"),
                }
            }
        }
        p2 = std::cmp::max(p2, last_ext_sig);
    }

    (p1, p2)
}
