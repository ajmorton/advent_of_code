#include "src/prelude.hpp"
#include "src/day_04.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_04.txt");
    auto [p1, p2] = day_04(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}