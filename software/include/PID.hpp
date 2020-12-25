#ifndef PID_HPP
#define PID_HPP

#include <chrono>
#include <stdexcept>

#include "Verbosity.hpp"

class PID
{

public:
   PID(
      const double min, // Output minimum limit
      const double max, // Output maximum limit
      const double Kp,  // Proportional term
      const double Ki,  // Integral term
      const double Kd   // Derivative term
      );
   ~PID(){};

   void setTarget(const double setPoint) { m_setPoint = setPoint; };
   void setVerbosity(const Verbosity v) { m_verbosity = v; };

   double getMaximum() const { return m_max; };
   double getMinimum() const { return m_min; };
   double getKp() const { return m_kp; };
   double getKi() const { return m_ki; };
   double getKs() const { return m_kd; };
	
   double calculate(
      const std::chrono::steady_clock::time_point processTime,
      const double processValue
      );

private:
	
   double m_max;
   double m_min;
   double m_kp;
   double m_kd;
   double m_ki;
   bool m_init;
   std::chrono::steady_clock::time_point m_prevTime;
   double m_setPoint;
   double m_integral;
   double m_prevError;
   Verbosity m_verbosity;

};


#endif
