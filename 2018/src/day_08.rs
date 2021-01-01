struct Node {
    children: Vec<Node>,
    metadata: Vec<usize>,
}

impl Node {
    fn sum_metadata(&self) -> usize {
        return self.metadata.iter().sum::<usize>()
            + self
                .children
                .iter()
                .map(|c| c.sum_metadata())
                .sum::<usize>();
    }

    fn get_value(&self) -> usize {
        if self.children.len() == 0 {
            self.metadata.iter().sum()
        } else {
            self.metadata
                .iter()
                .filter_map(|m| self.children.get(m - 1))
                .map(|c| c.get_value())
                .sum()
        }
    }
}

fn create_nodes<I>(nums: I) -> (Node, I)
where
    I: Iterator<Item = usize>,
{
    let mut nums = nums;
    let num_children = nums.next().unwrap();
    let num_metadata = nums.next().unwrap();
    let mut children = Vec::new();
    let mut metadata = Vec::new();

    for _i in 0..num_children {
        let (child, remaining_nums) = create_nodes(nums);
        nums = remaining_nums;
        children.push(child);
    }

    for _i in 0..num_metadata {
        metadata.push(nums.next().unwrap());
    }

    (Node { children, metadata }, nums)
}

pub fn run() -> (usize, usize) {
    let input: Vec<usize> = include_str!("../input/8.txt")
        .trim()
        .split(' ')
        .map(|x| x.parse::<usize>().unwrap())
        .collect();
    let (root, _remaining_nums) = create_nodes(input.into_iter());

    (root.sum_metadata(), root.get_value())
}
