#include <bitset>
#include <chrono>
#include <filesystem>
#include <iostream>
#include <regex>
#include <thread>
#include <unistd.h> // usleep
#include <vector>
#include <array>

#include "Camera.hpp"
#include "CImgPlot.hpp"


inline bool file_exists(const std::string  &filename)
{
   struct stat buffer;
   return (stat (filename.c_str(), &buffer) == 0);
}


void fileNameHandler(std::filesystem::path &filename)
{
   if ( file_exists(filename) )
   {
      // Try to find a number right before the extension and increment it.
      // If no number was found, add "_1" to the filename.
      std::cout << filename << " exists. Will try to rename." << '\n';
      std::filesystem::path filepath(filename);
      // See if there is a number at the end
      std::regex regex("[0-9]+$", std::regex::extended);
      std::smatch matches;
      std::filesystem::path parent_path = filepath.parent_path();
      std::string stem(filepath.stem().c_str());
      std::filesystem::path extension = filepath.extension().c_str();
      std::regex_search(stem, matches, regex);
      try {
	 unsigned int filenumber = stoi(matches[0]);
	 filename = parent_path / std::filesystem::path(
	    std::regex_replace(stem, regex, std::to_string(filenumber+1))
	    + extension.string()
	    );
      }
      catch ( const std::exception &) {
	 filename = parent_path
	    / std::filesystem::path(stem + "_1" + extension.string());
      }
      std::cout << "Renaming to " << filename << '\n';
      fileNameHandler(filename);
   }
   else return;
}


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
   
   Verbosity verbosity  = Verbosity::info;
   bool plot    = false;
   bool flush   = false;
   bool capture = false;
   bool cooling = false;
   bool reset   = false;
   double targetTemperature = 20.0;
   std::chrono::milliseconds integrationTime(0);
   std::filesystem::path imageFileName = "capture_0.tiff";
   
   // Read command line arguments
   for ( int i = 1; i < argc; i++ ) {
      // if ( checkArg(argc, argv, i, "--help", "-h", 0) ) {
      // 	 help(argv[0]);
      // 	 exit(EXIT_SUCCESS);
      // }
      if ( checkArg(argc, argv, i, "--debug", 0) ) {
	 verbosity = Verbosity::debug;
      }
      else if ( checkArg(argc, argv, i, "--reset", 0) ) {
	 reset = true;
      }
      // else if ( checkArg(argc, argv, i, "--log", 0) ) {
      // 	 logging = true;
      // }
      else if ( checkArg(argc, argv, i, "--cool", 1) ) {
	 targetTemperature = stod(std::string(argv[i+1]));
	 cooling = true;
	 ++i;
      }
      else if ( checkArg(argc, argv, i, "--cool-off", 0) ) {
	 cooling = false;
	 ++i;
      }
      else if ( checkArg(argc, argv, i, "--output", "-o", 1) ) {
	 imageFileName = std::string(argv[i+1]);
	 ++i;
      }
      else if ( checkArg(argc, argv, i, "--plot", 0) ) {
      	 plot = true;
      }
      else if ( checkArg(argc, argv, i, "--capture", "-c", 1) ) {
	 integrationTime
	    = std::chrono::milliseconds(
	       static_cast<unsigned long>(1e3*strtod(argv[i+1], NULL)));
	 capture = true;
	 ++i;
      }
      else if ( checkArg(argc, argv, i, "--flush", "-f", 0) ) {
	 flush = true;
      }
      else {
	 std::cerr << "ERROR: Unrecognized option: " << argv[i] << '\n';
	 exit(EXIT_FAILURE);
      }  
   }

   
   Camera camera;
   camera.setVerbosity(verbosity);

   try {
      camera.connect();
   }
   catch ( std::exception &e ) {
      std::cerr << "Exception: " << e.what() << '\n'
		<< "Exiting.\n";
      return 1;
   }

   std::cout << "Press ENTER to exit\n";
   std::string input;
   bool exit = false;
   bool shutterClosed = true;

   if ( reset ) {
      camera.reset();
   }
   
   camera.setOffset(10);
   camera.setGain(10);
   
   // camera.getAD9826Config();
	
   // camera.setOffset(12, true);
   
   camera.getAD9826Config();

   if ( flush ) {
      std::cout << "Flushing sensor\n";
      camera.flushSensor();
   }

   camera.setCoolerOn(cooling);
   if ( cooling ) {
      camera.setTemperature(targetTemperature);
   }

   if ( capture ) {
      
      fileNameHandler(imageFileName);
      
      camera.sampleTemperatures();
      auto lastTemperatureQuery = std::chrono::steady_clock::now();
      
      std::cout << "Integrating\n";
      camera.startExposure();
      auto start = std::chrono::steady_clock::now();
      std::chrono::milliseconds millisecSinceStart(0);
      
      while ( millisecSinceStart < integrationTime ) {
      	 auto now = std::chrono::steady_clock::now();
      	 millisecSinceStart
      	    = std::chrono::duration_cast<std::chrono::milliseconds>
      	    (now - start);
	 std::this_thread::sleep_for(std::chrono::milliseconds(10));
      }

      camera.stopExposure();
      std::vector<uint16_t> imageData = camera.getImageData();
      cimg_library::CImg<uint16_t> image(
	 camera.getWidth() + 1, camera.getHeight()
	 );
      // for ( size_t x = 0; x < imageData.size(); ++x ) {
      // 	 uint16_t pixel = imageData.at(x);
      // 	 image(pixel) = pixel;
      // }
      for ( size_t x = 0; x < camera.getWidth()-3; ++x ) {
	 for ( size_t y = 0; y < camera.getHeight(); ++y ) {
	    uint16_t pixel = imageData.at((x+3) + y*(1+camera.getWidth()));
	    image(x,y) = pixel;
	 }
      }
      image.save(imageFileName.c_str());
      CImgDisplay imgDisplay(image, imageFileName.c_str());
      image.resize_halfXY();
      imgDisplay.display(image);
      CImg<float> histogram(400, 300, 1, 3, 255);
      CImgDisplay histDisplay(histogram, "Histogram");
      // display histogram on display
      const unsigned char white[] = {255, 255, 255};
      histogram.draw_graph(image.get_histogram(255), white, 1, 3)
	 .display(histDisplay);
      std::this_thread::sleep_for(std::chrono::seconds(3));
      return 0;
   }

   if ( plot ) {
      const unsigned int temperatureImgSizeX = 500;
      const unsigned int temperatureImgSizeY = 400;
      std::vector<float> temperatureAmbient;
      std::vector<float> temperatureCCD;
      std::vector<float> temperatureTEC;
      std::vector<float> timeVec;
      std::vector<float> pwmVec;
      CImgPlot temperatureImg(temperatureImgSizeX, temperatureImgSizeY);
      temperatureImg.setTitle("Time (s)","Temperature (C)");
      temperatureImg.setXRange(30.0, true);
      CImgDisplay temperatureDisplay(temperatureImg, "Camera cooling");
      std::chrono::steady_clock::time_point start
	 = std::chrono::steady_clock::now();

      while ( !temperatureDisplay.is_closed() ) {
	 std::chrono::steady_clock::time_point now
	    = std::chrono::steady_clock::now();
	 auto msec
	    = std::chrono::duration_cast<std::chrono::milliseconds>(now-start);

	 // camera.test();
	 camera.sampleTemperatures();

	 timeVec.push_back(msec.count()/1000.0);
	 double ambTemp = camera.getTemperature(fpga::thermistor_id::ambient);
	 double ccdTemp = camera.getTemperature(fpga::thermistor_id::ccd);
	 double tecTemp = camera.getTemperature(fpga::thermistor_id::tec);
	 temperatureAmbient.push_back(ambTemp);
	 temperatureCCD.push_back(ccdTemp);
	 temperatureTEC.push_back(tecTemp);
      
	 pwmVec.push_back(static_cast<float>(camera.getCoolerOutputPercent()));

	 if ( temperatureAmbient.size() > 2 &&
	      temperatureCCD.size()     > 2 &&
	      timeVec.size()            > 2 
	    ) {
	    temperatureImg.line(1, timeVec, temperatureCCD, "l");
	    temperatureImg.line(2, timeVec, temperatureTEC, "l");
	    temperatureImg.line(3, timeVec, pwmVec, "l");
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
      
	 std::this_thread::sleep_for(std::chrono::milliseconds(1));
	 // std::this_thread::sleep_for(std::chrono::seconds(1));
      }
   }
   
   camera.disconnect();

   return 0;
}
