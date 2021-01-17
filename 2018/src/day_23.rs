use regex::Regex;
use std::str::FromStr;

struct Drone { x: isize, y: isize, z: isize, radius: isize }

impl Drone {
    const fn distance(&self, other: &Self) -> isize {
        (self.x - other.x).abs() + (self.y - other.y).abs() + (self.z - other.z).abs() 
    }

    const fn distance_to_point(&self, point: &Point) -> isize {
        (self.x - point.x).abs() + (self.y - point.y).abs() + (self.z - point.z).abs() 
    }
}

impl FromStr for Drone {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        lazy_static! {
            static ref DRONE_REGEX: Regex = Regex::new(r"pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)").unwrap();
        }        

        let drone_caps = DRONE_REGEX.captures(s).unwrap();
        let x = drone_caps[1].parse::<isize>().unwrap();
        let y = drone_caps[2].parse::<isize>().unwrap();
        let z = drone_caps[3].parse::<isize>().unwrap();
        let radius = drone_caps[4].parse::<isize>().unwrap();

        Ok( Self{x, y, z, radius} )
    }
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone, Copy)]
struct Point { x: isize, y: isize, z: isize }

#[derive(Debug, PartialEq, Eq)]
struct BoundingCube {
    min_corner: Point,
    size: isize,
    num_drones: usize
}

impl BoundingCube {
    fn get_corners(&self, size: isize) -> Vec<Point> {

        let mut corners = vec!();
        corners.push(Point {x: self.min_corner.x,        y: self.min_corner.y,        z: self.min_corner.z       });
        corners.push(Point {x: self.min_corner.x,        y: self.min_corner.y,        z: self.min_corner.z + size});
        corners.push(Point {x: self.min_corner.x,        y: self.min_corner.y + size, z: self.min_corner.z       });
        corners.push(Point {x: self.min_corner.x,        y: self.min_corner.y + size, z: self.min_corner.z + size});
        corners.push(Point {x: self.min_corner.x + size, y: self.min_corner.y,        z: self.min_corner.z       });
        corners.push(Point {x: self.min_corner.x + size, y: self.min_corner.y,        z: self.min_corner.z + size});
        corners.push(Point {x: self.min_corner.x + size, y: self.min_corner.y + size, z: self.min_corner.z       });
        corners.push(Point {x: self.min_corner.x + size, y: self.min_corner.y + size, z: self.min_corner.z + size});
        
        corners
    }

    fn count_intersecting_drones(&mut self, drones: &[Drone]) {

        self.num_drones = drones.iter().filter(|drone|{

            let drone_in_box = self.min_corner.x <= drone.x && drone.x <= self.min_corner.x + self.size
                && self.min_corner.y <= drone.y && drone.y <= self.min_corner.y + self.size
                && self.min_corner.z <= drone.z && drone.z <= self.min_corner.z + self.size;

            let in_range_of_corners = self.get_corners(self.size).iter().any(|corner| {
                drone.distance_to_point(corner) <= drone.radius
            });

            drone_in_box || in_range_of_corners

        }).count();
    }

    fn get_subcubes(&self, drones: &[Drone]) -> Vec<Self> {
        let new_corners = self.get_corners(self.size / 2);
        let mut sub_cubes: Vec<Self> = new_corners.iter().map(|new_corner| Self{min_corner: *new_corner, size: self.size >> 1, num_drones: 0}).collect();

        for sub_cube in &mut sub_cubes {
            sub_cube.count_intersecting_drones(drones);
        }

        sub_cubes
    }
}

impl PartialOrd for BoundingCube {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        let a = (self.num_drones, -self.size, -dist_from_zero(&self.min_corner));
        let b = (other.num_drones, -other.size, -dist_from_zero(&other.min_corner));
        Some(a.cmp(&b))
    }
}

impl Ord for BoundingCube {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.partial_cmp(other).unwrap()
    }
}

const fn dist_from_zero(point: &Point) -> isize {
    point.x.abs() + point.y.abs() + point.z.abs()
}

fn find_most_connected_cell(drones: &[Drone]) -> Option<Point> {

    let min_corner = drones.iter().map(|drone| Point {x: drone.x - drone.radius, y: drone.y - drone.radius, z: drone.z - drone.radius}).min().unwrap();
    let max_corner = drones.iter().map(|drone| Point {x: drone.x + drone.radius, y: drone.y + drone.radius, z: drone.z + drone.radius}).max().unwrap();

    let x_range = max_corner.x - min_corner.x;
    let y_range = max_corner.y - min_corner.y;
    let z_range = max_corner.z - min_corner.z;

    let biggest_range = isize::max(isize::max(x_range, y_range), z_range);

    let mut next_power_of_2 = 1;
    while next_power_of_2 < biggest_range {
        next_power_of_2 <<= 1;
    }

    let mut bounding_cube = BoundingCube{min_corner, size: next_power_of_2, num_drones: 0};
    bounding_cube.count_intersecting_drones(drones);

    let mut to_explore = std::collections::BinaryHeap::new();
    to_explore.push(bounding_cube);

    while let Some(cube) = to_explore.pop() {
        if cube.size == 0 {
            return Some(cube.min_corner);
        }

        for sub_cube in cube.get_subcubes(drones) {
            to_explore.push(sub_cube);
        }
    }
    
    None
}

#[must_use]
pub fn run() -> (usize, isize) {
    let input = include_str!("../input/23.txt").trim_end_matches('\n').split('\n');

    let drones: Vec<Drone> = input.into_iter().map(Drone::from_str).map(Result::unwrap).collect();

    let strongest_drone = drones.iter().max_by_key(|&drone| drone.radius).unwrap();
    let in_radius = drones.iter().filter(|&drone| strongest_drone.distance(drone) <= strongest_drone.radius).count();

    // P2
    let most_connected_point = find_most_connected_cell(&drones).unwrap();

    (in_radius, dist_from_zero(&most_connected_point))
}

#[test]
fn day_23() {
    assert_eq!(run(), (248, 124_623_002));
}