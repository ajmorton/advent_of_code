#include "day_10.hpp"

string lookAndSay(string line) {
    std::stringstream sstream;
    for(auto pos = line.begin(); pos != line.end(); ) {
        auto nextPos = std::find_if(pos, line.end(), [pos](char c){return c != *pos;});
        sstream << (nextPos - pos) << *pos;
        pos = nextPos;
    }
    return sstream.str();
}

tuple<int, int> day_10(string input) {

    int p1;
    for(int i = 1; i <= 50; i++) {
        input = lookAndSay(input);
        if(i == 40) {p1 = input.length();}
    }

    return {p1, input.length()};
}
