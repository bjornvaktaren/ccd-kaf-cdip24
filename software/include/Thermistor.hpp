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
      const double Rref
      );
   ~Thermistor(){};

   double celsius(const double &U);
   
   constexpr double getV0(){ return m_V0; };
   
private:

   // thermistor properties
   const double m_R25;
   const double m_beta;
   // circuit properties
   const double m_V0;
   const double m_Rref;
   // physical constants
   static constexpr double m_T25  = 298.15; // 25 C in Kelvin
   static constexpr double m_T0   = 273.15; // 0 C in Kelvin

};

#endif

