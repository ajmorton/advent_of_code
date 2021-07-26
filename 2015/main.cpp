#include "src/prelude.hpp"
#include "src/day_17.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_17.txt");
    auto [p1, p2] = day_17(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}