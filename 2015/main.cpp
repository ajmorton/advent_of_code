#include "src/prelude.hpp"
#include "src/day_02.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_02.txt");
    auto [p1, p2] = day_02(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}