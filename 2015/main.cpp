#include "src/prelude.hpp"
#include "src/day_20.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_20.txt");
    auto [p1, p2] = day_20(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}