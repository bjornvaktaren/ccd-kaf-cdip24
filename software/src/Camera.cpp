#include <Camera.hpp>

Camera::Camera()
   : m_thAmbient(2000.0, 3450.0, 3.3, 220)
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


double Camera::getAmbientTemperature()
{
   m_ft.writeByte(fpga::command::sample_mcp);
   usleep(fpga::delay::sample_mcp);

   unsigned char buffer[2];
   m_ft.read(buffer, 2);
   unsigned int result = ( buffer[0] << 8 | buffer[1] );
   std::cout << "INFO: Received " << std::bitset<8>(buffer[0])
   	     << ' ' << std::bitset<8>(buffer[1]) << " (bit), "
   	     << std::hex << result << " (hex), "
   	     << std::dec << result << " (dec)."<< '\n';

   double U = static_cast<double>(result)/1023.0*m_thAmbient.getV0();
   std::cout << "U = " << U << '\n';
   
   return m_thAmbient.celsius(U);
}
