#[must_use]
pub fn run() -> (usize, String) {
    let mut input = include_str!("../input/day08.txt").trim_ascii().chars();
    let height = 6;
    let width = 25;

    let mut p1 = 0;

    let mut decoded_message: Vec<Vec<Option<char>>> = vec![vec![None; width]; height];

    let mut least_zeros = usize::MAX;
    loop {
        let layer: Vec<_> = input.by_ref().take(height * width).collect();

        if layer.len() < height * width {
            break;
        }

        for (idx, pixel) in layer.iter().enumerate() {
            let r = idx / width;
            let c = idx % width;

            if *pixel != '2' && decoded_message[r][c].is_none() {
                decoded_message[r][c] = Some(*pixel);
            }
        }

        let num_zeros = layer.iter().filter(|c| **c == '0').count();
        let num_ones = layer.iter().filter(|c| **c == '1').count();
        let num_twos = layer.iter().filter(|c| **c == '2').count();

        if num_zeros < least_zeros {
            least_zeros = num_zeros;
            p1 = num_ones * num_twos;
        }
    }

    let mut p2 = String::new();
    for row in decoded_message {
        for pixel in row {
            match pixel.unwrap() {
                '0' => p2 += " ",
                '1' => p2 += "#",
                _ => panic!("bad pixel!"),
            }
        }
        p2 += "\n";
    }

    (p1, p2)
}
