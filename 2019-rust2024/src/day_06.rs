use ahash::AHashMap;

type Orbits = Vec<usize>;

fn num_orbiting(body_id: usize, orbits_vec: &Orbits) -> usize {
    let parent = orbits_vec[body_id];
    if parent != 0 { 1 + num_orbiting(parent, orbits_vec) } else { 0 }
}

fn path_to_com(body: usize, orbits_vec: &Orbits) -> Vec<usize> {
    let parent = orbits_vec[body];
    if parent != 0 {
        let mut path = path_to_com(parent, orbits_vec);
        path.push(body);
        path
    } else {
        vec![0]
    }
}

fn get_numeric_id<'a>(planet: &'a str, planet_ids: &mut AHashMap<&'a str, usize>) -> usize {
    if planet_ids.contains_key(planet) {
        planet_ids[planet]
    } else {
        let unique_id = planet_ids.len() + 1;
        planet_ids.insert(planet, unique_id);
        unique_id
    }
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/day06.txt").trim_ascii().lines();

    let mut planet_id: AHashMap<&str, usize> = AHashMap::new();
    let num_bodies = input.clone().count();
    let mut orbit_vec: Orbits = vec![0; 2 * num_bodies];

    for line in input {
        let mut split = line.split(')');
        let (a, b) = (split.next().unwrap(), split.next().unwrap());

        let a_num = get_numeric_id(a, &mut planet_id);
        let b_num = get_numeric_id(b, &mut planet_id);

        orbit_vec[b_num] = a_num;
    }

    let all_orbits: usize = (0..orbit_vec.len()).map(|b| num_orbiting(b, &orbit_vec)).sum();

    let you_path = path_to_com(planet_id["YOU"], &orbit_vec);
    let san_path = path_to_com(planet_id["SAN"], &orbit_vec);

    let common_path_len = you_path.iter().zip(san_path.iter()).take_while(|(x, y)| **x == **y).count();

    // Removing the common path to COM yields the paths from YOU to COMMON_PARENT and SAN to COMMON_PARENT.
    // By extension the sum of these paths is the path from YOU to SAN.
    // -1 as we want jumps between planets, not number of planets
    let jumps_you_common = you_path[common_path_len..].len() - 1;
    let jumps_common_san = san_path[common_path_len..].len() - 1;

    (all_orbits, jumps_you_common + jumps_common_san)
}
