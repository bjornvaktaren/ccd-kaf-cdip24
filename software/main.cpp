#include <unistd.h>  // usleep

#include <array>
#include <bitset>
#include <chrono>
#include <filesystem>
#include <iostream>
#include <regex>
#include <thread>
#include <vector>

#include "CImgPlot.hpp"
#include "Camera.hpp"
#include "Ft245.hpp"

inline bool file_exists(const std::string &filename) {
   struct stat buffer;
   return (stat(filename.c_str(), &buffer) == 0);
}

void fileNameHandler(std::filesystem::path &filename) {
   if (file_exists(filename)) {
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
         filename = parent_path /
                    std::filesystem::path(
                        std::regex_replace(stem, regex,
                                           std::to_string(filenumber + 1)) +
                        extension.string());
      } catch (const std::exception &) {
         filename = parent_path /
                    std::filesystem::path(stem + "_1" + extension.string());
      }
      std::cout << "Renaming to " << filename << '\n';
      fileNameHandler(filename);
   } else
      return;
}

bool checkArg(int argc, char *argv[], int &argi, const char *longOpt,
              const char *shortOpt, int nargs) {
   if (strcmp(argv[argi], longOpt) == 0 || strcmp(argv[argi], shortOpt) == 0) {
      if (argc == argi + nargs) {
         std::cerr << "ERROR: " << argv[argi] << " takes exactly " << nargs
                   << " argument(s)\n";
         exit(EXIT_FAILURE);
      }
      return true;
   }
   return false;
}

bool checkArg(int argc, char *argv[], int &argi, const char *longOpt,
              int nargs) {
   if (strcmp(argv[argi], longOpt) == 0) {
      if (argc == argi + nargs) {
         std::cerr << "ERROR: " << argv[argi] << " takes exactly " << nargs
                   << " argument(s)\n";
         exit(EXIT_FAILURE);
      }
      return true;
   }
   return false;
}

int main(int argc, char *argv[]) {
   Verbosity verbosity = Verbosity::info;
   bool plot = false;
   bool flush = false;
   bool capture = false;
   bool dark = false;
   bool cooling = false;
   bool reset = false;
   bool terminal = false;
   double targetTemperature = 20.0;
   std::chrono::milliseconds integrationTime(0);
   std::filesystem::path imageFileName = "capture_0.tiff";

   // Read command line arguments
   for (int i = 1; i < argc; i++) {
      // if ( checkArg(argc, argv, i, "--help", "-h", 0) ) {
      // 	 help(argv[0]);
      // 	 exit(EXIT_SUCCESS);
      // }
      if (checkArg(argc, argv, i, "--debug", 0)) {
         verbosity = Verbosity::debug;
      } else if (checkArg(argc, argv, i, "--reset", 0)) {
         reset = true;
      } else if (checkArg(argc, argv, i, "--terminal", "-t", 0)) {
         terminal = true;
      } else if (checkArg(argc, argv, i, "--cool", 1)) {
         targetTemperature = stod(std::string(argv[i + 1]));
         cooling = true;
         ++i;
      } else if (checkArg(argc, argv, i, "--cool-off", 0)) {
         cooling = false;
         ++i;
      } else if (checkArg(argc, argv, i, "--output", "-o", 1)) {
         imageFileName = std::string(argv[i + 1]);
         ++i;
      } else if (checkArg(argc, argv, i, "--plot", 0)) {
         plot = true;
      } else if (checkArg(argc, argv, i, "--capture", "-c", 1)) {
         integrationTime = std::chrono::milliseconds(
             static_cast<unsigned long>(1e3 * strtod(argv[i + 1], NULL)));
         capture = true;
         ++i;
      } else if (checkArg(argc, argv, i, "--dark", "-d", 1)) {
         integrationTime = std::chrono::milliseconds(
             static_cast<unsigned long>(1e3 * strtod(argv[i + 1], NULL)));
         dark = true;
         ++i;
      } else if (checkArg(argc, argv, i, "--flush", "-f", 0)) {
         flush = true;
      } else {
         std::cerr << "ERROR: Unrecognized option: " << argv[i] << '\n';
         exit(EXIT_FAILURE);
      }
   }

   Ft245 ft245;
   Camera camera(ft245);
   camera.setVerbosity(verbosity);

   try {
      camera.connect();
   } catch (std::exception &e) {
      std::cerr << "Exception: " << e.what() << '\n' << "Exiting.\n";
      return 1;
   }

   std::cout << "Press ENTER to exit\n";
   std::string input;
   bool exit = false;
   bool shutterClosed = true;

   if (reset) {
      camera.reset();
   }

   if (terminal) {
      std::cout << "Press h for help, q to exit\n";
      std::string command = "";

      while (command != "q" && command != "exit") {
         std::cin >> command;

         if (command == "h" || command == "help") {
            std::cout << "Commands:\n"
                      << "cool      c   : Set target temperature\n"
                      << "dark      d   : Capture a dark frame\n"
                      << "exit      q   : Quit\n"
                      << "gain      g   : Set CCD gain\n"
                      << "light     l   : Capture a light frame\n"
                      << "offset    o   : Sett CCD offest\n"
                      << "reset     r   : Reset CCD\n"
                      << "settings  s   : Print CCD settings\n"
                      << "tunepid   t   : Tune cooling PID\n";
         } else if (command == "gain" || command == "g") {
            double gain = 0;
            std::cout << "Enter gain [0,63]\n";
            std::cin >> gain;
            if (gain < 64) {
               std::cout << "Setting gain to " << (int)gain << '\n';
               camera.setGain(static_cast<unsigned char>(gain));
            } else {
               std::cout << "Invalid gain " << (int)gain << '\n';
            }
         } else if (command == "monitor" || command == "m") {
            std::cout << "Close window to exit command.\n";
            auto lastTemperatureQuery = std::chrono::steady_clock::now();
            const unsigned int temperatureImgSizeX = 500;
            const unsigned int temperatureImgSizeY = 400;
            std::vector<float> temperatureAmbient;
            std::vector<float> temperatureCCD;
            std::vector<float> temperatureTEC;
            std::vector<float> timeVec;
            std::vector<float> pwmVec;
            CImgPlot temperatureImg(temperatureImgSizeX, temperatureImgSizeY);
            temperatureImg.setTitle("Time (s)", "Temperature (C)");
            temperatureImg.setXRange(30.0, true);
            CImgDisplay temperatureDisplay(temperatureImg, "Camera cooling");
            std::chrono::steady_clock::time_point start =
                std::chrono::steady_clock::now();

            while (!temperatureDisplay.is_closed()) {
               std::chrono::steady_clock::time_point now =
                   std::chrono::steady_clock::now();
               auto msec =
                   std::chrono::duration_cast<std::chrono::milliseconds>(now -
                                                                         start);

               // camera.test();
               camera.sampleTemperatures();

               timeVec.push_back(msec.count() / 1000.0);
               double ambTemp =
                   camera.getTemperature(fpga::thermistor_id::ambient);
               double ccdTemp = camera.getTemperature(fpga::thermistor_id::ccd);
               double tecTemp = camera.getTemperature(fpga::thermistor_id::tec);
               temperatureAmbient.push_back(ambTemp);
               temperatureCCD.push_back(ccdTemp);
               temperatureTEC.push_back(tecTemp);

               pwmVec.push_back(
                   static_cast<float>(camera.getCoolerOutputPercent() / 10.0));

               if (temperatureAmbient.size() > 2 && temperatureCCD.size() > 2 &&
                   timeVec.size() > 2) {
                  temperatureImg.line(1, timeVec, temperatureCCD, "l");
                  temperatureImg.line(2, timeVec, temperatureTEC, "l");
                  temperatureImg.line(3, timeVec, pwmVec, "l");
                  temperatureImg.draw();
                  temperatureImg.display(temperatureDisplay);
               }
               std::this_thread::sleep_for(std::chrono::milliseconds(100));
            }
            command = "";
         } else if (command == "offset" || command == "o") {
            double offset = 0;
            std::cout << "Enter offset [-255,255]\n";
            std::cin >> offset;
            if (std::abs(offset) < 255) {
               std::cout << "Setting offset to " << (int)offset << '\n';
               unsigned char offsetChar =
                   static_cast<unsigned char>(std::abs(offset));
               if (offset > 0)
                  camera.setOffset(offsetChar, false);
               else
                  camera.setOffset(offsetChar, true);
            } else {
               std::cout << "Invalid offset " << (int)offset << '\n';
            }
         } else if (command == "settings" || command == "s") {
            camera.getAD9826Config();
         } else if (command == "reset" || command == "r") {
            camera.reset();
         } else if (command == "cool" || command == "c") {
            double celsius = 20.0;
            std::cout << "Enter target temperature in celsius\n";
            std::cin >> celsius;
            std::cout << "Setting target temperature to " << celsius << " C\n";
            if (celsius > -40.0 && celsius < 30.0) {
               camera.setCoolerOn();
               camera.setTemperature(celsius);
            }
         } else if (command == "dark" || command == "d") {
            double exposure = 1.0;
            int exposures = 1;
            std::cout << "Enter exposure time in seconds\n";
            std::cin >> exposure;
            std::cout << "Enter number of exposures\n";
            std::cin >> exposures;
            std::cout << "Capturing " << exposures << " dark frame(s) for "
                      << exposure << " s\n";

            integrationTime = std::chrono::milliseconds(
                static_cast<unsigned long>(1e3 * exposure));
            int exposureCount = 0;

            while (exposureCount < exposures) {
               std::filesystem::path imageFileName = "dark_0.tiff";
               fileNameHandler(imageFileName);

               std::cout << "Integrating\n";
               camera.startExposure(false);
               auto start = std::chrono::steady_clock::now();
               std::chrono::milliseconds millisecSinceStart(0);

               auto lastTemperatureQuery = std::chrono::steady_clock::now();
               camera.sampleTemperatures();

               while (millisecSinceStart < integrationTime) {
                  auto now = std::chrono::steady_clock::now();

                  auto millisecondsSinceLastTemperatureQuery =
                      std::chrono::duration_cast<std::chrono::milliseconds>(
                          now - lastTemperatureQuery);
                  if (millisecondsSinceLastTemperatureQuery.count() > 100.0) {
                     camera.sampleTemperatures();
                     lastTemperatureQuery = std::chrono::steady_clock::now();
                  }

                  millisecSinceStart =
                      std::chrono::duration_cast<std::chrono::milliseconds>(
                          now - start);
                  std::this_thread::sleep_for(std::chrono::milliseconds(100));
                  double ccdT = camera.getTemperature(fpga::thermistor_id::ccd);
                  double tecT = camera.getTemperature(fpga::thermistor_id::tec);
                  double coolPercent = camera.getCoolerOutputPercent();
                  std::cout << "  " << std::fixed << std::setprecision(1)
                            << millisecSinceStart.count() / 1000.0 << '/'
                            << integrationTime.count() / 1000.0 << " s, "
                            << "CCD: " << ccdT << " C, "
                            << "TEC: " << tecT << " C, "
                            << "Target: " << camera.getTargetTemperature()
                            << " C, Cooler: "
                            << (coolPercent > 0.0 ? coolPercent : 0.0) << " %"
                            << "\r";
                  std::cout.flush();
               }
               std::cout << '\n';

               camera.stopExposure(false);
               std::vector<uint16_t> imageData = camera.getImageData();
               cimg_library::CImg<uint16_t> image(camera.getWidth(),
                                                  camera.getHeight());
               for (size_t x = 0; x < camera.getWidth(); ++x) {
                  for (size_t y = 0; y < camera.getHeight(); ++y) {
                     try {
                        uint16_t pixel =
                            imageData.at(x + y * camera.getWidth());
                        image(x, y) = pixel;
                     } catch (std::exception &e) {
                        ;
                     }
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
               ++exposureCount;
            }
         } else if (command == "light" || command == "l") {
            double exposure = 1.0;
            int exposures = 1;
            std::cout << "Enter exposure time in seconds\n";
            std::cin >> exposure;
            std::cout << "Enter number of exposures\n";
            std::cin >> exposures;
            std::cout << "Capturing " << exposures << " light frame(s) for "
                      << exposure << " s\n";

            integrationTime = std::chrono::milliseconds(
                static_cast<unsigned long>(1e3 * exposure));
            int exposureCount = 0;

            while (exposureCount < exposures) {
               std::filesystem::path imageFileName = "light_0.tiff";
               fileNameHandler(imageFileName);

               std::cout << "Integrating\n";
               camera.startExposure();
               auto start = std::chrono::steady_clock::now();
               std::chrono::milliseconds millisecSinceStart(0);

               auto lastTemperatureQuery = std::chrono::steady_clock::now();
               camera.sampleTemperatures();

               while (millisecSinceStart < integrationTime) {
                  auto now = std::chrono::steady_clock::now();

                  auto millisecondsSinceLastTemperatureQuery =
                      std::chrono::duration_cast<std::chrono::milliseconds>(
                          now - lastTemperatureQuery);
                  if (millisecondsSinceLastTemperatureQuery.count() > 100.0) {
                     camera.sampleTemperatures();
                     lastTemperatureQuery = std::chrono::steady_clock::now();
                  }

                  millisecSinceStart =
                      std::chrono::duration_cast<std::chrono::milliseconds>(
                          now - start);
                  std::this_thread::sleep_for(std::chrono::milliseconds(100));
                  double ccdT = camera.getTemperature(fpga::thermistor_id::ccd);
                  double tecT = camera.getTemperature(fpga::thermistor_id::tec);
                  double coolPercent = camera.getCoolerOutputPercent();
                  std::cout << "  " << std::fixed << std::setprecision(1)
                            << millisecSinceStart.count() / 1000.0 << '/'
                            << integrationTime.count() / 1000.0 << " s, "
                            << "CCD: " << ccdT << " C, "
                            << "TEC: " << tecT << " C, "
                            << "Target: " << camera.getTargetTemperature()
                            << " C, Cooler: "
                            << (coolPercent > 0.0 ? coolPercent : 0.0) << " %"
                            << "\r";
                  std::cout.flush();
               }
               std::cout << '\n';

               camera.stopExposure();
               std::vector<uint16_t> imageData = camera.getImageData();
               cimg_library::CImg<uint16_t> image(camera.getWidth(),
                                                  camera.getHeight());
               for (size_t x = 0; x < camera.getWidth(); ++x) {
                  for (size_t y = 0; y < camera.getHeight(); ++y) {
                     try {
                        uint16_t pixel =
                            imageData.at(x + y * camera.getWidth());
                        image(x, y) = pixel;
                     } catch (std::exception &e) {
                        ;
                     }
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
               ++exposureCount;
            }
         } else if (command != "q" || command != "exit") {
            std::cout << "Unknown command: " << command << '\n'
                      << "Type h for help\n";
         }
      }

      camera.disconnect();
      return 0;
   }

   // camera.setOffset(20);
   camera.setGain(20);

   // camera.getAD9826Config();

   // camera.setOffset(12, true);

   camera.getAD9826Config();

   if (flush) {
      std::cout << "Flushing sensor\n";
      camera.flushSensor();
   }

   camera.setCoolerOn(cooling);
   if (cooling) {
      camera.setTemperature(targetTemperature);
   }

   if (capture || dark) {
      fileNameHandler(imageFileName);

      camera.sampleTemperatures();
      auto lastTemperatureQuery = std::chrono::steady_clock::now();

      std::cout << "Integrating\n";
      camera.startExposure(!dark);
      auto start = std::chrono::steady_clock::now();
      std::chrono::milliseconds millisecSinceStart(0);

      while (millisecSinceStart < integrationTime) {
         auto now = std::chrono::steady_clock::now();
         millisecSinceStart =
             std::chrono::duration_cast<std::chrono::milliseconds>(now - start);
         std::this_thread::sleep_for(std::chrono::milliseconds(10));
      }

      camera.stopExposure(!dark);
      std::vector<uint16_t> imageData = camera.getImageData();
      cimg_library::CImg<uint16_t> image(camera.getWidth(), camera.getHeight());
      // cimg_library::CImg<uint16_t> image(
      // 	 camera.getWidth() + 1, camera.getHeight()
      // 	 );
      // for ( size_t x = 0; x < imageData.size(); ++x ) {
      // 	 uint16_t pixel = imageData.at(x);
      // 	 image(pixel) = pixel;
      // }
      for (size_t x = 0; x < camera.getWidth(); ++x) {
         for (size_t y = 0; y < camera.getHeight(); ++y) {
            try {
               uint16_t pixel = imageData.at(x + y * camera.getWidth());
               image(x, y) = pixel;
            } catch (std::exception &e) {
               ;
            }
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

   if (plot) {
      const unsigned int temperatureImgSizeX = 500;
      const unsigned int temperatureImgSizeY = 400;
      std::vector<float> temperatureAmbient;
      std::vector<float> temperatureCCD;
      std::vector<float> temperatureTEC;
      std::vector<float> timeVec;
      std::vector<float> pwmVec;
      CImgPlot temperatureImg(temperatureImgSizeX, temperatureImgSizeY);
      temperatureImg.setTitle("Time (s)", "Temperature (C)");
      temperatureImg.setXRange(30.0, true);
      CImgDisplay temperatureDisplay(temperatureImg, "Camera cooling");
      std::chrono::steady_clock::time_point start =
          std::chrono::steady_clock::now();

      while (!temperatureDisplay.is_closed()) {
         std::chrono::steady_clock::time_point now =
             std::chrono::steady_clock::now();
         auto msec =
             std::chrono::duration_cast<std::chrono::milliseconds>(now - start);

         // camera.test();
         camera.sampleTemperatures();

         timeVec.push_back(msec.count() / 1000.0);
         double ambTemp = camera.getTemperature(fpga::thermistor_id::ambient);
         double ccdTemp = camera.getTemperature(fpga::thermistor_id::ccd);
         double tecTemp = camera.getTemperature(fpga::thermistor_id::tec);
         temperatureAmbient.push_back(ambTemp);
         temperatureCCD.push_back(ccdTemp);
         temperatureTEC.push_back(tecTemp);

         pwmVec.push_back(static_cast<float>(camera.getCoolerOutputPercent()));

         if (temperatureAmbient.size() > 2 && temperatureCCD.size() > 2 &&
             timeVec.size() > 2) {
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
