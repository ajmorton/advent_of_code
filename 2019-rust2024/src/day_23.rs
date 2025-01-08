use std::collections::VecDeque;

use crate::intcode::{IntComputer, RetCode};

#[derive(PartialEq, Copy, Clone, Debug)]
struct Packet {
    x: isize,
    y: isize,
}

#[must_use]
pub fn run() -> (isize, isize) {
    let prog: Vec<isize> = include_str!("../input/day23.txt")
        .trim_ascii()
        .split(',')
        .map(|n| n.parse().unwrap())
        .collect();

    let mut nics = vec![];
    let mut messages: Vec<VecDeque<Packet>> = vec![];
    for network_address in 0..50 {
        nics.push(IntComputer::new(&prog, vec![network_address]));
        messages.push(VecDeque::new());
    }

    let mut nat_packet = None;
    let mut last_sent_to_zero = None;
    let mut idle_count = 0;

    let mut p1 = None;
    let p2;
    'network: loop {
        if idle_count >= 2 {
            messages[0].push_back(nat_packet.unwrap());
            if !last_sent_to_zero.is_none() && last_sent_to_zero.unwrap() == nat_packet.unwrap() {
                p2 = nat_packet.unwrap().y;
                break 'network;
            }
            last_sent_to_zero = nat_packet;
            idle_count = 0;
        }

        idle_count += 1;
        for i in 0..50 {
            let res = nics[i].run();
            match res {
                RetCode::Done(_) => {
                    println!("        nic {i} halted")
                }
                RetCode::NeedInput => {
                    if let Some(packet) = messages[i].pop_front() {
                        nics[i].input(packet.x);
                        nics[i].input(packet.y);
                    } else {
                        nics[i].input(-1);
                    }
                }
                RetCode::Output(dest) => {
                    let out_x = if let RetCode::Output(out) = nics[i].run() {
                        out
                    } else {
                        panic!("a")
                    };

                    let out_y = if let RetCode::Output(out) = nics[i].run() {
                        out
                    } else {
                        panic!("a")
                    };

                    idle_count = 0;
                    if dest == 255 {
                        if p1.is_none() {
                            p1 = Some(out_y);
                        }
                        nat_packet = Some(Packet { x: out_x, y: out_y });
                    } else {
                        messages[dest as usize].push_back(Packet { x: out_x, y: out_y });
                    }
                }
            }
        }
    }

    (p1.unwrap(), p2)
}
