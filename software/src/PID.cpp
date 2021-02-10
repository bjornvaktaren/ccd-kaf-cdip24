#include <iostream>
#include "PID.hpp"

PID::PID(
   const double min,
   const double max,
   const double kp,
   const double ki,
   const double kd
   ) :
   m_max       {max},
   m_min       {min},
   m_kp        {kp},
   m_kd        {kd},
   m_ki        {ki},
   m_init      {false},
   m_prevTime  {},
   m_setPoint  {0.0},
   m_integral  {0.0},
   m_prevError {0.0},
   m_verbosity {Verbosity::error}
{
   if (m_min > m_max) {
      throw std::runtime_error("min must be lower than max");
   }
}


double PID::calculate(
   const std::chrono::steady_clock::time_point processTime,
   const double processValue
   )
{
   // Calculate time difference in seconds
   double dt = std::chrono::duration_cast<std::chrono::duration<double>>
      (processTime - m_prevTime).count();
	
   // Calculate error
   double error = m_setPoint - processValue;
	
   // Proportional term
   double p = m_kp * error;
	
   // Integral and derivative term
   // If it is the first time calling calcluate, set d and i to 0.
   double d = 0.0;
   double i = 0.0;
	
   if ( m_init ) {
		
      // integral
      m_integral += error * dt;
      i = m_ki * m_integral;
		
      // derivative
      double derivative = (error - m_prevError) / dt;
      d = m_kd * derivative;
		
   }
   else {
      m_init = true;
   }

   // Calculate total output
   double output = p + i + d;

   // Restrict to max/min
   if ( output > m_max ) {
      output = m_max;
   }
   else if ( output < m_min ) {
      output = m_min;
   }

   if ( m_verbosity == Verbosity::debug ) {
      std::cout << "pv = " << processValue
		<< ", set = " << m_setPoint
		<< ", p = " << p
		<< ", i = " << i
		<< ", d = " << d
		<< ", error = " << error
		<< ", dt = " << dt
		<< ", output = " << output
		<< '\n';
   }

   // Save current calues as previous values
   m_prevError = error;
   m_prevTime  = processTime;

   return output;
}
