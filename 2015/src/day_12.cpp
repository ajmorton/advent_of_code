#include "day_12.hpp"

string stripRedObjects(string jsonString){
    vector<string> stack = {""};
    for(char c: jsonString) {
        switch(c) {
            case '{': stack.push_back(""); break;
            case '}': {
                string object = stack.back();
                stack.pop_back();
                if(object.find(":\"red\"") == string::npos) {
                    stack.back().append(object);
                }
                break; 
            }
            default: stack.back().push_back(c);
        }
    }
    return stack[0];
}

int sumNumbers(string jsonString) {
    int sum = 0;
    std::regex numRegex("(-?[0-9]+)");
    vector<string> numbers(std::sregex_token_iterator(jsonString.begin(), jsonString.end(), numRegex), std::sregex_token_iterator());
    for(string m: numbers) {
        sum += stoi(m);
    }
    return sum;
}

tuple<int, int> day_12(string input) {
    return {sumNumbers(input), sumNumbers(stripRedObjects(input))};
}
