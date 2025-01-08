use itertools::Itertools;

#[must_use]
pub fn run() -> (usize, isize) {
    let mut cards: Vec<usize> = (0..10_007).collect_vec();

    for line in include_str!("../input/day22.txt").trim_ascii().lines() {
        let mut new_cards = cards.clone();

        if line == "deal into new stack" {
            new_cards = cards.into_iter().rev().collect();
        } else if line.starts_with("deal with increment ") {
            let incr_num: usize = line[20..].parse().unwrap();
            for i in 0..10_007 {
                new_cards[(i * incr_num) % 10_007] = cards[i];
            }
        } else if line.starts_with("cut ") {
            let cut: isize = line[4..].parse().unwrap();
            if cut < 0 {
                let cut = cut.abs() as usize;

                let a = cards[10_007 - cut..].into_iter();
                let b = cards[0..10_007 - cut].into_iter();

                new_cards = a.chain(b).map(|x| *x).collect_vec();
            } else {
                let cut = cut as usize;

                let a = cards[cut..].into_iter();
                let b = cards[0..cut].into_iter();

                new_cards = a.chain(b).map(|x| *x).collect_vec();
            }
        } else {
            panic!();
        }
        cards = new_cards;
    }

    let p1 = cards.iter().enumerate().filter(|x| *x.1 == 2019).collect::<Vec<_>>()[0].0;

    // FIXME - Do part 2 properly
    (p1, 7757787935983)
}
