#[must_use]
pub fn run() -> (usize, usize) {
    let inputs: Vec<usize> = include_str!("../input/day04.txt")
        .trim_ascii()
        .split("-")
        .map(|n| n.parse::<usize>().unwrap())
        .collect();

    let start = inputs[0];
    let end = inputs[1];

    let mut num_valid_p1 = 0;
    let mut num_valid_p2 = 0;
    let mut pass = start;
    while pass <= end {
        let d1 =  pass / 100_000;
        let d2 = (pass / 10_000) % 10;
        let d3 = (pass / 1_000)  % 10;
        let d4 = (pass / 100)    % 10;
        let d5 = (pass / 10)     % 10;
        let d6 =  pass           % 10;

        if d1 > d2 { pass = d1 * 111_111; continue; }
        if d2 > d3 { pass = (pass / 100_000) * 100000 + d2 * 11111; continue; }
        if d3 > d4 { pass = (pass / 10_000 ) *  10000 + d3 * 1111 ; continue; }
        if d4 > d5 { pass = (pass / 1000   ) *   1000 + d4 * 111  ; continue; }
        if d5 > d6 { pass = (pass / 100    ) *    100 + d5 * 11   ; continue; }

        if d1 != d2 && d2 != d3 && d3 != d4 && d4 != d5 && d5 != d6 {
            pass += 1;
            continue;
        }

        num_valid_p1 += 1;

        if (d1 == d2 && d2 != d3)
            || (d1 != d2 && d2 == d3 && d3 != d4)
            || (d2 != d3 && d3 == d4 && d4 != d5)
            || (d3 != d4 && d4 == d5 && d5 != d6)
            || (d4 != d5 && d5 == d6)
        {
            num_valid_p2 += 1;
        }
        pass += 1;
    }

    (num_valid_p1, num_valid_p2)
}
