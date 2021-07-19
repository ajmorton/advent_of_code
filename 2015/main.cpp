#include "src/prelude.hpp"
#include "src/day_10.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_10.txt");
    auto [p1, p2] = day_10(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}