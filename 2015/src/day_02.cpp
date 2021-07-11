#include "day_02.hpp"
#include <algorithm>

tuple<int, int> day_02(string input) {
    int totalArea = 0;
    int totalRibbon = 0;

    for(string line: splitOn(input, '\n')) {
        int h, w, d;
        std::sscanf(line.c_str(), "%dx%dx%d", &h, &w, &d);
        vector<int> dim = {h, w, d};

        std::sort(dim.begin(), dim.end());

        totalArea   += 3*(dim[0] * dim[1]) + 2*(dim[1] * dim[2]) + 2*(dim[2] * dim[0]);
        totalRibbon += 2*(dim[0] + dim[1]) + (dim[0] * dim[1] * dim[2]);
    }
    return {totalArea, totalRibbon};
}