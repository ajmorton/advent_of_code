const fn fuel_cost(weight: isize) -> isize {
    weight / 3 - 2
}

fn fuel_cost_rec(weight: isize) -> isize {
    let fuel_weight = weight / 3 - 2;
    if fuel_weight <= 0 { 0 } else { fuel_weight + fuel_cost_rec(fuel_weight) }
}

#[must_use]
pub fn run() -> (isize, isize) {
    include_str!("../input/day01.txt")
        .lines()
        .map(|x| x.parse::<isize>().unwrap())
        .map(|w| (fuel_cost(w), fuel_cost_rec(w)))
        .fold((0, 0), |l, r| (l.0 + r.0, l.1 + r.1))
}
