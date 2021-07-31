#include "src/prelude.hpp"
#include "src/day_22.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_22.txt");
    auto [p1, p2] = day_22(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}