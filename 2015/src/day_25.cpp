#include "days.hpp"

int sigma(int n) {
    int sum = 0;
    for(int i = 1; i <= n; i++) {
        sum += i;
    }
    return sum;
}

tuple<long, long> day_25(string input) {
    int targetRow, targetCol;
    sscanf(input.c_str(), 
           "To continue, please consult the code grid in the manual.  Enter the code at row %d, column %d.", 
           &targetRow, 
           &targetCol);

    int pos = sigma(targetRow + targetCol - 2) + targetCol - 1;

    // modular exp
    long base = 252533;
    long mod = 33554393;
    long exponent = pos;

    long result = 1;
    while(exponent > 0) {
        if(exponent % 2 == 1) {
            result = (result * base) % mod;
        }
        exponent >>= 1;
        base = (base * base) % mod;
    }

    // mult by orig num
    result = (result * 20151125) % mod;

    return { result, 0 };
}
