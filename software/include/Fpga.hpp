#ifndef FPGA_HPP
#define FPGA_HPP

namespace fpga {

   namespace command {
      static constexpr unsigned char none            = 0b00000000;
      static constexpr unsigned char get_temperature = 0b00000001;
      static constexpr unsigned char open_shutter    = 0b00000100;
      static constexpr unsigned char close_shutter   = 0b00001000;
       // turn on peltier cooling
      static constexpr unsigned char peltier_on      = 0b00010000;
       // turn off peltier cooling
      static constexpr unsigned char peltier_off     = 0b00100000;
      // set pwm value for peltier 1
      static constexpr unsigned char peltier_1_set   = 0b01000000;
      // set pwm value for peltier 2
      static constexpr unsigned char peltier_2_set   = 0b10000000;
   }

   namespace delay {
      static constexpr int sample_mcp = 120; // microseconds
   }

   namespace thermistor_id {
      // Identifier for the thermistor, sent from the FPGA.
      // The 2 least significant bits are not used.
      static constexpr unsigned char ambient   = 0b11000100;
      static constexpr unsigned char ccd       = 0b11010100;
      static constexpr unsigned char idBitMask = 0b11111100;
   }
}

#endif

