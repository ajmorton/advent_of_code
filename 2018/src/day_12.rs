use regex::Regex;
use std::collections::{HashSet, VecDeque};

fn meets_rules(i: isize, plants: &HashSet<isize>, ruleset: &HashSet<String>) -> bool {
    let neighbours: String = (i - 2..=i + 2)
        .map(|j| if plants.contains(&j) { '#' } else { '.' })
        .collect();

    ruleset.contains(&neighbours)
}

#[must_use]
pub fn run() -> (isize, isize) {
    let input: Vec<&str> = include_str!("../input/12.txt").trim().split("\n\n").collect();

    let mut plants: HashSet<isize> = input[0]
        .to_string()
        .chars()
        .filter(|&c| c == '#' || c == '.')
        .enumerate()
        .filter_map(|(i, c)| if c == '#' { Some(i as isize) } else { None })
        .collect();

    let rules: Vec<&str> = input[1].split('\n').collect();

    let pattern = Regex::new(r"([.#]{5}) => #").unwrap();
    let mut ruleset: HashSet<String> = HashSet::new();
    for rule in rules {
        let caps = pattern.captures(rule);

        if let Some(caps) = caps {
            ruleset.insert(caps[1].to_string().clone());
        }
    }

    let mut num = 0;
    let mut p1 = -1;
    let mut prev_deltas = VecDeque::new();

    let mut stable_state = (0, 0, 0);

    for step in 0..10000 {
        let mut new_plants: HashSet<isize> = HashSet::new();
        for i in plants.iter().min().unwrap() - 2..=plants.iter().max().unwrap() + 2 {
            if meets_rules(i, &plants, &ruleset) {
                new_plants.insert(i);
            }
        }
        plants = new_plants;
        let delta = plants.iter().sum::<isize>() - num;
        num = plants.iter().sum::<isize>();
        prev_deltas.push_front(delta);

        if step > 10 {
            let pop = prev_deltas.pop_back().unwrap();
            if pop == delta && prev_deltas.iter().all(|&prev| prev == delta) {
                stable_state = (step, num, delta);
                break;
            }
        }

        if step == 19 {
            p1 = num;
        }
    }

    let (step, cur_num, delta) = stable_state;
    let num_at_50_billion = cur_num + (50_000_000_000 - step - 1) * delta;

    (p1, num_at_50_billion)
}

#[test]
fn day_12() {
    assert_eq!(run(), (3793, 4_300_000_002_414));
}