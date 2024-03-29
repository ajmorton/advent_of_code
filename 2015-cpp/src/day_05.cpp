#include "days.hpp"

bool isNice(string line) {
    auto notSubstr = [line](const string& sub){ return line.find(sub) == string::npos; };
    bool noDissallowed = notSubstr("ab") && notSubstr("cd") && notSubstr("pq") && notSubstr("xy");

    auto isVowel = [](char c){ return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'; };    
    long numVowels = std::count_if(line.begin(), line.end(), isVowel);

    bool hasDouble = false;
    for(int i = 0; i < line.length() - 1; i++) {
        hasDouble |= line[i] == line[i+1];
    }

    return (numVowels >= 3) && hasDouble && noDissallowed;
}

bool isNice2(string line) {
    bool occursTwice = false;
    bool plusTwo = false;
    for(int i = 0; i < line.length() - 2; i++) {
        string subst = line.substr(i, 2);
        occursTwice |= line.substr(i + 2).find(subst) != string::npos;
        plusTwo |= line[i] == line[i + 2];
    }
    return occursTwice && plusTwo;
}

tuple<long, long> day_05(const string& input) {
    vector<string> lines = splitOn(input, '\n');
    long numNice1 = std::count_if(lines.begin(), lines.end(), isNice);
    long numNice2 = std::count_if(lines.begin(), lines.end(), isNice2);

    return { numNice1, numNice2 };
}
