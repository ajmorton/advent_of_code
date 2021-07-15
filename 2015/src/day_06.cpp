#include "day_06.hpp"

struct cell_t {int fst; int snd;};
struct instr_t {string action; int min_r; int min_c; int max_r; int max_c;};
const std::regex instrRegex("(turn on|toggle|turn off) (\\d+),(\\d+) through (\\d+),(\\d+)");

instr_t parseInstr(string instr) {
    std::smatch matches;
    std::regex_match(instr, matches, instrRegex);
    return instr_t{matches[1], stoi(matches[2]), stoi(matches[3]), stoi(matches[4]), stoi(matches[5])};
}

tuple<int, int> day_06(string input) {
    vector<cell_t> grid(1000 * 1000, cell_t{0,0});

    for(string line: splitOn(input, '\n')) {
        auto [action, min_r, min_c, max_r, max_c] = parseInstr(line);

        for(int r = min_r; r <= max_r; r++) {
            for(int c = min_c; c <= max_c; c++) {
                auto& cell = grid[1000*r + c];
                if(action == "turn on") {
                    cell = {1, cell.snd + 1};
                } else if (action == "toggle") {
                    cell = {cell.fst ^ 1, cell.snd + 2};
                } else if (action == "turn off") {
                    cell = {0, std::max(cell.snd - 1, 0)};
                }
            }
        }
    }

    auto add_cells = [](cell_t a, cell_t b){return cell_t{a.fst + b.fst, a.snd + b.snd};};
    cell_t result = std::accumulate(grid.begin(), grid.end(), cell_t{0,0}, add_cells);

    return {result.fst, result.snd};
}
