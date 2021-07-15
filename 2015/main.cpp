#include "src/prelude.hpp"
#include "src/day_06.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_06.txt");
    auto [p1, p2] = day_06(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}