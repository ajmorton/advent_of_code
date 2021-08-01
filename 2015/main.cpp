#include "src/days.hpp"

using namespace std::chrono;
    
void runTest(const string& day, auto func){
    std::cout << "Day " + day + "\n";
    string input = readFromFile("input/day_" + day + ".txt");
    long start = duration_cast< milliseconds >( system_clock::now().time_since_epoch() ).count();

    auto [p1, p2] = func(input);

    long end = duration_cast< milliseconds >( system_clock::now().time_since_epoch() ).count();
    std::cout << "Result = (" << p1 << ", " << p2 << ")\n";
    std::cout << "Runtime = " << (end - start) << " ms\n";
    cout << "==========================\n";
}

int main() {
    runTest("01", day_01);
    runTest("02", day_02);
    runTest("03", day_03);
    runTest("04", day_04);
    runTest("05", day_05);
    runTest("06", day_06);
    runTest("07", day_07);
    runTest("08", day_08);
    runTest("09", day_09);
    runTest("10", day_10);
    runTest("11", day_11);
    runTest("12", day_12);
    runTest("13", day_13);
    runTest("14", day_14);
    runTest("15", day_15);
    runTest("16", day_16);
    runTest("17", day_17);
    runTest("18", day_18);
    runTest("19", day_19);
    runTest("20", day_20);
    runTest("21", day_21);
    runTest("22", day_22);
    runTest("23", day_23);
    runTest("24", day_24);
    runTest("25", day_25);
    
    return 0;
}