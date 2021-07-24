#include "src/prelude.hpp"
#include "src/day_15.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_15.txt");
    auto [p1, p2] = day_15(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}