use std::collections::HashMap;

type Map = Vec<Vec<char>>;

#[derive(Debug, Hash, PartialEq, Eq, PartialOrd, Clone, Copy, Ord)]
struct Pos {
    r: usize,
    c: usize,
}
#[derive(Clone, Debug, PartialEq, PartialOrd, Eq, Ord, Copy)]
enum Move {
    Up,
    Left,
    Right,
    Down,
}

#[derive(Debug, Clone, Copy)]
struct Unit {
    race: char,
    health: isize,
    attack: usize,
}

#[derive(Debug, Clone, Copy)]
struct State {
    num_elves: usize,
    num_goblins: usize,
}

fn parse_input(input_str: &str) -> (Map, HashMap<Pos, Unit>, State) {
    let input: Vec<&str> = input_str.trim_end_matches('\n').split('\n').collect();

    let map: Map = input.iter().map(|&line| line.chars().collect()).collect();
    let mut units: HashMap<Pos, Unit> = HashMap::new();

    let mut num_elves = 0;
    let mut num_goblins = 0;

    for (r, row) in map.iter().enumerate() {
        for (c, &cell) in row.iter().enumerate() {
            if cell == 'E' {
                num_elves += 1;
                units.insert(
                    Pos { r, c },
                    Unit {
                        race: cell,
                        health: 200,
                        attack: 3,
                    },
                );
            } else if cell == 'G' {
                num_goblins += 1;
                units.insert(
                    Pos { r, c },
                    Unit {
                        race: cell,
                        health: 200,
                        attack: 3,
                    },
                );
            }
        }
    }

    let state = State { num_elves, num_goblins };
    (map, units, state)
}

fn _print_map(map: &Map) {
    for row in map {
        for cell in row {
            if *cell == 'X' {
                print!("\x1b[0;31m{}\x1b[0m", cell);
            } else if *cell == 'G' {
                print!("\x1b[0;35m{}\x1b[0m", cell);
            } else if *cell == 'E' {
                print!("\x1b[0;32m{}\x1b[0m", cell);
            } else {
                print!("{}", cell);
            }
        }
        println!();
    }
}

fn manhattan_dist(p1: &Pos, p2: &Pos) -> usize {
    ((p1.r as isize - p2.r as isize).abs() + (p1.c as isize - p2.c as isize).abs()) as usize
}

fn path_to_nearest(start: Pos, enemy: char, map: &Map) -> Option<Vec<Move>> {
    let mut paths: Vec<(Pos, Vec<Move>)> = Vec::new();
    let mut visited: Vec<Vec<bool>> = map.iter().map(|r| r.iter().map(|_c| false).collect()).collect();

    let open_tiles = vec!['.', 'X'];

    paths.push((start, vec![]));

    loop {
        paths.sort_by(|a, b| {
            let aa = (a.1.len(), a.0, &a.1);
            let bb = (b.1.len(), b.0, &b.1);
            aa.cmp(&bb)
        });

        if paths.is_empty() {
            break;
        }

        let (cur_pos, path_to) = paths.remove(0);
        if visited[cur_pos.r][cur_pos.c] {
            continue;
        }

        visited[cur_pos.r][cur_pos.c] = true;

        if map[cur_pos.r - 1][cur_pos.c] == enemy
            || map[cur_pos.r + 1][cur_pos.c] == enemy
            || map[cur_pos.r][cur_pos.c - 1] == enemy
            || map[cur_pos.r][cur_pos.c + 1] == enemy
        {
            return Some(path_to);
        }

        if open_tiles.contains(&map[cur_pos.r - 1][cur_pos.c]) && !visited[cur_pos.r - 1][cur_pos.c] {
            let mut new_path = path_to.clone();
            new_path.push(Move::Up);
            paths.push((
                Pos {
                    r: cur_pos.r - 1,
                    c: cur_pos.c,
                },
                new_path,
            ));
        }

        if open_tiles.contains(&map[cur_pos.r][cur_pos.c - 1]) && !visited[cur_pos.r][cur_pos.c - 1] {
            let mut new_path = path_to.clone();
            new_path.push(Move::Left);
            paths.push((
                Pos {
                    r: cur_pos.r,
                    c: cur_pos.c - 1,
                },
                new_path,
            ));
        }

        if open_tiles.contains(&map[cur_pos.r][cur_pos.c + 1]) && !visited[cur_pos.r][cur_pos.c + 1] {
            let mut new_path = path_to.clone();
            new_path.push(Move::Right);
            paths.push((
                Pos {
                    r: cur_pos.r,
                    c: cur_pos.c + 1,
                },
                new_path,
            ));
        }

        if open_tiles.contains(&map[cur_pos.r + 1][cur_pos.c]) && !visited[cur_pos.r + 1][cur_pos.c] {
            let mut new_path = path_to.clone();
            new_path.push(Move::Down);
            paths.push((
                Pos {
                    r: cur_pos.r + 1,
                    c: cur_pos.c,
                },
                new_path,
            ));
        }
    }

    None
}

fn fight(map: &Map, units: &HashMap<Pos, Unit>, state: &State) -> (usize, usize, usize) {
    let mut map = map.clone();
    let mut units = units.clone();
    let mut state = *state;

    for t in 0.. {
        let units_copy = units.clone();
        let mut positions_to_update: Vec<&Pos> = units_copy.keys().into_iter().collect();
        positions_to_update.sort_by(|a, b| a.cmp(&b).reverse());

        while !positions_to_update.is_empty() {
            let mut cur_pos = *positions_to_update.pop().unwrap();
            let bar = units.clone();
            let cur_unit = bar.get(&cur_pos);
            if cur_unit.is_none() {
                continue;
            }
            let cur_unit = cur_unit.unwrap();

            let enemy_positions: Vec<Pos> = units
                .iter()
                .filter_map(|(&pos, u)| if u.race != cur_unit.race { Some(pos) } else { None })
                .collect();

            let enemy = if cur_unit.race == 'G' { 'E' } else { 'G' };
            let shortest_path = path_to_nearest(cur_pos, enemy, &map);
            if shortest_path.is_none() {
                continue;
            }
            let shortest_path = shortest_path.unwrap();

            if !shortest_path.is_empty() {
                let next_move = shortest_path[0];

                //move
                let new_pos = match next_move {
                    Move::Up => Pos {
                        r: cur_pos.r - 1,
                        c: cur_pos.c,
                    },
                    Move::Left => Pos {
                        r: cur_pos.r,
                        c: cur_pos.c - 1,
                    },
                    Move::Right => Pos {
                        r: cur_pos.r,
                        c: cur_pos.c + 1,
                    },
                    Move::Down => Pos {
                        r: cur_pos.r + 1,
                        c: cur_pos.c,
                    },
                };

                map[cur_pos.r][cur_pos.c] = '.';
                map[new_pos.r][new_pos.c] = cur_unit.race;

                units.remove(&cur_pos);
                units.insert(new_pos, *cur_unit);

                cur_pos = new_pos;
            }

            // attack

            let mut adjacent_enemies: Vec<&Pos> = enemy_positions
                .iter()
                .filter(|&enemy_pos| manhattan_dist(&cur_pos, enemy_pos) == 1)
                .collect();

            adjacent_enemies.sort_by_key(|&pos| (units.get(pos).unwrap().health, pos));

            if !adjacent_enemies.is_empty() {
                let weakest_enemy_pos = adjacent_enemies.remove(0);
                let enemy = units.get_mut(weakest_enemy_pos).unwrap();
                enemy.health -= cur_unit.attack as isize;
                if enemy.health <= 0 {
                    // kill
                    if map[weakest_enemy_pos.r][weakest_enemy_pos.c] == 'E' {
                        state.num_elves -= 1;
                    } else if map[weakest_enemy_pos.r][weakest_enemy_pos.c] == 'G' {
                        state.num_goblins -= 1;
                    }

                    map[weakest_enemy_pos.r][weakest_enemy_pos.c] = 'X';
                    units.remove(weakest_enemy_pos);

                    if state.num_elves == 0 || state.num_goblins == 0 {
                        let remaining_health: isize = units.iter().map(|(_pos, u)| u.health).sum();
                        let mut num_full_turns = t;
                        if positions_to_update.is_empty() {
                            // all moves made in this round
                            num_full_turns += 1;
                        }
                        let num_remaining_elves = units.iter().filter(|(_pos, unit)| unit.race == 'E').count();
                        return (num_full_turns, remaining_health as usize, num_remaining_elves);
                    }
                }
            };
        }

        // print!("\x1B[2J"); // clear console
        // println!();
        // println!("{}", state.tick);
        // print_map(&map);
        // std::thread::sleep(Duration::from_millis(500));
    }
    panic!("unreachable");
}

fn find_first_survivable_conflict(map: &Map, units: HashMap<Pos, Unit>, state: &State) -> usize {
    let num_elves_start = units.iter().filter(|(_pos, unit)| unit.race == 'E').count();

    let mut updated_units = units;

    let update_attack_power = |atk, units: HashMap<Pos, Unit>| {
        units
            .into_iter()
            .map(|mut it| {
                if it.1.race == 'E' {
                    it.1.attack = atk;
                }
                it
            })
            .collect()
    };

    // exp backoff
    let mut attack_power = 4;
    loop {
        updated_units = update_attack_power(attack_power, updated_units);

        let (_tick, _remaining_health, num_elves_remaining) = fight(&map, &updated_units, &state);
        if num_elves_remaining == num_elves_start {
            break; // return tick * remaining_health;
        }
        attack_power *= 2;
    }

    for attack_power in attack_power / 2 + 1..attack_power {
        updated_units = update_attack_power(attack_power, updated_units);

        let (tick, remaining_health, num_elves_remaining) = fight(&map, &updated_units, &state);
        if num_elves_remaining == num_elves_start {
            return tick * remaining_health;
        }
    }

    panic!("unreachable");
}

pub fn run() -> (usize, usize) {
    let input_str = include_str!("../input/15.txt");
    let (map, units, state) = parse_input(input_str);

    let (tick, remaining_health, _) = fight(&map, &units, &state);
    let p1 = tick * remaining_health;

    // P2
    (p1, find_first_survivable_conflict(&map, units, &state))
}

#[test]
fn day_15() {
    assert_eq!(run(), (206720, 37992));
}

#[test]
fn scen_1() {
    let input_str = include_str!("../input/15.test_1.txt");
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (47, 590, 0));
}

#[test]
fn scen_2() {
    let input_str = include_str!("../input/15.test_2.txt");
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (37, 982, 5));
}

#[test]
fn scen_3() {
    let input_str = include_str!("../input/15.test_3.txt");
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (46, 859, 5));
}

#[test]
fn scen_4() {
    let input_str = include_str!("../input/15.test_4.txt");
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (35, 793, 0));
}

#[test]
fn scen_5() {
    let input_str = include_str!("../input/15.test_5.txt");
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (54, 536, 0));
}

#[test]
fn scen_6() {
    let input_str = include_str!("../input/15.test_6.txt");
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (20, 937, 0));
}
