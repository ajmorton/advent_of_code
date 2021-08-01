#include "days.hpp"

using combo_t = vector<int>;

long bestQuantum(const vector<combo_t>& possibleCombos) {
    auto quantumScore = [](combo_t v){return std::accumulate(v.begin(), v.end(), 1L, std::multiplies<>());};

    long minQuantum = LONG_MAX;
    for(const combo_t& combo: possibleCombos) {
        minQuantum = std::min(minQuantum, quantumScore(combo));
    }
    return minQuantum;
}

unsigned nextNumSameOneBits(unsigned n) {
    if (n == 0) { return n; };
    unsigned leastSig    = n & -n;
    unsigned incr        = n + leastSig;
    unsigned newLeastSig = incr & -incr;
    unsigned shift       = newLeastSig / leastSig;

    unsigned bitShift = (shift >> 1) - 1;
    return incr | bitShift;
}

vector<combo_t> validCombinations(int n, combo_t weights, int targetWeight) {

    vector<combo_t> validCombos;
    int k = int(weights.size());
    unsigned mask = (1 << n) - 1;

    while((mask & (1<<k)) == 0) {

        int weightsSum = 0;
        for(int i = 0; i < k; i++) {
            if(((1 << i) & mask) != 0) {
                weightsSum += weights[i];
            }
        }

        if(weightsSum == targetWeight) {
            combo_t valCombo;
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

long bestConfig(combo_t weights, int numContainers) {
    int totalWeight  = std::accumulate(weights.begin(), weights.end(), 0);
    int targetWeight = totalWeight / numContainers;
    int numPackages  = int(weights.size());

    vector<combo_t> validCombos;
    for(int n = 1; n <= numPackages; n++) {
        validCombos = validCombinations(n, weights, targetWeight);
        if(not validCombos.empty()) {
            break;
        }
    }
    return bestQuantum(validCombos);
}

tuple<long, long> day_24(const string& input) {
    combo_t packageWeights;

    std::istringstream reader(input);
    int packageWeight = 0;
    while(reader >> packageWeight) {
        packageWeights.push_back(packageWeight);
    }

    return { bestConfig(packageWeights, 3), bestConfig(packageWeights, 4) };
}
