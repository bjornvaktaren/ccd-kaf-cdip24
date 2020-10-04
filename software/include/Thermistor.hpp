#ifndef THERMISTOR_HPP
#define THERMISTOR_HPP

#include <cmath>

// Class representing a NTC thermistor connected as the negative-side resistor
// on a voltage divider:
//  ----------< V0
//  |
// | | Rref
//  |
//  ----------< U
//  |
// | | R25 (NTC)
//  |
//  ----------< GND

class Thermistor
{

public:
   
   Thermistor(
      const double R25,
      const double beta,
      const double V0,
      const double Rref,
      const double ADCRes
      );
   ~Thermistor(){};

   double getCelsius();
   template <typename T> void setMeasurement(const T m) {
      m_U = static_cast<double>(m)/m_ADCRes*m_V0;
   };
   double getMeasuredVoltage() { return m_U; };
   
   constexpr double getV0(){ return m_V0; };
   
private:

   // physical constants
   static constexpr double m_T25  = 298.15; // 25 Kelvin in C
   static constexpr double m_T0   = 273.15; // 0 Kelvin in C
   
   // thermistor properties
   const double m_R25;
   const double m_beta;
   // circuit properties
   const double m_V0;
   const double m_Rref;
   const double m_ADCRes;

   // data
   double m_U;

};

#endif

