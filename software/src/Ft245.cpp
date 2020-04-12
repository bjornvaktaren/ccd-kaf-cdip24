#include <Ft245.hpp>

int Ft245::init()
{
   // initialize
   int ftdi_status = 0;
   ftdi_status = ftdi_init(&m_ftdi);
   if ( m_verbosity == Verbosity::debug ) {
      std::cout << "Camera::open() ftdi_status = " << ftdi_status << '\n';
   }
   if ( ftdi_status != 0 ) {
      std::cerr << "ERROR: Failed to initialize device\n";
      return ftdi_status;
   }
   ftdi_set_interface(&m_ftdi, INTERFACE_ANY);
   
   ftdi_status = ftdi_usb_open(&m_ftdi, m_ftdiSetup.vendor,
			       m_ftdiSetup.product);
   if ( ftdi_status != 0 ) {
      std::cerr << "ERROR: Can't open device. Got error\n"
		<< ftdi_get_error_string(&m_ftdi) << '\n';
      return ftdi_status;
   }
   
   ftdi_status = ftdi_set_bitmode(&m_ftdi, 0, BITMODE_SYNCFF); // Sync FT245
   if ( ftdi_status != 0 ) {
      std::cerr << "ERROR: Can't set bit mode. Got error\n"
	       << ftdi_get_error_string(&m_ftdi) << '\n';
      return ftdi_status;
   }
   
   ftdi_status = ftdi_set_latency_timer(&m_ftdi, 255);
   if ( ftdi_status != 0 ) {
      std::cerr << "ERROR: Can't set latency timer. Got error\n"
	       << ftdi_get_error_string(&m_ftdi) << '\n';
      return ftdi_status;
   }

   ftdi_status = ftdi_usb_purge_buffers(&m_ftdi);
   if ( ftdi_status != 0 ) {
      std::cerr << "ERROR: Can't purge buffer. Got error\n"
	       << ftdi_get_error_string(&m_ftdi) << '\n';
      return ftdi_status;
   }

   usleep(50000); // sleep 50 ms for setup to complete
   
   ftdi_status = ftdi_read_eeprom(&m_ftdi);
   if (ftdi_status < 0)
   {
      fprintf(stderr, "ftdi_read_eeprom: %d (%s)\n",
	      ftdi_status, ftdi_get_error_string(&m_ftdi));
      return -1;
   }

   ftdi_eeprom_decode(&m_ftdi, 0);
   int type;
   ftdi_get_eeprom_value(&m_ftdi, ftdi_eeprom_value::CHANNEL_A_TYPE, &type);
   
   if ( type != CHANNEL_IS_FIFO ) {
      std::cerr << "ERROR: channel is not FIFO. Please program the EEPROM\n";
      return -1;
   }
   

   return 0;
}


int Ft245::close()
{
   // close interface
   ftdi_usb_close(&m_ftdi);

   return 0;
}


int Ft245::write(const unsigned char &byte)
{
   int ftdi_status = ftdi_write_data(&m_ftdi, &byte, 1);
   if ( ftdi_status != 1 ) {
      std::cerr << "ERROR: Ft245::write() failed with status " << ftdi_status
		<< '\n';
   }
   return ftdi_status;
}


int Ft245::read(unsigned char &byte)
{
   // need to purge rx when reading for some etherial reason
   if ( ftdi_usb_purge_rx_buffer(&m_ftdi) != 0) {
      std::cerr << "ERROR: Can't purge FTDI buffers: "
   		<< "       " << ftdi_get_error_string(&m_ftdi) << '\n';
   }
   
   int bytesRead = 0;
   for ( int tries = 0; tries < 10 && bytesRead != 1; ++tries) {
      bytesRead = ftdi_read_data(&m_ftdi, &byte, 1);
   }
   // int ftdi_status = ftdi_read_data(&m_ftdi, &byte, 1);
   if ( bytesRead != 1 ) {
      std::cerr << "ERROR: Ft245::read() failed with status " << bytesRead
   		<< '\n';
   }
   return bytesRead;
}
