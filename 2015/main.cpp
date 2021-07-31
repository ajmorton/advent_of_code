#include "src/prelude.hpp"
#include "src/day_24.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_24.txt");
    auto [p1, p2] = day_24(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}