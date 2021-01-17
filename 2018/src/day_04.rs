use regex::Regex;
use std::collections::HashMap;

#[must_use]
pub fn run() -> (usize, usize) {
    type Schedule = [usize; 60];
    type GuardID = usize;

    let mut lines: Vec<&str> = include_str!("../input/4.txt").trim_end().split('\n').collect();
    lines.sort_unstable();

    let line_pattern = Regex::new(r"\[\d+-\d+-\d+ \d+:(\d+)\] (.*)").unwrap();

    let mut guard_schedules: HashMap<GuardID, Schedule> = HashMap::new();

    let mut cur_guard = 0;
    let mut sleep_start = 0;

    for line in lines {
        let caps = line_pattern.captures(line).unwrap();
        let minute: usize = caps[1].parse().unwrap();
        let event = caps[2].to_string();

        if event.contains("begins shift") {
            let split: Vec<&str> = event.split_whitespace().collect();
            cur_guard = split[1].trim_start_matches('#').to_string().parse::<usize>().unwrap();

            guard_schedules.entry(cur_guard).or_insert([0; 60]);
        } else if event == "wakes up" {
            guard_schedules.entry(cur_guard).and_modify(|shift| {
                for min in &mut shift[sleep_start..minute] {
                    *min += 1;
                }
            });
        } else if event == "falls asleep" {
            sleep_start = minute;
        }
    }

    let (laziest_guard, most_minutes) = guard_schedules
        .iter()
        .max_by_key::<usize, _>(|elem| elem.1.iter().sum())
        .unwrap();

    let best_minute = most_minutes
        .iter()
        .position(|x| x == most_minutes.iter().max().unwrap())
        .unwrap();

    let p1 = laziest_guard * best_minute;

    let (most_freq_guard, minutes) = guard_schedules
        .iter()
        .max_by_key::<usize, _>(|elem| *elem.1.iter().max().unwrap())
        .unwrap();

    let most_freq_minute = minutes
        .iter()
        .position(|x| x == minutes.iter().max().unwrap())
        .unwrap();

    let p2 = most_freq_guard * most_freq_minute;

    (p1, p2)
}

#[test]
fn day_04() {
    assert_eq!(run(), (14346, 5705));
}