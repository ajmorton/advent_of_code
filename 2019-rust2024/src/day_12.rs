use ahash::AHashSet;
use regex::Regex;

#[derive(Debug)]
struct Moon {
    x: isize,
    y: isize,
    z: isize,
    vx: isize,
    vy: isize,
    vz: isize,
}

fn energy(moon: &Moon) -> isize {
    let potential = moon.x.abs() + moon.y.abs() + moon.z.abs();
    let kinetic = moon.vx.abs() + moon.vy.abs() + moon.vz.abs();
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
                x,
                y,
                z,
                vx: 0,
                vy: 0,
                vz: 0,
            }
        })
        .collect();

    let mut p1 = 0;
    let mut x_state = AHashSet::new();
    let mut found_x = None;
    let mut y_state = AHashSet::new();
    let mut found_y = None;
    let mut z_state = AHashSet::new();
    let mut found_z = None;
    for step in 0 as usize.. {
        if found_x.is_none() {
            let xx = (
                moons[0].x,
                moons[0].vx,
                moons[1].x,
                moons[1].vx,
                moons[2].x,
                moons[2].vx,
                moons[3].x,
                moons[3].vx,
            );
            if x_state.contains(&xx) {
                found_x = Some(step);
            } else {
                x_state.insert(xx);
            }
        }

        if found_y.is_none() {
            let yy = (
                moons[0].y,
                moons[0].vy,
                moons[1].y,
                moons[1].vy,
                moons[2].y,
                moons[2].vy,
                moons[3].y,
                moons[3].vy,
            );
            if y_state.contains(&yy) {
                found_y = Some(step);
            } else {
                y_state.insert(yy);
            }
        }

        if found_z.is_none() {
            let zz = (
                moons[0].z,
                moons[0].vz,
                moons[1].z,
                moons[1].vz,
                moons[2].z,
                moons[2].vz,
                moons[3].z,
                moons[3].vz,
            );
            if z_state.contains(&zz) {
                found_z = Some(step);
            } else {
                z_state.insert(zz);
            }
        }

        if found_x.is_some() && found_y.is_some() && found_z.is_some() {
            break;
        }

        // Update velocities
        for i in 0..moons.len() {
            for j in i + 1..moons.len() {
                let x_delta = moons[i].x.cmp(&moons[j].x) as isize;
                moons[i].vx -= x_delta;
                moons[j].vx += x_delta;

                let y_delta = moons[i].y.cmp(&moons[j].y) as isize;
                moons[i].vy -= y_delta;
                moons[j].vy += y_delta;

                let z_delta = moons[i].z.cmp(&moons[j].z) as isize;
                moons[i].vz -= z_delta;
                moons[j].vz += z_delta;
            }
        }

        // Moving on up
        for i in 0..moons.len() {
            moons[i].x += moons[i].vx;
            moons[i].y += moons[i].vy;
            moons[i].z += moons[i].vz;
        }

        if step == 999 {
            p1 = moons.iter().map(|m| energy(m)).sum();
        }
    }

    let p2 = num::integer::lcm(num::integer::lcm(found_x.unwrap(), found_y.unwrap()), found_z.unwrap());
    (p1, p2)
}
