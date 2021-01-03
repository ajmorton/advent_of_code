pub fn run() -> (usize, usize) {
    let input = [1, 1, 0, 2, 0, 1];
    let input_len = input.len();
    let target_recipes = input.iter().fold(0, |acc, n| acc * 10 + n);

    let mut recipes: Vec<usize> = vec![3, 7];
    let mut recipes_len = recipes.len();

    let mut ptr_1 = 0;
    let mut ptr_2 = 1;

    let mut p1 = 0;
    let mut p1_found = false;

    loop {
        let mut new_recipe = recipes[ptr_1] + recipes[ptr_2];
        let num_new_recipes = if new_recipe > 9 { 2 } else { 1 };

        if new_recipe > 9 {
            recipes.push(new_recipe / 10);
            new_recipe %= 10;
        }
        recipes.push(new_recipe);
        recipes_len += num_new_recipes;

        if !p1_found && recipes_len > target_recipes + 10 {
            p1 = recipes[target_recipes..target_recipes + 10]
                .iter()
                .fold(0, |acc, n| acc * 10 + n);
            p1_found = true;
        }

        if recipes_len > 10 {
            if num_new_recipes == 2
                && &recipes[recipes_len - 1 - input_len..recipes_len - 1] == input
            {
                recipes_len -= 1;
                break;
            }

            if &recipes[recipes_len - input_len..recipes_len] == input {
                break;
            }
        }

        ptr_1 = (ptr_1 + recipes[ptr_1] + 1) % recipes_len;
        ptr_2 = (ptr_2 + recipes[ptr_2] + 1) % recipes_len;
    }

    (p1, recipes_len - 6)
}
