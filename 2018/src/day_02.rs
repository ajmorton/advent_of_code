use itertools::Itertools;

#[must_use]
pub fn run() -> (usize, String) {
    let lines: Vec<&str> = include_str!("../input/2.txt").lines().collect();

    let counts = |lines: &[&str], num| {
        lines.iter()
            .filter(|line| line.chars().counts().values().any(|v| *v == num))
            .count()
    };

    let twos = counts(&lines, 2);
    let threes = counts(&lines, 3);
    let p1 = twos * threes;

    let p2 = lines
        .into_iter()
        .combinations(2)
        .map(|pair| {
            let a = pair[0].chars();
            let b = pair[1].chars();
            a.zip(b)
                .filter_map(|(a, b)| if a == b { Some(a) } else { None })
                .collect()
        })
        .max_by_key(String::len)
        .unwrap();

    (p1, p2)
}

#[test]
fn day_02() {
    assert_eq!(run(), (6175, String::from("asgwjcmzredihqoutcylvzinx")));
}