#include "src/prelude.hpp"
#include "src/day_19.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_19.txt");
    auto [p1, p2] = day_19(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}