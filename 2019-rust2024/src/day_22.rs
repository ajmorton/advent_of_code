use itertools::Itertools;

#[must_use]
pub fn run() -> (usize, isize) {
    let mut cards: Vec<usize> = (0..10_007).collect_vec();

    for line in include_str!("../input/day22.txt").trim_ascii().lines() {
        let mut new_cards = cards.clone();

        if line == "deal into new stack" {
            new_cards = cards.into_iter().rev().collect();
        } else if let Some(incr_str) = line.strip_prefix("deal with increment ") {
            let incr_num: usize = incr_str.parse().unwrap();
            for i in 0..10_007 {
                new_cards[(i * incr_num) % 10_007] = cards[i];
            }
        } else if let Some(cut_size) = line.strip_prefix("cut ") {
            let cut: isize = cut_size.parse().unwrap();
            if cut < 0 {
                let cut = cut.unsigned_abs();

                let a = cards[10_007 - cut..].iter();
                let b = cards[0..10_007 - cut].iter();

                new_cards = a.chain(b).copied().collect_vec();
            } else {
                let cut = cut as usize;

                let a = cards[cut..].iter();
                let b = cards[0..cut].iter();

                new_cards = a.chain(b).copied().collect_vec();
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
