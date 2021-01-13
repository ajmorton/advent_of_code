use regex::Regex;
use std::str::FromStr;

struct Drone {
    x: isize,
    y: isize,
    z: isize,
    r: isize
}

impl Drone {
    fn distance(&self, other: &Drone) -> isize {
        (self.x - other.x).abs() + (self.y - other.y).abs() + (self.z - other.z).abs() 
    }

    fn distance_to_point(&self, (x,y,z): &(isize, isize, isize)) -> isize {
        (self.x - x).abs() + (self.y - y).abs() + (self.z - z).abs() 
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
        let r = drone_caps[4].parse::<isize>().unwrap();

        Ok(Drone{x, y, z, r})
    }
}

#[derive(Debug, PartialEq, Eq, Ord)]
struct BoundingCube {
    min_corner: (isize, isize, isize),
    size: isize,
    num_drones: usize
}

impl BoundingCube {
    fn get_corners(&self, size: isize) -> Vec<(isize, isize, isize)> {

        let mut corners = vec!();
        corners.push((self.min_corner.0,        self.min_corner.1,        self.min_corner.2));
        corners.push((self.min_corner.0,        self.min_corner.1,        self.min_corner.2 + size));
        corners.push((self.min_corner.0,        self.min_corner.1 + size, self.min_corner.2));
        corners.push((self.min_corner.0,        self.min_corner.1 + size, self.min_corner.2 + size));
        corners.push((self.min_corner.0 + size, self.min_corner.1,        self.min_corner.2));
        corners.push((self.min_corner.0 + size, self.min_corner.1,        self.min_corner.2 + size));
        corners.push((self.min_corner.0 + size, self.min_corner.1 + size, self.min_corner.2));
        corners.push((self.min_corner.0 + size, self.min_corner.1 + size, self.min_corner.2 + size));
        
        corners
    }

    fn count_intersecting_drones(&mut self, drones: &[Drone]) {

        let cube_x_range = self.min_corner.0 ..= self.min_corner.0 + self.size;
        let cube_y_range = self.min_corner.1 ..= self.min_corner.1 + self.size;
        let cube_z_range = self.min_corner.2 ..= self.min_corner.2 + self.size;

        self.num_drones = drones.iter().filter(|drone|{
            let drone_in_box = 
            cube_x_range.contains(&drone.x) && cube_y_range.contains(&drone.y) && cube_z_range.contains(&drone.z);

            let in_range_of_corners = self.get_corners(self.size).iter().any(|corner| {
                drone.distance_to_point(corner) <= drone.r
            });

            drone_in_box || in_range_of_corners

        }).count();
    }

    fn get_subcubes(&self, drones: &[Drone]) -> Vec<BoundingCube> {
        let new_corners = self.get_corners(self.size >> 1);
        let mut sub_cubes: Vec<BoundingCube> = new_corners.iter().map(|new_corner| BoundingCube{min_corner: *new_corner, size: self.size >> 1, num_drones: 0}).collect();

        for sub_cube in sub_cubes.iter_mut() {
            sub_cube.count_intersecting_drones(&drones);
        }

        sub_cubes
    }
}

impl PartialOrd for BoundingCube {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        let a = (self.num_drones, -self.size, -dist_from_zero(self.min_corner));
        let b = (other.num_drones, -other.size, -dist_from_zero(other.min_corner));
        Some(a.cmp(&b))
    }
}

fn dist_from_zero((x, y, z): (isize, isize, isize)) -> isize {
    x.abs() + y.abs() + z.abs()
}

fn find_most_connected_cell(drones: &[Drone]) -> Option<(isize, isize, isize)> {

    let min_corner = drones.iter().map(|drone| (drone.x - drone.r, drone.y - drone.r, drone.z - drone.r)).min().unwrap();
    let max_corner = drones.iter().map(|drone| (drone.x + drone.r, drone.y + drone.r, drone.z + drone.r)).max().unwrap();

    let x_range = max_corner.0 - min_corner.0;
    let y_range = max_corner.1 - min_corner.1;
    let z_range = max_corner.2 - min_corner.2;

    let biggest_range = isize::max(isize::max(x_range, y_range), z_range);

    let mut next_power_of_2 = 1;
    while next_power_of_2 < biggest_range {
        next_power_of_2 <<= 1;
    }

    let mut bounding_cube = BoundingCube{min_corner, size: next_power_of_2, num_drones: 0};
    bounding_cube.count_intersecting_drones(&drones);

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


pub fn run() -> (usize, isize) {
    let input = include_str!("../input/23.txt").trim_end_matches('\n').split('\n');

    let drones: Vec<Drone> = input.into_iter().map(Drone::from_str).map(Result::unwrap).collect();

    let strongest_drone = drones.iter().max_by_key(|&drone| drone.r).unwrap();
    let in_radius = drones.iter().filter(|&drone| strongest_drone.distance(drone) <= strongest_drone.r).count();

    // P2
    let most_connected_point = find_most_connected_cell(&drones).unwrap();

    (in_radius, dist_from_zero(most_connected_point))
}

#[test]
fn day_23() {
    assert_eq!(run(), (248, 124623002));
}