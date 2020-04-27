#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <iostream>
#include <stdexcept>
#include <cmath>
#include <bitset>

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

   std::pair<std::string, double> getTemperature();
   
private:
   
   enum class Verbosity {debug,warnings,info};
   Verbosity m_verbosity = Verbosity::info;
   Ft245 m_ft;
   Thermistor m_thAmbient;
   Thermistor m_thCCD;

};

#endif
