#include <iostream>
#include <chrono>
#include <thread>

#include "PID.hpp"

int main()
{
	
	PID pid(0.0, 255.0, 1.0, 0.1, 0.0);
	
	const double setTemperature = -10.0;
	double temperature = 20.0;
	pid.init(setTemperature, std::chrono::steady_clock::now());
	
	unsigned char pwm = 0;
	
	for ( int i = 0; i < 240; ++i ) {
		temperature -= static_cast<double>(pwm)/255*(
			std::abs(temperature - setTemperature)
			);
		std::this_thread::sleep_for(std::chrono::milliseconds(100));
		pwm = static_cast<unsigned char>(
			pid.calculate(std::chrono::steady_clock::now(), temperature)
			);
		std::cout << "set = " << setTemperature << ", "
					 << "pwm = " << static_cast<int>(pwm) << ", "
					 << "val = " << temperature << '\n';
	}
	
}
