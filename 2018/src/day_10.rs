use regex::Regex;
use std::collections::HashSet;
use std::thread::sleep;
use std::time::Duration;

struct Star {
    pos_r: isize,
    pos_c: isize,
    vel_r: isize,
    vel_c: isize,
}

impl Star {
    fn pos_after(&self, t: isize) -> (isize, isize) {
        (self.pos_r + t * self.vel_r, self.pos_c + t * self.vel_c)
    }
}

fn starmap_string(starmap: HashSet<(isize, isize)>) -> String {
    let min_pos_r = starmap.iter().map(|s| s.0).min().unwrap();
    let max_pos_r = starmap.iter().map(|s| s.0).max().unwrap();
    let min_pos_c = starmap.iter().map(|s| s.1).min().unwrap();
    let max_pos_c = starmap.iter().map(|s| s.1).max().unwrap();

    let mut stars_string = String::new();
    for r in min_pos_r..=max_pos_r {
        for c in min_pos_c..=max_pos_c {
            if starmap.contains(&(r, c)) {
                stars_string.push('#');
            } else {
                stars_string.push(' ');
            }
        }
        stars_string.push('\n');
    }
    stars_string
}

pub fn run() -> (String, isize) {
    let input = include_str!("../input/10.txt").trim().split('\n');
    let pattern = Regex::new(r"position=< *(-?\d+), *(-?\d+)> velocity=< *(-?\d+), *(-?\d+)>").unwrap();

    let mut stars = Vec::new();

    for line in input {
        let caps = pattern.captures(line).unwrap();
        let pos_c = caps[1].parse::<isize>().unwrap();
        let pos_r = caps[2].parse::<isize>().unwrap();
        let vel_c = caps[3].parse::<isize>().unwrap();
        let vel_r = caps[4].parse::<isize>().unwrap();

        stars.push(Star {
            pos_r,
            pos_c,
            vel_r,
            vel_c,
        });
    }

    let mut min_size = isize::MAX;
    let mut alignment_time = 0;

    let s = stars.get(0).unwrap();
    let rough_start_time = (s.pos_r / s.vel_r).abs() - 100;

    for t in rough_start_time.. {
        let mut starmap = HashSet::new();
        for star in &stars {
            starmap.insert(star.pos_after(t));
        }

        let min_pos_r = starmap.iter().map(|s| s.0).min().unwrap();
        let max_pos_r = starmap.iter().map(|s| s.0).max().unwrap();
        let min_pos_c = starmap.iter().map(|s| s.1).min().unwrap();
        let max_pos_c = starmap.iter().map(|s| s.1).max().unwrap();

        let size = (max_pos_r - min_pos_r).abs() * (max_pos_c - min_pos_c).abs();
        if size < min_size {
            min_size = size;
            alignment_time = t;
        } else {
            break;
        }

        if max_pos_r - min_pos_r < 100 && max_pos_c - min_pos_c < 100 {
            let stars_string = starmap_string(starmap);
            print!("\x1B[2J"); // clear console
            print!("{}", stars_string);
            sleep(Duration::from_millis(100));
        }
    }

    let aligned_stars = starmap_string(stars.iter().map(|s| s.pos_after(alignment_time)).collect());
    (aligned_stars, alignment_time)
}

#[test]
fn day_10() {
    let stars = concat!(
        "  ##    #    #  ######  #       #        ####     ##    #     \n",
        " #  #   #    #       #  #       #       #    #   #  #   #     \n",
        "#    #  #    #       #  #       #       #       #    #  #     \n",
        "#    #  #    #      #   #       #       #       #    #  #     \n",
        "#    #  ######     #    #       #       #       #    #  #     \n",
        "######  #    #    #     #       #       #       ######  #     \n",
        "#    #  #    #   #      #       #       #       #    #  #     \n",
        "#    #  #    #  #       #       #       #       #    #  #     \n",
        "#    #  #    #  #       #       #       #    #  #    #  #     \n",
        "#    #  #    #  ######  ######  ######   ####   #    #  ######\n"
    )
    .to_string();
    assert_eq!(run(), (stars, 10333));
}