#include <catch2/catch.hpp>
#include "src/day_01.hpp"

TEST_CASE( "Day 01") {
    string input = readFromFile("test/input/day_01.txt");
    SECTION( "Part 1" ) { REQUIRE( day_01_01(input) ==   74 ); }
    SECTION( "Part 2" ) { REQUIRE( day_01_02(input) == 1795 ); }
}