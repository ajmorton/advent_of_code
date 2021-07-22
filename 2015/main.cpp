#include "src/prelude.hpp"
#include "src/day_13.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_13.txt");
    auto [p1, p2] = day_13(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}