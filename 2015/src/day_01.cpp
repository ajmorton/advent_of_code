#include "day_01.hpp"
#include <algorithm>

int day_01_01(string input) {
    auto numChars = [input](char c) { return std::count(input.begin(), input.end(), c); };
    return numChars('(') - numChars(')');
}

int day_01_02(string input) {
    int numOpens = 0;
    int numClosed = 0;
    for(char c: input) {
        if (c == '(') { numOpens  += 1; }
        if (c == ')') { numClosed += 1; }
        if (numClosed > numOpens) { return numOpens + numClosed; }
    }
    return -1;
}