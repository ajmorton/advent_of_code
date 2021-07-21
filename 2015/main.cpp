#include "src/prelude.hpp"
#include "src/day_12.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_12.txt");
    auto [p1, p2] = day_12(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}