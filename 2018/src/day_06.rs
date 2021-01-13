use std::collections::{HashMap, HashSet};

type Point = (isize, isize);

fn manhattan(a: &Point, b: &Point) -> isize {
    (a.0 - b.0).abs() + (a.1 - b.1).abs()
}

pub fn run() -> (usize, isize) {
    let input: Vec<&str> = include_str!("../input/6.txt").trim().split('\n').collect();

    let mut points = Vec::new();
    for point in input {
        let point: Vec<&str> = point.split(", ").into_iter().collect();
        let r = point[0].parse().unwrap();
        let c = point[1].parse().unwrap();
        points.push((r, c));
    }

    let min_r = points.iter().map(|p| p.0).min().unwrap();
    let max_r = points.iter().map(|p| p.0).max().unwrap();
    let min_c = points.iter().map(|p| p.1).min().unwrap();
    let max_c = points.iter().map(|p| p.1).max().unwrap();

    let points: Vec<(usize, &Point)> = points.iter().enumerate().collect();
    let mut closest: HashMap<Point, Option<usize>> = HashMap::new();
    let mut closest_cells: HashMap<usize, Vec<Point>> = HashMap::new();

    for r in min_r - 1..=max_r + 1 {
        for c in min_c - 1..=max_c + 1 {
            let mut closest_point = None;
            let mut closest_dist = isize::MAX;
            for point in &points {
                let dist = manhattan(point.1, &(r, c));
                match dist.cmp(&closest_dist) {
                    std::cmp::Ordering::Equal => closest_point = None,
                    std::cmp::Ordering::Less => {
                        closest_point = Some(point.0);
                        closest_dist = dist;
                    }
                    std::cmp::Ordering::Greater => {}
                }
            }

            closest.insert((r, c), closest_point);
            if let Some(closest_point) = closest_point {
                closest_cells.entry(closest_point).or_default().push((r, c));
            }
        }
    }

    let edges: HashSet<&usize> = closest
        .iter()
        .filter_map(|(p, closest)| {
            if closest.is_some() && (p.0 == min_r - 1 || p.0 == max_r + 1 || p.1 == min_c - 1 || p.1 == max_c + 1) {
                closest.as_ref()
            } else {
                None
            }
        })
        .collect();

    let bounded_cells = closest_cells.iter().filter(|p| !edges.contains(p.0));
    let largest_cell = bounded_cells.max_by_key(|p| p.1.len()).unwrap().0;
    let size_largest = closest_cells.get(largest_cell).unwrap().len();

    // p2
    let mut count = 0;
    for r in min_r - 1..=max_r + 1 {
        for c in min_c - 1..=max_c + 1 {
            if points.iter().map(|p| manhattan(p.1, &(r, c))).sum::<isize>() < 10000 {
                count += 1;
            }
        }
    }

    (size_largest, count)
}

#[test]
fn day_06() {
    assert_eq!(run(), (3894, 39398));
}