#include <catch2/catch.hpp>
#include <tuple>
#include "src/day_01.hpp"
#include "src/day_02.hpp"
#include "src/day_03.hpp"
#include "src/day_04.hpp"
#include "src/day_05.hpp"
#include "src/day_06.hpp"
#include "src/day_07.hpp"
#include "src/day_08.hpp"
#include "src/day_09.hpp"
#include "src/day_10.hpp"
#include "src/day_11.hpp"
#include "src/day_12.hpp"

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

TEST_CASE( "Day 04") {
    string input = readFromFile("test/input/day_04.txt");
    REQUIRE( day_04(input) == std::tuple{117946, 3938038} );
}

TEST_CASE( "Day 05") {
    string input = readFromFile("test/input/day_05.txt");
    REQUIRE( day_05(input) == std::tuple{255, 55} );
}

TEST_CASE( "Day 06") {
    string input = readFromFile("test/input/day_06.txt");
    REQUIRE( day_06(input) == std::tuple{377891, 14110788} );
}

TEST_CASE( "Day 07") {
    string input = readFromFile("test/input/day_07.txt");
    REQUIRE( day_07(input) == std::tuple{46065, 14134} );
}

TEST_CASE( "Day 08") {
    string input = readFromFile("test/input/day_08.txt");
    REQUIRE( day_08(input) == std::tuple{1371, 2117} );
}

TEST_CASE( "Day 09") {
    string input = readFromFile("test/input/day_09.txt");
    REQUIRE( day_09(input) == std::tuple{141, 736} );
}

TEST_CASE( "Day 10") {
    string input = readFromFile("test/input/day_10.txt");
    REQUIRE( day_10(input) == std::tuple{252594, 3579328} );
}

TEST_CASE( "Day 11") {
    auto [a, b] = day_11( readFromFile("test/input/day_11.txt") );

    CHECK_THAT( a, Catch::Equals( "hepxxyzz" ) );
    CHECK_THAT( b, Catch::Equals( "heqaabcc" ) );
}

TEST_CASE( "Day 12") {
    string input = readFromFile("test/input/day_12.txt");
    REQUIRE( day_12(input) == std::tuple{111754, 65402} );
}
