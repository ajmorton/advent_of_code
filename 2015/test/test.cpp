#include <catch2/catch.hpp>
#include <tuple>
#include "src/day_01.hpp"
#include "src/day_02.hpp"
#include "src/day_03.hpp"

TEST_CASE( "Day 01") {
    string input = readFromFile("test/input/day_01.txt");
    SECTION( "Part 1" ) { REQUIRE( day_01_01(input) ==   74 ); }
    SECTION( "Part 2" ) { REQUIRE( day_01_02(input) == 1795 ); }
}

TEST_CASE( "Day 02") {
    string input = readFromFile("test/input/day_02.txt");
    REQUIRE( day_02(input) == std::tuple{1598415, 3812909} );
}

TEST_CASE( "Day 03") {
    string input = readFromFile("test/input/day_03.txt");
    REQUIRE( day_03(input) == std::tuple{2592, 2360} );
}