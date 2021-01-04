use std::collections::HashSet;

fn first_repeated_freq(nums: Vec<isize>) -> Option<isize> {
    let mut seen: HashSet<isize> = HashSet::new();
    seen.insert(0);
    nums.iter()
        .cycle()
        .scan(0, |x, y| {
            *x += y;
            Some(*x)
        })
        .find(|freq| !seen.insert(*freq))
}

pub fn run() -> (isize, isize) {
    let nums: Vec<isize> = include_str!("../input/1.txt")
        .trim()
        .split('\n')
        .map(|x| x.parse().unwrap())
        .collect();
    (nums.iter().sum::<isize>(), first_repeated_freq(nums).unwrap())
}

#[test]
fn day_01_helpers() {
    assert_eq!(first_repeated_freq(vec![1, -1]), Some(0));
    assert_eq!(first_repeated_freq(vec![3, 3, 4, -2, -4]), Some(10));
    assert_eq!(first_repeated_freq(vec![-6, 3, 8, 5, -6]), Some(5));
    assert_eq!(first_repeated_freq(vec![7, 7, -2, -7, -4]), Some(14));
}
