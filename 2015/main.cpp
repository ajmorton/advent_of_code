#include "src/prelude.hpp"
#include "src/day_25.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_25.txt");
    auto [p1, p2] = day_25(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}