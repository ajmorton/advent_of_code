use crate::ascii_code::{AsciiComputer, AsciiRetCode};

fn run_prog(prog: &[isize], command: &str) -> Option<isize> {
    let mut ascii_comp = AsciiComputer::new(prog, command);
    let (retcode, out) = ascii_comp.run();

    let AsciiRetCode::Halt(res) = retcode else {
        panic!("");
    };

    if res == -1 {
        println!("{out}");
        None
    } else {
        Some(res)
    }
}

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> =
        include_str!("../input/day21.txt").trim_ascii().split(',').map(|n| n.parse().unwrap()).collect();

    let command = r#"OR A T
AND B T
AND C T
NOT T J
AND D J
WALK
"#;

    let command_p2 = r#"OR A T
AND B T
AND C T
NOT T J
AND D J
OR E T
OR H T
AND T J
RUN
"#;

    let p1 = run_prog(&prog, command).unwrap();
    let p2 = run_prog(&prog, command_p2).unwrap();

    (p1, p2)
}
