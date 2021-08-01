#include "days.hpp"

using stats_t = struct stats_t{string name; int cost; int damage; int armor;};
using fighter_t = struct fighter_t{int hitpoints; int damage; int armor;};

const vector<stats_t> weapons = {
    {"Dagger",     8,  4, 0}, {"Shortsword", 10, 5, 0}, {"Warhammer", 25, 6, 0}, 
    {"Longsword",  40, 7, 0}, {"Greataxe",   74, 8, 0}};

const vector<stats_t> armors = {
    {"Leather",     13, 0, 1}, {"Chainmail",  31,  0, 2}, {"Splintmail",  53, 0, 3}, 
    {"Bandedmail",  75, 0, 4}, {"Platemail",  102, 0, 5}, {"None",         0, 0, 0}};

const vector<stats_t> rings = {
    {"Damage +1",   25, 1, 0}, {"Damage +2",  50, 2, 0}, {"Damage +3",  100, 3, 0}, {"Defense +1", 20, 0, 1},
    {"Defense +2",  40, 0, 2}, {"Defense +3", 80, 0, 3}, {"None 1",       0, 0, 0}, {"None 2",      0, 0, 0}};


bool winsFight(fighter_t fighter, fighter_t boss) {
    while(true) {
        boss.hitpoints -= std::max(1, fighter.damage - boss.armor);
        if(boss.hitpoints <= 0) {return true;}

        fighter.hitpoints -= std::max(1, boss.damage - fighter.armor);
        if(fighter.hitpoints <= 0) {return false;}
    }
}

std::pair<int, int> findCheapest(fighter_t boss) {

    int cheapest = INT_MAX;
    int expensive = 0;

    for(const stats_t& weapon: weapons) {
        for(const stats_t& armor: armors) {
            for(const stats_t& ring1: rings) {
                for(const stats_t& ring2: rings) {
                    if(ring1.name == ring2.name) { continue; }
                    int cost         = 0;
                    int damageRating = 0;
                    int armorRating  = 0;
                    cost         = weapon.cost   + armor.cost   + ring1.cost   + ring2.cost;
                    damageRating = weapon.damage + armor.damage + ring1.damage + ring2.damage;
                    armorRating  = weapon.armor  + armor.armor  + ring1.armor  + ring2.armor;
                    fighter_t fighter = {100, damageRating, armorRating};
                    if(winsFight(fighter, boss)){
                        cheapest = std::min(cheapest, cost);
                    } else {
                        expensive = std::max(expensive, cost);
                    }
                }
            }
        }
    }

    return {cheapest, expensive};
}

tuple<int, int> day_21(const string& input) {
    int hp     = 0;
    int damage = 0;
    int armor  = 0;
    std::sscanf(input.c_str(), "Hit Points: %d\nDamage: %d\nArmor: %d", &hp, &damage, &armor);

    fighter_t boss = {hp, damage, armor};
    return findCheapest(boss);
}
