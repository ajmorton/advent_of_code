use ahash::{AHashMap, AHashSet};
use std::cmp::Reverse;
use std::collections::{BinaryHeap, VecDeque};

type Pos = (isize, isize);
type KeyDoorMap = AHashMap<Pos, usize>;
type Grid = Vec<Vec<char>>;

fn shortest_keys_path(start: Pos, keys: &KeyDoorMap, doors: &KeyDoorMap, grid: &Grid) -> usize {
    let keys_paths = build_paths(start, keys, doors, grid);
    let mut seen = AHashSet::new();
    let keys_needed = keys.values().fold(0, |acc, key| acc | key);

    let mut to_explore = BinaryHeap::new();
    to_explore.push(Reverse((0, start, 0)));
    while let Some(Reverse((dist, pos, keys_found))) = to_explore.pop() {
        if keys_found == keys_needed {
            return dist;
        }

        if seen.insert((pos, keys_found)) {
            for path in &keys_paths[&pos] {
                if path.new_key & keys_found != 0 {
                    continue; // Already found this key
                }

                if path.doors_on_path & keys_found != path.doors_on_path {
                    continue; // Can't reach. Haven't unlocked all doors
                }

                to_explore.push(Reverse((dist + path.dist, path.next_pos, keys_found | path.new_key)));
            }
        }
    }

    unreachable!();
}

fn build_paths(start: Pos, keys: &KeyDoorMap, doors: &KeyDoorMap, grid: &Grid) -> AHashMap<Pos, Vec<Path>> {
    let mut hm = AHashMap::new();
    hm.insert(start, path_to_keys(&start, grid, keys, doors));
    for k in keys {
        hm.insert(*k.0, path_to_keys(k.0, grid, keys, doors));
    }
    hm
}

struct Path {
    dist: usize,
    next_pos: Pos,
    new_key: usize,
    doors_on_path: usize,
}

fn path_to_keys(pos: &Pos, grid: &Grid, keys: &KeyDoorMap, doors: &KeyDoorMap) -> Vec<Path> {
    let mut paths = Vec::new();
    let mut to_explore = VecDeque::new();
    let mut seen = AHashSet::new();

    to_explore.push_back((0_usize, *pos, 0));

    while let Some((dist, pos, doors_on_path)) = to_explore.pop_front() {
        if seen.insert(pos) {
            if let Some(&key) = keys.get(&pos) {
                paths.push(Path { dist, next_pos: pos, new_key: key, doors_on_path });
            }

            for (dr, dc) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
                let next_pos = (pos.0 + dr, pos.1 + dc);
                let next_cell = grid[next_pos.0 as usize][next_pos.1 as usize];
                if next_cell == '#' {
                    continue;
                }

                let mut next_doors_on_path = doors_on_path;
                if doors.contains_key(&next_pos) {
                    next_doors_on_path |= key_idx(next_cell.to_ascii_lowercase());
                }

                to_explore.push_back((dist + 1, next_pos, next_doors_on_path));
            }
        }
    }

    paths
}

const fn key_idx(key: char) -> usize {
    1 << (key as u8 - b'a')
}

fn create_map(input: &str) -> (Pos, KeyDoorMap, KeyDoorMap, Grid) {
    let mut start = (-1, -1);
    let mut keys = KeyDoorMap::new();
    let mut doors = KeyDoorMap::new();

    let grid: Grid = input.lines().map(|line| line.chars().collect()).collect();

    for (r, row) in grid.iter().enumerate() {
        for (c, cell) in row.iter().enumerate() {
            let (r, c) = (r as isize, c as isize);
            match cell {
                'a'..='z' => {
                    keys.insert((r, c), key_idx(*cell));
                }
                'A'..='Z' => {
                    doors.insert((r, c), key_idx(cell.to_ascii_lowercase()));
                }
                '@' => start = (r, c),
                '.' | '#' => {}
                _ => panic!("unexpected cell in map! {cell}"),
            }
        }
    }

    (start, keys, doors, grid)
}

#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/day18.txt");

    let (start, keys, doors, mut grid) = create_map(input);
    let p1 = shortest_keys_path(start, &keys, &doors, &grid);

    for dr in [-1, 0, 1] {
        for dc in [-1, 0, 1] {
            let new_cell = if dr != 0 && dc != 0 { '@' } else { '#' };
            grid[(start.0 + dr) as usize][(start.1 + dc) as usize] = new_cell;
        }
    }

    let quadrant = [(1, 1), (1, -1), (-1, 1), (-1, -1)];

    let mut p2 = 0;
    for &(dr, dc) in quadrant.iter() {
        // No chance I find this by myself. The input is set up so there are any doors with
        // their key in a different quadrant blocks a dead end and never a key that needs picking up.
        // this means we can just treat these doors as dead ends and still pick up all keys.
        let keys = keys
            .clone()
            .into_iter()
            .filter(|((r, c), _)| dr * r > dr * start.0 && dc * c > dc * start.1)
            .collect::<KeyDoorMap>();
        let keys_ids = keys.values().collect::<AHashSet<_>>();
        let doors = doors
            .iter()
            .map(|(&k, &v)| (k, v))
            .filter(|((r, c), _)| dr * r > dr * start.0 && dc * c > dc * start.1)
            .filter(|(_, k)| keys_ids.contains(&k))
            .collect::<KeyDoorMap>();

        let dist = shortest_keys_path((start.0 + dr, start.1 + dc), &keys, &doors, &grid);
        p2 += dist;
    }

    (p1, p2)
}
