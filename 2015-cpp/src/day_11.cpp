#include "days.hpp"

void incr(string& password) {
    for(int i = int(password.length() -1); i >= 0; i--) {
        switch(password[i]) {
            case 'z': password[i] = 'a'; break;
            case 'h': password[i] = 'j'; return;
            case 'n': password[i] = 'p'; return;
            case 'k': password[i] = 'm'; return;
            default : password[i] += 1; return;
        }
    }
}

bool isValid(const string& password) {

    char prev = '-', prev2 = '-';
    bool banned = false;
    bool trip = false;
    int numPairs = 0;
    for(char c: password) {
        banned   |= c == 'i' || c == 'o' || c == 'l';
        trip     |= (prev2 + 1 == prev) && (prev + 1 == c);
        numPairs += (c == prev && prev2 != c) ? 1 : 0;

        prev2 = prev;
        prev = c;
    }
    return not banned && trip && numPairs >= 2;
}

string findNext(string password) {
    do{ incr(password); } while( not isValid(password) );
    return password;
}

tuple<string, string> day_11(string input) {
    string p1 = findNext(std::move(input));
    string p2 = findNext(p1);
    return {p1, p2};
}
