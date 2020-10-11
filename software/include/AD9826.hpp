#ifndef AD9826_HPP
#define AD9826_HPP

struct AD9826 {
   std::string inputRange;
   bool internalVRef;
   bool threeChMode;
   bool cdsMode;
   std::string inputClamp;
   bool powerDown;
   std::string muxOrder;
   bool redSelect;
   bool greenSelect;
   bool blueSelect;
   uint16_t gainInteger;
   double gainVolt;
   uint16_t offsetInteger;
   double offsetMilliVolt;

   void print() {
      std::cout << "Parameter            Setting\n"
		<< "Input range          " << inputRange << '\n'
		<< "Internal VRef        " << internalVRef << '\n'
		<< "Three channel mode   " << threeChMode << '\n'
		<< "CDS mode             " << cdsMode << '\n'
		<< "Input clamp          " << inputClamp << '\n'
		<< "Power down           " << powerDown << '\n'
		<< "MUX order            " << muxOrder << '\n'
		<< "Red select           " << redSelect << '\n'
		<< "Green select         " << greenSelect << '\n'
		<< "Blue select          " << blueSelect << '\n'
		<< "Gain                 " << gainInteger << " (" << gainVolt
		<< " V/V)\n"
		<< "Offset               " << offsetInteger << " ("
		<< offsetMilliVolt << " mV)\n";
   }
};

#endif
