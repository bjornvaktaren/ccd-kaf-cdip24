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

bool CameraConfiguration::SetReadoutMode(ReadoutMode mode) {
   std::vector<uint8_t> writeBuffer{fpga::command::set_register,
                                    fpga::reg_addr::ccd_readout_mode,
                                    static_cast<uint8_t>(mode)};

   return ft_.Write(std::move(writeBuffer));
}

std::optional<Configuration> CameraConfiguration::GetConfiguration() {
   // const size_t nBytes = 12;
   // const unsigned char writeBuffer[nBytes] = {
   //     fpga::command::rw_adconf, fpga::ad9826::cmd::read_config,     0x00,
   //     fpga::command::rw_adconf, fpga::ad9826::cmd::read_mux_config, 0x00,
   //     fpga::command::rw_adconf, fpga::ad9826::cmd::read_gain,       0x00,
   //     fpga::command::rw_adconf, fpga::ad9826::cmd::read_offset,     0x00};
   // ft245_.write(writeBuffer, nBytes);

   // // Read back the result, same number of bytes
   // unsigned char buffer[nBytes] = {0};
   // int readBytes = ft245_.read(buffer, nBytes);
}

};  // namespace camera
