#pragma once

#include <iostream>
#include <string>
#include <tuple>
#include <vector>

using std::cout;
using std::string;
using std::tuple;
using std::vector;

string readFromFile(string fileName);
vector<string> splitOn(string input, char ch);