#include "Ft245.hpp"
#include "Fpga.hpp"
#include <bitset>

int main(int argc, char* argv[])
{

   Ft245 m_ft;

   int status = m_ft.init();
   if ( status != 0 ) {
      throw std::runtime_error("Unable to connect to camera");
      return 1;
   }
   if ( ! m_ft.writeByte(fpga::command::reset) ) {
      throw std::runtime_error("Unable to reset camera");
      return 1;
   }
   
   {
      // Configure the AD9826
      const size_t nBytes = 3;
      const unsigned char writeBuffer[nBytes] = {
	 fpga::command::rw_adconf,
	 fpga::ad9826::cmd::write_config,
	 0b11011000, //4 V input, internal Vref, 1 Ch mode, CDS, 4V clamp
      };
      m_ft.write(writeBuffer, nBytes);
      // Read back the result, same number of bytes. Discard the result.
      unsigned char buffer[nBytes] = {0};
      int readBytes = m_ft.read(buffer, nBytes);
   }

   // Read the AD9862 configuration
   const size_t nBytes = 12;
   const unsigned char writeBuffer[nBytes] = {
      fpga::command::rw_adconf,
      fpga::ad9826::cmd::read_config,
      0x00,
      fpga::command::rw_adconf,
      fpga::ad9826::cmd::read_mux_config,
      0x00,
      fpga::command::rw_adconf,
      fpga::ad9826::cmd::read_gain,
      0x00,
      fpga::command::rw_adconf,
      fpga::ad9826::cmd::read_offset,
      0x00
   };
   m_ft.write(writeBuffer, nBytes);
   
   // Read back the result, same number of bytes
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);

   // Print the result
   for ( size_t i = 0; i < nBytes; i++ ) {
      std::cout << std::bitset<8>(buffer[i]) << ' ';
   }
   std::cout << '\n';
   
   m_ft.close();
   
   return 0;
}
