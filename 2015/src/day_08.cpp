#include "day_08.hpp"

int encodedStringDecrease(string line) {
    string newLine;
    for(int i = 0; i < line.length(); i++) {
        if(line[i] == '\\') {
            switch(line[i+1]) {
                case '\\': newLine += '\\'; i += 1; break;
                case '"':  newLine +=  '"'; i += 1; break;
                case 'x':  newLine +=  '_'; i += 3; break;
            }
        } else {
            newLine += line[i];
        }
    }
    return (line.length() - newLine.length()) + 2;
}

int decodedStringIncrease(string line) {
    string newLine = "";
    for(char c: line) {
        switch (c) {
            case '\\': newLine += "\\\\"; break;
            case '"':  newLine += "\\\""; break;
            default:   newLine += c;      break;
        }
    }
    return (newLine.length() - line.length()) + 2;
}

tuple<int, int> day_08(string input) {
    int decrease = 0;
    int increase = 0;
    for(string line: splitOn(input, '\n')) {
        decrease += encodedStringDecrease(line);
        increase += decodedStringIncrease(line);
    }
    return {decrease, increase};
}
