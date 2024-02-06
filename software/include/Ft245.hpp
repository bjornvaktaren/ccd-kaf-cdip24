#ifndef FT245_HPP
#define FT245_HPP

#include <ftdi.h>

#include <iostream>

#include "Ft245_if.hpp"

// struct FtdiSetup_t {
//   // FT2232H
//   int vendor = 0x0403;   // ftdi chip usb specification
//   int product = 0x6010;  // ftdi chip usb specification
// };

class Ft245 : public Ft245Interface {
 public:
  Ft245(){};
  ~Ft245(){};

  // Ft245interface
  bool Open() override;
  void Close() override;
  bool WriteByte(uint8_t byte) override;
  std::optional<uint8_t> ReadByte() override;
  bool Write(const std::vector<uint8_t> &data) override;
  std::vector<uint8_t> Read(unsigned int bytes_to_read) override;

 private:
  struct ftdi_context m_ftdi;
  struct FtdiSetup_t m_ftdiSetup;
  enum class Verbosity { debug, warnings, info };
  Verbosity m_verbosity = Verbosity::info;
};

#endif
