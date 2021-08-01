#include <catch2/catch.hpp>
#include "src/days.hpp"

TEST_CASE( "Day 01") {
    string input = readFromFile("test/input/day_01.txt");
    REQUIRE( day_01(input) == tuple{74, 1795} );
}

TEST_CASE( "Day 02") {
    string input = readFromFile("test/input/day_02.txt");
    REQUIRE( day_02(input) == tuple{1598415, 3812909} );
}

TEST_CASE( "Day 03") {
    string input = readFromFile("test/input/day_03.txt");
    REQUIRE( day_03(input) == tuple{2592, 2360} );
}

TEST_CASE( "Day 04") {
    string input = readFromFile("test/input/day_04.txt");
    REQUIRE( day_04(input) == tuple{117946, 3938038} );
}

TEST_CASE( "Day 05") {
    string input = readFromFile("test/input/day_05.txt");
    REQUIRE( day_05(input) == tuple{255, 55} );
}

TEST_CASE( "Day 06") {
    string input = readFromFile("test/input/day_06.txt");
    REQUIRE( day_06(input) == tuple{377891, 14110788} );
}

TEST_CASE( "Day 07") {
    string input = readFromFile("test/input/day_07.txt");
    REQUIRE( day_07(input) == tuple{46065, 14134} );
}

TEST_CASE( "Day 08") {
    string input = readFromFile("test/input/day_08.txt");
    REQUIRE( day_08(input) == tuple{1371, 2117} );
}

TEST_CASE( "Day 09") {
    string input = readFromFile("test/input/day_09.txt");
    REQUIRE( day_09(input) == tuple{141, 736} );
}

TEST_CASE( "Day 10") {
    string input = readFromFile("test/input/day_10.txt");
    REQUIRE( day_10(input) == tuple{252594, 3579328} );
}

TEST_CASE( "Day 11") {
    auto [a, b] = day_11( readFromFile("test/input/day_11.txt") );

    CHECK_THAT( a, Catch::Equals( "hepxxyzz" ) );
    CHECK_THAT( b, Catch::Equals( "heqaabcc" ) );
}

TEST_CASE( "Day 12") {
    string input = readFromFile("test/input/day_12.txt");
    REQUIRE( day_12(input) == tuple{111754, 65402} );
}

TEST_CASE( "Day 13") {
    string input = readFromFile("test/input/day_13.txt");
    REQUIRE( day_13(input) == tuple{709, 668} );
}

TEST_CASE( "Day 14") {
    string input = readFromFile("test/input/day_14.txt");
    REQUIRE( day_14(input) == tuple{2660, 1256} );
}

TEST_CASE( "Day 15") {
    string input = readFromFile("test/input/day_15.txt");
    REQUIRE( day_15(input) == tuple{21367368, 1766400} );
}

TEST_CASE( "Day 16") {
    string input = readFromFile("test/input/day_16.txt");
    REQUIRE( day_16(input) == tuple{40, 241} );
}

TEST_CASE( "Day 17") {
    string input = readFromFile("test/input/day_17.txt");
    REQUIRE( day_17(input) == tuple{1304, 18} );
}

TEST_CASE( "Day 18") {
    string input = readFromFile("test/input/day_18.txt");
    REQUIRE( day_18(input) == tuple{768, 781} );
}

TEST_CASE( "Day 19") {
    string input = readFromFile("test/input/day_19.txt");
    REQUIRE( day_19(input) == tuple{509, 195} );
}

TEST_CASE( "Day 20") {
    string input = readFromFile("test/input/day_20.txt");
    REQUIRE( day_20(input) == tuple{665280, 705600} );
}

TEST_CASE( "Day 21") {
    string input = readFromFile("test/input/day_21.txt");
    REQUIRE( day_21(input) == tuple{91, 158} );
}

TEST_CASE( "Day 22") {
    string input = readFromFile("test/input/day_22.txt");
    REQUIRE( day_22(input) == tuple{953, 1289} );
}

TEST_CASE( "Day 23") {
    string input = readFromFile("test/input/day_23.txt");
    REQUIRE( day_23(input) == tuple{170, 247} );
}

TEST_CASE( "Day 24") {
    string input = readFromFile("test/input/day_24.txt");
    REQUIRE( day_24(input) == tuple{10723906903L, 74850409L} );
}

TEST_CASE( "Day 25") {
    string input = readFromFile("test/input/day_25.txt");
    REQUIRE( day_25(input) == tuple{8997277L, 0} );
}
