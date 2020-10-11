#include <iostream>
#include <unistd.h> // usleep
#include <bitset>
#include <vector>
#include <chrono>
#include <thread>

#include "Camera.hpp"
#include "CImgPlot.hpp"

bool checkArg(int argc, char* argv[], int &argi, const char* longOpt,
	      const char* shortOpt, int nargs)
{
   if ( strcmp(argv[argi], longOpt) == 0 ||
	strcmp(argv[argi], shortOpt) == 0 ) {
      if ( argc == argi+nargs ) {
 	 std::cerr << "ERROR: " << argv[argi] << " takes exactly " << nargs
		   << " argument(s)\n";
	 exit(EXIT_FAILURE);
      }
      return true;
   }
   return false;
}

bool checkArg(int argc, char* argv[], int &argi, const char* longOpt,
	      int nargs)
{
   if ( strcmp(argv[argi], longOpt) == 0 ) {
      if ( argc == argi+nargs ) {
 	 std::cerr << "ERROR: " << argv[argi] << " takes exactly " << nargs
		   << " argument(s)\n";
	 exit(EXIT_FAILURE);
      }
      return true;
   }
   return false;
}


int main(int argc, char* argv[])
{
   Verbosity v = Verbosity::info;
   // Read command line arguments
   for ( int i = 1; i < argc; i++ ) {
      // if ( checkArg(argc, argv, i, "--help", "-h", 0) ) {
      // 	 help(argv[0]);
      // 	 exit(EXIT_SUCCESS);
      // }
      if ( checkArg(argc, argv, i, "--debug", 0) ) {
	 v = Verbosity::debug;
      }
      // else if ( checkArg(argc, argv, i, "--reset", 0) ) {
      // 	 resetCamera = true;
      // }
      // else if ( checkArg(argc, argv, i, "--log", 0) ) {
      // 	 logging = true;
      // }
      // else if ( checkArg(argc, argv, i, "--cool", 1) ) {
      // 	 targetTemperature = atoi(argv[i+1]);
      // 	 activateCooling = true;
      // 	 ++i;
      // }
      // else if ( checkArg(argc, argv, i, "--output", "-o", 1) ) {
      // 	 imageFileName = std::string(argv[i+1]);
      // 	 ++i;
      // }
      // else if ( checkArg(argc, argv, i, "--monitor", 0) ) {
      // 	 monitor = true;
      // }
      // else if ( checkArg(argc, argv, i, "--capture", 1) ) {
      // 	 integrationTime
      // 	    = std::chrono::milliseconds(
      // 	       static_cast<unsigned long>(1e3*strtod(argv[i+1], NULL)));
      // 	 capture = true;
      // 	 ++i;
      // }
      else {
	 std::cerr << "ERROR: Unrecognized option: " << argv[i] << '\n';
	 exit(EXIT_FAILURE);
      }  
   }

   
   Camera camera;
   camera.setVerbosity(v);

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
   std::vector<float> temperatureTEC;
   std::vector<float> timeAmbient;
   std::vector<float> timeCCD;
   std::vector<float> timeTEC;
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

   camera.setOffset(10);
   camera.setGain(10);
   
   // camera.getAD9826Config();
	
   // camera.setOffset(12, true);
   
   camera.getAD9826Config();
   // int i = 0;
   // while ( !temperatureDisplay.is_closed() ) {
   //    std::chrono::system_clock::time_point now
   // 	 = std::chrono::system_clock::now();
   //    auto msec
   // 	 = std::chrono::duration_cast<std::chrono::milliseconds>(now-start);

   //    // camera.test();
   //    camera.sampleTemperatures();

   //    timeAmbient.push_back(msec.count()/1000.0);
   //    timeCCD.push_back(msec.count()/1000.0);
   //    timeTEC.push_back(msec.count()/1000.0);
   //    double ambTemp = camera.getTemperature(fpga::thermistor_id::ambient);
   //    double ccdTemp = camera.getTemperature(fpga::thermistor_id::ccd);
   //    double tecTemp = camera.getTemperature(fpga::thermistor_id::tec);
   //    temperatureAmbient.push_back(ambTemp);
   //    temperatureCCD.push_back(ccdTemp);
   //    temperatureTEC.push_back(tecTemp);

   //    if ( temperatureAmbient.size() > 2 &&
   //    	   temperatureCCD.size()     > 2 &&
   //    	   timeAmbient.size()        > 2 &&
   //    	   timeCCD.size()            > 2 &&
   //    	   timeTEC.size()            > 2 
   // 	 ) {
   //    	 temperatureImg.line(1, timeAmbient, temperatureAmbient, "l");
   //    	 temperatureImg.line(2, timeCCD, temperatureCCD, "l");
   //    	 temperatureImg.line(3, timeTEC, temperatureTEC, "l");
   //    	 temperatureImg.draw();
   //    	 temperatureImg.display(temperatureDisplay);
   //    }

   //    // if ( shutterClosed ) {
   //    // 	 camera.openShutter();
   //    // 	 shutterClosed = false;
   //    // }
   //    // else {
   //    // 	 camera.closeShutter();
   //    // 	 shutterClosed = true;
   //    // }
      
   //    // unsigned char duty = 1 << i;
   //    // std::cout << static_cast<int>(duty) << '\n';
   //    // camera.setPeltierPWM(1, duty);
   //    // if ( i == 7 ) i = 0;
   //    // else ++i;
      
   //    // std::this_thread::sleep_for(std::chrono::microseconds(100));
   //    std::this_thread::sleep_for(std::chrono::seconds(1));
   // }
   
   camera.disconnect();

   return 0;
}
