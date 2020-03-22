EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 8
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 3800 3850 1500 1500
U 5E5DF889
F0 "fpga" 50
F1 "fpga.sch" 50
F2 "iCE40-CDONE" O L 3800 4300 50 
F3 "iCE40-SDO" I L 3800 4000 50 
F4 "iCE40-SDI" I L 3800 4100 50 
F5 "iCE40-SCK" I L 3800 3900 50 
F6 "iCE40-SS" I L 3800 4200 50 
F7 "iCE40-CRESET" I L 3800 4400 50 
F8 "FT_RXF#" I L 3800 4700 50 
F9 "FT_D[0..7]" B L 3800 4550 50 
F10 "FT_RD#" O L 3800 4900 50 
F11 "FT_WR#" O L 3800 5000 50 
F12 "FT_SIWUA" O L 3800 5300 50 
F13 "FT_TXE#" I L 3800 4800 50 
F14 "FT_CLKOUT" I L 3800 5100 50 
F15 "FT_OE#" O L 3800 5200 50 
F16 "AMP_OFF" O R 5300 3950 50 
F17 "H_3.3V" O R 5300 4050 50 
F18 "R_3.3V" O R 5300 4150 50 
F19 "V1_3.3V" O R 5300 4250 50 
F20 "V2_3.3V" O R 5300 4350 50 
F21 "AD_OEB" O R 5300 4500 50 
F22 "AD_CDSCLK1" O R 5300 4600 50 
F23 "AD_CDSCLK2" O R 5300 4700 50 
F24 "AD_ADCLK" O R 5300 4800 50 
F25 "AD_D[0..7]" I R 5300 4950 50 
$EndSheet
Wire Wire Line
	3350 3900 3800 3900
Wire Wire Line
	3800 4000 3350 4000
Wire Wire Line
	3350 4100 3800 4100
Wire Wire Line
	3800 4200 3350 4200
Wire Wire Line
	3350 4300 3800 4300
Wire Wire Line
	3800 4400 3350 4400
$Sheet
S 5750 3850 600  1200
U 5E76D4CA
F0 "ccd" 50
F1 "ccd.sch" 50
F2 "AMP_OFF" I L 5750 3950 50 
F3 "H_3.3V" I L 5750 4050 50 
F4 "R_3.3V" I L 5750 4150 50 
F5 "V2_3.3V" I L 5750 4250 50 
F6 "V1_3.3V" I L 5750 4350 50 
F7 "AD_OEB" I L 5750 4500 50 
F8 "AD_CDSCLK1" I L 5750 4600 50 
F9 "AD_CDSCLK2" I L 5750 4700 50 
F10 "AD_ADCLK" I L 5750 4800 50 
F11 "AD_D[0..7]" O L 5750 4950 50 
$EndSheet
$Sheet
S 8250 3900 950  1500
U 5E643BF7
F0 "power" 50
F1 "power.sch" 50
$EndSheet
$Sheet
S 2450 3850 900  1550
U 5E6A6B3B
F0 "usb-interface" 50
F1 "usb-interface.sch" 50
F2 "FT_RXF#" O R 3350 4700 50 
F3 "FT_D[0..7]" B R 3350 4550 50 
F4 "FT_CLKOUT" O R 3350 5100 50 
F5 "FT_RD#" I R 3350 4900 50 
F6 "FT_WR#" I R 3350 5000 50 
F7 "FT_SIWUA" I R 3350 5300 50 
F8 "FT_OE#" I R 3350 5200 50 
F9 "FT_TXE#" O R 3350 4800 50 
F10 "FT_SCK" O R 3350 3900 50 
F11 "FT_MOSI" O R 3350 4000 50 
F12 "FT_MISO" I R 3350 4100 50 
F13 "FT_SS" O R 3350 4200 50 
F14 "FT_CDONE" O R 3350 4300 50 
F15 "FT_CRESET" O R 3350 4400 50 
$EndSheet
Wire Wire Line
	3350 4700 3800 4700
Wire Wire Line
	3800 4800 3350 4800
Wire Wire Line
	3350 4900 3800 4900
Wire Wire Line
	3800 5000 3350 5000
Wire Wire Line
	3350 5100 3800 5100
Wire Wire Line
	3800 5200 3350 5200
Wire Wire Line
	3350 5300 3800 5300
Wire Bus Line
	3350 4550 3800 4550
Wire Bus Line
	5750 4950 5300 4950
Wire Wire Line
	5300 3950 5750 3950
Wire Wire Line
	5300 4050 5750 4050
Wire Wire Line
	5300 4150 5750 4150
Wire Wire Line
	5300 4250 5750 4250
Wire Wire Line
	5300 4350 5750 4350
Wire Wire Line
	5300 4500 5750 4500
Wire Wire Line
	5300 4600 5750 4600
Wire Wire Line
	5300 4700 5750 4700
Wire Wire Line
	5300 4800 5750 4800
$EndSCHEMATC
