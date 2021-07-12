#include "src/prelude.hpp"
#include "src/day_03.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_03.txt");
    auto [p1, p2] = day_03(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}