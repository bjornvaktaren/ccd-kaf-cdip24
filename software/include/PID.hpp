#ifndef PID_HPP
#define PID_HPP

#include <chrono>
#include <stdexcept>

class PID
{

public:
	PID(
		const double min,
		const double max,
		const double Kp,
		const double Ki,
		const double Kd
		);
	~PID(){};

	void init(
		const double setPoint,
		const std::chrono::steady_clock::time_point processTime
		);
	
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

};


#endif
