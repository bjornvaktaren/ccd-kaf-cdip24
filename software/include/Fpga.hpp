#ifndef FPGA_HPP
#define FPGA_HPP

namespace fpga {

   namespace command {
      static constexpr unsigned char none = 0x00;
      static constexpr unsigned char sample_mcp = 0x01;
   }

   namespace delay {
      static constexpr int sample_mcp = 60; // microseconds
   }
}

#endif

