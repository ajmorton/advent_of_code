#include "day_22.hpp"

enum Effect{Shielded = 0, Poisoned = 1, Recharging = 2};

enum Result{InProgress, Win, Lose};
enum Spell{MagicMissile = 0, Drain = 1, Shield = 2, Poison = 3, Recharge = 4};

typedef struct fighter_t{
    int hp; 
    int damage; 
    int armor; 
    int mana; 
    int effectCounters[3] = {0};

    bool attack(int attackPower) {
        int hit = attackPower - armor;
        if(effectCounters[Shielded] > 0) {hit -= 7;}
        hp -= std::max(1, hit);
        return hp <= 0;
    }

    bool applyEffects() {

        if(effectCounters[Shielded]  == 1) {armor -= 7;  }
        if(effectCounters[Poisoned]   > 0) {hp    -= 3;  }
        if(effectCounters[Recharging] > 0) {mana  += 101;}

        effectCounters[Shielded]   -= 1;
        effectCounters[Poisoned]   -= 1;
        effectCounters[Recharging] -= 1;

        return hp <= 0;
    }

} fighter_t;

typedef struct state_t{
    int manaSpent; 
    fighter_t hero; 
    fighter_t boss; 
    Result result;

    bool operator<(state_t other) const {
        return this->manaSpent > other.manaSpent;
    }
} state_t;

std::map<Spell, int> spellCosts({
    {MagicMissile, 53}, {Drain, 73}, {Shield, 113}, {Poison, 173}, {Recharge, 229}
}); 

bool setEffect(fighter_t& fighter, Effect effect, int count) {
    if(fighter.effectCounters[effect] > 0) {return false;}
    fighter.effectCounters[effect] = count;
    return true;
}

bool castSpell(Spell spell, fighter_t& hero, fighter_t& boss, int& manaSpent) {
    if(spellCosts[spell] > hero.mana) { return false; } 

    hero.mana -= spellCosts[spell];
    manaSpent += spellCosts[spell];

    switch(spell) {
        case MagicMissile: boss.attack(4);              return true;
        case Drain:        boss.attack(2); hero.hp +=2; return true;
        case Shield:       return setEffect(hero, Shielded,   6);
        case Poison:       return setEffect(boss, Poisoned,   6);
        case Recharge:     return setEffect(hero, Recharging, 5);
    }
}

std::optional<state_t> tick(state_t state, Spell nextSpell, bool hardMode) {
    fighter_t& hero = state.hero;
    fighter_t& boss = state.boss;

    if(hardMode) {
        hero.hp -= 1;
        if(hero.hp <= 0) {
            return std::nullopt;
        }
    }

    if(boss.applyEffects()) { state.result = Win; return state; }
    if(hero.applyEffects()) { return std::nullopt; };

    if(castSpell(nextSpell, hero, boss, state.manaSpent) == false){ return std::nullopt; }

    if(boss.applyEffects()) { state.result = Win; return state; }
    if(hero.applyEffects()) { return std::nullopt; };

    if(hero.attack(boss.damage)) { return std::nullopt; };

    return state;
}

int findCheapest(fighter_t boss, bool hardMode) {

    fighter_t hero = {50, 0, 0, 500};
    vector<state_t> toExplore = { state_t{0, hero, boss, {}} };

    state_t curState;
    while(toExplore.size() > 0) {
        // pop heap
        std::pop_heap(toExplore.begin(), toExplore.end());
        curState = toExplore.back();
        toExplore.pop_back();

        if(curState.result == Win) {
            return curState.manaSpent;
        
        } else {
            for(Spell spell: {MagicMissile, Drain, Shield, Poison, Recharge}) {
                std::optional<state_t> nextState = tick(curState, spell, hardMode);
                if(nextState.has_value()) {
                    toExplore.push_back(nextState.value());
                    std::push_heap(toExplore.begin(), toExplore.end());
                }
            }
        }
    }

    return -1;
}

tuple<int, int> day_22(string input) {

    int hp, damage;
    std::sscanf(input.c_str(), "Hit Points: %d\nDamage: %d", &hp, &damage);
    fighter_t boss = {hp, damage, 0, 0};

    return {findCheapest(boss, false), findCheapest(boss, true)};
}
