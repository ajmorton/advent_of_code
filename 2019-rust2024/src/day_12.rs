use regex::Regex;

#[derive(Debug, PartialEq, Copy, Clone)]
struct Kine {
    pos: isize,
    vel: isize,
}

#[derive(Debug)]
struct Moon {
    x: Kine,
    y: Kine,
    z: Kine,
}

const fn energy(moon: &Moon) -> isize {
    let potential = moon.x.pos.abs() + moon.y.pos.abs() + moon.z.pos.abs();
    let kinetic = moon.x.vel.abs() + moon.y.vel.abs() + moon.z.vel.abs();
    potential * kinetic
}

#[must_use]
pub fn run() -> (isize, usize) {
    let input = include_str!("../input/day12.txt").trim_ascii().lines();

    let mut moons: Vec<Moon> = input
        .map(|line| {
            let line_pattern = Regex::new(r"<x=(-?\d+), y=(-?\d+), z=(-?\d+)>").unwrap();
            let pos = line_pattern.captures(line).unwrap();
            let x: isize = pos[1].parse().unwrap();
            let y: isize = pos[2].parse().unwrap();
            let z: isize = pos[3].parse().unwrap();

            Moon {
                x: Kine { pos: x, vel: 0 },
                y: Kine { pos: y, vel: 0 },
                z: Kine { pos: z, vel: 0 },
            }
        })
        .collect();

    let mut p1 = 0;
    let init_x_state = (moons[0].x, moons[1].x, moons[2].x, moons[3].x);
    let mut found_x = None;
    let init_y_state = (moons[0].y, moons[1].y, moons[2].y, moons[3].y);
    let mut found_y = None;
    let init_z_state = (moons[0].z, moons[1].z, moons[2].z, moons[3].z);
    let mut found_z = None;

    for step in 0_usize.. {
        if found_x.is_none() {
            let x_state = (moons[0].x, moons[1].x, moons[2].x, moons[3].x);
            if step != 0 && x_state == init_x_state {
                found_x = Some(step);
            }
        }

        if found_y.is_none() {
            let y_state = (moons[0].y, moons[1].y, moons[2].y, moons[3].y);
            if step != 0 && y_state == init_y_state {
                found_y = Some(step);
            }
        }

        if found_z.is_none() {
            let z_state = (moons[0].z, moons[1].z, moons[2].z, moons[3].z);
            if step != 0 && z_state == init_z_state {
                found_z = Some(step);
            }
        }

        if found_x.is_some() && found_y.is_some() && found_z.is_some() {
            break;
        }

        // Update velocities
        for i in 0..moons.len() {
            for j in i + 1..moons.len() {
                let x_delta = moons[i].x.pos.cmp(&moons[j].x.pos) as isize;
                moons[i].x.vel -= x_delta;
                moons[j].x.vel += x_delta;

                let y_delta = moons[i].y.pos.cmp(&moons[j].y.pos) as isize;
                moons[i].y.vel -= y_delta;
                moons[j].y.vel += y_delta;

                let z_delta = moons[i].z.pos.cmp(&moons[j].z.pos) as isize;
                moons[i].z.vel -= z_delta;
                moons[j].z.vel += z_delta;
            }
        }

        // Moving on up
        for moon in &mut moons {
            moon.x.pos += moon.x.vel;
            moon.y.pos += moon.y.vel;
            moon.z.pos += moon.z.vel;
        }

        if step == 999 {
            p1 = moons.iter().map(energy).sum();
        }
    }

    let p2 = num::integer::lcm(num::integer::lcm(found_x.unwrap(), found_y.unwrap()), found_z.unwrap());
    (p1, p2)
}
