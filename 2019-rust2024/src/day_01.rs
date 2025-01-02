
fn fuel_cost(weight: isize) -> isize {
    weight / 3 - 2
}

fn fuel_cost_rec(weight: isize) -> isize {
    let fuel_weight = (weight / 3) - 2;
    if fuel_weight <= 0 {
        0
    } else {
        fuel_weight + fuel_cost_rec(fuel_weight)
    }
}

#[must_use]
pub fn run() -> (isize, isize) {

    let mut p1 = 0;
    let mut p2 = 0;

    let module_weights: Vec<isize> = include_str!("../input/day01.txt")
        .lines()
        .map(|x| x.parse().unwrap())
        .collect();

    for module in module_weights {
        p1 += fuel_cost(module);
        p2 += fuel_cost_rec(module);
    }

    (p1, p2)
}


#[test]
fn day_01() {
    assert_eq!(run(), (3125750, 4685788));
}