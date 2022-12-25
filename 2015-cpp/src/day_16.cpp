#include "days.hpp"

const std::map<string, int> knownVals = {
    {"children", 3}, {"cats", 7}, {"samoyeds", 2}, {"pomeranians", 3}, {"akitas", 0}, 
    {"vizslas", 0}, {"goldfish", 5}, {"trees", 3}, {"cars", 2}, {"perfumes", 1}
};

tuple<int, int> day_16(const string& input) {

    int p1 = 0; 
    int p2 = 0;
    for(string line: splitOn(input, '\n')) {
        stripChars(line, ":,");

        string sue, key;
        int id  = 0;
        int val = 0;

        std::istringstream reader(line);
        reader >> sue >> id;

        bool isVal1 = true, isVal2 = true;
        while(reader >> key >> val) {
            isVal1 &= knownVals.at(key) == val;

            if(key == "cats" || key == "trees") {
                isVal2 &= !knownVals.contains(key) || knownVals.at(key) <= val;
            } else if(key == "pomeranians" || key == "goldfish") {
                isVal2 &= !knownVals.contains(key) || knownVals.at(key) > val;
            } else {
                isVal2 &= knownVals.at(key) == val;
            }
        }
        if(isVal1) { p1 = id; }
        if(isVal2) { p2 = id; }
    }
    return {p1, p2};
}
