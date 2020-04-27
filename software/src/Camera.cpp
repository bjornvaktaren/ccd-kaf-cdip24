#include <Camera.hpp>

Camera::Camera() :
   m_thAmbient(2000.0, 3450.0, 3.3, 2200),
   m_thCCD(10000.0, 4080.0, 3.3, 10000)
{
}

void Camera::connect()
{
   int status = m_ft.init();
   if ( status != 0 ) {
      throw std::runtime_error("Unable to connect to camera");
   }
}


void Camera::disconnect()
{
   m_ft.close();
}


std::pair<std::string, double> Camera::getTemperature()
{
   m_ft.writeByte(fpga::command::get_temperature);
   usleep(fpga::delay::sample_mcp);

   unsigned char buffer[2];
   m_ft.read(buffer, 2);
   unsigned int result = (
      ((( static_cast<unsigned int>(buffer[1]) &
	  ~fpga::thermistor_id::idBitMask )) << 8 )
      | static_cast<unsigned int>(buffer[0]) 
      );

   double U = 0.0;
   std::string thermistor = "unknown";
   double temperature = 0.0;
   if ( ( buffer[1] & fpga::thermistor_id::idBitMask ) ==
	fpga::thermistor_id::ambient ) {
      thermistor = "ambient";
      U = static_cast<double>(result)/1023.0*m_thAmbient.getV0();
      temperature = m_thAmbient.celsius(U);
   }
   else if ( ( buffer[1] & fpga::thermistor_id::idBitMask ) ==
	fpga::thermistor_id::ccd ) {
      thermistor = "ccd";
      U = static_cast<double>(result)/1023.0*m_thCCD.getV0();
      temperature = m_thCCD.celsius(U);
   }

   // std::cout << "INFO: Received " << std::bitset<64>(result)
   // 	     << ' ' << std::bitset<8>(buffer[0])
   // 	     << ' ' << std::bitset<8>(buffer[1]) << " (bit), "
   // 	     << std::hex << result << " (hex), "
   // 	     << std::dec << result << " (dec)."<< '\n';

   // std::cout << "U = " << U << '\n';
   
   return std::pair<std::string, double>(thermistor, temperature);
}
