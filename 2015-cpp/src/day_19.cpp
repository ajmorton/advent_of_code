#include <utility>

#include "days.hpp"

struct replacement_t {string input; string output;};

std::set<string> allTransforms(string molecule, const vector<replacement_t>& replacements) {
    std::set<string> outputMolecules;

    for(const replacement_t& repl: replacements) {
        size_t replPos = molecule.find(repl.input, 0);
        while(replPos != string::npos) {
            string prefix = string(molecule.begin(), molecule.begin() + replPos);
            string postfix = string(molecule.begin() + replPos + repl.input.size(), molecule.end());
            string outputMolecule = prefix + repl.output + postfix;
            outputMolecules.insert(outputMolecule);
            replPos = molecule.find(repl.input,replPos+1);
        }
    }

    return outputMolecules;
}

int numOccurences(string input, const string& regex) {
    std::regex searchRegex(regex);
    vector<string> numElements(
        std::sregex_token_iterator(input.begin(), input.end(), searchRegex), 
        std::sregex_token_iterator()
    );
    return int(numElements.size());
}

tuple<int, int> day_19(const string& input) {

    vector<string> inputLines = splitOn(input, '\n');
    vector<string> replStrings = vector(inputLines.begin(), inputLines.end() - 2);
    string targetMolecule = inputLines.back();

    string ignore;
    vector<replacement_t> replacements;

    for(const string& replacement: replStrings) {
        replacement_t repl;
        std::istringstream reader(replacement);
        reader >> repl.input >> ignore >> repl.output;
        replacements.push_back(repl);
    }

    std::set<string> outputMolecules = allTransforms(targetMolecule, replacements);

    int numElements = numOccurences(targetMolecule, "[A-Z]");
    int numAr = numOccurences(targetMolecule, "Ar");
    int numRn = numOccurences(targetMolecule, "Rn");
    int numY = numOccurences(targetMolecule, "Y");

    // Each transformation adds an additional element to the molecule, with the execptions of (Ar, Y, Rn)
    int numTransforms = 
        numElements         // all elements
        - (numAr + numRn)   // ignore Ar and Rn as artifacts of transformations
        - (2*numY)          // ignore Y, for each Y an additional Element is added
        - 1;                // initial conversion from e, adds two elements

    return {outputMolecules.size(), numTransforms};
}
