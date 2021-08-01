#include "day_24.hpp"

long bestQuantum(vector<vector<int>> possibleCombos) {
    auto quantumScore = [](vector<int> v){return std::accumulate(v.begin(), v.end(), 1L, std::multiplies<long>());};

    long minQuantum = LONG_MAX;
    for(auto combo: possibleCombos) {
        minQuantum = std::min(minQuantum, quantumScore(combo));
    }
    return minQuantum;
}

unsigned nextNumSameOneBits(unsigned n) {
    if (n == 0) return n;
    unsigned leastSig    = n & -n;
    unsigned incr        = n + leastSig;
    unsigned newLeastSig = incr & -incr;
    unsigned shift       = newLeastSig / leastSig;

    unsigned bitShift = (shift >> 1) - 1;
    return incr | bitShift;
}

vector<vector<int>> validCombinations(int n, vector<int> weights, int targetWeight) {

    vector<vector<int>> validCombos;
    int k = weights.size();
    unsigned mask = (1 << n) - 1;

    while((mask & (1<<k)) == 0) {

        int weightsSum = 0;
        for(int i = 0; i < k; i++) {
            if(((1 << i) & mask) != 0) {
                weightsSum += weights[i];
            }
        }

        if(weightsSum == targetWeight) {
            vector<int> valCombo;
            for(int i = 0; i < k; i++) {
                if(((1 << i) & mask) != 0) {
                    valCombo.push_back(weights[i]);
                }
            }
            validCombos.push_back(valCombo);
        }

        mask = nextNumSameOneBits(mask);
    }

    return validCombos;
}

long bestConfig(vector<int> weights, int numContainers) {
    int totalWeight  = std::accumulate(weights.begin(), weights.end(), 0);
    int targetWeight = totalWeight / numContainers;
    int numPackages  = weights.size();

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
