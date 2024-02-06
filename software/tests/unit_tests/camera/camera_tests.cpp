#include "Camera.hpp"
#include "Ft245_if.hpp"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

class MockFt245 : public Ft245Interface {
  public:
   MOCK_METHOD(bool, Open, (), (override));
   MOCK_METHOD(void, Close, (), (override));
   MOCK_METHOD(bool, WriteByte, (uint8_t byte), (override));
   MOCK_METHOD(std::optional<uint8_t>, ReadByte, (), (override));
   MOCK_METHOD(bool, Write, (const std::vector<uint8_t> &data), (override));
   MOCK_METHOD(std::vector<uint8_t>, Read, (unsigned int bytes_to_read),
               (override));
};

class CameraTests : public testing::Test {
  protected:
   MockFt245 ft245_;
};

TEST_F(CameraTests, Connect) {
   Camera cut{ft245_};
   EXPECT_CALL(ft245_, Open);
   cut.connect();
}
