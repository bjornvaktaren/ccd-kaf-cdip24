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
	m_integral  {0.0}
{
	if (m_min > m_max) {
		throw std::runtime_error("min must be lower than max");
	}
}


void PID::init(
	const double setPoint,
	const std::chrono::steady_clock::time_point processTime
	)
{
	m_setPoint = setPoint;
	m_prevTime = processTime;
	m_init = true;
}


double PID::calculate(
	const std::chrono::steady_clock::time_point processTime,
	const double processValue
	)
{
	if ( ! m_init ) throw std::runtime_error("PID not initialized");

	// Calculate time difference in seconds
	double dt = std::chrono::duration_cast<std::chrono::duration<double>>
		(processTime - m_prevTime).count();
	if ( dt < 0.0 ) throw std::runtime_error("PID called with negative time");
	
	// Calculate error
	double error = std::abs(m_setPoint - processValue);
	
	// Proportional term
	double p = m_kp * error;
	
	// Integral term
	m_integral += error * dt;
	double i = m_ki * m_integral;

	// Derivative term
	double derivative = (error - m_prevError) / dt;
	double d = m_kd * derivative;

	// Calculate total output
	double output = p + i + d;

	// Restrict to max/min
	if ( output > m_max ) {
		output = m_max;
	}
	else if ( output < m_min ) {
		output = m_min;
	}
	
	std::cout << "p = " << p
				 << ", i = " << i
				 << ", d = " << d
				 << ", error = " << error
				 << ", dt = " << dt
				 << ", output = " << output
				 << '\n';

	// Save current calues as previous values
	m_prevError = error;
	m_prevTime  = processTime;

	return output;
}
