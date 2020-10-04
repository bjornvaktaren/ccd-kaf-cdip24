#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <iostream>
#include <stdexcept>
#include <cmath>
#include <bitset>
#include <map>
#include <stdint.h>

#include "Ft245.hpp"
#include "Fpga.hpp"
#include "Thermistor.hpp"

class Camera
{
   
public:

   Camera();
   ~Camera(){};

   void connect();
   void disconnect();

   bool sampleTemperatures();
   double getTemperature(const uint16_t thermistor);
   bool openShutter();
   bool closeShutter();
   bool setCooling(const bool on=true);
   bool setPeltierPWM(const int peltier, const unsigned char pwmVal);
   bool setCCDReadoutMode(const unsigned char mode);
	
   void test();
   
private:
   
   fpga::DataPacket decodePacket(
      const unsigned char byte1,
      const unsigned char byte2,
      const unsigned char byte3
      );
   void decodeTemperatures(const fpga::DataPacket);

   enum class Verbosity {debug,warnings,info};
   Verbosity m_verbosity = Verbosity::info;
   Ft245 m_ft;
   std::map<uint16_t, Thermistor> m_thermistors =
   {
		{fpga::thermistor_id::ambient,
		 Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0)},
		{fpga::thermistor_id::ccd,
		 Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0)},
		{fpga::thermistor_id::tec,
		 Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0)}
	};
   
};

#endif
