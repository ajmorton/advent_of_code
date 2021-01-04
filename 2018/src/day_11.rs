type Power = isize;
type Size = usize;
type Pos = (usize, usize);
#[derive(Eq, PartialEq, Debug)]
struct Result {
    pos: Pos,
    size: Size,
    power: Power,
}

const GRID_SIZE: usize = 300;

fn power_level(r: isize, c: isize, serial_number: isize) -> Power {
    let rack_id = c + 10;
    let power_level = ((rack_id * r) + serial_number) * rack_id;
    let power_level = (power_level / 100) % 10;
    power_level - 5
}

fn find_subcell<I>(partial_sums: &[Vec<Power>], size_range: I) -> Result
where
    I: Iterator<Item = Size>,
{
    let mut most_power = 0;
    let mut best_pos = (0, 0);
    let mut best_size = 0;

    for size in size_range {
        for r in 1..=300 - size {
            for c in 1..=300 - size {
                let power = partial_sums[r + size][c + size] + partial_sums[r][c]
                    - partial_sums[r][c + size]
                    - partial_sums[r + size][c];
                if power > most_power {
                    most_power = power;
                    best_pos = (c + 1, r + 1); // flipped to match puzzle format
                    best_size = size;
                }
            }
        }
    }

    Result {
        pos: best_pos,
        size: best_size,
        power: most_power,
    }
}

fn build_partial_sums(serial_number: isize) -> Vec<Vec<Power>> {
    let mut partial_sums = vec![vec!(0_isize; GRID_SIZE + 1); GRID_SIZE + 1];

    for r in 1..=GRID_SIZE {
        for c in 1..=GRID_SIZE {
            partial_sums[r][c] =
                power_level(r as isize, c as isize, serial_number) + partial_sums[r][c - 1] + partial_sums[r - 1][c]
                    - partial_sums[r - 1][c - 1];
        }
    }
    partial_sums
}

pub fn run() -> ((usize, usize), (usize, usize, usize)) {
    const SERIAL_NUMBER: isize = 5235;

    let partial_sums = build_partial_sums(SERIAL_NUMBER);

    let p1 = find_subcell(&partial_sums, 3..=3);
    let p2 = find_subcell(&partial_sums, 1..=300);

    (p1.pos, (p2.pos.0, p2.pos.1, p2.size))
}

#[test]
fn day_11_power_level() {
    assert_eq!(power_level(5, 3, 8), 4);
    assert_eq!(power_level(79, 122, 57), -5);
    assert_eq!(power_level(196, 217, 39), 0);
    assert_eq!(power_level(153, 101, 71), 4);
}

#[test]
fn day_11_find_subcell() {
    assert_eq!(
        find_subcell(&build_partial_sums(18), 3..=3),
        Result {
            pos: (33, 45),
            size: 3,
            power: 29
        }
    );
    assert_eq!(
        find_subcell(&build_partial_sums(42), 3..=3),
        Result {
            pos: (21, 61),
            size: 3,
            power: 30
        }
    );

    assert_eq!(
        find_subcell(&build_partial_sums(18), 1..=300),
        Result {
            pos: (90, 269),
            size: 16,
            power: 113
        }
    );

    assert_eq!(
        find_subcell(&build_partial_sums(42), 1..=300),
        Result {
            pos: (232, 251),
            size: 12,
            power: 119
        }
    );
}
