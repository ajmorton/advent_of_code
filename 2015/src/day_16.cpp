#include "day_16.hpp"

std::map<string, int> knownVals = {
    {"children", 3}, {"cats", 7}, {"samoyeds", 2}, {"pomeranians", 3}, {"akitas", 0}, 
    {"vizslas", 0}, {"goldfish", 5}, {"trees", 3}, {"cars", 2}, {"perfumes", 1}
};

tuple<int, int> day_16(string input) {

    int p1, p2;
    for(string line: splitOn(input, '\n')) {
        stripChars(line, ":,");

        string sue, key;
        int id, val;

        std::istringstream reader(line);
        reader >> sue >> id;

        bool isVal1 = true, isVal2 = true;
        while(reader >> key >> val) {
            isVal1 &= knownVals[key] == val;

            if(key == "cats" || key == "trees") {
                isVal2 &= !knownVals.contains(key) || knownVals[key] <= val;
            } else if(key == "pomeranians" || key == "goldfish") {
                isVal2 &= !knownVals.contains(key) || knownVals[key] > val;
            } else {
                isVal2 &= knownVals[key] == val;
            }
        }
        if(isVal1) { p1 = id; }
        if(isVal2) { p2 = id; }
    }
    return {p1, p2};
}
