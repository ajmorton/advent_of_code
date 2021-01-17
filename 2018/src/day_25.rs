use std::collections::HashSet;

use regex::Regex;

struct Point { x: isize, y: isize, z: isize, t: isize }

impl Point {
    const fn dist(&self, other: &Self) -> isize {
        (self.x - other.x).abs() + (self.y - other.y).abs() + (self.z - other.z).abs() + (self.t - other.t).abs()
    }
}

#[must_use]
pub fn run() -> (isize, isize) {
    let coord_pattern = Regex::new(r"(-?\d+),(-?\d+),(-?\d+),(-?\d+)").unwrap();
    let coords: Vec<Point> = include_str!("../input/25.txt").trim_end_matches('\n').split('\n').map( 
        |line| {
            let caps = coord_pattern.captures(line).unwrap();
            let x = caps[1].parse::<isize>().unwrap();
            let y = caps[2].parse::<isize>().unwrap();
            let z = caps[3].parse::<isize>().unwrap();
            let t = caps[4].parse::<isize>().unwrap();
            Point{x,y,z,t}
        }
    ).collect();

    let mut connections = vec![vec!(); coords.len()];

    for i in 0..coords.len() {
        for j in i+1 .. coords.len() {
            if coords[i].dist(&coords[j]) <= 3 {
                connections[i].push(j);
                connections[j].push(i);
            }
        }
    }

    let mut unexplored_points: HashSet<usize> = HashSet::new();
    unexplored_points.extend((0..coords.len()).into_iter());

    let mut num_constellations = 0;

    while ! unexplored_points.is_empty() {
        num_constellations += 1;

        let next_coord = unexplored_points.iter().cloned().next().unwrap();
        unexplored_points.remove(&next_coord);

        let mut in_constellation = vec![next_coord];
        while ! in_constellation.is_empty() {
            let point = in_constellation.remove(0);
            unexplored_points.remove(&point);

            for connected in &connections[point] {
                if unexplored_points.get(connected).is_some() {
                    in_constellation.push(*connected);
                    unexplored_points.remove(connected);
                }
            }
        }
    }

    (num_constellations, 0)
}

#[test]
fn day_25() {
    assert_eq!(run(), (399, 0));
}