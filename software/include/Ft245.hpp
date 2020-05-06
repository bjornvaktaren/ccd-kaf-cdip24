#ifndef FT245_HPP
#define FT245_HPP

#include <ftdi.h>
#include <iostream>
#include <unistd.h> // usleep

struct FtdiSetup_t {
   // UM232H development module
   int vendor = 0x0403;        // ftdi chip usb specification
   int product = 0x6014;       // ftdi chip usb specification
};

class Ft245
{
   
public:

   Ft245(){};
   ~Ft245(){};

   int init();
   int close();

   int writeByte(const unsigned char &byte);
   int readByte(unsigned char &byte);
   int write(const unsigned char *buffer, const int nBytes);
   int read(unsigned char *buffer, const int nBytes);
   
private:
   
   struct ftdi_context m_ftdi;
   struct FtdiSetup_t m_ftdiSetup;
   enum class Verbosity {debug,warnings,info};
   Verbosity m_verbosity = Verbosity::info;

};

#endif
