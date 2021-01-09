use core::panic;
use std::collections::BinaryHeap;

fn get_erosion_levels(depth: usize, target_r: usize, target_c: usize) -> Vec<Vec<usize>> {
    const BUFFER: usize = 100;
    const MOD: usize = 20183;

    let mut erosion_level = vec![vec![0; target_c + 1 + BUFFER]; depth]; 

    for r in 0..depth {
        erosion_level[r][0] = (r * 48271 + depth) % MOD;
    }

    for c in 0..=target_c + BUFFER{
        erosion_level[0][c] = (c * 16807 + depth) % MOD;
    }

    for r in 1..depth {
        for c in 1..=target_c + BUFFER {
            let left = erosion_level[r][c-1];
            let up = erosion_level[r-1][c];
            erosion_level[r][c] = (((left % MOD) * (up % MOD)) + depth) % MOD;

            if r == target_r && c == target_c {
                erosion_level[r][c] = 0;
            }
        }
    }

    erosion_level
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone, Copy)]
enum Equipment {Torch, ClimbingGear, Neither}

impl Into<usize> for Equipment {
    fn into(self) -> usize {
        match self {
            Equipment::Neither => 0,
            Equipment::ClimbingGear => 1,
            Equipment::Torch => 2
        }
    }
} 

fn neighbours(pos: (usize, usize)) -> Vec<(usize, usize)> {
    let mut neighbours = vec!();
    if pos.0 > 0 {
        neighbours.push((pos.0 -1, pos.1));
    }
    if pos.1 > 0 {
        neighbours.push((pos.0, pos.1 - 1));
    }
    neighbours.push((pos.0 + 1, pos.1));
    neighbours.push((pos.0, pos.1 + 1));
    neighbours
}

enum CaveType {Rocky, Wet, Narrow}

fn cave_type(erosion_level: &usize) -> CaveType {
    match erosion_level % 3 {
        0 => CaveType::Rocky,
        1 => CaveType::Wet,
        2 => CaveType::Narrow,
        _ => panic!(format!("Unknown erosion level {}", erosion_level).as_str())
    }
}

#[derive(PartialEq, Eq, Ord)]
struct Node {
    time: usize,
    pos: (usize, usize),
    equipped: Equipment
}

impl PartialOrd for Node {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.time.cmp(&other.time).reverse())
    }
}

fn allowed_equipment(cave_type: CaveType) -> Vec<Equipment> {
    match cave_type {
        CaveType::Rocky => {vec![Equipment::ClimbingGear, Equipment::Torch]}
        CaveType::Wet => {vec![Equipment::ClimbingGear, Equipment::Neither]}
        CaveType::Narrow => {vec![Equipment::Neither, Equipment::Torch]}
    }
}

fn search(erosion_level: Vec<Vec<usize>>, target: &(usize, usize)) -> Option<usize> {

    let mut nodes: BinaryHeap<Node> = std::collections::BinaryHeap::new();
    nodes.push(Node{time: 0, pos: (0,0), equipped: Equipment::Torch});

    let depth = erosion_level.len();
    let width = erosion_level[0].len();
    let mut visited = vec![vec![[0; 3]; width]; depth];

    const TRAVEL_TIME: usize = 1;
    const TOOL_SWAP_TIME: usize = 7;

    while let Some(node) = nodes.pop() {

        if &node.pos == target && node.equipped == Equipment::Torch{
            return Some(node.time);
        } else if visited[node.pos.0][node.pos.1][node.equipped as usize] != 0 {
            continue;
        }

        visited[node.pos.0][node.pos.1][node.equipped as usize] = node.time;

        for neighbour in neighbours(node.pos).iter() {
            if neighbour.0 >= depth || neighbour.1 >= width {
                continue;
            }

            let cave_type = cave_type(&erosion_level[neighbour.0][neighbour.1]);
            let allowed_equipment = allowed_equipment(cave_type);

            // move to next cell
            if allowed_equipment.contains(&node.equipped) {
                nodes.push(Node{time: node.time + TRAVEL_TIME, pos: *neighbour, equipped: node.equipped});
            }
        }

        // swap equipment
        let cur_cave_type = cave_type(&erosion_level[node.pos.0][node.pos.1]);
        let cur_allowed_equipment = allowed_equipment(cur_cave_type);

        for tool in cur_allowed_equipment {
            if node.equipped != tool {
                nodes.push(Node{time: node.time + TOOL_SWAP_TIME, pos: node.pos, equipped: tool});
            }
        }
    }

    None
}

pub fn run() -> (usize, usize) {
    let input: Vec<&str> = include_str!("../input/22.txt").trim_end_matches('\n').split('\n').into_iter().collect();
    let depth: usize = input[0].trim_start_matches("depth: ").parse::<usize>().unwrap();
    let target: Vec<&str> = input[1].trim_start_matches("target: ").split(',').collect();
    let target_c = target[0].parse::<usize>().unwrap();
    let target_r = target[1].parse::<usize>().unwrap();

    let erosion_level = get_erosion_levels(depth, target_r, target_c);
    
    let mut sum = 0;
    for r in 0..=target_r {
        for c in 0 ..=target_c {
            sum += erosion_level[r][c] % 3;
        }
    }

    (sum, search(erosion_level, &(target_r, target_c)).unwrap())
}
