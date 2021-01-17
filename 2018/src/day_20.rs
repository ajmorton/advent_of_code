use std::{collections::{BinaryHeap, HashMap}, usize};

type Pos = (isize, isize);
#[derive(PartialEq)]
enum Cell {Wall, DoorNS, DoorEW, Room, Start}

struct Map {
    hashmap: HashMap<Pos,Cell>,
    min_r: isize,
    max_r: isize,
    min_c: isize,
    max_c: isize,
}

impl Map {
    fn new() -> Self {
        Self {
            hashmap: HashMap::new(), 
            min_r: isize::max_value(), 
            max_r: isize::min_value(), 
            min_c: isize::max_value(), 
            max_c: isize::min_value()
        }
    }

    pub fn insert(&mut self, pos: Pos, cell: Cell) {
        self.hashmap.insert(pos, cell);
        self.min_r = isize::min(self.min_r, pos.0 - 1);
        self.max_r = isize::max(self.max_r, pos.0 + 1);
        self.min_c = isize::min(self.min_c, pos.1 - 1);
        self.max_c = isize::max(self.max_c, pos.1 + 1);
    }

    pub fn get(&self, k: &Pos) -> &Cell {
        self.hashmap.get(k).unwrap_or(&Cell::Wall)
    }

    pub fn _print(&self) {
        for r in self.min_r..=self.max_r {
            for c in self.min_c..=self.max_c {
                match self.get(&(r,c)) {
                    Cell::Start => print!("X"),
                    Cell::Wall => print!("#"),
                    Cell::DoorNS => print!("-"),
                    Cell::DoorEW => print!("|"),
                    Cell::Room => print!(".")
                }
            }
            println!();
        }
    }

    fn doors_to_rooms(&self) -> (usize, usize) {

        type Node = (usize, Pos);

        let mut nodes: BinaryHeap<Node> = BinaryHeap::new();
        nodes.push((0, (0,0)));
        let width = self.max_c - self.min_c;
        let height = self.max_r - self.min_r;
        let mut visited = vec![vec![false; height.abs() as usize]; width.abs() as usize];

        let mut max_doors = 0;
        let mut rooms_with_at_least_1000 = 0;

        while let Some((mut cur_doors, cur_pos)) = nodes.pop() {

            max_doors = usize::max(cur_doors, max_doors);
            let cur_cell = self.get(&cur_pos);

            if cur_cell == &Cell::Room && cur_doors >= 1000 {
                rooms_with_at_least_1000 += 1;
            }

            if [Cell::DoorNS, Cell::DoorEW].contains(cur_cell) {
                cur_doors += 1;
            }

            for &neighbour in &neighbours(cur_pos) {
                if self.get(&neighbour) != &Cell::Wall && ! visited[(neighbour.0 - self.min_r).abs() as usize][(neighbour.1 - self.min_c).abs() as usize] {
                    visited[(neighbour.0 - self.min_r).abs() as usize][(neighbour.1 - self.min_c).abs() as usize] = true;
                    nodes.push((cur_doors, neighbour));
                }
            }
        }
        (max_doors, rooms_with_at_least_1000)
    }
}

fn build_map(regex_str: &str) -> Map {

    let mut ptrs_at_level = vec!();
    let mut cur_ptrs = vec!();
    let mut other_ptrs_at_level = vec!();

    let mut map = Map::new();
    map.insert((0,0), Cell::Start);
    cur_ptrs.push((0,0));

    for ch in regex_str.chars() {
        match ch {
            '(' => ptrs_at_level.push(cur_ptrs.clone()),
            ')' => {
                cur_ptrs.extend(ptrs_at_level.pop().unwrap().drain(..));
                cur_ptrs.extend(other_ptrs_at_level.drain(..));
                cur_ptrs.sort_unstable();
                cur_ptrs.dedup();
            },
            '|' => {
                other_ptrs_at_level = cur_ptrs;
                cur_ptrs = ptrs_at_level[ptrs_at_level.len() -1].clone()
            },
            'N' | 'S' | 'E' | 'W' => {
                for ptr in &mut cur_ptrs {
                    match ch {
                        'N' => {
                            map.insert((ptr.0 - 1, ptr.1), Cell::DoorNS);
                            map.insert((ptr.0 - 2, ptr.1), Cell::Room);
                            ptr.0 -= 2;
                        } 
                        'S' => {
                            map.insert((ptr.0 + 1, ptr.1), Cell::DoorNS);
                            map.insert((ptr.0 + 2, ptr.1), Cell::Room);
                            ptr.0 += 2;
                        } 
                        'E' => {
                            map.insert((ptr.0, ptr.1 + 1), Cell::DoorEW);
                            map.insert((ptr.0, ptr.1 + 2), Cell::Room);
                            ptr.1 += 2;
                        } 
                        'W' => {
                            map.insert((ptr.0, ptr.1 - 1), Cell::DoorEW);
                            map.insert((ptr.0, ptr.1 - 2), Cell::Room);
                            ptr.1 -= 2;
                        } 
                        _ => panic!()
                    }
                }
            },
            '^' => {},
            '$' => {return map;},
            _ => panic!(format!("enuexpected character: {}", ch))
        }
    }

    map
}

const fn neighbours(pos: Pos) -> [Pos; 4] {
    [
        (pos.0 - 1, pos.1), 
        (pos.0 + 1, pos.1), 
        (pos.0, pos.1 - 1), 
        (pos.0, pos.1 + 1)
    ]
} 


#[must_use]
pub fn run() -> (usize, usize) {
    let input = include_str!("../input/20.txt").trim_end_matches('\n');
    let map = build_map(input);
    // map.print();

    map.doors_to_rooms()
}

#[test]
fn day_20() {
    assert_eq!(run(), (3885, 8677));
}