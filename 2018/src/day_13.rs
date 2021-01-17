use std::collections::{HashMap, HashSet};

type Pos = (usize, usize);
type Map = [Vec<char>];
type CartID = usize;

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Debug)]
enum Direction { N, E, S, W }

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Debug)]
enum Turn { Left, Straight, Right }

const fn turn(dir: Direction, turn: Turn) -> Direction {
    match turn {
        Turn::Straight => dir,
        Turn::Left => match dir {
            Direction::N => Direction::W,
            Direction::E => Direction::N,
            Direction::S => Direction::E,
            Direction::W => Direction::S,
        },
        Turn::Right => match dir {
            Direction::N => Direction::E,
            Direction::E => Direction::S,
            Direction::S => Direction::W,
            Direction::W => Direction::N,
        },
    }
}

const fn next_turn(turn: Turn) -> Turn {
    match turn {
        Turn::Left => Turn::Straight,
        Turn::Straight => Turn::Right,
        Turn::Right => Turn::Left,
    }
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Debug)]
struct Cart {
    r: usize,
    c: usize,
    direction: Direction,
    next_turn: Turn,
}

impl Cart {
    fn update(mut self, map: &Map) -> Self {
        match self.direction {
            Direction::N => self.r -= 1,
            Direction::E => self.c += 1,
            Direction::S => self.r += 1,
            Direction::W => self.c -= 1,
        }

        // match map[self.r][self.c] {
        match map[self.r][self.c] {
            '+' => {
                self.direction = turn(self.direction, self.next_turn);
                self.next_turn = next_turn(self.next_turn);
            }
            '/' => {
                self.direction = match self.direction {
                    Direction::N => Direction::E,
                    Direction::E => Direction::N,
                    Direction::S => Direction::W,
                    Direction::W => Direction::S,
                }
            }
            '\\' => {
                self.direction = match self.direction {
                    Direction::N => Direction::W,
                    Direction::E => Direction::S,
                    Direction::S => Direction::E,
                    Direction::W => Direction::N,
                }
            }
            _ => {}
        }
        self
    }
}

fn run_carts(carts: HashMap<CartID, Cart>, map: &Map, end_on_first_crash: bool) -> Pos {
    let mut carts = carts;
    let mut positions: HashSet<Pos> = HashSet::new();
    let mut crashed: HashSet<CartID> = HashSet::new();

    for _tick in 0.. {
        carts = carts.into_iter().filter(|(id, _c)| !crashed.contains(id)).collect();
        if carts.iter().len() == 1 {
            let last_cart = carts.into_iter().next().unwrap().1;
            return (last_cart.c, last_cart.r); // flipped to match puzzle coords
        }

        let mut exec_order = carts.iter().collect::<Vec<(&usize, &Cart)>>();
        exec_order.sort_by_key(|(_id, cart)| (cart.r, cart.c));
        let exec_order: Vec<CartID> = exec_order.iter().map(|(&id, _cart)| id).collect();

        for cart_id in exec_order {
            if crashed.contains(&cart_id) {
                continue;
            }
            let mut cart = *carts.get(&cart_id).unwrap();
            positions.remove(&(cart.r, cart.c));
            cart = cart.update(map);

            let new_position = (cart.r, cart.c);

            if positions.contains(&new_position) {
                // println!("CRASH at {:?} time {}!!", (cart.r, cart.c), tick);
                if end_on_first_crash {
                    return (cart.c, cart.r); // flipped to match puzzle coords
                } else {
                    positions.remove(&new_position);
                    crashed.insert(cart_id);
                    let cl = carts.clone();
                    let other_cart = cl.iter().find(|(&_id, &c)| c.r == cart.r && c.c == cart.c).unwrap().0;
                    crashed.insert(*other_cart);
                }
            } else {
                carts.insert(cart_id, cart);
                positions.insert(new_position);
            }
        }
    }
    panic!("unreachable");
}

fn parse_carts(map: &Map) -> HashMap<CartID, Cart> {
    let mut carts = Vec::new();

    // parse carts
    for (r, row) in map.iter().enumerate() {
        for (c, cell) in row.iter().enumerate() {
            let direction = match cell {
                '<' => Some(Direction::W),
                'v' => Some(Direction::S),
                '>' => Some(Direction::E),
                '^' => Some(Direction::N),
                _ => None,
            };

            if let Some(direction) = direction {
                carts.push(Cart {
                    r,
                    c,
                    direction,
                    next_turn: Turn::Left,
                });
            }
        }
    }

    carts.into_iter().enumerate().collect()
}

#[must_use]
pub fn run() -> (Pos, Pos) {
    let input = include_str!("../input/13.txt").trim_end_matches('\n');
    let rows: Vec<&str> = input.split('\n').collect();
    let map: Vec<Vec<char>> = rows.iter().map(|&r| r.chars().collect()).collect();

    let carts = parse_carts(&map);

    // run
    let crash = run_carts(carts.clone(), &map, true);
    let last_cart = run_carts(carts, &map, false);

    (crash, last_cart)
}

#[test]
fn day_13() {
    assert_eq!(run(), ((118, 66), (70, 129)));
}