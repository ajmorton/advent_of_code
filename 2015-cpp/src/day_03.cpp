#include "days.hpp"

using pos_t = struct pos_t{int x = 0; int y = 0;};
using visitedMap = map<tuple<int, int>, int>;

void deliver(const string& path, visitedMap& visited) {
    visited[{0,0}] = 1;
    int x = 0, y = 0;

    for(char step: path) {
        switch (step) {
            case '^': y += 1; break;
            case '>': x += 1; break;
            case 'v': y -= 1; break;
            case '<': x -= 1; break;
        }
        visited[{x, y}] += 1;
    }
}

tuple<int, int> day_03(const string& input) {

    visitedMap visited1, visited2;
    deliver(input, visited1);

    std::array<string, 2> splitPaths;
    for(int i = 0; i < input.length(); i++) {
        splitPaths.at(i % 2) += input[i];
    }
    deliver(splitPaths[0], visited2);
    deliver(splitPaths[1], visited2);

    return { visited1.size(), visited2.size() };
}
