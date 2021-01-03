use std::collections::HashMap;

type Map = Vec<Vec<char>>;

#[derive(Debug, Hash, PartialEq, Eq, PartialOrd, Clone, Copy, Ord)]
struct Pos {
    r: usize,
    c: usize,
}
#[derive(Clone, Debug, PartialEq, PartialOrd, Copy)]
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

    let state = State {
        num_elves,
        num_goblins,
    };
    (map, units, state)
}

// fn print_map(map: &Map) {
//     for row in map {
//         for cell in row {
//             if *cell == 'X' {
//                 print!("\x1b[0;31m{}\x1b[0m", cell);
//             } else if *cell == 'G' {
//                 print!("\x1b[0;35m{}\x1b[0m", cell);
//             } else if *cell == 'E' {
//                 print!("\x1b[0;32m{}\x1b[0m", cell);
//             } else {
//                 print!("{}", cell);
//             }
//         }
//         println!();
//     }
// }

fn manhattan_dist(p1: &Pos, p2: &Pos) -> usize {
    ((p1.r as isize - p2.r as isize).abs() + (p1.c as isize - p2.c as isize).abs()) as usize
}

fn path_to_nearest(start: Pos, enemy: char, map: &Map) -> Option<Vec<Move>> {
    let mut paths: Vec<(Pos, Vec<Move>)> = Vec::new();
    let mut visited: Vec<Vec<bool>> = map
        .iter()
        .map(|r| r.iter().map(|_c| false).collect())
        .collect();

    let open_tiles = vec!['.', 'X'];

    paths.push((start, vec![]));

    loop {
        paths.sort_by(|a, b| {
            let len_cmp = a.1.len().partial_cmp(&b.1.len()).unwrap().reverse();
            match len_cmp {
                std::cmp::Ordering::Equal => {
                    let pos_cmp = a.0.partial_cmp(&b.0).unwrap().reverse();
                    match pos_cmp {
                        std::cmp::Ordering::Equal => {
                            let path_cmp = a.1.partial_cmp(&b.1).unwrap().reverse();
                            match path_cmp {
                                std::cmp::Ordering::Equal => panic!(),
                                _ => path_cmp,
                            }
                        }
                        _ => pos_cmp,
                    }
                }
                _ => len_cmp,
            }
        });

        let next_path = paths.pop();
        if next_path.is_none() {
            break;
        }

        let (cur_pos, path_to) = next_path.unwrap();
        if visited[cur_pos.r][cur_pos.c] == true {
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

        if open_tiles.contains(&map[cur_pos.r - 1][cur_pos.c]) && !visited[cur_pos.r - 1][cur_pos.c]
        {
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

        if open_tiles.contains(&map[cur_pos.r][cur_pos.c - 1]) && !visited[cur_pos.r][cur_pos.c - 1]
        {
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

        if open_tiles.contains(&map[cur_pos.r][cur_pos.c + 1]) && !visited[cur_pos.r][cur_pos.c + 1]
        {
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

        if open_tiles.contains(&map[cur_pos.r + 1][cur_pos.c]) && !visited[cur_pos.r + 1][cur_pos.c]
        {
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
    let mut state = state.clone();

    for t in 0.. {
        let foo = units.clone();
        let mut positions_to_update: Vec<&Pos> = foo.keys().into_iter().collect();
        positions_to_update.sort_by(|a, b| a.partial_cmp(&b).unwrap().reverse());

        while positions_to_update.len() > 0 {
            let mut cur_pos = positions_to_update.pop().unwrap().clone();
            let bar = units.clone();
            let cur_unit = bar.get(&cur_pos);
            if cur_unit.is_none() {
                continue;
            }
            let cur_unit = cur_unit.unwrap();

            let enemy_positions: Vec<Pos> = units
                .iter()
                .filter_map(|(&pos, u)| {
                    if u.race != cur_unit.race {
                        Some(pos)
                    } else {
                        None
                    }
                })
                .collect();

            let enemy = if cur_unit.race == 'G' { 'E' } else { 'G' };
            let shortest_path = path_to_nearest(cur_pos, enemy, &map);
            if shortest_path.is_none() {
                continue;
            }
            let shortest_path = shortest_path.unwrap();

            if shortest_path.len() > 0 {
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
            adjacent_enemies.sort_by(|&a, &b| {
                let health_a = units.get(a).unwrap().health;
                let health_b = units.get(b).unwrap().health;
                let health_cmp = health_a.cmp(&health_b).reverse();
                match health_cmp {
                    std::cmp::Ordering::Equal => a.cmp(&b).reverse(),
                    _ => health_cmp,
                }
            });

            let weakest_enemy_pos = adjacent_enemies.pop();

            if weakest_enemy_pos.is_some() {
                let weakest_enemy_pos = weakest_enemy_pos.unwrap();
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
                        if positions_to_update.len() == 0 {
                            // all moves made in this round
                            num_full_turns += 1;
                        }
                        let num_remaining_elves = units
                            .iter()
                            .filter(|(_pos, unit)| unit.race == 'E')
                            .collect::<Vec<_>>()
                            .len();
                        return (
                            num_full_turns,
                            remaining_health as usize,
                            num_remaining_elves,
                        );
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

pub fn run() -> (usize, usize) {
    let input_str = include_str!("../input/15.txt");
    let (map, units, state) = parse_input(input_str);

    let (tick, remaining_health, _) = fight(&map, &units, &state);
    let p1 = tick * remaining_health;

    // P2
    let num_elves_start = units
        .iter()
        .filter(|(_pos, unit)| unit.race == 'E')
        .collect::<Vec<_>>()
        .len();

    let mut p2 = 0;
    let mut updated_units = units.clone();
    for attack_power in 4.. {
        updated_units = updated_units
            .into_iter()
            .map(|mut it| {
                if it.1.race == 'E' {
                    it.1.attack = attack_power;
                }
                it
            })
            .collect();

        let (tick, remaining_health, num_elves_remaining) = fight(&map, &updated_units, &state);
        if num_elves_remaining == num_elves_start {
            p2 = tick * remaining_health;
            break;
        }
    }
    (p1, p2)
}

#[test]
fn scen_1() {
    let input_str = concat!(
        "#######\n",
        "#.G...#\n",
        "#...EG#\n",
        "#.#.#G#\n",
        "#..G#E#\n",
        "#.....#\n",
        "#######\n"
    );
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (47, 590, 0));
}

#[test]
fn scen_2() {
    let input_str = concat!(
        "#######\n",
        "#G..#E#\n",
        "#E#E.E#\n",
        "#G.##.#\n",
        "#...#E#\n",
        "#...E.#\n",
        "#######\n"
    );
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (37, 982, 5));
}

#[test]
fn scen_3() {
    let input_str = concat!(
        "#######\n",
        "#E..EG#\n",
        "#.#G.E#\n",
        "#E.##E#\n",
        "#G..#.#\n",
        "#..E#.#\n",
        "#######\n"
    );
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (46, 859, 5));
}

#[test]
fn scen_4() {
    let input_str = concat!(
        "#######\n",
        "#E.G#.#\n",
        "#.#G..#\n",
        "#G.#.G#\n",
        "#G..#.#\n",
        "#...E.#\n",
        "#######\n"
    );
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (35, 793, 0));
}

#[test]
fn scen_5() {
    let input_str = concat!(
        "#######\n",
        "#.E...#\n",
        "#.#..G#\n",
        "#.###.#\n",
        "#E#G#G#\n",
        "#...#G#\n",
        "#######\n"
    );
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (54, 536, 0));
}

#[test]
fn scen_6() {
    let input_str = concat!(
        "#########\n",
        "#G......#\n",
        "#.E.#...#\n",
        "#..##..G#\n",
        "#...##..#\n",
        "#...#...#\n",
        "#.G...G.#\n",
        "#.....G.#\n",
        "#########\n"
    );
    let (map, units, state) = parse_input(input_str);
    assert_eq!(fight(&map, &units, &state), (20, 937, 0));
}
