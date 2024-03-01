#include "CameraConfiguration.hpp"

#include <iostream>

#include "Fpga.hpp"

namespace camera {

CameraConfiguration::CameraConfiguration(Ft245Interface &ft) : ft_{ft} {}

bool CameraConfiguration::SetGain(const uint8_t gain) {
   if (gain > 63) {
      std::cerr
          << "[CameraConfiguration] Gain can't be larger than 63. Ignoring.\n";
      return false;
   }

   // Configure the AD9826
   std::vector<uint8_t> message{
       fpga::command::rw_adconf,
       fpga::ad9826::cmd::write_gain,
       gain,
   };
   return ft_.Write(std::move(message));
}

bool CameraConfiguration::SetOffset(int16_t offset) {
   if (offset > 255 || offset < -255) {
      std::cerr
          << "[CameraConfiguration] Offset must be in [-255,255]. Ignoring.\n";
      return false;
   }

   const auto ad_command{offset < 0 ? fpga::ad9826::cmd::write_negative_offset
                                    : fpga::ad9826::cmd::write_positive_offset};
   // Configure the AD9826
   std::vector<uint8_t> message{
       fpga::command::rw_adconf,
       std::move(ad_command),
       static_cast<uint8_t>(std::abs(offset)),
   };
   return ft_.Write(std::move(message));
}

bool CameraConfiguration::SetReadoutMode(ReadoutMode mode) {}

bool CameraConfiguration::getAD9826Config() {}

};  // namespace camera
