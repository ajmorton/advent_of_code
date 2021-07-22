#include "day_13.hpp"

typedef int person_t;
typedef int score_t;

person_t getIDOrAllocate(std::map<string, person_t>& personIDs, char* person, int& numGuests) {
    if(personIDs.contains(string(person)) == false) {
        personIDs[string(person)] = numGuests++;
    }
    return personIDs[string(person)];
}

int readInGuests(string input, score_t happiness[10][10]) {
    char person1[20], person2[20], gainLose[20];
    score_t score;

    int numGuests = 0;
    map<string, person_t> personIDs;

    for(string line: splitOn(input, '\n')) {
        sscanf(line.c_str(), "%s would %s %d happiness units by sitting next to %s", person1, gainLose, &score, person2);
        person_t idPerson1 = getIDOrAllocate(personIDs, person1, numGuests);
        person_t idPerson2 = getIDOrAllocate(personIDs, person2, numGuests);
        happiness[idPerson1][idPerson2] = std::strcmp(gainLose, "gain") == 0 ? score : -score;
    }
    return numGuests;
}

int bestScore(int numGuests, score_t happiness[10][10]) {
    score_t max_score = INT_MIN;
    vector<person_t> people(numGuests);
    std::iota(people.begin(), people.end(), 0);

    do {
        score_t score = 0;
        person_t p2 = people.back();
        for(person_t p1: people) {
            score += happiness[p1][p2] + happiness[p2][p1];
            p2 = p1;
        }
        max_score = std::max(max_score, score);
    } while(std::next_permutation(people.begin(), people.end()));

    return max_score;
}

tuple<int, int> day_13(string input) {

    score_t happiness[10][10] = {{0}};
    int numGuests = readInGuests(input, happiness);

    score_t p1 = bestScore(numGuests, happiness);
    score_t p2 = bestScore(numGuests + 1, happiness);

    return {p1, p2};
}
