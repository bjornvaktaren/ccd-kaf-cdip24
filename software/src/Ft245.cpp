#include "Ft245.hpp"

#include <chrono>
#include <thread>

namespace {
constexpr std::chrono::milliseconds kFtdiConfigureSleep{50};

}

bool Ft245::Open() {
   // initialize
   int ftdi_status = 0;
   ftdi_status = ftdi_init(&m_ftdi);
   if (m_verbosity == Verbosity::debug) {
      std::cout << "Camera::open() ftdi_status = " << ftdi_status << '\n';
   }
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Failed to initialize device\n";
      return false;
   }
   ftdi_set_interface(&m_ftdi, INTERFACE_A);

   ftdi_status =
       ftdi_usb_open(&m_ftdi, m_ftdiSetup.vendor, m_ftdiSetup.product);
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Can't open device. Got error\n"
                << ftdi_get_error_string(&m_ftdi) << '\n';
      return false;
   }

   ftdi_status = ftdi_set_bitmode(&m_ftdi, 0xff, BITMODE_RESET);  // Sync FT245
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Can't set bit mode. Got error\n"
                << ftdi_get_error_string(&m_ftdi) << '\n';
      return false;
   }

   std::this_thread::sleep_for(kFtdiConfigureSleep);

   ftdi_status = ftdi_set_bitmode(&m_ftdi, 0xff, BITMODE_SYNCFF);  // Sync FT245
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Can't set bit mode. Got error\n"
                << ftdi_get_error_string(&m_ftdi) << '\n';
      return false;
   }

   // ftdi_status = ftdi_set_latency_timer(&m_ftdi, 1); // 16 worked on UM232H
   ftdi_status = ftdi_set_latency_timer(&m_ftdi, 16);  // 16 worked on UM232H
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Can't set latency timer. Got error\n"
                << ftdi_get_error_string(&m_ftdi) << '\n';
      return false;
   }

   ftdi_status = ftdi_read_data_set_chunksize(&m_ftdi, 16384);
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Can't set chunk size. Got error\n"
                << ftdi_get_error_string(&m_ftdi) << '\n';
      return false;
   }

   ftdi_status = ftdi_tcioflush(&m_ftdi);
   if (ftdi_status != 0) {
      std::cerr << "ERROR: Can't flush buffer. Got error\n"
                << ftdi_get_error_string(&m_ftdi) << '\n';
      return false;
   }

   std::this_thread::sleep_for(kFtdiConfigureSleep);

   ftdi_status = ftdi_read_eeprom(&m_ftdi);
   if (ftdi_status < 0) {
      fprintf(stderr, "ftdi_read_eeprom: %d (%s)\n", ftdi_status,
              ftdi_get_error_string(&m_ftdi));
      return -1;
   }

   ftdi_eeprom_decode(&m_ftdi, 0);
   int type;
   ftdi_get_eeprom_value(&m_ftdi, ftdi_eeprom_value::CHANNEL_A_TYPE, &type);

   if (type != CHANNEL_IS_FIFO) {
      std::cerr << "ERROR: channel is not FIFO. Please program the EEPROM\n";
      return -1;
   }

   return 0;
}

void Ft245::Close() { ftdi_usb_close(&m_ftdi); }

bool Ft245::WriteByte(const uint8_t byte) {
   return this->Write({byte});
   // // need to purge tx when writing for some etherial reason
   // if ( ftdi_usb_purge_tx_buffer(&m_ftdi) != 0) {
   //    std::cerr << "ERROR: Can't purge FTDI tx buffer: "
   // 		<< "       " << ftdi_get_error_string(&m_ftdi) << '\n';
   // }
   // int ftdi_status = ftdi_write_data(&m_ftdi, &byte, 1);
   // if ( ftdi_status != 1 ) {
   //    std::cerr << "ERROR: Ft245::write() failed with status " <<
   //    ftdi_status
   // 		<< '\n';
   // }
   // return ftdi_status;
}

std::optional<uint8_t> Ft245::ReadByte() {
   // // need to purge rx when reading for some etherial reason
   // if ( ftdi_usb_purge_rx_buffer(&m_ftdi) != 0) {
   //    std::cerr << "ERROR: Can't purge FTDI buffers: "
   // 		<< "       " << ftdi_get_error_string(&m_ftdi) << '\n';
   // }

   int bytesRead = 0;
   uint8_t byte{0};
   for (int tries = 0; tries < 10 && bytesRead != 1; ++tries) {
      bytesRead = ftdi_read_data(&m_ftdi, &byte, 1);
   }
   // int ftdi_status = ftdi_read_data(&m_ftdi, &byte, 1);
   if (bytesRead != 1) {
      std::cerr << "ERROR: Ft245::read() failed with status " << bytesRead
                << '\n';
      return std::nullopt;
   }
   return byte;
}

bool Ft245::Write(const std::vector<uint8_t> &data) {
   // // need to purge tx when writing for some etherial reason
   // if ( ftdi_usb_purge_tx_buffer(&m_ftdi) != 0) {
   //    std::cerr << "ERROR: Can't purge FTDI tx buffer: "
   // 		<< "       " << ftdi_get_error_string(&m_ftdi) << '\n';
   // }
   int bytesWritten = 0;
   for (int tries = 0; tries < 10 && bytesWritten != data.size(); ++tries) {
      bytesWritten += ftdi_write_data(&m_ftdi, &data[bytesWritten],
                                      data.size() - bytesWritten);
   }
   if (bytesWritten != data.size()) {
      std::cerr << "ERROR: Ft245::write() failed with error "
                << ftdi_get_error_string(&m_ftdi) << '\n';
   }
   return bytesWritten == data.size();
}

std::vector<uint8_t> Ft245::Read(unsigned int bytes_to_read) {
   // // need to purge rx when reading for some etherial reason
   // // otherwise a lot of old crap it still there
   // if ( ftdi_usb_purge_tx_buffer(&m_ftdi) != 0) {
   //    std::cerr << "ERROR: Can't purge FTDI buffers: "
   // 		<< "       " << ftdi_get_error_string(&m_ftdi) << '\n';
   // }
   std::vector<uint8_t> data;
   data.resize(bytes_to_read);
   int bytesRead = 0;
   for (int tries = 0; tries < 10 && bytesRead != bytes_to_read; ++tries) {
      int ret = ftdi_read_data(&m_ftdi, data.data(), bytes_to_read - bytesRead);
      if (ret < 0) {
         std::cerr << "ERROR in Ft245::read(): "
                   << ftdi_get_error_string(&m_ftdi) << '\n';
      }
      bytesRead += ret;
      // else {
      // 	 std::cout << "INFO in Ft245::read(): ftdi_read_data returned "
      // 		   << ret << '\n';
      // 	 bytesRead += ret;
      // }
      // if ( ret == 0 ) break;
   }
   data.resize(bytesRead);
   return data;
}
