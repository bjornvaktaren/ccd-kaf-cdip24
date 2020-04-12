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
   m_ft.write(fpga::command::sample_mcp);
   usleep(fpga::delay::sample_mcp);

   unsigned char byte;
   m_ft.read(byte);
   // Apparently shifted by 1 or 2 bit. Bug in firmware?
   byte = byte << 2;
   std::cout << "INFO: Received " << std::bitset<8>(byte) << " (bit), "
   	     << std::hex << (int)byte << " (hex), "
   	     << std::dec << (int)byte << " (dec)."<< '\n';
   
   double U = static_cast<double>(byte)/255.0*m_thAmbient.getV0();
   std::cout << "U = " << U << '\n';
   
   return m_thAmbient.celsius(U);
}
