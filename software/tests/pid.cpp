#include <iostream>
#include <chrono>
#include <thread>
#include <vector>

#include "PID.hpp"
#include "CImgPlot.hpp"
#include "Verbosity.hpp"

int main()
{
	
   PID pid(0.0, 255.0, 1.0, 0.1, 0.0);
   pid.setVerbosity(Verbosity::debug);
	
   const double setTemperature = -10.0;
   double temperature = 20.0;
   pid.setTarget(setTemperature);
	
   unsigned char pwm = 0;
	
   auto start = std::chrono::steady_clock::now();
   std::vector<float> setVec;
   std::vector<float> pwmVec;
   std::vector<float> valVec;
   std::vector<float> timeVec;
   for ( int i = 0; i < 240; ++i ) {
      temperature -= static_cast<double>(pwm)/255*(
	 std::abs(temperature - setTemperature)
	 );
      std::this_thread::sleep_for(std::chrono::milliseconds(500));
      auto now = std::chrono::steady_clock::now();
      pwm = static_cast<unsigned char>(pid.calculate(now, temperature));
		
      setVec.push_back(setTemperature);
      pwmVec.push_back(pwm/10.0);
      valVec.push_back(temperature);
      timeVec.push_back(
	 std::chrono::duration_cast<std::chrono::duration<double>>
	 (now - start).count()
	 );
   }

   CImgPlot plot(500, 400);
   plot.setTitle("Time (s)","Temperature (C)");
   plot.setXRange(120.0, true);
   CImgDisplay display(plot, "PID test");
	
   plot.line(1, timeVec, setVec, "l");
   plot.line(2, timeVec, valVec, "l");
   plot.line(3, timeVec, pwmVec, "l");
   plot.draw();
   plot.display(display);
	
   while ( !display.is_closed() ) {
      std::this_thread::sleep_for(std::chrono::milliseconds(100));
   }
	
}
