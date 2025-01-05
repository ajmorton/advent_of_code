use crate::intcode::{IntComputer, RetCode};
use std::thread::sleep;
use std::time;

type Screen = [[Tile; 36]; 21];

#[derive(PartialEq, Copy, Clone)]
enum Tile {
    Empty = 0,
    Wall = 1,
    Block = 2,
    Paddle = 3,
    Ball = 4,
}

fn process_frame(computer: &mut IntComputer, screen: &mut Screen) -> (Option<isize>, bool, isize, isize) {
    let mut outputs = vec![];

    let mut game_done = false;
    let mut score = None;
    let mut ball_x = -1;
    let mut paddle_x = -1;

    loop {
        match computer.run() {
            RetCode::Done(_) => {
                game_done = true;
                break;
            }
            RetCode::NeedInput => break,
            RetCode::Output(out) => outputs.push(out),
        };
    }

    let mut tiles = outputs.chunks(3);
    while let Some(tile) = tiles.next() {
        let (x, y, id) = (tile[0], tile[1], tile[2]);
        if x == -1 && y == 0 {
            score = Some(id);
        } else {
            let tile = match id {
                0 => Tile::Empty,
                1 => Tile::Wall,
                2 => Tile::Block,
                3 => Tile::Paddle,
                4 => Tile::Ball,
                _ => panic!("asdasdasda"),
            };

            if tile == Tile::Ball {
                ball_x = x;
            }
            if tile == Tile::Paddle {
                paddle_x = x;
            }
            screen[y as usize][x as usize] = tile;
        }
    }

    (score, game_done, ball_x, paddle_x)
}

#[allow(dead_code)]
fn print_screen(screen: &Screen, score: isize) {
    println!("\x1B[2J\x1B[1;1H");
    for r in 0..=20 {
        for c in 0..=35 {
            print!("{}", match screen[r][c] {
                Tile::Empty => " ",
                Tile::Wall => "|",
                Tile::Block => "#",
                Tile::Paddle => "=",
                Tile::Ball => "O",
            });
        }
        println!("");
    }
    println!("{score}");
    sleep(time::Duration::from_millis(10));
}

#[must_use]
pub fn run() -> (usize, isize) {
    let prog: Vec<isize> = include_str!("../input/day13.txt")
        .trim_ascii()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let mut screen: Screen = [[Tile::Empty; 36]; 21];

    let mut computer = IntComputer::new(&prog, vec![]);
    let (_, _, _, _) = process_frame(&mut computer, &mut screen);
    let p1 = screen
        .iter()
        .map(|row| row.iter().filter(|t| **t == Tile::Block).count())
        .sum();

    // P2
    let p2;
    let mut score = 0;
    let mut piracy = prog.clone();
    piracy[0] = 2;
    let mut computer_p2 = IntComputer::new(&piracy, vec![]);
    loop {
        let (frame_score, game_done, ball_x, paddle_x) = process_frame(&mut computer_p2, &mut screen);
        if let Some(sscore) = frame_score {
            score = sscore;
        }

        // print_screen(&screen, score);

        if game_done {
            p2 = score;
            break;
        } else {
            let move_paddle = ball_x.cmp(&paddle_x) as isize;
            computer_p2.input(move_paddle);
        }
    }

    (p1, p2)
}
