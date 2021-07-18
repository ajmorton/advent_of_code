#include "day_09.hpp"

typedef string city_t;
typedef int distance_t;

typedef map< tuple<city_t, city_t>, distance_t > distanceBetween_t;

tuple<int, int> day_09(string input) {

    distanceBetween_t distanceBetween;
    std::set<city_t> cities;

    std::smatch matches;
    for(string line: splitOn(input, '\n')) {
        std::regex_match(line, matches, std::regex("(\\w+) to (\\w+) = (\\d+)"));
        city_t city1 = matches[1];
        city_t city2 = matches[2];
        distance_t dist = stoi(matches[3]);

        cities.insert(city1);
        cities.insert(city2);
        distanceBetween[{city1, city2}] = dist;
        distanceBetween[{city2, city1}] = dist;
    }

    vector<city_t> citiesList = vector(cities.begin(), cities.end());

    int shortest = INT_MAX;
    int largest = 0;
    do {
        int pathDist = 0;
        for(int i = 0; i < citiesList.size() - 1; i++) {
            pathDist += distanceBetween[{citiesList[i], citiesList[i+1]}];
        }
        shortest = std::min(shortest, pathDist);
        largest = std::max(largest, pathDist);
    } while( std::next_permutation(citiesList.begin(), citiesList.end()) );

    return {shortest, largest};
}
