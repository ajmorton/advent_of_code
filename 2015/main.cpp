#include "src/prelude.hpp"
#include "src/day_08.hpp"

int main(int argc, char** argv) {
    string input = readFromFile("input/day_08.txt");
    auto [p1, p2] = day_08(input);
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    return 0;
}