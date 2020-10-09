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
#include "Verbosity.hpp"

class Camera
{
   
public:

   Camera();
   ~Camera(){};

   void connect();
   void disconnect();

   bool getAD9826Config();
   bool sampleTemperatures();
   double getTemperature(const uint16_t thermistor);
   bool openShutter();
   bool closeShutter();
   bool setCooling(const bool on=true);
   bool setPeltierPWM(const int peltier, const unsigned char pwmVal);
   bool setCCDReadoutMode(const unsigned char mode);
   void setVerbosity(Verbosity v) { m_verbosity = v; };

   // Image size in number of pixels
   int getWidth() { return 2184; };
   int getHeight() { return 1472; };
   
   // Pixel size in micrometer
   double getPixelWidth() { return 6.8; };
   double getPixelHeight() { return 6.8; };
   
   // ADC channels
   int getADCResolution() { return 16; };
	
   void test();
   
private:
   
   fpga::DataPacket decodePacket(
      const unsigned char byte1,
      const unsigned char byte2,
      const unsigned char byte3
      );
   void decodeTemperatures(const fpga::DataPacket);
   
   Verbosity m_verbosity;
   Ft245 m_ft;
   std::map<uint16_t, Thermistor> m_thermistors;
   
};

#endif
