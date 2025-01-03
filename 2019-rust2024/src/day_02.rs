use crate::intcode::IntComputer;

#[must_use]
pub fn run() -> (usize, usize) {
    let input: Vec<usize> = include_str!("../input/day02.txt")
        .strip_suffix("\n")
        .unwrap()
        .split(',')
        .map(|x| x.parse().unwrap())
        .collect();

    let mut p1 = 0;
    let mut p2 = 0;

    for noun in 0..=99 {
        for verb in 0..=99 {
            let mut program = input.clone();
            program[1] = noun;
            program[2] = verb;

            let result = IntComputer::new(program).run();

            if noun == 12 && verb == 2 {
                p1 = result;
            }

            if result == 19690720 {
                p2 = noun * 100 + verb;
            }

            if p1 != 0 && p2 != 0 {
                return (p1, p2);
            }
        }
    }

    unreachable!();
}
