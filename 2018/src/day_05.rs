use std::collections::HashSet;

fn reduce(polymer: Vec<char>) -> Vec<char> {
    let mut p = polymer.clone();
    loop {
        let mut new_polymer = vec![];
        for c in p.iter() {
            match new_polymer.last() {
                None => new_polymer.push(*c),
                Some(&nc) => {
                    if c.is_uppercase() != nc.is_uppercase() && c.eq_ignore_ascii_case(&nc) {
                        new_polymer.pop();
                    } else {
                        new_polymer.push(*c);
                    }
                }
            }
        }
        if new_polymer.len() == p.len() {
            return new_polymer;
        } else {
            p = new_polymer;
        }
    }
}

pub fn run() -> (usize, usize) {
    let polymer: Vec<char> = include_str!("../input/5.txt").trim_end().chars().collect();

    // p2
    let letters: HashSet<char> = polymer.iter().map(|c| c.to_ascii_lowercase()).collect();
    let stripped_polymers: Vec<Vec<char>> = letters
        .iter()
        .map(|l| {
            polymer
                .clone()
                .into_iter()
                .filter(|&c| !c.eq_ignore_ascii_case(&l))
                .collect()
        })
        .collect();

    let reduced_lens = stripped_polymers.into_iter().map(|poly| reduce(poly).len());
    let shortest = reduced_lens.min().unwrap();

    (reduce(polymer).len(), shortest)
}
