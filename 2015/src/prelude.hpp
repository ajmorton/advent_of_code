#pragma once

#include <algorithm>
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

string readFromFile(string fileName);
vector<string> splitOn(string input, char ch);