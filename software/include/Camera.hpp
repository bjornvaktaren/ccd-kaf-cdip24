#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <iostream>
#include <stdexcept>
#include <cmath>
#include <bitset>
#include <map>

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
   double getTemperature(const std::string &thermistor);
   bool openShutter();
   bool closeShutter();
   bool setCooling(const bool on=true);
   bool setPeltierPWM(const int peltier, const unsigned char pwmVal);
   
private:
   
   enum class Verbosity {debug,warnings,info};
   Verbosity m_verbosity = Verbosity::info;
   Ft245 m_ft;
   std::map<std::string,Thermistor> m_thermistors =
   {{"ambient", Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0)},
    {"ccd",     Thermistor(2000.0, 3500.0, 3.3, 10000, 1023.0)}};


};

#endif
