use std::collections::VecDeque;

use ahash::AHashMap;
type Reactions<'a> = AHashMap<&'a str, (usize, Vec<(usize, &'a str)>)>;

fn ore_for_fuel(reactions: &Reactions, num_fuel: usize) -> usize {
    let mut require = VecDeque::new();
    require.push_back((num_fuel, "FUEL"));

    let mut excess: AHashMap<&str, usize> = AHashMap::new();

    let mut total_ore_needed = 0;

    while !require.is_empty() {
        let (mut need, chem) = require.pop_front().unwrap();

        let excess_chem = excess.entry(chem).or_insert(0);
        if *excess_chem >= need {
            *excess_chem -= need;
            continue;
        } else if *excess_chem > 0 {
            need -= *excess_chem;
            *excess_chem = 0;
        }

        if chem == "ORE" {
            total_ore_needed += need;
            continue;
        }

        // else normal chems needed
        let (num_out, inputs) = reactions.get(chem).unwrap();
        let react_mult = ((need - 1) / num_out) + 1; // mult to meet or exceed requirements
        for (n, c) in inputs {
            require.push_back((n * react_mult, c));
        }

        let num_produced = num_out * react_mult;
        let extra_produced = num_produced - need;
        *excess_chem += extra_produced;
    }

    total_ore_needed
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/day14.txt").trim_ascii().lines();

    let mut reactions = Reactions::new();

    // let mut nodes = vec![];
    for line in input {
        let split: Vec<_> = line.split(" => ").collect();
        let inn = split[0];
        let out = split[1];

        let mut inputs = vec![];
        for input in inn.split(", ") {
            let parts: Vec<_> = input.split(" ").collect();

            let n = parts[0].parse::<usize>().unwrap();
            let chem = parts[1];
            inputs.push((n, chem));
        }

        let out: Vec<_> = out.split(" ").collect();
        let (out_num, out_name) = (out[0].parse::<usize>().unwrap(), out[1]);

        reactions.insert(out_name, (out_num, inputs));
    }

    let ore_per_fuel = ore_for_fuel(&reactions, 1);
    // println!("{}", ore_for_fuel(&reactions, 1_000_000_000_000 / ore_per_fuel + 1022904));
    // println!("{}", 1_000_000_000_000 as usize);

    (ore_per_fuel, 1_000_000_000_000 / ore_per_fuel + 1022904)
}
