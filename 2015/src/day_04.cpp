#include "days.hpp"
#include <boost/uuid/detail/md5.hpp>

using boost::uuids::detail::md5;

int firstNum(const string& prefix, int leadingZeros) {
    const unsigned int mask = 0xffffffff << 4*(8 - leadingZeros); 
    int salt = -1;
    md5::digest_type digest;

    do {
        string plaintext = prefix + std::to_string(salt++);

        md5 hash;
        hash.process_bytes(plaintext.data(), plaintext.size());
        hash.get_digest(digest);
    } while((digest[0] & mask) != 0);

    return salt - 1;
}

tuple<int, int> day_04(const string& input) {
    return { firstNum(input, 5), firstNum(input, 6) };
}
