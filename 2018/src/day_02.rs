use itertools::*;

pub fn run() -> (isize, String) {
    let lines: Vec<&str> = include_str!("../input/2.txt").lines().collect();

    let counts = |lines: &Vec<&str>, num| {
        lines
            .iter()
            .filter(|line| line.chars().counts().values().any(|v| *v == num))
            .count()
    };
    let twos = counts(&lines, 2);
    let threes = counts(&lines, 3);
    let p1 = (twos * threes) as isize;

    let foo = lines
        .clone()
        .into_iter()
        .combinations(2)
        .map(|pair| {
            let a = &pair.get(0).unwrap();
            let b = &pair.get(1).unwrap();
            a.chars()
                .zip(b.chars())
                .filter(|x| x.0 == x.1)
                .map(|x| x.0)
                .collect::<Vec<char>>()
        })
        .into_iter()
        .max_by_key(|x| x.iter().count());

    let p2: String = foo.unwrap().into_iter().collect();

    (p1, p2)
}
