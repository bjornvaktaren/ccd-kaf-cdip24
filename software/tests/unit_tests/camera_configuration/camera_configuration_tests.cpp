#include "AD9826.hpp"
#include "CameraConfiguration.hpp"
#include "Fpga.hpp"
#include "gmock/gmock.h"
#include "gtest/gtest.h"
#include "mocks/Ft245Mock.hpp"

using testing::DoAll;
using testing::Return;
using testing::SaveArg;

class CameraConfigurationTests : public testing::Test {
  protected:
   MockFt245 ft245_;
};

TEST_F(CameraConfigurationTests, SetGainMin_ReturnTrue) {
   camera::CameraConfiguration cut{ft245_};

   std::vector<uint8_t> data;
   EXPECT_CALL(ft245_, Write).WillOnce(DoAll(SaveArg<0>(&data), Return(true)));
   EXPECT_TRUE(cut.SetGain(0));

   ASSERT_EQ(data.size(), 3);
   EXPECT_EQ(data[0], fpga::command::rw_adconf);
   EXPECT_EQ(data[1], fpga::ad9826::cmd::write_gain);
   EXPECT_EQ(data[2], 0);
}

TEST_F(CameraConfigurationTests, SetGainMax_ReturnTrue) {
   camera::CameraConfiguration cut{ft245_};

   std::vector<uint8_t> data;
   EXPECT_CALL(ft245_, Write).WillOnce(DoAll(SaveArg<0>(&data), Return(true)));
   EXPECT_TRUE(cut.SetGain(63));

   ASSERT_EQ(data.size(), 3);
   EXPECT_EQ(data[0], fpga::command::rw_adconf);
   EXPECT_EQ(data[1], fpga::ad9826::cmd::write_gain);
   EXPECT_EQ(data[2], 63);
}

TEST_F(CameraConfigurationTests, SetGainAboveMax_ReturnFalse) {
   camera::CameraConfiguration cut{ft245_};

   EXPECT_CALL(ft245_, Write).Times(0);
   EXPECT_FALSE(cut.SetGain(64));
}

TEST_F(CameraConfigurationTests, SetOffsetMin_ReturnTrue) {
   camera::CameraConfiguration cut{ft245_};

   std::vector<uint8_t> data;
   EXPECT_CALL(ft245_, Write).WillOnce(DoAll(SaveArg<0>(&data), Return(true)));
   EXPECT_TRUE(cut.SetOffset(-255));

   ASSERT_EQ(data.size(), 3);
   EXPECT_EQ(data[0], fpga::command::rw_adconf);
   EXPECT_EQ(data[1], fpga::ad9826::cmd::write_negative_offset);
   EXPECT_EQ(data[2], 255);
}

TEST_F(CameraConfigurationTests, SetOffsetMax_ReturnTrue) {
   camera::CameraConfiguration cut{ft245_};

   std::vector<uint8_t> data;
   EXPECT_CALL(ft245_, Write).WillOnce(DoAll(SaveArg<0>(&data), Return(true)));
   EXPECT_TRUE(cut.SetOffset(255));

   ASSERT_EQ(data.size(), 3);
   EXPECT_EQ(data[0], fpga::command::rw_adconf);
   EXPECT_EQ(data[1], fpga::ad9826::cmd::write_positive_offset);
   EXPECT_EQ(data[2], 255);
}

TEST_F(CameraConfigurationTests, SetOffsetBelowMin_ReturnFalse) {
   camera::CameraConfiguration cut{ft245_};

   EXPECT_CALL(ft245_, Write).Times(0);
   EXPECT_FALSE(cut.SetOffset(-256));
   EXPECT_FALSE(cut.SetOffset(std::numeric_limits<int16_t>::min()));
}

TEST_F(CameraConfigurationTests, SetOffsetAboveMax_ReturnFalse) {
   camera::CameraConfiguration cut{ft245_};

   EXPECT_CALL(ft245_, Write).Times(0);
   EXPECT_FALSE(cut.SetOffset(256));
   EXPECT_FALSE(cut.SetOffset(std::numeric_limits<int16_t>::max()));
}
