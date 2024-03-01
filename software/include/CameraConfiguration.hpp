#pragma once

#include <optional>

#include "Ft245_if.hpp"

namespace camera {

enum class ReadoutMode { kFlush, k1x1, k2x2 };
struct Configuration {
   uint8_t gain;
   int16_t offset;
};

class CameraConfiguration {
  public:
   CameraConfiguration(Ft245Interface &ft);

   bool SetGain(uint8_t gain);
   bool SetOffset(int16_t offset);
   bool SetReadoutMode(ReadoutMode mode);
   std::optional<Configuration> GetConfiguration();

  private:
   Ft245Interface &ft_;
   bool getAD9826Config();
};

}  // namespace camera
