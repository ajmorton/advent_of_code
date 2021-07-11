#include "prelude.hpp"
#include <fstream>
#include <sstream>

string readFromFile(string fileName) {
    std::ifstream ifs(fileName);
    std::string content( (std::istreambuf_iterator<char>(ifs)), std::istreambuf_iterator<char>());
    return content;
}

vector<string> splitOn(string input, char ch) {
    std::stringstream inputStream(input);
    string line;
    vector<string> lines;

    while(std::getline(inputStream, line, ch)) {
        lines.push_back(line);
    }
    return lines;
}