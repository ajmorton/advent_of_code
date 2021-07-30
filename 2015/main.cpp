#include "src/prelude.hpp"
#include "src/day_21.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_21.txt");
    auto [p1, p2] = day_21(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}