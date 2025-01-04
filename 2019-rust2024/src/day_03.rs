use ahash::AHashMap;

fn manhattan(point: (isize, isize)) -> isize {
    point.0.abs() + point.1.abs()
}

#[must_use]
pub fn run() -> (isize, isize) {
    let input = include_bytes!("../input/day03.txt").trim_ascii().split(|x| *x == b'\n');
    let mut wire1: AHashMap<(isize, isize), isize> = AHashMap::new();

    wire1.insert((0, 0), 0);
    let mut shortest_manhattan_dist = isize::MAX;
    let mut shortest_travel_dist = isize::MAX;

    let mut is_wire1 = true;
    for line in input {
        let mut travel_dist = 0;
        let (mut r, mut c) = (0, 0);
        for instr in line.split(|x| *x == b',') {
            let dir = instr[0] as char;
            let dist: usize = std::str::from_utf8(&instr[1..]).unwrap().parse().unwrap();

            let (dr, dc) = match dir {
                'U' => (-1, 0),
                'D' => (1, 0),
                'L' => (0, -1),
                'R' => (0, 1),
                _ => panic!("Unexpected direction {}!", dir),
            };

            for _ in 1..=dist {
                travel_dist += 1;
                (r, c) = (r + dr, c + dc);
                if is_wire1 {
                    wire1.insert((r, c), travel_dist);
                } else {
                    if wire1.contains_key(&(r, c)) {
                        shortest_manhattan_dist = std::cmp::min(shortest_manhattan_dist, manhattan((r, c)));
                        shortest_travel_dist = std::cmp::min(shortest_travel_dist, travel_dist + wire1[&(r, c)]);
                    }
                }
            }
        }
        is_wire1 = false;
    }

    (shortest_manhattan_dist, shortest_travel_dist)
}
