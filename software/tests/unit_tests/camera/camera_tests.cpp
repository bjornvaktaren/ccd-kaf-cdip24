#include "Camera.hpp"
#include "Ft245_if.hpp"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

class CameraTests : public testing::Test {
  protected:
   MockFt245 ft245_;
};

TEST_F(CameraTests, Connect) {
   Camera cut{ft245_};
   EXPECT_CALL(ft245_, Open);
   cut.connect();
}
