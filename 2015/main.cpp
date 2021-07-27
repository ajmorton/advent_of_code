#include "src/prelude.hpp"
#include "src/day_18.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_18.txt");
    auto [p1, p2] = day_18(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}