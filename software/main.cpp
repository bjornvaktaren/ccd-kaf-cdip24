#include <iostream>
#include <unistd.h> // usleep
#include <bitset>
#include <vector>
#include <chrono>
#include <thread>

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
   bool shutterClosed = true;
	
   int i = 0;
   while ( !temperatureDisplay.is_closed() ) {
      std::chrono::system_clock::time_point now
   	 = std::chrono::system_clock::now();
      auto msec
   	 = std::chrono::duration_cast<std::chrono::milliseconds>(now-start);

      // camera.test();
      camera.sampleTemperatures();

      timeAmbient.push_back(msec.count()/1000.0);
      timeCCD.push_back(msec.count()/1000.0);
		double ambTemp = camera.getTemperature(fpga::thermistor_id::ambient);
		double ccdTemp = camera.getTemperature(fpga::thermistor_id::ccd);
      temperatureAmbient.push_back(ambTemp);
      temperatureCCD.push_back(ccdTemp);

      if ( temperatureAmbient.size() > 2 &&
      	   temperatureCCD.size()     > 2 &&
      	   timeAmbient.size()        > 2 &&
      	   timeCCD.size()            > 2 ) {
      	 temperatureImg.line(1, timeAmbient, temperatureAmbient, "l");
      	 temperatureImg.line(2, timeCCD, temperatureCCD, "l");
      	 temperatureImg.draw();
      	 temperatureImg.display(temperatureDisplay);
      }

      // if ( shutterClosed ) {
      // 	 camera.openShutter();
      // 	 shutterClosed = false;
      // }
      // else {
      // 	 camera.closeShutter();
      // 	 shutterClosed = true;
      // }
      
      // unsigned char duty = 1 << i;
      // std::cout << static_cast<int>(duty) << '\n';
      // camera.setPeltierPWM(1, duty);
      // if ( i == 7 ) i = 0;
      // else ++i;
      
      std::this_thread::sleep_for(std::chrono::microseconds(100));
   }
   
   camera.disconnect();

   return 0;
}
