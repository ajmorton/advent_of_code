#include "days.hpp"

vector<int> factors(int n) {
    vector<int> factors;
    for(int i = 1; i <= sqrt(n); i++) {
        if(n % i == 0) {
            factors.push_back(i);
            factors.push_back(n / i);
        }
    }

    // sqrt is added twice above
    if(factors.back() * factors.back() == n) {
        factors.pop_back();
    }
    return factors;
}

tuple<int, int> day_20(string input) {
    int n = stoi(input);

    auto [p1Found, p2Found] = tuple{false, false};
    auto [p1, p2] = tuple{0, 0};

    // numbers with many factors will have a higher sum of factors
    int base = 1*2*3*5*7;
    for(int i = base; ; i += base) {
        vector<int> facs = factors(i);
        auto [p1Sum, p2Sum] = tuple{0, 0};
        for(auto fac: facs) {
            p1Sum += fac;
            if(i / fac <= 50) {
                p2Sum += fac;
            }
        }

        if(!p1Found && p1Sum * 10 >= n) {p1 = i; p1Found = true;}
        if(!p2Found && p2Sum * 11 >= n) {p2 = i; p2Found = true;}
        if(p1Found && p2Found) { break; }
    }

    return {p1, p2};
}
