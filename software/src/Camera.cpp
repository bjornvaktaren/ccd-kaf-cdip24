#include <Camera.hpp>

Camera::Camera() :
   m_verbosity { Verbosity::info },
   m_ft { },
   m_thermistors {
      { fpga::thermistor_id::ambient,
	Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0) },
      { fpga::thermistor_id::ccd,
	Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0) },
      { fpga::thermistor_id::tec,
	Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0) }
   }
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
      if ( m_verbosity == Verbosity::debug ) {
	 std::cout << "DEBUG: " << " Got topic 'mcp'\n";
      }
   }
   else if ( byte1 == fpga::data_topic::adconf ) {
      dataPacket.topic = fpga::DataTopic::adconf;
      if ( m_verbosity == Verbosity::debug ) {
	 std::cout << "DEBUG: " << " Got topic 'adconf'\n";
      }
   }
   else if ( byte1 == fpga::data_topic::pixel ) {
      dataPacket.topic = fpga::DataTopic::pixel;
      if ( m_verbosity == Verbosity::debug ) {
	 std::cout << "DEBUG: " << " Got topic 'pixel'\n";
      }
   }
   dataPacket.data =
      ( static_cast<uint16_t>(byte2) << 8 ) | static_cast<uint16_t>(byte3);
   if ( m_verbosity == Verbosity::debug ) {
      std::cout << "DEBUG: " << " Got data "
		<< std::bitset<16>(dataPacket.data) << '\n';
   }
   return dataPacket;
}


void Camera::decodeTemperatures(const fpga::DataPacket packet)
{
   m_thermistors.at(packet.data & fpga::thermistor_id::bitmask)
      .setMeasurement(packet.data & ~fpga::thermistor_id::bitmask);
}


bool Camera::getAD9826Config()
{
   //
   const size_t nBytes = 12;
   const unsigned char writeBuffer[nBytes] = {
      fpga::command::rw_adconf,
      fpga::ad9826_cmd::read_config,
      0x00,
      fpga::command::rw_adconf,
      fpga::ad9826_cmd::read_mux_config,
      0x00,
      fpga::command::rw_adconf,
      fpga::ad9826_cmd::read_gain,
      0x00,
      fpga::command::rw_adconf,
      fpga::ad9826_cmd::read_offset,
      0x00
   };
   m_ft.write(writeBuffer, nBytes);
   
   // Read back the result, same number of bytes
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);
   auto pktConfig = this->decodePacket(buffer[0], buffer[1], buffer[2]);
   auto pktMux    = this->decodePacket(buffer[3], buffer[4], buffer[5]);
   auto pktGain   = this->decodePacket(buffer[6], buffer[7], buffer[8]);
   auto pktOffset = this->decodePacket(buffer[9], buffer[10], buffer[11]);
   return true;
}


bool Camera::sampleTemperatures()
{
   m_ft.writeByte(fpga::command::toggle_mcp);
   // The FTDI latency timer is dominating the delay, so delay is not needed.

   // Read back the result
   const size_t nBytes = 9;
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);

   if ( m_verbosity == Verbosity::debug) {
      std::cout << "DEBUG: Received ";
      for ( int i = 0; i < nBytes; ++i ) {
	 std::cout << ' ' << std::bitset<8>(buffer[i]);
      }
      std::cout << '\n';
   }

   // Decode the recieved packets to temperature values
   for ( int i = 0; i < 3; ++i ) {
      auto pkt = this->decodePacket(buffer[i*3], buffer[i*3+1], buffer[i*3+2]);
      if ( pkt.topic == fpga::DataTopic::mcp ) {
	 this->decodeTemperatures(pkt);
      }
      else if ( m_verbosity == Verbosity::debug ) {
	 std::string topic = "unknown";
	 if ( pkt.topic == fpga::DataTopic::adconf ) topic = "adconf";
	 else if ( pkt.topic == fpga::DataTopic::pixel ) topic = "pixel";
	 std::cout << "DEBUG: "
		   << " Expected topic 'mcp', got topic '" << topic << "'\n";
      }
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
