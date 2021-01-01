use regex::Regex;
use std::collections::{HashMap, HashSet};

fn get_time(job: &String) -> usize {
    vec![
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
        "S", "T", "U", "V", "W", "X", "Y", "Z",
    ]
    .iter()
    .position(|c| c == job)
    .unwrap()
        + 60
}

fn assemble(
    deps_map: &HashMap<String, HashSet<String>>,
    queue_size: usize,
    time_fn: fn(&String) -> usize,
) -> (String, usize) {
    let mut tick = 0;

    let mut deps_map = deps_map.clone();

    let mut order = String::from("");
    let foo = deps_map.clone();
    let all_dependents: HashSet<String> = foo.values().cloned().flatten().collect();
    let all_depends_on: HashSet<String> = foo.keys().cloned().collect();
    let mut can_finish: HashSet<String> = all_depends_on
        .difference(&all_dependents)
        .cloned()
        .collect();

    let mut in_progress: HashMap<String, usize> = HashMap::new();

    while !can_finish.is_empty() || !in_progress.is_empty() {
        tick += 1;

        // decr in progress
        for (job, &time_left) in in_progress.clone().iter() {
            if time_left == 0 {
                order.push_str(job);
                in_progress.remove(job);

                let dependents = deps_map.remove(job);
                if dependents.is_some() {
                    let remaining_dependents = deps_map.values().cloned().flatten().collect();
                    let new_cfs: HashSet<String> = dependents
                        .unwrap()
                        .difference(&remaining_dependents)
                        .cloned()
                        .collect();
                    can_finish.extend(new_cfs.into_iter());
                }
            } else {
                in_progress.entry(job.clone()).and_modify(|v| *v -= 1);
            }
        }

        if in_progress.len() == queue_size {
            continue;
        } else {
            while in_progress.len() < queue_size && !can_finish.is_empty() {
                let cf = can_finish.iter().min().unwrap().to_owned();
                can_finish.remove(&cf);
                let job_time = time_fn(&cf);
                in_progress.insert(cf, job_time);
            }
        }
    }

    return (order, tick - 1);
}

pub fn run() -> (String, usize) {
    let input = include_str!("../input/7.txt").trim().split('\n');
    let dependency_pattern =
        Regex::new(r"Step ([A-Z]) must be finished before step ([A-Z]) can begin.").unwrap();

    let mut deps_map: HashMap<String, HashSet<String>> = HashMap::new();

    for line in input {
        let caps = dependency_pattern.captures(line).unwrap();
        let depends_on = caps[1].to_string();
        let dependent = caps[2].to_string();
        deps_map.entry(depends_on).or_default().insert(dependent);
    }

    (
        assemble(&deps_map, 1, |_f| 0).0,
        assemble(&deps_map, 5, get_time).1,
    )
}
