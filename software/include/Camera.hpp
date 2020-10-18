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
#include "AD9826.hpp"
#include "PID.hpp"

class Camera
{
   
public:

   Camera();
   ~Camera(){};

   void connect();
   void disconnect();

   bool setGain(const unsigned char gain);
   bool setOffset(const unsigned char offset, const bool negative = false);
   void startExposure();
   void stopExposure();
   bool getAD9826Config();
   bool sampleTemperatures();
   double getTemperature(const uint16_t thermistor);
   bool openShutter();
   bool closeShutter();
   bool setCCDReadoutMode(const unsigned char mode);
   void setVerbosity(Verbosity v);
   void setCCDTargetTemperature(const double celsius) {
      m_ccdTargetTemperature = celsius;
   };

   bool getCoolerOn() { return m_coolerOn; };
   void setCoolerOn(const bool on=true);

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
   void decodeTemperatures(
      const fpga::DataPacket packet
      );
   void decodeAD9826ConfigPacket(
      const fpga::DataPacket packet
      );
	
   bool setPeltierPWM(
      const int peltier,
      const unsigned char pwmVal
      );
   
   Verbosity m_verbosity;
   bool m_coolerOn;
   Ft245 m_ft;
   AD9826 m_ad;
   std::map<uint16_t, Thermistor> m_thermistors;
   double m_ccdTargetTemperature;
   PID m_pid;
   
};

#endif
