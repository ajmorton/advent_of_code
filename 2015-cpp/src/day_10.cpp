#include "days.hpp"

int lookAndSay(vector<char>& word1, vector<char>& word2) {
    int ptr1 = 0;
    int ptr2 = 0;
    char curNum = word1[0];
    int curPos = 0;
    while(word1[ptr1++] != 0) {
        if(word1[ptr1] != curNum) {
            word2[ptr2++] = char(ptr1 - curPos);
            word2[ptr2++] = curNum;
            curNum = word1[ptr1];
            curPos = ptr1;
        }
    }
    word2[ptr2] = 0;

    return ptr2;
}

tuple<int, int> day_10(const string& input) {
    int lenNewWord = 0;
    int p1 = 0;

    vector<char> word1(4'000'000, 0);
    vector<char> word2(4'000'000, 0);

    int ptr = 0;
    for(char c: input) { word1[ptr++] = char(c - '0'); }

    for(int loop = 1; loop <= 50; loop++) {
        lenNewWord = lookAndSay(word1, word2);
        if(loop == 40) { p1 = lenNewWord; }
        std::swap(word1, word2);
    }

    return {p1, lenNewWord};
}
