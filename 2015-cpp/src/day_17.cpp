#include "days.hpp"

int numCombos(int n, vector<int> containers, int numContainers, std::map<int, int>& counts) {

    if(n == 0) { 
        counts[numContainers] += 1;
        return 1; 
    }
    
    while(!containers.empty() && containers.back() > n) {
        containers.pop_back();
    }

    if(containers.empty()) { return 0; }

    int curContainer = containers.back();
    containers.pop_back();
    return numCombos(n - curContainer, containers, numContainers + 1, counts)
         + numCombos(n, containers, numContainers, counts);
}

tuple<int, int> day_17(const string& input) {
    vector<int> containers;
    
    for(const string& line: splitOn(input, '\n')) {
        containers.push_back(stoi(line));
    }
    std::sort(containers.begin(), containers.end());

    std::map<int, int> counts;
    int p1 = numCombos(150, containers, 0, counts);

    // std::map is auto sorted on keys -> .begin() is the smallest key
    int p2 = counts.begin()->second;

    return {p1, p2};
}
