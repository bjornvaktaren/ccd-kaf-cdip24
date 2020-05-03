#include <Camera.hpp>

Camera::Camera()
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


bool Camera::sampleTemperatures()
{
   m_ft.writeByte(fpga::command::get_temperature);
   // the FTDI latency timer is dominating the delay, so below delay is not
   // needed
   // usleep(fpga::delay::sample_mcp);

   const size_t nBytes = 4;
   unsigned char buffer[nBytes];
   int readBytes = m_ft.read(buffer, nBytes);
   for ( unsigned int i = 0; i < 2; ++i ) {
      unsigned int result = (
	 ((( static_cast<unsigned int>(buffer[1 + 2*i]) &
	     ~fpga::thermistor_id::idBitMask )) << 8 )
	 | static_cast<unsigned int>(buffer[0 + 2*i]) 
	 );

      if ( ( buffer[1 + 2*i] & fpga::thermistor_id::idBitMask ) ==
	   fpga::thermistor_id::ambient ) {
	 m_thermistors.at("ambient").setMeasurement(result);
      }
      else if ( ( buffer[1 + 2*i] & fpga::thermistor_id::idBitMask ) ==
		fpga::thermistor_id::ccd ) {
	 m_thermistors.at("ccd").setMeasurement(result);
      }
   }

   std::cout << "INFO: Received "
   	     << ' ' << std::bitset<8>(buffer[0])
   	     << ' ' << std::bitset<8>(buffer[1])
   	     << ' ' << std::bitset<8>(buffer[2])
   	     << ' ' << std::bitset<8>(buffer[3])
	     << ' ' << m_thermistors.at("ccd").getMeasuredVoltage()
	     << ' ' << m_thermistors.at("ambient").getMeasuredVoltage()
	     << ' ' << m_thermistors.at("ccd").getCelsius()
	     << ' ' << m_thermistors.at("ambient").getCelsius()
	     << '\n';

   return readBytes == nBytes;
}


double Camera::getTemperature(const std::string &thermistor)
{
   return m_thermistors.at(thermistor).getCelsius();
}


bool Camera::openShutter()
{
   return m_ft.writeByte(fpga::command::open_shutter) == 1;
}


bool Camera::closeShutter()
{
   return m_ft.writeByte(fpga::command::close_shutter) == 1;
}
