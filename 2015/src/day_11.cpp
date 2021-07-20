#include "day_11.hpp"

void incr(string& password) {
    for(int i = password.length() -1; i >= 0; i--) {
        switch(password[i]) {
            case 'z': password[i] = 'a'; break;
            case 'h': password[i] = 'j'; return;
            case 'n': password[i] = 'p'; return;
            case 'k': password[i] = 'm'; return;
            default : password[i] += 1; return;
        }
    }
}

bool isValid(string password) {

    char prev = '-', prev2 = '-';
    bool banned = false;
    bool trip = false;
    int numPairs = 0;
    for(char c: password) {
        banned   |= c == 'i' || c == 'o' || c == 'l';
        trip     |= (prev2 + 1 == prev) && (prev + 1 == c);
        numPairs += (c == prev) && (prev2 != c);

        prev2 = prev;
        prev = c;
    }
    return banned == false && trip && numPairs >= 2;
}

string findNext(string password) {
    do{ incr(password); } while( isValid(password) == false );
    return password;
}

tuple<string, string> day_11(string input) {
    string p1 = findNext(input);
    string p2 = findNext(p1);
    return {p1, p2};
}
