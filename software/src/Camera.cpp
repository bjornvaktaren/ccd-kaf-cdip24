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
   if ( ! m_ft.writeByte(fpga::command::reset) ) {
      throw std::runtime_error("Unable to reset camera");
   }      
}


void Camera::disconnect()
{
   m_ft.close();
}


// void Camera::test()
// {
//    unsigned char writeBuffer[6];
//    writeBuffer[0] = fpga::command::rw_adconf;
//    writeBuffer[1] = fpga::ad9826_cmd::read_config;
//    writeBuffer[2] = 0b00000000; // need to send a dummy byte
//    m_ft.write(writeBuffer, 3);

//    unsigned char readBuffer[3] = {0};
//    m_ft.read(readBuffer, 3);
   
//    for ( int i = 0; i < 3; ++i ) {
//       std::cout << ' ' << std::bitset<8>(readBuffer[i]);
//    }
//    std::cout << '\n';
// }

fpga::DataPacket Camera::decodePacket(
   const unsigned char byte1,
   const unsigned char byte2,
   const unsigned char byte3
   )
{
   fpga::DataPacket dataPacket;
   if ( byte1 == fpga::data_topic::mcp ) {
      dataPacket.topic = fpga::DataTopic::mcp;
      // std::cout << "mcp\n";
   }
   else if ( byte1 == fpga::data_topic::adconf ) {
      dataPacket.topic = fpga::DataTopic::adconf;
      // std::cout << "adconf\n";
   }
   else if ( byte1 == fpga::data_topic::pixel ) {
      dataPacket.topic = fpga::DataTopic::pixel;
      // std::cout << "pixel\n";
   }
   dataPacket.data =
      ( static_cast<uint16_t>(byte2) << 8 ) | static_cast<uint16_t>(byte3);
   // std::cout << std::bitset<16>(dataPacket.data) << '\n';
   return dataPacket;
}


void Camera::decodeTemperatures(const fpga::DataPacket packet)
{
   m_thermistors.at(packet.data & fpga::thermistor_id::bitmask)
      .setMeasurement(packet.data & ~fpga::thermistor_id::bitmask);
}


bool Camera::sampleTemperatures()
{
   m_ft.writeByte(fpga::command::toggle_mcp);
   // The FTDI latency timer is dominating the delay, so delay is not needed.

   // Read back the result
   const size_t nBytes = 9;
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);

   // std::cout << "INFO: Received ";
   // for ( int i = 0; i < nBytes; ++i ) {
   //    std::cout << ' ' << std::bitset<8>(buffer[i]);
   // }
   // std::cout << '\n';

   // Decode the recieved packets to temperature values
   for ( int i = 0; i < 3; ++i ) {
      auto pkt = this->decodePacket(buffer[i*3], buffer[i*3+1], buffer[i*3+2]);
      this->decodeTemperatures(pkt);
   }
   
   return readBytes == nBytes;
}


double Camera::getTemperature(const uint16_t thermistor)
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


bool Camera::setPeltierPWM(const int peltier, const unsigned char pwmVal)
{
   unsigned char writeBuffer[3];
   writeBuffer[0] = fpga::command::set_register;
   
   if ( peltier == 1 ) {
      writeBuffer[1] = fpga::reg_addr::tec1_duty;
   }
   else if ( peltier == 2 ) {
      writeBuffer[1] = fpga::reg_addr::tec2_duty;
   }
   else {
      std::cerr << "Unsupported peltier '" << peltier << "'\n";
      return false;
   }
   writeBuffer[2] = pwmVal;
   
   return m_ft.write(writeBuffer, 3);
}


bool Camera::setCCDReadoutMode(const unsigned char mode)
{
   unsigned char writeBuffer[3];
   writeBuffer[0] = fpga::command::set_register;
	writeBuffer[1] = fpga::reg_addr::ccd_readout_mode;
   writeBuffer[2] = mode;
	
   return m_ft.write(writeBuffer, 3);
}
