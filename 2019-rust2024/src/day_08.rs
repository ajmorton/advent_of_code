use std::iter::zip;

#[must_use]
pub fn run() -> (usize, String) {
    let mut input = include_str!("../input/day08.txt").trim_ascii().chars();
    let height = 6;
    let width = 25;

    let mut p1 = 0;

    let mut decoded_message: Vec<Option<char>> = vec![None; height * width];

    let mut least_zeros = usize::MAX;
    loop {
        let layer: Vec<_> = input.by_ref().take(height * width).collect();

        if layer.len() < height * width {
            break;
        }

        decoded_message = zip(&layer, decoded_message)
            .map(|(layer_pix, decoded_pix)| {
                if decoded_pix.is_none() && *layer_pix != '2' {
                    Some(*layer_pix)
                } else {
                    decoded_pix
                }
            })
            .collect();

        let num_zeros = layer.iter().filter(|c| **c == '0').count();
        let num_ones = layer.iter().filter(|c| **c == '1').count();
        let num_twos = layer.iter().filter(|c| **c == '2').count();

        if num_zeros < least_zeros {
            least_zeros = num_zeros;
            p1 = num_ones * num_twos;
        }
    }

    let mut p2 = String::new();
    for (idx, pixel) in decoded_message.iter().enumerate() {
        match pixel.unwrap() {
            '0' => p2 += " ",
            '1' => p2 += "#",
            _ => panic!("bad pixel!"),
        }
        if idx % width == width - 1 {
            p2 += "\n";
        }
    }

    (p1, p2)
}
