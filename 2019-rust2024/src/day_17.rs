use crate::ascii_code::{AsciiComputer, AsciiRetCode};

#[must_use]
pub fn run() -> (usize, isize) {
    let prog: Vec<isize> =
        include_str!("../input/day17.txt").trim_ascii().split(',').map(|n| n.parse().unwrap()).collect();

    let mut ascii_comp = AsciiComputer::new(&prog, "");
    let (_, grid) = ascii_comp.run();
    let mut grid: Vec<Vec<char>> = grid.lines().map(|line| line.chars().collect()).collect();

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

    let prog_input_ascii = r#"B,C,B,A,C,B,A,B,A,C
R,4,L,12,L,12,R,6
L,12,L,8,L,8
L,12,R,4,L,12,R,6
n
"#;

    let mut mod_prog = prog;
    mod_prog[0] = 2;
    let (AsciiRetCode::Halt(p2), _) = AsciiComputer::new(&mod_prog, prog_input_ascii).run() else { panic!("") };

    (p1, p2)
}
