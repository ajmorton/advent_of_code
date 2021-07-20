#include "src/prelude.hpp"
#include "src/day_11.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_11.txt");
    auto [p1, p2] = day_11(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}