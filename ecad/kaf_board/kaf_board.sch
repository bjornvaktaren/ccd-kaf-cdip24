EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 9
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	3400 2150 3850 2150
Wire Wire Line
	3850 2250 3400 2250
Wire Wire Line
	3400 2350 3850 2350
Wire Wire Line
	3850 2450 3400 2450
Wire Wire Line
	3400 2550 3850 2550
Wire Wire Line
	3850 2650 3400 2650
$Sheet
S 5800 2100 650  1500
U 5E76D4CA
F0 "ccd" 50
F1 "ccd.sch" 50
F2 "AMP_OFF" I L 5800 2200 50 
F3 "H_3.3V" I L 5800 2300 50 
F4 "R_3.3V" I L 5800 2400 50 
F5 "V2_3.3V" I L 5800 2500 50 
F6 "V1_3.3V" I L 5800 2600 50 
F7 "AD_OEB" I L 5800 2750 50 
F8 "AD_CDSCLK1" I L 5800 2850 50 
F9 "AD_CDSCLK2" I L 5800 2950 50 
F10 "AD_ADCLK" I L 5800 3050 50 
F11 "AD_D[0..7]" O L 5800 3200 50 
F12 "AD_SLOAD" I L 5800 3350 50 
F13 "AD_SCLK" I L 5800 3450 50 
F14 "AD_SDATA" B L 5800 3550 50 
$EndSheet
$Sheet
S 1750 5300 950  1500
U 5E643BF7
F0 "power" 50
F1 "power.sch" 50
F2 "V_IN" U L 1750 6650 50 
$EndSheet
$Sheet
S 2350 2100 1050 1550
U 5E6A6B3B
F0 "usb-interface" 50
F1 "usb-interface.sch" 50
F2 "FT_RXF#" O R 3400 2950 50 
F3 "FT_D[0..7]" B R 3400 2800 50 
F4 "FT_CLKOUT" O R 3400 3350 50 
F5 "FT_RD#" I R 3400 3150 50 
F6 "FT_WR#" I R 3400 3250 50 
F7 "FT_SIWUA" I R 3400 3550 50 
F8 "FT_OE#" I R 3400 3450 50 
F9 "FT_TXE#" O R 3400 3050 50 
F10 "FT_SCK" O R 3400 2150 50 
F11 "FT_MOSI" O R 3400 2250 50 
F12 "FT_MISO" I R 3400 2350 50 
F13 "FT_SS" O R 3400 2450 50 
F14 "FT_CDONE" O R 3400 2550 50 
F15 "FT_CRESET" O R 3400 2650 50 
F16 "USB_SHIELD" U L 2350 3550 50 
F17 "VUSB" U L 2350 3450 50 
F18 "DM" B L 2350 3350 50 
F19 "DP" B L 2350 3250 50 
$EndSheet
Wire Wire Line
	3400 2950 3850 2950
Wire Wire Line
	3850 3050 3400 3050
Wire Wire Line
	3400 3150 3850 3150
Wire Wire Line
	3850 3250 3400 3250
Wire Wire Line
	3400 3350 3850 3350
Wire Wire Line
	3850 3450 3400 3450
Wire Wire Line
	3400 3550 3850 3550
Wire Bus Line
	3400 2800 3850 2800
Wire Bus Line
	5800 3200 5350 3200
Wire Wire Line
	5350 2200 5800 2200
Wire Wire Line
	5350 2300 5800 2300
Wire Wire Line
	5350 2400 5800 2400
Wire Wire Line
	5350 2500 5800 2500
Wire Wire Line
	5350 2600 5800 2600
Wire Wire Line
	5350 2750 5800 2750
Wire Wire Line
	5350 2850 5800 2850
Wire Wire Line
	5350 2950 5800 2950
Wire Wire Line
	5350 3050 5800 3050
$Sheet
S 3850 2100 1500 2300
U 5E5DF889
F0 "fpga" 50
F1 "fpga.sch" 50
F2 "iCE40-CDONE" O L 3850 2550 50 
F3 "iCE40-SDO" I L 3850 2250 50 
F4 "iCE40-SDI" I L 3850 2350 50 
F5 "iCE40-SCK" I L 3850 2150 50 
F6 "iCE40-SS" I L 3850 2450 50 
F7 "iCE40-CRESET" I L 3850 2650 50 
F8 "FT_RXF#" I L 3850 2950 50 
F9 "FT_D[0..7]" B L 3850 2800 50 
F10 "FT_RD#" O L 3850 3150 50 
F11 "FT_WR#" O L 3850 3250 50 
F12 "FT_SIWUA" O L 3850 3550 50 
F13 "FT_TXE#" I L 3850 3050 50 
F14 "FT_CLKOUT" I L 3850 3350 50 
F15 "FT_OE#" O L 3850 3450 50 
F16 "AMP_OFF" O R 5350 2200 50 
F17 "H_3.3V" O R 5350 2300 50 
F18 "R_3.3V" O R 5350 2400 50 
F19 "V1_3.3V" O R 5350 2500 50 
F20 "V2_3.3V" O R 5350 2600 50 
F21 "AD_OEB" O R 5350 2750 50 
F22 "AD_CDSCLK1" O R 5350 2850 50 
F23 "AD_CDSCLK2" O R 5350 2950 50 
F24 "AD_ADCLK" O R 5350 3050 50 
F25 "AD_D[0..7]" I R 5350 3200 50 
F26 "AD_SLOAD" O R 5350 3350 50 
F27 "AD_SCLK" O R 5350 3450 50 
F28 "AD_SDATA" B R 5350 3550 50 
F29 "MCP_CS_N" O R 5350 4050 50 
F30 "MCP_DIN" O R 5350 4150 50 
F31 "MCP_DOUT" I R 5350 4250 50 
F32 "MCP_CLK" O R 5350 4350 50 
F33 "PWM_TEC1" O R 5350 3800 50 
F34 "PWM_SERVO" O R 5350 3900 50 
F35 "PWM_TEC2" O R 5350 3700 50 
$EndSheet
Wire Wire Line
	5350 3350 5800 3350
Wire Wire Line
	5800 3450 5350 3450
Wire Wire Line
	5350 3550 5800 3550
$Sheet
S 6150 3900 1400 1250
U 5EA78292
F0 "thermo_and_mechanical" 50
F1 "thermo_and_mechanical.sch" 50
F2 "MCP_CS_N" I L 6150 4400 50 
F3 "MCP_DIN" I L 6150 4500 50 
F4 "MCP_DOUT" O L 6150 4600 50 
F5 "MCP_CLK" I L 6150 4700 50 
F6 "PWM_SERVO" I L 6150 4250 50 
F7 "PWM_TEC1" I L 6150 4150 50 
F8 "PWM_TEC2" I L 6150 4050 50 
F9 "V_TEC1" I L 6150 4950 50 
F10 "V_TEC2" I L 6150 5050 50 
$EndSheet
Wire Wire Line
	5350 4050 5900 4050
Wire Wire Line
	5900 4050 5900 4400
Wire Wire Line
	5900 4400 6150 4400
Wire Wire Line
	5350 4150 5850 4150
Wire Wire Line
	5850 4150 5850 4500
Wire Wire Line
	5850 4500 6150 4500
Wire Wire Line
	5350 4250 5800 4250
Wire Wire Line
	5800 4250 5800 4600
Wire Wire Line
	5800 4600 6150 4600
Wire Wire Line
	5350 4350 5750 4350
Wire Wire Line
	5750 4350 5750 4700
Wire Wire Line
	5750 4700 6150 4700
Wire Wire Line
	5350 3700 6100 3700
Wire Wire Line
	6100 3700 6100 4050
Wire Wire Line
	6100 4050 6150 4050
Wire Wire Line
	5350 3800 6050 3800
Wire Wire Line
	6050 3800 6050 4150
Wire Wire Line
	6050 4150 6150 4150
Wire Wire Line
	6000 4250 6000 3900
Wire Wire Line
	6000 3900 5350 3900
Wire Wire Line
	6000 4250 6150 4250
$Comp
L Connector_Generic:Conn_02x06_Odd_Even J?
U 1 1 5EE6FE33
P 4300 5850
AR Path="/5E5DF889/5EE6FE33" Ref="J?"  Part="1" 
AR Path="/5EE6FE33" Ref="J1"  Part="1" 
F 0 "J1" H 4350 6267 50  0000 C CNN
F 1 "I/O" H 4350 6176 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x06_Pitch2.54mm" H 4300 5850 50  0001 C CNN
F 3 "~" H 4300 5850 50  0001 C CNN
	1    4300 5850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 3250 1850 3250
Wire Wire Line
	2350 3350 1850 3350
Wire Wire Line
	2350 3450 1850 3450
Wire Wire Line
	2350 3550 1850 3550
Text Label 1850 3250 0    50   ~ 0
DP
Text Label 1850 3350 0    50   ~ 0
DM
Text Label 1850 3450 0    50   ~ 0
VUSB
Text Label 1850 3550 0    50   ~ 0
USB_SHIELD
Wire Wire Line
	6150 4950 5750 4950
Wire Wire Line
	6150 5050 5750 5050
Text Label 5750 4950 0    50   ~ 0
V_TEC1
Text Label 5750 5050 0    50   ~ 0
V_TEC2
Wire Wire Line
	4600 5650 5100 5650
Text Label 3600 5650 0    50   ~ 0
V_TEC1
Text Label 5100 5650 2    50   ~ 0
V_TEC2
Wire Wire Line
	4600 6050 5100 6050
Wire Wire Line
	4100 6050 3600 6050
Wire Wire Line
	4100 6150 3600 6150
Text Label 5100 6150 2    50   ~ 0
DP
Text Label 3600 6050 0    50   ~ 0
VUSB
Text Label 3600 6150 0    50   ~ 0
USB_SHIELD
Text Label 5100 6050 2    50   ~ 0
DM
Wire Wire Line
	4600 6150 5100 6150
Text Label 3600 5950 0    50   ~ 0
USB_GND
Text Label 3600 5750 0    50   ~ 0
GND_TEC1
Text Label 5100 5750 2    50   ~ 0
GND_TEC2
Wire Wire Line
	4100 5650 3600 5650
Wire Wire Line
	4600 5850 5100 5850
Text Label 5100 5850 2    50   ~ 0
V_IN
Text Label 3600 5850 0    50   ~ 0
GND_IN
Text Label 5100 5950 2    50   ~ 0
GND_IN
Wire Wire Line
	3500 5750 3500 5850
Wire Wire Line
	3500 6400 4350 6400
Wire Wire Line
	5200 6400 5200 5950
Wire Wire Line
	4600 5750 5200 5750
Wire Wire Line
	3500 5750 4100 5750
Wire Wire Line
	4600 5950 5200 5950
Connection ~ 5200 5950
Wire Wire Line
	5200 5950 5200 5750
Wire Wire Line
	3500 5850 4100 5850
Connection ~ 3500 5850
Wire Wire Line
	3500 5850 3500 5950
Wire Wire Line
	3500 5950 4100 5950
Connection ~ 3500 5950
Wire Wire Line
	3500 5950 3500 6400
$Comp
L power:GND #PWR0139
U 1 1 5EF19FE4
P 4350 6400
F 0 "#PWR0139" H 4350 6150 50  0001 C CNN
F 1 "GND" H 4355 6227 50  0000 C CNN
F 2 "" H 4350 6400 50  0001 C CNN
F 3 "" H 4350 6400 50  0001 C CNN
	1    4350 6400
	1    0    0    -1  
$EndComp
Connection ~ 4350 6400
Wire Wire Line
	4350 6400 5200 6400
Wire Wire Line
	1750 6650 1450 6650
Text Label 1450 6650 0    50   ~ 0
V_IN
$EndSCHEMATC
