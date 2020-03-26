EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 7 9
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:GND #PWR0148
U 1 1 5E75805A
P 3450 7150
F 0 "#PWR0148" H 3450 6900 50  0001 C CNN
F 1 "GND" H 3455 6977 50  0000 C CNN
F 2 "" H 3450 7150 50  0001 C CNN
F 3 "" H 3450 7150 50  0001 C CNN
	1    3450 7150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E75BB3A
P 2800 6050
F 0 "C?" V 2650 6050 50  0000 C CNN
F 1 "27p" V 2950 6050 50  0000 C CNN
F 2 "" H 2838 5900 50  0001 C CNN
F 3 "~" H 2800 6050 50  0001 C CNN
	1    2800 6050
	0    1    1    0   
$EndComp
$Comp
L Device:C C?
U 1 1 5E75C454
P 2800 6450
F 0 "C?" V 2650 6450 50  0000 C CNN
F 1 "27p" V 2950 6450 50  0000 C CNN
F 2 "" H 2838 6300 50  0001 C CNN
F 3 "~" H 2800 6450 50  0001 C CNN
	1    2800 6450
	0    1    1    0   
$EndComp
$Comp
L Device:Crystal Y?
U 1 1 5E75C82D
P 3200 6250
F 0 "Y?" V 3154 6381 50  0000 L CNN
F 1 "12MHz" V 3245 6381 50  0000 L CNN
F 2 "" H 3200 6250 50  0001 C CNN
F 3 "~" H 3200 6250 50  0001 C CNN
	1    3200 6250
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0149
U 1 1 5E75D1E4
P 2550 6550
F 0 "#PWR0149" H 2550 6300 50  0001 C CNN
F 1 "GND" H 2555 6377 50  0000 C CNN
F 2 "" H 2550 6550 50  0001 C CNN
F 3 "" H 2550 6550 50  0001 C CNN
	1    2550 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 6050 3200 6050
Wire Wire Line
	3200 6100 3200 6050
Connection ~ 3200 6050
Wire Wire Line
	3200 6050 2950 6050
Wire Wire Line
	3500 6450 3200 6450
Wire Wire Line
	3200 6400 3200 6450
Connection ~ 3200 6450
Wire Wire Line
	3200 6450 2950 6450
Wire Wire Line
	2650 6050 2550 6050
Wire Wire Line
	2550 6050 2550 6450
Wire Wire Line
	2650 6450 2550 6450
Connection ~ 2550 6450
Wire Wire Line
	2550 6450 2550 6550
$Comp
L Device:C C?
U 1 1 5E762240
P 2550 3400
F 0 "C?" H 2600 3500 50  0000 L CNN
F 1 "0.1u" H 2600 3300 50  0000 L CNN
F 2 "" H 2588 3250 50  0001 C CNN
F 3 "~" H 2550 3400 50  0001 C CNN
	1    2550 3400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E762774
P 3250 3350
F 0 "C?" H 3350 3450 50  0000 L CNN
F 1 "3.3u" H 3365 3305 50  0000 L CNN
F 2 "" H 3288 3200 50  0001 C CNN
F 3 "~" H 3250 3350 50  0001 C CNN
	1    3250 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E762A53
P 3900 2250
F 0 "C?" H 4015 2296 50  0000 L CNN
F 1 "0.1u" H 4015 2205 50  0000 L CNN
F 2 "" H 3938 2100 50  0001 C CNN
F 3 "~" H 3900 2250 50  0001 C CNN
	1    3900 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E762D87
P 3450 2250
F 0 "C?" H 3565 2296 50  0000 L CNN
F 1 "0.1u" H 3565 2205 50  0000 L CNN
F 2 "" H 3488 2100 50  0001 C CNN
F 3 "~" H 3450 2250 50  0001 C CNN
	1    3450 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E7632D9
P 5700 2150
F 0 "C?" H 5815 2196 50  0000 L CNN
F 1 "0.1u" H 5815 2105 50  0000 L CNN
F 2 "" H 5738 2000 50  0001 C CNN
F 3 "~" H 5700 2150 50  0001 C CNN
	1    5700 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E7635F6
P 6100 2150
F 0 "C?" H 6215 2196 50  0000 L CNN
F 1 "0.1u" H 6215 2105 50  0000 L CNN
F 2 "" H 6138 2000 50  0001 C CNN
F 3 "~" H 6100 2150 50  0001 C CNN
	1    6100 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E76390A
P 6500 2150
F 0 "C?" H 6615 2196 50  0000 L CNN
F 1 "0.1u" H 6615 2105 50  0000 L CNN
F 2 "" H 6538 2000 50  0001 C CNN
F 3 "~" H 6500 2150 50  0001 C CNN
	1    6500 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 5E764741
P 3000 2250
F 0 "C?" H 3118 2296 50  0000 L CNN
F 1 "4.7u tan" H 3000 2150 50  0000 L CNN
F 2 "" H 3038 2100 50  0001 C CNN
F 3 "~" H 3000 2250 50  0001 C CNN
	1    3000 2250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0150
U 1 1 5E764ED7
P 3000 4250
F 0 "#PWR0150" H 3000 4000 50  0001 C CNN
F 1 "GND" V 3005 4122 50  0000 R CNN
F 2 "" H 3000 4250 50  0001 C CNN
F 3 "" H 3000 4250 50  0001 C CNN
	1    3000 4250
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0151
U 1 1 5E7652AE
P 2550 2500
F 0 "#PWR0151" H 2550 2250 50  0001 C CNN
F 1 "GND" H 2555 2327 50  0000 C CNN
F 2 "" H 2550 2500 50  0001 C CNN
F 3 "" H 2550 2500 50  0001 C CNN
	1    2550 2500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5E765FDB
P 3250 4250
F 0 "R?" V 3350 4350 50  0000 C CNN
F 1 "12k 1%" V 3350 4100 50  0000 C CNN
F 2 "" V 3180 4250 50  0001 C CNN
F 3 "~" H 3250 4250 50  0001 C CNN
	1    3250 4250
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 5E766666
P 3250 4450
F 0 "R?" V 3150 4400 50  0000 R CNN
F 1 "4.7k" V 3150 4650 50  0000 R CNN
F 2 "" V 3180 4450 50  0001 C CNN
F 3 "~" H 3250 4450 50  0001 C CNN
	1    3250 4450
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 5E7A94CD
P 2400 5350
F 0 "R?" H 2470 5396 50  0000 L CNN
F 1 "10k" H 2470 5305 50  0000 L CNN
F 2 "" V 2330 5350 50  0001 C CNN
F 3 "~" H 2400 5350 50  0001 C CNN
	1    2400 5350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5E7A9AED
P 2100 5350
F 0 "R?" H 2170 5396 50  0000 L CNN
F 1 "10k" H 2170 5305 50  0000 L CNN
F 2 "" V 2030 5350 50  0001 C CNN
F 3 "~" H 2100 5350 50  0001 C CNN
	1    2100 5350
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5E7AA065
P 2700 5350
F 0 "R?" H 2770 5396 50  0000 L CNN
F 1 "10k" H 2770 5305 50  0000 L CNN
F 2 "" V 2630 5350 50  0001 C CNN
F 3 "~" H 2700 5350 50  0001 C CNN
	1    2700 5350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E7B9762
P 1150 5700
F 0 "C?" H 1265 5746 50  0000 L CNN
F 1 "0.1u" H 1265 5655 50  0000 L CNN
F 2 "" H 1188 5550 50  0001 C CNN
F 3 "~" H 1150 5700 50  0001 C CNN
	1    1150 5700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0152
U 1 1 5E7EEB64
P 1150 5900
F 0 "#PWR0152" H 1150 5650 50  0001 C CNN
F 1 "GND" H 1155 5727 50  0000 C CNN
F 2 "" H 1150 5900 50  0001 C CNN
F 3 "" H 1150 5900 50  0001 C CNN
	1    1150 5900
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5E81B739
P 2300 5850
F 0 "R?" V 2350 6000 50  0000 C CNN
F 1 "2k" V 2400 5850 50  0000 C CNN
F 2 "" V 2230 5850 50  0001 C CNN
F 3 "~" H 2300 5850 50  0001 C CNN
	1    2300 5850
	0    1    1    0   
$EndComp
$Comp
L Interface_USB:FT2232H U?
U 1 1 5E835E13
P 4700 4850
F 0 "U?" H 4700 5000 50  0000 C CNN
F 1 "FT2232H" H 4700 4850 50  0000 C CNN
F 2 "" H 4700 4850 50  0001 C CNN
F 3 "https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf" H 4700 4850 50  0001 C CNN
	1    4700 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 6650 3450 6650
Wire Wire Line
	3450 6650 3450 7100
Wire Wire Line
	3450 7100 4100 7100
Wire Wire Line
	5000 7100 5000 7050
Connection ~ 3450 7100
Wire Wire Line
	3450 7100 3450 7150
Wire Wire Line
	4900 7050 4900 7100
Connection ~ 4900 7100
Wire Wire Line
	4900 7100 5000 7100
Wire Wire Line
	4800 7100 4800 7050
Connection ~ 4800 7100
Wire Wire Line
	4800 7100 4900 7100
Wire Wire Line
	4700 7050 4700 7100
Connection ~ 4700 7100
Wire Wire Line
	4700 7100 4800 7100
Wire Wire Line
	4600 7100 4600 7050
Connection ~ 4600 7100
Wire Wire Line
	4600 7100 4700 7100
Wire Wire Line
	4500 7050 4500 7100
Connection ~ 4500 7100
Wire Wire Line
	4500 7100 4600 7100
Wire Wire Line
	4400 7100 4400 7050
Connection ~ 4400 7100
Wire Wire Line
	4400 7100 4500 7100
Wire Wire Line
	4300 7050 4300 7100
Connection ~ 4300 7100
Wire Wire Line
	4300 7100 4400 7100
Wire Wire Line
	4100 7100 4100 7050
Connection ~ 4100 7100
Wire Wire Line
	4100 7100 4300 7100
Wire Wire Line
	3400 4250 3500 4250
Wire Wire Line
	3000 4250 3100 4250
Wire Wire Line
	3400 4450 3450 4450
$Comp
L power:GND #PWR0153
U 1 1 5E690A3B
P 3250 3600
F 0 "#PWR0153" H 3250 3350 50  0001 C CNN
F 1 "GND" V 3255 3472 50  0000 R CNN
F 2 "" H 3250 3600 50  0001 C CNN
F 3 "" H 3250 3600 50  0001 C CNN
	1    3250 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 3200 3250 3150
Wire Wire Line
	3250 3500 3250 3600
Connection ~ 3250 3150
$Comp
L power:GND #PWR0154
U 1 1 5E6AA00A
P 2550 3600
F 0 "#PWR0154" H 2550 3350 50  0001 C CNN
F 1 "GND" V 2555 3472 50  0000 R CNN
F 2 "" H 2550 3600 50  0001 C CNN
F 3 "" H 2550 3600 50  0001 C CNN
	1    2550 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0155
U 1 1 5E6AA446
P 1900 1700
F 0 "#PWR0155" H 1900 1550 50  0001 C CNN
F 1 "+3.3V" V 1915 1828 50  0000 L CNN
F 2 "" H 1900 1700 50  0001 C CNN
F 3 "" H 1900 1700 50  0001 C CNN
	1    1900 1700
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2550 3600 2550 3550
Wire Wire Line
	2500 2950 2550 2950
Wire Wire Line
	2550 2950 2550 3250
Wire Wire Line
	2550 2950 3500 2950
Connection ~ 2550 2950
Wire Wire Line
	4500 2550 4500 2650
Wire Wire Line
	4500 2550 4600 2550
Wire Wire Line
	4600 2550 4600 2650
Wire Wire Line
	4700 2650 4700 2550
Wire Wire Line
	4700 2550 4600 2550
Connection ~ 4600 2550
Wire Wire Line
	4900 2650 4900 2550
Wire Wire Line
	5200 2550 5200 2650
Wire Wire Line
	5100 2650 5100 2550
Connection ~ 5100 2550
Wire Wire Line
	5100 2550 5200 2550
Wire Wire Line
	5000 2650 5000 2550
Wire Wire Line
	4900 2550 5000 2550
Connection ~ 5000 2550
Wire Wire Line
	5000 2550 5100 2550
Wire Wire Line
	3250 3150 3500 3150
Connection ~ 5200 2550
Text Label 1600 3250 0    50   ~ 0
VBUS
$Comp
L ccd_camera:USB_OTG J?
U 1 1 5E6DA0AA
P 1400 3950
F 0 "J?" H 1457 4417 50  0000 C CNN
F 1 "USB_OTG" H 1457 4326 50  0000 C CNN
F 2 "" H 1550 3900 50  0001 C CNN
F 3 " ~" H 1550 3900 50  0001 C CNN
	1    1400 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1700 4050 2350 4050
$Comp
L Device:CP C?
U 1 1 5E6FA507
P 2550 2250
F 0 "C?" H 2668 2296 50  0000 L CNN
F 1 "4.7u tan" H 2550 2150 50  0000 L CNN
F 2 "" H 2588 2100 50  0001 C CNN
F 3 "~" H 2550 2250 50  0001 C CNN
	1    2550 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1900 1700 1950 1700
Wire Wire Line
	1950 1700 1950 2000
Wire Wire Line
	1950 2000 2050 2000
Connection ~ 1950 1700
Wire Wire Line
	1950 1700 2050 1700
Wire Wire Line
	2350 1700 2550 1700
Wire Wire Line
	2550 1700 2550 2100
Wire Wire Line
	2550 1700 3450 1700
Wire Wire Line
	3450 1700 3450 2100
Connection ~ 2550 1700
Wire Wire Line
	2350 2000 3000 2000
Wire Wire Line
	3000 2000 3000 2100
Wire Wire Line
	3000 2000 3900 2000
Wire Wire Line
	3900 2000 3900 2100
Connection ~ 3000 2000
Wire Wire Line
	2550 2400 2550 2450
Wire Wire Line
	2550 2450 3000 2450
Wire Wire Line
	3000 2450 3000 2400
Connection ~ 2550 2450
Wire Wire Line
	2550 2450 2550 2500
Wire Wire Line
	3000 2450 3450 2450
Wire Wire Line
	3450 2450 3450 2400
Connection ~ 3000 2450
Wire Wire Line
	3450 2450 3900 2450
Wire Wire Line
	3900 2450 3900 2400
Connection ~ 3450 2450
$Comp
L power:+3.3V #PWR0156
U 1 1 5E74EECC
P 2500 2950
F 0 "#PWR0156" H 2500 2800 50  0001 C CNN
F 1 "+3.3V" V 2515 3078 50  0000 L CNN
F 2 "" H 2500 2950 50  0001 C CNN
F 3 "" H 2500 2950 50  0001 C CNN
	1    2500 2950
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3900 2000 4200 2000
Wire Wire Line
	4200 2000 4200 2650
Connection ~ 3900 2000
Wire Wire Line
	3450 1700 4300 1700
Wire Wire Line
	4300 1700 4300 2650
Connection ~ 3450 1700
$Comp
L Device:C C?
U 1 1 5E75DE35
P 6900 2150
F 0 "C?" H 7015 2196 50  0000 L CNN
F 1 "0.1u" H 7015 2105 50  0000 L CNN
F 2 "" H 6938 2000 50  0001 C CNN
F 3 "~" H 6900 2150 50  0001 C CNN
	1    6900 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E769463
P 5700 1200
F 0 "C?" H 5815 1246 50  0000 L CNN
F 1 "0.1u" H 5815 1155 50  0000 L CNN
F 2 "" H 5738 1050 50  0001 C CNN
F 3 "~" H 5700 1200 50  0001 C CNN
	1    5700 1200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E769469
P 6100 1200
F 0 "C?" H 6215 1246 50  0000 L CNN
F 1 "0.1u" H 6215 1155 50  0000 L CNN
F 2 "" H 6138 1050 50  0001 C CNN
F 3 "~" H 6100 1200 50  0001 C CNN
	1    6100 1200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E76946F
P 6500 1200
F 0 "C?" H 6615 1246 50  0000 L CNN
F 1 "0.1u" H 6615 1155 50  0000 L CNN
F 2 "" H 6538 1050 50  0001 C CNN
F 3 "~" H 6500 1200 50  0001 C CNN
	1    6500 1200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0157
U 1 1 5E76F40C
P 5700 2400
F 0 "#PWR0157" H 5700 2150 50  0001 C CNN
F 1 "GND" H 5705 2227 50  0000 C CNN
F 2 "" H 5700 2400 50  0001 C CNN
F 3 "" H 5700 2400 50  0001 C CNN
	1    5700 2400
	1    0    0    -1  
$EndComp
$Comp
L power:+1V8 #PWR0158
U 1 1 5E77141C
P 6500 950
F 0 "#PWR0158" H 6500 800 50  0001 C CNN
F 1 "+1V8" H 6515 1123 50  0000 C CNN
F 2 "" H 6500 950 50  0001 C CNN
F 3 "" H 6500 950 50  0001 C CNN
	1    6500 950 
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0159
U 1 1 5E7BEC9D
P 6900 1900
F 0 "#PWR0159" H 6900 1750 50  0001 C CNN
F 1 "+3.3V" H 6915 2073 50  0000 C CNN
F 2 "" H 6900 1900 50  0001 C CNN
F 3 "" H 6900 1900 50  0001 C CNN
	1    6900 1900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0160
U 1 1 5E7C09D9
P 5700 1450
F 0 "#PWR0160" H 5700 1200 50  0001 C CNN
F 1 "GND" H 5705 1277 50  0000 C CNN
F 2 "" H 5700 1450 50  0001 C CNN
F 3 "" H 5700 1450 50  0001 C CNN
	1    5700 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6500 1000 6500 1050
Wire Wire Line
	6500 1000 6100 1000
Wire Wire Line
	6100 1000 6100 1050
Wire Wire Line
	6100 1000 5700 1000
Wire Wire Line
	5700 1000 5700 1050
Connection ~ 6100 1000
Wire Wire Line
	5700 1350 5700 1400
Wire Wire Line
	5700 1400 6100 1400
Wire Wire Line
	6100 1400 6100 1350
Connection ~ 5700 1400
Wire Wire Line
	5700 1400 5700 1450
Wire Wire Line
	6100 1400 6500 1400
Wire Wire Line
	6500 1400 6500 1350
Connection ~ 6100 1400
Wire Wire Line
	6900 1900 6900 1950
Wire Wire Line
	6900 1950 6500 1950
Wire Wire Line
	6500 1950 6500 2000
Connection ~ 6900 1950
Wire Wire Line
	6900 1950 6900 2000
Wire Wire Line
	6500 1950 6100 1950
Wire Wire Line
	6100 1950 6100 2000
Connection ~ 6500 1950
Wire Wire Line
	6100 1950 5700 1950
Wire Wire Line
	5700 1950 5700 2000
Connection ~ 6100 1950
Wire Wire Line
	5700 2300 5700 2350
Wire Wire Line
	5700 2350 6100 2350
Wire Wire Line
	6100 2350 6100 2300
Connection ~ 5700 2350
Wire Wire Line
	5700 2350 5700 2400
Wire Wire Line
	6100 2350 6500 2350
Wire Wire Line
	6500 2350 6500 2300
Connection ~ 6100 2350
Wire Wire Line
	6500 2350 6900 2350
Wire Wire Line
	6900 2350 6900 2300
Connection ~ 6500 2350
Wire Wire Line
	5200 1950 5700 1950
Wire Wire Line
	5200 1950 5200 2550
Connection ~ 5700 1950
Wire Wire Line
	4700 2550 4700 1000
Wire Wire Line
	4700 1000 5700 1000
Connection ~ 4700 2550
Connection ~ 5700 1000
Wire Wire Line
	4500 2550 3250 2550
Wire Wire Line
	3250 2550 3250 3150
Connection ~ 4500 2550
$Comp
L ccd_camera:93LCxxBxxOT U?
U 1 1 5E895808
P 1750 5700
F 0 "U?" H 1750 6075 50  0000 C CNN
F 1 "93LCxxBxxOT" H 1750 5984 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-6" H 1750 6100 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20001749K.pdf" H 1700 5700 50  0001 C CNN
	1    1750 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 5550 1150 5550
Wire Wire Line
	1150 5850 1450 5850
Wire Wire Line
	1150 5850 1150 5900
Connection ~ 1150 5850
Wire Wire Line
	2050 5850 2100 5850
Wire Wire Line
	2050 5750 2500 5750
Wire Wire Line
	2450 5850 2500 5850
Wire Wire Line
	2500 5850 2500 5750
Connection ~ 2500 5750
Wire Wire Line
	2500 5750 3500 5750
Wire Wire Line
	2050 5650 2400 5650
Wire Wire Line
	3500 5550 2700 5550
Wire Wire Line
	2100 5850 2100 5500
Connection ~ 2100 5850
Wire Wire Line
	2100 5850 2150 5850
Wire Wire Line
	2400 5500 2400 5650
Connection ~ 2400 5650
Wire Wire Line
	2400 5650 3500 5650
Wire Wire Line
	2700 5500 2700 5550
Connection ~ 2700 5550
Wire Wire Line
	2700 5550 2050 5550
$Comp
L power:+3.3V #PWR0161
U 1 1 5E906E06
P 1000 5150
F 0 "#PWR0161" H 1000 5000 50  0001 C CNN
F 1 "+3.3V" H 1015 5323 50  0000 C CNN
F 2 "" H 1000 5150 50  0001 C CNN
F 3 "" H 1000 5150 50  0001 C CNN
	1    1000 5150
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2700 5200 2700 5150
Wire Wire Line
	2700 5150 2400 5150
Wire Wire Line
	1150 5150 1000 5150
Wire Wire Line
	1150 5150 1150 5550
Connection ~ 1150 5550
Wire Wire Line
	2100 5200 2100 5150
Connection ~ 2100 5150
Wire Wire Line
	2100 5150 1150 5150
Wire Wire Line
	2400 5200 2400 5150
Connection ~ 2400 5150
Wire Wire Line
	2400 5150 2100 5150
Wire Wire Line
	6500 950  6500 1000
Connection ~ 6500 1000
$Comp
L Device:D_TVS D?
U 1 1 5E964732
P 2050 4400
F 0 "D?" V 1900 4400 50  0000 L CNN
F 1 "PGB101" H 1900 4300 50  0000 L CNN
F 2 "" H 2050 4400 50  0001 C CNN
F 3 "~" H 2050 4400 50  0001 C CNN
	1    2050 4400
	0    1    1    0   
$EndComp
$Comp
L Device:D_TVS D?
U 1 1 5E964BA0
P 2350 4400
F 0 "D?" V 2200 4400 50  0000 L CNN
F 1 "PGB101" H 2200 4300 50  0000 L CNN
F 2 "" H 2350 4400 50  0001 C CNN
F 3 "~" H 2350 4400 50  0001 C CNN
	1    2350 4400
	0    1    1    0   
$EndComp
$Comp
L power:GNDPWR #PWR0162
U 1 1 5E96D623
P 950 4450
F 0 "#PWR0162" H 950 4250 50  0001 C CNN
F 1 "GNDPWR" H 954 4296 50  0000 C CNN
F 2 "" H 950 4400 50  0001 C CNN
F 3 "" H 950 4400 50  0001 C CNN
	1    950  4450
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5E96E3E7
P 1300 4700
F 0 "R?" H 1150 4700 50  0000 L CNN
F 1 "Populate: NO" V 1400 4500 50  0000 L CNN
F 2 "" V 1230 4700 50  0001 C CNN
F 3 "~" H 1300 4700 50  0001 C CNN
	1    1300 4700
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0163
U 1 1 5E9870BB
P 1600 4900
F 0 "#PWR0163" H 1600 4650 50  0001 C CNN
F 1 "GND" H 1605 4727 50  0000 C CNN
F 2 "" H 1600 4900 50  0001 C CNN
F 3 "" H 1600 4900 50  0001 C CNN
	1    1600 4900
	1    0    0    -1  
$EndComp
Connection ~ 1150 5150
Wire Wire Line
	1300 4350 1300 4400
Wire Wire Line
	1300 4400 950  4400
Wire Wire Line
	950  4400 950  4450
Wire Wire Line
	1300 4400 1300 4550
Connection ~ 1300 4400
Wire Wire Line
	1300 4850 1300 4900
Wire Wire Line
	1300 4900 1600 4900
Wire Wire Line
	1400 4350 1400 4400
Wire Wire Line
	1400 4400 1600 4400
Wire Wire Line
	1600 4400 1600 4900
Connection ~ 1600 4900
Wire Wire Line
	1600 4900 1800 4900
Wire Wire Line
	2050 4900 2050 4550
Wire Wire Line
	2050 4900 2350 4900
Wire Wire Line
	2350 4900 2350 4550
Connection ~ 2050 4900
Wire Wire Line
	2050 4250 2050 3950
Connection ~ 2050 3950
Wire Wire Line
	2050 3950 1700 3950
Wire Wire Line
	2050 3950 3500 3950
Wire Wire Line
	2350 4250 2350 4050
Connection ~ 2350 4050
Wire Wire Line
	2350 4050 3500 4050
$Comp
L Device:R R?
U 1 1 5EA39380
P 3450 4750
F 0 "R?" H 3380 4704 50  0000 R CNN
F 1 "10k" H 3380 4795 50  0000 R CNN
F 2 "" V 3380 4750 50  0001 C CNN
F 3 "~" H 3450 4750 50  0001 C CNN
	1    3450 4750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0164
U 1 1 5EA39EA3
P 3450 5000
F 0 "#PWR0164" H 3450 4750 50  0001 C CNN
F 1 "GND" V 3455 4872 50  0000 R CNN
F 2 "" H 3450 5000 50  0001 C CNN
F 3 "" H 3450 5000 50  0001 C CNN
	1    3450 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 4450 2850 4450
Wire Wire Line
	3450 4450 3450 4600
Connection ~ 3450 4450
Wire Wire Line
	3450 4450 3500 4450
Wire Wire Line
	3450 4900 3450 5000
Text Label 2850 4450 0    50   ~ 0
VBUS
$Comp
L Device:L L?
U 1 1 5EA854AD
P 2200 1700
F 0 "L?" V 2019 1700 50  0000 C CNN
F 1 "600R/0.5A" V 2110 1700 50  0000 C CNN
F 2 "" H 2200 1700 50  0001 C CNN
F 3 "~" H 2200 1700 50  0001 C CNN
	1    2200 1700
	0    1    1    0   
$EndComp
$Comp
L Device:L L?
U 1 1 5EA85EC4
P 2200 2000
F 0 "L?" V 2019 2000 50  0000 C CNN
F 1 "600R/0.5A" V 2110 2000 50  0000 C CNN
F 2 "" H 2200 2000 50  0001 C CNN
F 3 "~" H 2200 2000 50  0001 C CNN
	1    2200 2000
	0    1    1    0   
$EndComp
$Comp
L Device:L L?
U 1 1 5EA87361
P 1800 3500
F 0 "L?" H 1756 3454 50  0000 R CNN
F 1 "600R/0.5A" H 1756 3545 50  0000 R CNN
F 2 "" H 1800 3500 50  0001 C CNN
F 3 "~" H 1800 3500 50  0001 C CNN
	1    1800 3500
	-1   0    0    1   
$EndComp
$Comp
L Device:C C?
U 1 1 5EA9174E
P 1800 4400
F 0 "C?" H 1850 4500 50  0000 L CNN
F 1 "0.1u" H 1850 4300 50  0000 L CNN
F 2 "" H 1838 4250 50  0001 C CNN
F 3 "~" H 1800 4400 50  0001 C CNN
	1    1800 4400
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 3750 1800 3750
Wire Wire Line
	1800 3750 1800 3650
Wire Wire Line
	1800 3750 1800 4250
Connection ~ 1800 3750
Wire Wire Line
	1800 4550 1800 4900
Connection ~ 1800 4900
Wire Wire Line
	1800 4900 2050 4900
Wire Wire Line
	1600 3250 1800 3250
Wire Wire Line
	1800 3250 1800 3350
Wire Wire Line
	5900 4750 6750 4750
Wire Wire Line
	6750 5450 5900 5450
Wire Wire Line
	5900 5350 6750 5350
Wire Wire Line
	6750 5150 5900 5150
Wire Wire Line
	5900 4950 6750 4950
Wire Wire Line
	6750 4850 5900 4850
Wire Wire Line
	5900 4450 6750 4450
Wire Wire Line
	5900 4250 6750 4250
Wire Wire Line
	6750 4150 5900 4150
Wire Wire Line
	5900 4050 6750 4050
Wire Wire Line
	6750 3950 5900 3950
Wire Wire Line
	5900 3850 6750 3850
Text Label 6350 3650 0    50   ~ 0
FT_D7
Text Label 6350 3550 0    50   ~ 0
FT_D6
Text Label 6350 3450 0    50   ~ 0
FT_D5
Text Label 6350 3350 0    50   ~ 0
FT_D4
Text Label 6350 3250 0    50   ~ 0
FT_D3
Text Label 6350 3150 0    50   ~ 0
FT_D2
Text Label 6350 3050 0    50   ~ 0
FT_D1
Text Label 6350 2950 0    50   ~ 0
FT_D0
Text HLabel 6750 3850 2    50   Output ~ 0
FT_RXF#
Wire Wire Line
	5900 2950 6550 2950
Wire Wire Line
	5900 3050 6550 3050
Wire Wire Line
	5900 3150 6550 3150
Wire Wire Line
	5900 3250 6550 3250
Wire Wire Line
	5900 3350 6550 3350
Wire Wire Line
	6550 3450 5900 3450
Wire Wire Line
	5900 3550 6550 3550
Wire Wire Line
	6550 3650 5900 3650
Wire Bus Line
	6650 3750 6750 3750
Entry Wire Line
	6550 2950 6650 3050
Entry Wire Line
	6550 3050 6650 3150
Entry Wire Line
	6550 3150 6650 3250
Entry Wire Line
	6550 3250 6650 3350
Entry Wire Line
	6550 3350 6650 3450
Entry Wire Line
	6550 3450 6650 3550
Entry Wire Line
	6550 3550 6650 3650
Entry Wire Line
	6550 3650 6650 3750
Text HLabel 6750 3750 2    50   BiDi ~ 0
FT_D[0..7]
Text HLabel 6750 4350 2    50   Output ~ 0
FT_CLKOUT
Text HLabel 6750 4050 2    50   Input ~ 0
FT_RD#
Text HLabel 6750 4150 2    50   Input ~ 0
FT_WR#
Text HLabel 6750 4250 2    50   Input ~ 0
FT_SIWUA
Text HLabel 6750 4450 2    50   Input ~ 0
FT_OE#
Text HLabel 6750 3950 2    50   Output ~ 0
FT_TXE#
Wire Wire Line
	6750 4350 5900 4350
Text HLabel 6750 4750 2    50   Output ~ 0
FT_SCK
Text HLabel 6750 4850 2    50   Output ~ 0
FT_MOSI
Text HLabel 6750 4950 2    50   Input ~ 0
FT_MISO
Text HLabel 6750 5150 2    50   Output ~ 0
FT_SS
Text HLabel 6750 5350 2    50   Output ~ 0
FT_CDONE
Text HLabel 6750 5450 2    50   Output ~ 0
FT_CRESET
Wire Bus Line
	6650 3050 6650 3750
$EndSCHEMATC
