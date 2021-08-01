#include "days.hpp"

using std::regex;

typedef unsigned short voltage_t ;
typedef string wire_t;
enum class Oper{EQ, AND, OR, LSHIFT, RSHIFT, NOT};

struct gate_t{wire_t inA; Oper oper; wire_t inB; wire_t out;};

regex exprRegex("([\\w ]+) -> (\\w+)");
regex valueRegex("(\\w+)");
regex unaryRegex("NOT (\\w+)");
regex binaryRegex("(\\w+) ([A-Z]+) (\\w+)");

class Circuit {

    map<wire_t, std::set<wire_t>> _inputs;
    map<wire_t, std::set<wire_t>> _outputs;
    map<wire_t, voltage_t> _wireVoltage;

    map<wire_t, gate_t> _gateOf;
    std::deque<wire_t> _inputsToResolve;

    private:
        Oper fromString(string oper) {
            if(oper == "EQ")          {return Oper::EQ;     }
            else if(oper == "AND")    {return Oper::AND;    }
            else if(oper == "OR")     {return Oper::OR;     }
            else if(oper == "LSHIFT") {return Oper::LSHIFT; }
            else if(oper == "RSHIFT") {return Oper::RSHIFT; }
            else                      {return Oper::NOT;    }
        }

        void evaluate(gate_t gate) {
            switch(gate.oper) {
                case Oper::EQ:     _wireVoltage[gate.out] = eval(gate.inA);                   break;
                case Oper::AND:    _wireVoltage[gate.out] = eval(gate.inA) &  eval(gate.inB); break;
                case Oper::OR:     _wireVoltage[gate.out] = eval(gate.inA) |  eval(gate.inB); break;
                case Oper::LSHIFT: _wireVoltage[gate.out] = eval(gate.inA) << eval(gate.inB); break;
                case Oper::RSHIFT: _wireVoltage[gate.out] = eval(gate.inA) >> eval(gate.inB); break;
                case Oper::NOT:    _wireVoltage[gate.out] = eval(gate.inA) ^  -1;             break;
            }
        }

        voltage_t eval(string input) {
            return isNumber(input) ? stoi(input) : _wireVoltage[input];
        }

        bool isNumber(string str) {
            return std::all_of(str.begin(), str.end(), ::isdigit);
        }

        void addConnection(string input, wire_t output) {
            if(isNumber(input) == false) {
                _outputs[input].insert(output);
                _inputs[output].insert(input);
            }
        }

    public : 
        void setUp(string input) {
            std::smatch matches;
            for(string line: splitOn(input, '\n')) {

                regex_match(line, matches, exprRegex);
                string input = matches[1]; 
                wire_t wire = matches[2];

                if(regex_match(input, matches, valueRegex)) {
                    _gateOf[wire] = gate_t{matches[1], Oper::EQ, "", wire};
                    addConnection(matches[1], wire);

                    if(isNumber(matches[1])) {
                        _wireVoltage[wire] = stoi(matches[1]);
                        _inputsToResolve.push_back(wire);
                    }

                } else if(regex_match(input, matches, unaryRegex)) {
                    _gateOf[wire] = gate_t{matches[1], Oper::NOT, "", wire};
                    addConnection(matches[1], wire);

                } else if(regex_match(input, matches, binaryRegex)) {
                    _gateOf[wire] = gate_t{matches[1], fromString(matches[2]), matches[3], wire};
                    addConnection(matches[1], wire);
                    addConnection(matches[3], wire);
                }
            }
        }

        void resolve() {
            while(_inputsToResolve.empty() == false) {
                wire_t knownInput = _inputsToResolve.front();
                _inputsToResolve.pop_front();

                for(wire_t output: _outputs[knownInput]) {
                    _inputs[output].erase(knownInput);
                    if(_inputs[output].size() == 0) {
                        evaluate(_gateOf[output]);
                        _inputsToResolve.push_back(output);
                    }
                }
            }
        }

        voltage_t voltage(wire_t wire) {
            return _wireVoltage[wire];
        }

        void setVoltage(wire_t wire, voltage_t voltage) {
            _wireVoltage[wire] = voltage;
        }
};

tuple<int, int> day_07(string input) {

    Circuit circuit;
    circuit.setUp(input);
    circuit.resolve();
    voltage_t p1 = circuit.voltage("a");

    // Part 2
    circuit.setUp(input);
    circuit.setVoltage("b", p1);
    circuit.resolve();
    voltage_t p2 = circuit.voltage("a");

    return {p1, p2};
}
