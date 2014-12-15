#include "type.hpp"
#include "utils/bufOp.hpp"

namespace TypeDB {
    void IntType::Jump(const char*& buf) {
        Utils::jumpInt(buf);
    }
    Object* IntType::CreateAndJump(const char*& buf) {
        return new Int(Utils::readInt(buf));
    }
    void StringType::Jump(const char*& buf) {
        Utils::jumpString(buf);
    }
    Object* StringType::CreateAndJump(const char*& buf) {
        return new String(Utils::readString(buf));
    }
}