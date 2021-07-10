#include "prelude.hpp"
#include <fstream>

string readFromFile(string fileName) {
    std::ifstream ifs(fileName);
    std::string content( (std::istreambuf_iterator<char>(ifs)), std::istreambuf_iterator<char>());
    return content;
}