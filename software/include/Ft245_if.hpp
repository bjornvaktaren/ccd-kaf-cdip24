#pragma once

#include <cstdint>
#include <optional>
#include <vector>

struct FtdiSetup_t {
  // FT2232H
  int vendor = 0x0403;   // ftdi chip usb specification
  int product = 0x6010;  // ftdi chip usb specification
};

class Ft245Interface {
 public:
  /* Open the Ft245 interface

     @return true if success, false otherwise
   */
  virtual bool Open() = 0;

  /* Close the Ft245 interface */
  virtual void Close() = 0;

  /* Write one byte to the FT245 device

     @param byte the byte to write
     @return true if success, false otherwise
   */
  virtual bool WriteByte(uint8_t byte) = 0;

  /* Read one byte from the FT245 device

     @return the byte if success, std::nullopt of not
   */
  virtual std::optional<uint8_t> ReadByte() = 0;

  /* Write bytes to the FT245 device

     @param data the data to write
     @return true if success, false otherwise
   */
  virtual bool Write(const std::vector<uint8_t> &data) = 0;

  /* Read bytes from the FT245 device

     @param bytes_to_read the number of bytes to read
     @return the read data
   */
  virtual std::vector<uint8_t> Read(unsigned int bytes_to_read) = 0;
};
