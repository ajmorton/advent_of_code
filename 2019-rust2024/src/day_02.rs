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

    for noun in 0..99 {
        for verb in 0..99 {
            let mut program = input.clone();
            let mut pc: usize = 0;
            program[1] = noun;
            program[2] = verb;

            loop {
                match program[pc] {
                    1 => {
                        let arg1 = program[pc + 1];
                        let arg2 = program[pc + 2];
                        let output = program[pc + 3];
                        program[output] = program[arg1] + program[arg2];
                        pc += 4;
                    }
                    2 => {
                        let arg1 = program[pc + 1];
                        let arg2 = program[pc + 2];
                        let output = program[pc + 3];
                        program[output] = program[arg1] * program[arg2];
                        pc += 4;
                    }
                    99 => break,
                    _ => (),
                }
            }

            if noun == 12 && verb == 02 {
                p1 = program[0];
            }

            if program[0] == 19690720 {
                p2 = noun * 100 + verb;
            }

            if p1 != 0 && p2 != 0 {
                break;
            }
        }
    }

    (p1, p2)
}

#[test]
fn day_02() {
    assert_eq!(run(), (4930687, 5335));
}
