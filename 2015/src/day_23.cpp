#include "days.hpp"

enum reg_t{A = 0, B = 1};
enum command_t {HLF, TPL, INC, JMP, JIE, JIO};
struct instr_t {command_t cmd; reg_t reg; int jmp;};

int runProg(vector<instr_t> instructions, bool p2) {
    int ptr = 0;
    unsigned int regs[2] = {0};

    if(p2) {regs[A] = 1;}

    while(ptr >= 0 && ptr < instructions.size()) {
        instr_t instr = instructions[ptr];
        switch(instr.cmd) {
            case HLF: regs[instr.reg] /= 2; ptr++; break;
            case TPL: regs[instr.reg] *= 3; ptr++; break;
            case INC: regs[instr.reg] += 1; ptr++; break;
            case JMP: ptr += instr.jmp;            break; 
            case JIE: ptr += regs[instr.reg] % 2 == 0 ? instr.jmp : 1; break;
            case JIO: ptr += regs[instr.reg] == 1     ? instr.jmp : 1; break;
        }
    }

    return regs[B];
}

tuple<int, int> day_23(string input) {

    vector<instr_t> instructions;

    int jumpVal;
    char command[5];
    char reg;
    for(string line: splitOn(input, '\n')) {

        string instrFormat;
        if(line.find(',') != line.npos) {
            sscanf(line.c_str(), "%s %c, %d", command, &reg, &jumpVal);
        } else if(line.find("jmp") != line.npos) {
            sscanf(line.c_str(), "%s %d", command, &jumpVal);
        } else {
            sscanf(line.c_str(), "%s %c", command, &reg);
        }

        instr_t instr;
        if(     string(command) == "hlf") {instr.cmd = HLF;}
        else if(string(command) == "tpl") {instr.cmd = TPL;}
        else if(string(command) == "inc") {instr.cmd = INC;}
        else if(string(command) == "jmp") {instr.cmd = JMP;}
        else if(string(command) == "jie") {instr.cmd = JIE;}
        else if(string(command) == "jio") {instr.cmd = JIO;}

        switch(reg) {
            case 'a': instr.reg = A; break;
            case 'b': instr.reg = B; break;
        }

        instr.jmp = jumpVal;

        instructions.push_back(instr);
    }

    int p1 = runProg(instructions, false);
    int p2 = runProg(instructions, true);

    return {p1, p2};
}
