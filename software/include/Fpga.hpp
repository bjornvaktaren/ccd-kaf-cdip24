#ifndef FPGA_HPP
#define FPGA_HPP

namespace fpga {

   namespace command {
      static constexpr unsigned char none            = 0x00;
      static constexpr unsigned char get_temperature = 0x01;
      static constexpr unsigned char open_shutter    = 0x03;
      static constexpr unsigned char close_shutter   = 0x04;
       // turn on peltier cooling
      static constexpr unsigned char peltier_on      = 0x06;
       // turn off peltier cooling
      static constexpr unsigned char peltier_off     = 0x07;
      // set pwm value for peltier 1
      static constexpr unsigned char peltier_1_set   = 0x08;
      // set pwm value for peltier 2
      static constexpr unsigned char peltier_2_set   = 0x09;
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

