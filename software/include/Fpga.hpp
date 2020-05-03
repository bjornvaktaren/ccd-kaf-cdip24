#ifndef FPGA_HPP
#define FPGA_HPP

namespace fpga {

   namespace command {
      static constexpr unsigned char none = 0x00;
      static constexpr unsigned char get_temperature = 0x01;
   }

   namespace delay {
      static constexpr int sample_mcp = 120; // microseconds
   }

   namespace thermistor_id {
      // Identifier for the thermistor, sent from the FPGA.
      // The 2 least significant bits are not used.
      static constexpr unsigned char ambient   = 0b10000100;
      static constexpr unsigned char ccd       = 0b10010100;
      static constexpr unsigned char idBitMask = 0b11111100;
   }
}

#endif
