#include "days.hpp"

int day_01_01(const string& input) {
    auto numChars = [input](char c) { return std::count(input.begin(), input.end(), c); };
    return int(numChars('(') - numChars(')'));
}

int day_01_02(const string& input) {
    int numOpens = 0;
    int numClosed = 0;
    for(char c: input) {
        if (c == '(') { numOpens  += 1; }
        if (c == ')') { numClosed += 1; }
        if (numClosed > numOpens) { return numOpens + numClosed; }
    }
    return -1;
}

tuple<int, int> day_01(const string& input) {
    return {day_01_01(input), day_01_02(input)};
}