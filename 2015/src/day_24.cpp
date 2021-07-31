#include "day_24.hpp"

long bestQuantum(vector<vector<int>> possibleCombos) {
    auto quantumScore = [](vector<int> v){return std::accumulate(v.begin(), v.end(), 1L, std::multiplies<long>());};

    long minQuantum = LONG_MAX;
    for(auto combo: possibleCombos) {
        minQuantum = std::min(minQuantum, quantumScore(combo));
    }
    return minQuantum;
}

vector<vector<int>> validCombinations(int n, vector<int> weights, int targetWeight) {

    vector<vector<int>> totalCombos;
    int k = weights.size();

    auto sum = [](vector<int> v){ return std::accumulate(v.begin(), v.end(), 0);};

    vector<bool> mask(k, false);
    for(int i = 0; i < n; i++) {
        mask[i] = true;
    }

    std::sort(mask.begin(), mask.end());

    do {
        vector<int> possibleCombo;
        for(int i = 0; i < k; i++) {
            if(mask[i]) {
                possibleCombo.push_back(weights[i]);
            }
        }

        if(sum(possibleCombo) == targetWeight) {
            totalCombos.push_back(possibleCombo);
        }
    } while(std::next_permutation(mask.begin(), mask.end()));

    return totalCombos;
}

long bestConfig(vector<int> weights, int numContainers) {
    int totalWeight = std::accumulate(weights.begin(), weights.end(), 0);
    int targetWeight = totalWeight / numContainers;

    int numPackages = weights.size();

    vector<vector<int>> validCombos;

    for(int n = 1; n <= numPackages; n++) {
        validCombos = validCombinations(n, weights, targetWeight);
        if(validCombos.empty() == false) {
            break;
        }
    }

    return bestQuantum(validCombos);
}

tuple<long, long> day_24(string input) {
    vector<int> packageWeights;

    std::istringstream reader(input);
    int packageWeight;
    while(reader >> packageWeight) {
        packageWeights.push_back(packageWeight);
    }

    return { bestConfig(packageWeights, 3), bestConfig(packageWeights, 4) };
}
