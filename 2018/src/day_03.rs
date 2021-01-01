use itertools::*;
use regex::*;
use std::collections::{HashMap, HashSet};
use std::str::FromStr;

#[derive(Debug)]
struct Request {
    id: usize,
    c: usize,
    r: usize,
    width: usize,
    height: usize,
}

impl FromStr for Request {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        lazy_static! {
            static ref REQUEST_REGEX: Regex =
                Regex::new(r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)").unwrap();
        }
        let captures = REQUEST_REGEX.captures(s).unwrap();
        Ok(Request {
            id: captures[1].parse().unwrap(),
            c: captures[2].parse().unwrap(),
            r: captures[3].parse().unwrap(),
            width: captures[4].parse().unwrap(),
            height: captures[5].parse().unwrap(),
        })
    }
}

pub fn run() -> (usize, usize) {
    let requests: Vec<Request> = include_str!("../input/3.txt")
        .lines()
        .map(Request::from_str)
        .map(Result::unwrap)
        .collect();
    let mut claimed: HashMap<(usize, usize), usize> = HashMap::new();
    let mut all_claims: HashSet<usize> = requests.iter().map(|r| r.id).collect();
    let mut conflicts: HashSet<(usize, usize)> = HashSet::new();

    for req in requests {
        let rows = req.r..req.r + req.height;
        let cols = req.c..req.c + req.width;

        for pos in iproduct!(rows, cols) {
            let f = claimed.get(&pos);
            match f {
                Some(x) => {
                    all_claims.remove(&req.id);
                    all_claims.remove(x);
                    conflicts.insert(pos);
                }
                None => {
                    claimed.insert(pos, req.id);
                }
            }
        }
    }

    let unique_square = all_claims.iter().collect::<Vec<&usize>>()[0];

    (conflicts.len(), *unique_square)
}
