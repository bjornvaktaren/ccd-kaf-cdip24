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
   // const unsigned char cmd[1] = {fpga::command::open_shutter};
   // return m_ft.write(cmd, 1);
   return m_ft.writeByte(fpga::command::open_shutter) == 1;
}


bool Camera::closeShutter()
{
   // const unsigned char cmd[1] = {fpga::command::close_shutter};
   // return m_ft.write(cmd, 1);
   return m_ft.writeByte(fpga::command::close_shutter) == 1;
}


bool Camera::setCooling(const bool on)
{
   if ( on ) return m_ft.writeByte(fpga::command::peltier_on);
   else return m_ft.writeByte(fpga::command::peltier_off);
}


bool Camera::setPeltierPWM(const int peltier, const unsigned char pwmVal)
{
   unsigned char writeBuffer[2];
   
   if ( peltier == 1 ) {
      writeBuffer[0] = fpga::command::peltier_1_set;
   }
   else if ( peltier == 2 ) {
      writeBuffer[0] = fpga::command::peltier_2_set;
   }
   else {
      std::cerr << "Unsupported peltier '" << peltier << "'\n";
      return false;
   }
   writeBuffer[1] = pwmVal;
   
   return m_ft.write(writeBuffer, 2);
}
