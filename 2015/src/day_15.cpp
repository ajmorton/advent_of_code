#include "days.hpp"

struct ingr_t{char name[20]; int capacity; int durability; int flavour; int texture; int calories;};

tuple<int, int> day_15(string input) {
    vector<ingr_t> ingredients;

    for(string line: splitOn(input, '\n')) {
        ingr_t i;
        sscanf(
            line.c_str(), 
            "%[a-zA-Z]: capacity %d, durability %d, flavor %d, texture %d, calories %d",
            i.name, &i.capacity, &i.durability, &i.flavour, &i.texture, &i.calories
        );
        ingredients.push_back(i);
    }

    int maxScore1 = 0, maxScore2 = 0;
    ingr_t i1 = ingredients[0];
    ingr_t i2 = ingredients[1];
    ingr_t i3 = ingredients[2];
    ingr_t i4 = ingredients[3];
    for(int i = 0; i <= 100; i++) {
        for(int j = 0; j <= 100; j++) {
            for(int k = 0; k <= 100; k++) {
                if(i + j + k <= 100) {
                    int l = 100 - i - j - k;
        
                    int capScore = std::max(i*i1.capacity   + j*i2.capacity   + k*i3.capacity   + l*i4.capacity,   0);
                    int durScore = std::max(i*i1.durability + j*i2.durability + k*i3.durability + l*i4.durability, 0);
                    int flaScore = std::max(i*i1.flavour    + j*i2.flavour    + k*i3.flavour    + l*i4.flavour,    0);
                    int texScore = std::max(i*i1.texture    + j*i2.texture    + k*i3.texture    + l*i4.texture,    0);
                    int calScore = std::max(i*i1.calories   + j*i2.calories   + k*i3.calories   + l*i4.calories,   0);

                    int score = capScore * durScore * flaScore * texScore;
                    maxScore1 = std::max(maxScore1, score);
                    if(calScore == 500) {
                        maxScore2 = std::max(maxScore2, score);
                    }
                }
            }
        }
    }
    
    return {maxScore1, maxScore2};
}
