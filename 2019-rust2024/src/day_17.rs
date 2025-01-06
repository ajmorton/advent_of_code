use crate::intcode::{IntComputer, RetCode};

#[must_use]
pub fn run() -> (usize, isize) {
    let prog: Vec<isize> = include_str!("../input/day17.txt")
        .trim_ascii()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let mut grid: Vec<Vec<char>> = vec![];

    let mut comp = IntComputer::new(&prog, vec![]);
    let mut row = vec![];
    while let RetCode::Output(out) = comp.run() {
        let ascii = (out as u8) as char;
        if ascii == '\n' {
            grid.push(row.clone());
            row.clear();
        } else {
            row.push(ascii);
        }
    }

    // Double newline at end of output
    grid.pop();

    let height = grid.len();
    let width = grid[0].len();

    let mut p1 = 0;
    for r in 1..height - 1 {
        for c in 1..width - 1 {
            if grid[r][c] == '#'
                && grid[r - 1][c] == '#'
                && grid[r + 1][c] == '#'
                && grid[r][c - 1] == '#'
                && grid[r][c + 1] == '#'
            {
                p1 += r * c;
            }
        }
    }

    let prog_input: Vec<isize> = r#"B,C,B,A,C,B,A,B,A,C
R,4,L,12,L,12,R,6
L,12,L,8,L,8
L,12,R,4,L,12,R,6
n
"#
    .chars()
    .map(|c| c as isize)
    .collect();

    let mut mod_prog = prog.clone();
    mod_prog[0] = 2;
    let mut computer = IntComputer::new(&mod_prog, prog_input);

    let mut p2 = 0;
    loop {
        let res = computer.run();
        match res {
            RetCode::Output(out) => p2 = out,
            RetCode::Done(_) => break,
            RetCode::NeedInput => panic!("all input has been provided"),
        }
    }

    (p1, p2)
}
