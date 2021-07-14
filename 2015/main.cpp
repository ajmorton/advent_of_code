#include "src/prelude.hpp"
#include "src/day_05.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_05.txt");
    auto [p1, p2] = day_05(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}