CCD-KAF-CDIP24
==============

A complete CCD camera for astrophotography with the Kodak/ONSemi full-frame CCD sensors the CDIP24 package (KAF-0402, KAF-1600, KAF-1603, KAF-3200). 

Features
--------

 - 16-bit ADC with programmable gain and offset.
 - Two-stage peltier cooling.
 - USB interface (FTDI FT2232H) with libftdi driver.
 - Mechanical shutter (servo).
 - Lattice iCE40 FPGA programmable through the USB interface using opensource tools.
 - Three temperature sensors.
 - Power from a 5.2 V to 5.5 V supply.
 - Sensor bias voltages are set by a few resistors to match the CCD specifications.


Firmware
--------

Flash the FTDI EEPROM:

    ftdi_eeprom --flash-eeprom software/ftdi2232h_eeprom.conf

Remove and insert the USB connector. Check that the chip is recognized with dmesg or lsusb.

Program the FPGA:

    cd firmware
    make
    iceprog -I B top.bin

The state of the project
------------------------
 
A prototype as been built and everything electrically seems to work. Some pixels are getting lost in the USB transfer every now and them. Debugging i ongoing.
