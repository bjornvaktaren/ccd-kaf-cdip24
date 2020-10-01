#ifndef FPGA_HPP
#define FPGA_HPP

namespace fpga {
   
   namespace command {
      static constexpr unsigned char none            = 0b00000000;
      static constexpr unsigned char toggle_mcp      = 0b00000001;
      static constexpr unsigned char toggle_read_ccd = 0b00000010;
      static constexpr unsigned char open_shutter    = 0b00000100;
      static constexpr unsigned char close_shutter   = 0b00001000;
      static constexpr unsigned char rw_adconf       = 0b00010000;
      static constexpr unsigned char set_register    = 0b00100000;
      static constexpr unsigned char reset           = 0b11111111;
   }

   // Named addresses of the FPGA internal register 
   namespace reg_addr {
      static constexpr unsigned char tec1_duty        = 0;
      static constexpr unsigned char tec2_duty        = 1;
      static constexpr unsigned char ccd_readout_mode = 2;
   }
   
   // Named commands to read/write from/to the AD9826 configuration register 
   namespace ad9826_cmd {
      static constexpr unsigned char write_config     = 0b00000000;
      static constexpr unsigned char read_config      = 0b10000000;
      static constexpr unsigned char write_mux_config = 0b00010000;
      static constexpr unsigned char read_mux_config  = 0b10010000;
      // Red PGA gain register. We are not using the others.
      static constexpr unsigned char write_gain       = 0b00100000;
      static constexpr unsigned char read_gain        = 0b10100000;
      // Red offset register. We are not using the others.
      static constexpr unsigned char write_offet      = 0b01010000;
      static constexpr unsigned char read_offset      = 0b11010000;
      // The last bit is actually the most significant bit for the offset value
      static constexpr unsigned char offset_msb       = 0b00000001;
   }

   namespace data_topic {
      // Each message is sent with a 8-bit header
      static constexpr unsigned char mcp    = 0b00000001;
      static constexpr unsigned char adconf = 0b00000010;
      static constexpr unsigned char pixel  = 0b00000011;
   }
   
   enum class DataTopic {unknown, mcp, adconf, pixel};
   struct DataPacket {
      DataTopic topic = DataTopic::unknown;
      uint16_t data = 0;
   };

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

