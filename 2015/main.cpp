#include "src/prelude.hpp"
#include "src/day_07.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_07.txt");
    auto [p1, p2] = day_07(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}