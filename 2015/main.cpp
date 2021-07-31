#include "src/prelude.hpp"
#include "src/day_23.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_23.txt");
    auto [p1, p2] = day_23(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}