use ahash::{AHashMap, AHashSet};

type Orbits<'a> = AHashMap<&'a str, AHashSet<&'a str>>;

fn num_orbiting(body: &str, orbits: &Orbits) -> usize {
    let mut num_orbits = 0;
    if let Some(parent) = orbits.get(body) {
        num_orbits += parent.len();
        for p in parent {
            num_orbits += num_orbiting(p, &orbits);
        }
    }
    num_orbits
}

fn path_to_com<'a>(body: &'a str, orbits: &'a Orbits) -> AHashSet<&'a str> {

    if body == "COM" {
        return AHashSet::new();
    } else {
        if let Some(parent) = orbits.get(body) {
            let p = parent.iter().next().unwrap();
            let mut path = path_to_com(p, orbits);
            path.insert(body);
            return path;
        }
    }
    unreachable!();
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/day06.txt").trim_ascii().lines();
    let mut orbits: Orbits  = AHashMap::new();

    for line in input {
        let mut split = line.split(')');
        let (a, b) = (split.next().unwrap(), split.next().unwrap());
        orbits.entry(b).or_default().insert(a);
    }

    let mut p1 = 0;
    for body in orbits.keys() {
        p1 += num_orbiting(body, &orbits);
    }

    let my_path = path_to_com("YOU", &orbits);
    let san_path = path_to_com("SAN", &orbits);

    let differing_planets = my_path.symmetric_difference(&san_path);

    // minus two because SAN and YOU are included
    let num_hops = differing_planets.count() - 2;

    (p1, num_hops)
}
