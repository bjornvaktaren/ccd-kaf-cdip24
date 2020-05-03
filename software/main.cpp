#include <iostream>
#include <unistd.h> // usleep
#include <bitset>
#include <vector>
#include <chrono>

#include "Camera.hpp"
#include "CImgPlot.hpp"

int main(int argc, char* argv[])
{
   
   Camera camera;

   try {
      camera.connect();
   }
   catch ( std::exception &e ) {
      std::cerr << "Exception: " << e.what() << '\n'
		<< "Exiting.\n";
      return 1;
   }

   const unsigned int temperatureImgSizeX = 500;
   const unsigned int temperatureImgSizeY = 400;
   std::vector<float> temperatureAmbient;
   std::vector<float> temperatureCCD;
   std::vector<float> timeAmbient;
   std::vector<float> timeCCD;
   CImgPlot temperatureImg(temperatureImgSizeX, temperatureImgSizeY);
   temperatureImg.setTitle("Time (s)","Temperature (C)");
   temperatureImg.setXRange(30.0, true);
   CImgDisplay temperatureDisplay(temperatureImg, "Camera cooling");
   std::chrono::system_clock::time_point start
      = std::chrono::system_clock::now();

   std::cout << "Press ENTER to exit\n";
   std::string input;
   bool exit = false;
   while ( !temperatureDisplay.is_closed() ) {
      std::chrono::system_clock::time_point now
	 = std::chrono::system_clock::now();
      auto msec
	 = std::chrono::duration_cast<std::chrono::milliseconds>(now-start);

      camera.sampleTemperatures();
      
      temperatureAmbient.push_back(camera.getTemperature("ambient"));
      timeAmbient.push_back(msec.count()/1000.0);
      temperatureCCD.push_back(camera.getTemperature("ccd"));
      timeCCD.push_back(msec.count()/1000.0);

      temperatureImg.line(1, timeAmbient, temperatureAmbient, "l");
      temperatureImg.line(2, timeCCD, temperatureCCD, "l");
      temperatureImg.draw();
      temperatureImg.display(temperatureDisplay);

      // usleep(1000);
   }

   camera.disconnect();

   return 0;
}
