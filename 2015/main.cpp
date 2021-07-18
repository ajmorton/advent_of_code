#include "src/prelude.hpp"
#include "src/day_09.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_09.txt");
    auto [p1, p2] = day_09(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}