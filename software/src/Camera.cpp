#include <Camera.hpp>

Camera::Camera() :
   m_verbosity { Verbosity::info },
	m_coolerOn  { false },
   m_ft { },
   m_ad { },
   m_thermistors {
      { fpga::thermistor_id::ambient,
	Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0) },
      { fpga::thermistor_id::ccd,
	Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0) },
      { fpga::thermistor_id::tec,
	Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0) }
   },
	m_ccdTargetTemperature { 20.0 },
	m_pid {0.0, 127.0, 1.0, 0.1, 0.0} // PID regulator: min, max, kp, ki, kd
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

   // Configure the AD9826
   const size_t nBytes = 3;
   const unsigned char writeBuffer[nBytes] = {
      fpga::command::rw_adconf,
      fpga::ad9826::cmd::write_config,
      0b11011000, //4 V input, internal Vref, 1 Ch mode, CDS, 4V clamp
   };
   m_ft.write(writeBuffer, nBytes);
   // Read back the result, same number of bytes. Discard with the result.
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);

}


void Camera::disconnect()
{
   m_ft.close();
}


bool Camera::setGain(const unsigned char gain)
{
   if ( gain > 63 ) {
      std::cout << "Gain can't be larger than 63. Ignoring.\n";
      return false;
   }
   
   // Configure the AD9826
   const size_t nBytes = 3;
   const unsigned char writeBuffer[nBytes] = {
      fpga::command::rw_adconf,
      fpga::ad9826::cmd::write_gain,
      gain,
   };
   bool ok = m_ft.write(writeBuffer, nBytes);
   // Read back the result, same number of bytes. Discard with the result.
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);

   return ok;
}


bool Camera::setOffset(const unsigned char offset, const bool negative)
{
   if ( offset > 63 ) {
      std::cout << "Offset can't be larger than 63. Ignoring.\n";
      return false;
   }

   // If negative, the LSB of the command is set to 1.
   unsigned char write_cmd = fpga::ad9826::cmd::write_offset;
   if ( negative ) write_cmd |= 0b00000001;
   std::cout << std::bitset<8>(write_cmd) << '\n';
   
   // Configure the AD9826
   const size_t nBytes = 3;
   const unsigned char writeBuffer[nBytes] = {
      fpga::command::rw_adconf,
      write_cmd,
      offset,
   };
   bool ok = m_ft.write(writeBuffer, nBytes);
   // Read back the result, same number of bytes. Discard with the result.
   unsigned char buffer[nBytes] = {0};
   int readBytes = m_ft.read(buffer, nBytes);

   return ok;
}


void Camera::startExposure()
{
	// this->flushSensor(); // need to implement
	this->openShutter();
}


void Camera::stopExposure()
{
	this->closeShutter();
}


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
	try {
		m_thermistors.at(packet.data & fpga::thermistor_id::bitmask)
			.setMeasurement(packet.data & ~fpga::thermistor_id::bitmask);
	}
	catch ( const std::out_of_range& oor ) {
		std::cerr << "ERROR: Unable to decode thermistor ID. Exception: "
					 << oor.what() << '\n';
	}
}


void Camera::decodeAD9826ConfigPacket(const fpga::DataPacket packet)
{
   
   const uint16_t address = packet.data & fpga::ad9826::reg::addr_mask;
   const uint16_t data = packet.data & fpga::ad9826::reg::data_mask;
   const std::bitset<16> bits(data);
   
   if ( address == fpga::ad9826::reg::config ) {
      m_ad.inputRange   = bits.test(7) ? "4V" : "2V";
      m_ad.internalVRef = bits.test(6);
      m_ad.threeChMode  = bits.test(5);
      m_ad.cdsMode      = bits.test(4);
      m_ad.inputClamp   = bits.test(3) ? "4V" : "3V";
      m_ad.powerDown    = bits.test(2);
   }
   else if ( address == fpga::ad9826::reg::muxconfig ) {
      m_ad.muxOrder    = bits.test(7) ? "RGB" : "BGR";
      m_ad.redSelect   = bits.test(6);
      m_ad.greenSelect = bits.test(5);
      m_ad.blueSelect  = bits.test(4);
   }
   else if ( address == fpga::ad9826::reg::gain ) {
      m_ad.gainInteger = data;
      m_ad.gainVolt    = 6.0/(1.0 + 5.0*(63 - static_cast<double>(data))/63.0);
   }
   else if ( address == fpga::ad9826::reg::offset ) {
      m_ad.offsetInteger   = data;
      m_ad.offsetMilliVolt = 1.17647058823529411765
	 * static_cast<double>(data & 0x00FF); // Just the 8 LSBs
      if ( bits.test(8) ) m_ad.offsetMilliVolt = -1.0 * m_ad.offsetMilliVolt;
   }
   else if ( m_verbosity == Verbosity::debug ) {
      std::cout << "Unknown AD9826 register\n";
   }
}


bool Camera::getAD9826Config()
{
   //
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

   // Decode the recieved data
   for ( int i = 0; i < 4; ++i ) {
      auto pkt = this->decodePacket(buffer[i*3], buffer[i*3+1], buffer[i*3+2]);
      this->decodeAD9826ConfigPacket(pkt);
   }

   m_ad.print();
   
   return true;
}


bool Camera::sampleTemperatures()
{
   m_ft.writeByte(fpga::command::toggle_mcp);
   // The FTDI latency timer is dominating the delay, so delay is not needed.

   // Store timepoint to be used to update PID regulator
   auto now = std::chrono::steady_clock::now();

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

   // Update PID regulator if cooling is on
   if ( m_coolerOn ) {
      unsigned char pwm = static_cast<unsigned char>(
	 m_pid.calculate(
	    now, this->m_thermistors.at(fpga::thermistor_id::ccd).getCelsius()
	    )
	 );
      this->setPeltierPWM(1, pwm);
      this->setPeltierPWM(2, pwm);
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

   // Just write: we are not expecting anything back from the FPGA.
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


void Camera::setVerbosity(Verbosity v)
{
	m_verbosity = v;
	m_pid.setVerbosity(v);
}


void Camera::setCoolerOn(const bool on)
{
   // Turn off cooling by setting the PWM outputs to 0
   if ( !on ) {
      this->setPeltierPWM(1, 0);
      this->setPeltierPWM(2, 0);
   }
   m_coolerOn = on;
}
