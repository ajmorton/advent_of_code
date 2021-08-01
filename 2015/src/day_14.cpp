#include "days.hpp"

struct deer_t{string name; int speed; int travel; int rest; int score;};

int distanceAfter(deer_t deer, int time) {
    int fullCycles = time / (deer.travel + deer.rest);
    int partialCycle = std::min(time % (deer.travel + deer.rest), deer.travel);
    int secondsTravelling = (fullCycles * deer.travel) + partialCycle;
    return secondsTravelling * deer.speed;
}

tuple<int, int> day_14(string input) {
    char name[20];
    int speed, travel, rest;

    vector<deer_t> deers;
    for(string line: splitOn(input, '\n')) {
        sscanf(line.c_str(), "%s can fly %d km/s for %d seconds, but then must rest for %d seconds.", name, &speed, &travel, &rest);
        deers.push_back({string(name), speed, travel, rest});
    }

    int maxDistance = 0;
    for(deer_t deer: deers) { maxDistance = std::max(maxDistance, distanceAfter(deer, 2503)); }

    for(int t = 1; t <= 2503; t++) {
        int maxDistAtTime = 0;
        for(deer_t deer: deers)  { maxDistAtTime = std::max(maxDistAtTime, distanceAfter(deer, t)); }
        for(deer_t& deer: deers) { deer.score += distanceAfter(deer, t) == maxDistAtTime; }
    }

    int maxScore = 0;
    for(deer_t deer: deers) { maxScore = std::max(maxScore, deer.score); }

    return {maxDistance, maxScore};
}
