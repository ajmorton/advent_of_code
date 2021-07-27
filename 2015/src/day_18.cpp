#include "day_18.hpp"

const int SIZE = 100;

class Grid {
    char grid[SIZE][SIZE]     = {{0}};
    char nextGrid[SIZE][SIZE] = {{0}};

    public:
        Grid(string input) {
            int r = 0;
            for(string line: splitOn(input, '\n')) {
                int c = 0;
                for(char light: line) {
                    grid[r][c] = light;
                    c += 1;
                }
                r += 1;
            }
        }

        void incr() {
            for(int r = 0; r < SIZE; r++) {
                for(int c = 0; c < SIZE; c++) {
                    
                    int neigbours = 0;
                    for(int rr = r - 1; rr < r + 2; rr++) {
                        for(int cc = c - 1; cc < c + 2; cc++) {
                            if(rr < 0 || rr >= SIZE) { continue; }
                            if(cc < 0 || cc >= SIZE) { continue; }
                            if(rr == r && cc == c)   { continue; }
                            neigbours += grid[rr][cc] == '#';
                        }
                    }

                    if(grid[r][c] == '.') {
                        nextGrid[r][c] = neigbours == 3 ? '#' : '.';
                    }

                    if(grid[r][c] == '#') {
                        nextGrid[r][c] = ((neigbours == 2) || (neigbours == 3)) ? '#' : '.';
                    }
                }
            }
            for(int r = 0; r < SIZE; r++) {
                for(int c = 0; c < SIZE; c++) {
                    grid[r][c] = nextGrid[r][c];
                }
            }
        }

        void setCorners() {
            grid[0][0] = '#';
            grid[0][SIZE-1] = '#';
            grid[SIZE-1][0] = '#';
            grid[SIZE-1][SIZE-1] = '#';
        }

        int numOn() {
            int numOn = 0;
            for(int r = 0; r < SIZE; r++) {
                for(int c = 0; c < SIZE; c++) {
                    numOn += grid[r][c] == '#';
                }
            }
            return numOn;
        }

        void printGrid(char grid[SIZE][SIZE]) {
            for(int r = 0; r < SIZE; r++) {
                for(int c = 0; c < SIZE; c++) {
                    cout << grid[r][c];
                }
                cout << "\n";
            }
        }

};

tuple<int, int> day_18(string input) {

    Grid g1 = Grid(input);
    Grid g2 = Grid(input);

    for(int step = 0; step < 100; step++) {
        g1.incr();
        
        g2.incr(); 
        g2.setCorners();
    }

    return {g1.numOn(), g2.numOn()};
}
