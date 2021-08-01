#pragma once

#include <algorithm>
#include <array>
#include <deque>
#include <iostream>
#include <map>
#include <numeric>
#include <regex>
#include <set>
#include <sstream>
#include <string>
#include <tuple>
#include <vector>

using std::cout;
using std::map;
using std::string;
using std::tuple;
using std::vector;

string readFromFile(const string& fileName);
vector<string> splitOn(const string& input, char ch);
void stripChars(string& str, const string& chars);
