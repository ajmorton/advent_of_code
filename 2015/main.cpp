#include "src/prelude.hpp"
#include "src/day_01.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_01.txt");
    std::cout << "Result = " << day_01_02(input);
    return 0;
}