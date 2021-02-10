#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <bitset>
#include <cmath>
#include <iostream>
#include <map>
#include <stdexcept>
#include <stdint.h>
#include <vector>
#include <thread>
#include <chrono>

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
   void startExposure(const bool openShutter = true);
   void stopExposure(const bool closeShutter = true);
   void flushSensor();
   bool getAD9826Config();
   bool sampleTemperatures();
   double getTemperature(const uint16_t thermistor);
   bool openShutter();
   bool closeShutter();
   bool setCCDReadoutMode(const unsigned char mode);
   void setVerbosity(Verbosity v);

   bool getCoolerOn() const { return m_coolerOn; };
   void setCoolerOn(const bool on=true);
   double getCoolerOutputPercent() const { return m_pidOutPercent; };
   double getTargetTemperature() const { return m_pid.getTarget(); };

   void setTemperature(double celsius);
   
   std::vector<uint16_t> getImageData() const { return m_imageData; };
   std::vector<uint16_t> getActiveImageData();

   // Image size in number of pixels
   constexpr int getWidth() const { return 2267; };
   constexpr int getHeight() const { return 1510 + 1; };
   constexpr int getActiveWidth() const { return 2184; };
   constexpr int getActiveHeight() const { return 1472; };
   constexpr int getInvalidLeft() const { return 50; };
   constexpr int getInvalidRight() const { return 33; };
   constexpr int getInvalidTop() const { return 35; };
   constexpr int getInvalidBottom() const { return 4; };
   
   // Pixel size in micrometer
   double getPixelWidth() const { return 6.8; };
   double getPixelHeight() const { return 6.8; };
   
   // ADC channels
   int getADCResolution() const { return 16; };

   void reset();
	
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
   double m_pidOutPercent;
   std::vector<uint16_t> m_imageData;
   std::vector<unsigned char> m_rawPixelData;
   
};

#endif
