use itertools::Itertools;

fn run_fft(input: &Vec<isize>) -> Vec<isize> {
    let mut cur_num = input.clone();
    let mut new_num: Vec<isize> = vec![];
    let base_pattern = [0, 1, 0, -1];

    for _ in 0 .. 100 {
        for i in 0 .. cur_num.len() {
            let mut n = 0;
            for j in 0 .. cur_num.len() {
                let base_index = (j+1)/ (i + 1);
                n += cur_num[j] * base_pattern[base_index % 4];
            }
            new_num.push(n.abs() % 10);
        }
        cur_num = new_num;
        new_num = vec![];    
    }

    cur_num
}

#[must_use]
pub fn run() -> (isize, isize) {


    let num: Vec<isize> = include_str!("../input/day16.txt").trim_ascii().chars().map(|c| c.to_digit(10).unwrap() as isize).collect();
    let p1_fft = run_fft(&num);
    let p1 = p1_fft[0..8].iter().map(|n| n.to_string()).join("").parse().unwrap();


    // P2
    let offset: usize = num[0..7].iter().map(|n| n.to_string()).join("").parse().unwrap();
    let mut p2_num = num.repeat(10_000);
    let lenn = p2_num.len();

    for _ in 0 .. 100 {
        let mut partial_sum: isize = p2_num[offset..lenn].iter().sum();
        for i in offset .. lenn {
            let t = partial_sum;
            partial_sum -= p2_num[i];
            if t >= 0 {
                p2_num[i] = t % 10;
            } else {
                p2_num[i] = -t % 10;
            }
        }
    }
    let p2 = p2_num[offset..offset+8].iter().map(|n| n.to_string()).join("").parse().unwrap();
    (p1, p2)
}