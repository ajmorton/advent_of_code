#include "days.hpp"
#include <boost/uuid/detail/md5.hpp>

using boost::uuids::detail::md5;

int firstNum(string prefix, int leadingZeros) {
    unsigned int mask = 0xffffffff << 4*(8 - leadingZeros); 
    int salt = 0;
    md5::digest_type digest;

    while((digest[0] & mask) != 0) {
        salt += 1;
        string plaintext = prefix + std::to_string(salt);

        md5 hash;
        hash.process_bytes(plaintext.data(), plaintext.size());
        hash.get_digest(digest);
    }
    return salt;
}

tuple<int, int> day_04(string input) {
    return { firstNum(input, 5), firstNum(input, 6) };
}
