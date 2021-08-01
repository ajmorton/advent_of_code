#include "days.hpp"

typedef int cityGrid_t[10][10];

tuple<int, int> findPaths(int cityGrid[10][10], int numCities){
    int shortest = INT_MAX;
    int largest = 0;

    vector<int> paths(numCities);
    std::iota(paths.begin(), paths.end(), 0);

    do {
        int pathDist = 0;
        for(int i = 0; i < numCities - 1; i++) {
            pathDist += cityGrid[paths[i]][paths[i+1]];
        }
        shortest = std::min(shortest, pathDist);
        largest = std::max(largest, pathDist);
    } while( std::next_permutation(paths.begin(), paths.end()) );

    return {shortest, largest};
}

int readInCities(string input, cityGrid_t& cityGrid) {
    std::map<string, int> cityIds;
    int numCities = 0;

    std::smatch matches;
    for(string line: splitOn(input, '\n')) {
        std::regex_match(line, matches, std::regex("(\\w+) to (\\w+) = (\\d+)"));
        string city1 = matches[1];
        string city2 = matches[2];
        int dist = stoi(matches[3]);

        if(cityIds.contains(city1) == false) { cityIds[city1] = numCities++; }
        if(cityIds.contains(city2) == false) { cityIds[city2] = numCities++; }

        int cityId1 = cityIds[city1];
        int cityId2 = cityIds[city2];

        cityGrid[cityId1][cityId2] = dist;
        cityGrid[cityId2][cityId1] = dist;
    }
    return numCities;
}

tuple<int, int> day_09(string input) {
    cityGrid_t cityGrid;
    int numCities = readInCities(input, cityGrid);

    return findPaths(cityGrid, numCities);
}
