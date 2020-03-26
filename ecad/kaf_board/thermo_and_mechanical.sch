EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 9 9
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
L Analog_ADC:MCP3004 U?
U 1 1 5EA78421
P 3200 3500
F 0 "U?" H 3200 4081 50  0000 C CNN
F 1 "MCP3004" H 3200 3990 50  0000 C CNN
F 2 "" H 4100 3200 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/21295C.pdf" H 4100 3200 50  0001 C CNN
	1    3200 3500
	1    0    0    -1  
$EndComp
$Comp
L Device:Thermistor_NTC TH?
U 1 1 5EA78AD3
P 1100 4400
F 0 "TH?" H 1198 4446 50  0000 L CNN
F 1 "2000, beta 3450" H 1198 4355 50  0000 L CNN
F 2 "" H 1100 4450 50  0001 C CNN
F 3 "~" H 1100 4450 50  0001 C CNN
	1    1100 4400
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5EA79E1E
P 1100 4000
F 0 "R?" H 1170 4046 50  0000 L CNN
F 1 "2200" H 1170 3955 50  0000 L CNN
F 2 "" V 1030 4000 50  0001 C CNN
F 3 "~" H 1100 4000 50  0001 C CNN
	1    1100 4000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5EA7A2AE
P 650 4400
F 0 "C?" H 765 4446 50  0000 L CNN
F 1 "0.1u" H 765 4355 50  0000 L CNN
F 2 "" H 688 4250 50  0001 C CNN
F 3 "~" H 650 4400 50  0001 C CNN
	1    650  4400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EA7C042
P 1100 4650
F 0 "#PWR?" H 1100 4400 50  0001 C CNN
F 1 "GND" H 1105 4477 50  0000 C CNN
F 2 "" H 1100 4650 50  0001 C CNN
F 3 "" H 1100 4650 50  0001 C CNN
	1    1100 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 3750 1100 3850
Wire Wire Line
	1100 4550 1100 4600
Wire Wire Line
	1100 4150 1100 4200
Wire Wire Line
	650  4250 650  4200
Wire Wire Line
	650  4200 1100 4200
Connection ~ 1100 4200
Wire Wire Line
	1100 4200 1100 4250
Wire Wire Line
	650  4550 650  4600
Wire Wire Line
	650  4600 1100 4600
Connection ~ 1100 4600
Wire Wire Line
	1100 4600 1100 4650
$Comp
L Device:Thermistor_NTC TH?
U 1 1 5EA82A48
P 1100 1500
F 0 "TH?" H 1198 1546 50  0000 L CNN
F 1 "2000, beta 3450" H 1198 1455 50  0000 L CNN
F 2 "" H 1100 1550 50  0001 C CNN
F 3 "~" H 1100 1550 50  0001 C CNN
	1    1100 1500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5EA82A4E
P 1100 1100
F 0 "R?" H 1170 1146 50  0000 L CNN
F 1 "2200" H 1170 1055 50  0000 L CNN
F 2 "" V 1030 1100 50  0001 C CNN
F 3 "~" H 1100 1100 50  0001 C CNN
	1    1100 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5EA82A54
P 650 1500
F 0 "C?" H 765 1546 50  0000 L CNN
F 1 "0.1u" H 765 1455 50  0000 L CNN
F 2 "" H 688 1350 50  0001 C CNN
F 3 "~" H 650 1500 50  0001 C CNN
	1    650  1500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EA82A60
P 1100 1750
F 0 "#PWR?" H 1100 1500 50  0001 C CNN
F 1 "GND" H 1105 1577 50  0000 C CNN
F 2 "" H 1100 1750 50  0001 C CNN
F 3 "" H 1100 1750 50  0001 C CNN
	1    1100 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 850  1100 950 
Wire Wire Line
	1100 1650 1100 1700
Wire Wire Line
	1100 1250 1100 1300
Wire Wire Line
	650  1350 650  1300
Wire Wire Line
	650  1300 1100 1300
Connection ~ 1100 1300
Wire Wire Line
	1100 1300 1100 1350
Wire Wire Line
	650  1650 650  1700
Wire Wire Line
	650  1700 1100 1700
Connection ~ 1100 1700
Wire Wire Line
	1100 1700 1100 1750
$Comp
L Device:Thermistor_NTC TH?
U 1 1 5EA8391C
P 1100 2950
F 0 "TH?" H 1198 2996 50  0000 L CNN
F 1 "2000, beta 3450" H 1198 2905 50  0000 L CNN
F 2 "" H 1100 3000 50  0001 C CNN
F 3 "~" H 1100 3000 50  0001 C CNN
	1    1100 2950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5EA83922
P 1100 2550
F 0 "R?" H 1170 2596 50  0000 L CNN
F 1 "2200" H 1170 2505 50  0000 L CNN
F 2 "" V 1030 2550 50  0001 C CNN
F 3 "~" H 1100 2550 50  0001 C CNN
	1    1100 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5EA83928
P 650 2950
F 0 "C?" H 765 2996 50  0000 L CNN
F 1 "0.1u" H 765 2905 50  0000 L CNN
F 2 "" H 688 2800 50  0001 C CNN
F 3 "~" H 650 2950 50  0001 C CNN
	1    650  2950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5EA83934
P 1100 3200
F 0 "#PWR?" H 1100 2950 50  0001 C CNN
F 1 "GND" H 1105 3027 50  0000 C CNN
F 2 "" H 1100 3200 50  0001 C CNN
F 3 "" H 1100 3200 50  0001 C CNN
	1    1100 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 2300 1100 2400
Wire Wire Line
	1100 3100 1100 3150
Wire Wire Line
	1100 2700 1100 2750
Wire Wire Line
	650  2800 650  2750
Wire Wire Line
	650  2750 1100 2750
Connection ~ 1100 2750
Wire Wire Line
	1100 2750 1100 2800
Wire Wire Line
	650  3100 650  3150
Wire Wire Line
	650  3150 1100 3150
Connection ~ 1100 3150
Wire Wire Line
	1100 3150 1100 3200
Wire Wire Line
	1100 1300 2200 1300
Wire Wire Line
	2200 1300 2200 3400
Wire Wire Line
	2200 3400 2600 3400
Wire Wire Line
	1100 2750 2100 2750
Wire Wire Line
	2100 2750 2100 3500
Wire Wire Line
	2100 3500 2600 3500
Wire Wire Line
	1100 4200 2100 4200
Wire Wire Line
	2100 4200 2100 3600
Wire Wire Line
	2100 3600 2600 3600
$Comp
L Connector_Generic:Conn_01x02 J?
U 1 1 5EA9E29D
P 9900 2900
F 0 "J?" H 9980 2892 50  0000 L CNN
F 1 "Peltier1" H 9980 2801 50  0000 L CNN
F 2 "" H 9900 2900 50  0001 C CNN
F 3 "~" H 9900 2900 50  0001 C CNN
	1    9900 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:L L?
U 1 1 5EA9F87A
P 8650 3400
F 0 "L?" V 8469 3400 50  0000 C CNN
F 1 "100u" V 8560 3400 50  0000 C CNN
F 2 "" H 8650 3400 50  0001 C CNN
F 3 "~" H 8650 3400 50  0001 C CNN
	1    8650 3400
	0    1    1    0   
$EndComp
$Comp
L Device:C C?
U 1 1 5EA9FDA4
P 9050 3150
F 0 "C?" H 9165 3196 50  0000 L CNN
F 1 "4.7u" H 9165 3105 50  0000 L CNN
F 2 "" H 9088 3000 50  0001 C CNN
F 3 "~" H 9050 3150 50  0001 C CNN
	1    9050 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	9700 3000 9450 3000
Text Label 9550 2900 0    50   ~ 0
+
Text Label 9550 3000 0    50   ~ 0
-
Wire Wire Line
	9450 3000 9450 3400
Wire Wire Line
	9450 3400 9050 3400
Wire Wire Line
	9050 3300 9050 3400
Wire Wire Line
	8500 3400 8150 3400
$Comp
L Device:D D?
U 1 1 5EAB58CC
P 8150 3150
F 0 "D?" V 8104 3229 50  0000 L CNN
F 1 "D" V 8195 3229 50  0000 L CNN
F 2 "" H 8150 3150 50  0001 C CNN
F 3 "~" H 8150 3150 50  0001 C CNN
	1    8150 3150
	0    1    1    0   
$EndComp
Wire Wire Line
	8150 2900 8150 3000
Wire Wire Line
	9050 3000 9050 2900
Wire Wire Line
	9050 2900 9700 2900
Wire Wire Line
	8150 3300 8150 3400
Wire Wire Line
	9050 3400 8800 3400
Connection ~ 9050 3400
Wire Wire Line
	8150 2900 9050 2900
Connection ~ 9050 2900
$Comp
L ccd_camera:TC4427 U?
U 1 1 5E77F27F
P 6800 5350
F 0 "U?" H 6800 5725 50  0000 C CNN
F 1 "TC4427" H 6800 5634 50  0000 C CNN
F 2 "" H 6700 5250 50  0001 C CNN
F 3 "" H 6700 5250 50  0001 C CNN
	1    6800 5350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E78153D
P 5850 5850
F 0 "#PWR?" H 5850 5600 50  0001 C CNN
F 1 "GND" H 5855 5677 50  0000 C CNN
F 2 "" H 5850 5850 50  0001 C CNN
F 3 "" H 5850 5850 50  0001 C CNN
	1    5850 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E781FCA
P 5450 5600
F 0 "C?" H 5565 5646 50  0000 L CNN
F 1 "4.7u" H 5565 5555 50  0000 L CNN
F 2 "" H 5488 5450 50  0001 C CNN
F 3 "~" H 5450 5600 50  0001 C CNN
	1    5450 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E782666
P 5850 5600
F 0 "C?" H 5965 5646 50  0000 L CNN
F 1 "0.1u" H 5965 5555 50  0000 L CNN
F 2 "" H 5888 5450 50  0001 C CNN
F 3 "~" H 5850 5600 50  0001 C CNN
	1    5850 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 5400 5850 5450
Wire Wire Line
	5850 5400 5450 5400
Wire Wire Line
	5450 5400 5450 5450
Connection ~ 5850 5400
Wire Wire Line
	5450 5750 5450 5800
Wire Wire Line
	5450 5800 5850 5800
Wire Wire Line
	5850 5750 5850 5800
Connection ~ 5850 5800
Wire Wire Line
	5850 5800 5850 5850
Wire Wire Line
	6300 5200 6150 5200
Text HLabel 6150 5200 0    50   Input ~ 0
PWM_TEC1
Wire Wire Line
	6300 5300 6250 5300
Wire Wire Line
	6250 5300 6250 5500
Wire Wire Line
	6250 5500 6300 5500
Wire Wire Line
	6250 5500 6250 5800
Wire Wire Line
	5850 5800 6250 5800
Connection ~ 6250 5500
Wire Wire Line
	5850 5400 6300 5400
$Comp
L Device:Q_NMOS_GDS Q?
U 1 1 5E7B631C
P 8050 3750
F 0 "Q?" H 8254 3796 50  0000 L CNN
F 1 "Q_NMOS_GDS" H 8254 3705 50  0000 L CNN
F 2 "" H 8250 3850 50  0001 C CNN
F 3 "~" H 8050 3750 50  0001 C CNN
	1    8050 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 3400 8150 3550
Connection ~ 8150 3400
Connection ~ 6250 5800
Wire Wire Line
	5450 5400 4850 5400
Connection ~ 5450 5400
Wire Wire Line
	8150 2900 7850 2900
Connection ~ 8150 2900
Text Label 7850 2900 0    50   ~ 0
TEC_SUPPLY1
Text Label 4850 5400 0    50   ~ 0
NMOS_SUPPLY
Wire Wire Line
	4000 3700 3800 3700
Wire Wire Line
	3800 3600 4000 3600
Wire Wire Line
	4000 3500 3800 3500
Wire Wire Line
	3800 3400 4000 3400
Text HLabel 4000 3700 2    50   Input ~ 0
MCP_CS_N
Text HLabel 4000 3600 2    50   Input ~ 0
MCP_DIN
Text HLabel 4000 3500 2    50   Output ~ 0
MCP_DOUT
Text HLabel 4000 3400 2    50   Input ~ 0
MCP_CLK
$Comp
L power:+3.3V #PWR?
U 1 1 5E7EB7CF
P 3900 2800
F 0 "#PWR?" H 3900 2650 50  0001 C CNN
F 1 "+3.3V" H 3915 2973 50  0000 C CNN
F 2 "" H 3900 2800 50  0001 C CNN
F 3 "" H 3900 2800 50  0001 C CNN
	1    3900 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E7EC025
P 3900 3050
F 0 "C?" H 4015 3096 50  0000 L CNN
F 1 "1u" H 4015 3005 50  0000 L CNN
F 2 "" H 3938 2900 50  0001 C CNN
F 3 "~" H 3900 3050 50  0001 C CNN
	1    3900 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 4050 3200 4000
Wire Wire Line
	3200 4050 3100 4050
Wire Wire Line
	3100 4050 3100 4000
Connection ~ 3200 4050
$Comp
L power:GND #PWR?
U 1 1 5E800B76
P 3900 4100
F 0 "#PWR?" H 3900 3850 50  0001 C CNN
F 1 "GND" H 3905 3927 50  0000 C CNN
F 2 "" H 3900 4100 50  0001 C CNN
F 3 "" H 3900 4100 50  0001 C CNN
	1    3900 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 4050 3200 4050
Wire Wire Line
	3900 3200 3900 4050
Connection ~ 3900 4050
Wire Wire Line
	3900 4100 3900 4050
Wire Wire Line
	3900 2800 3900 2850
Wire Wire Line
	3900 2850 3200 2850
Wire Wire Line
	3100 2850 3100 3100
Connection ~ 3900 2850
Wire Wire Line
	3900 2850 3900 2900
Wire Wire Line
	3200 3100 3200 2850
Connection ~ 3200 2850
Wire Wire Line
	3200 2850 3100 2850
$Comp
L power:+3.3V #PWR?
U 1 1 5E7BA483
P 1100 850
F 0 "#PWR?" H 1100 700 50  0001 C CNN
F 1 "+3.3V" H 1115 1023 50  0000 C CNN
F 2 "" H 1100 850 50  0001 C CNN
F 3 "" H 1100 850 50  0001 C CNN
	1    1100 850 
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR?
U 1 1 5E7BAAB4
P 1100 2300
F 0 "#PWR?" H 1100 2150 50  0001 C CNN
F 1 "+3.3V" H 1115 2473 50  0000 C CNN
F 2 "" H 1100 2300 50  0001 C CNN
F 3 "" H 1100 2300 50  0001 C CNN
	1    1100 2300
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR?
U 1 1 5E7BB4EB
P 1100 3750
F 0 "#PWR?" H 1100 3600 50  0001 C CNN
F 1 "+3.3V" H 1115 3923 50  0000 C CNN
F 2 "" H 1100 3750 50  0001 C CNN
F 3 "" H 1100 3750 50  0001 C CNN
	1    1100 3750
	1    0    0    -1  
$EndComp
$Comp
L Motor:Motor_Servo M?
U 1 1 5E7EE41F
P 2500 6300
F 0 "M?" H 2832 6365 50  0000 L CNN
F 1 "Motor_Servo" H 2832 6274 50  0000 L CNN
F 2 "" H 2500 6110 50  0001 C CNN
F 3 "http://forums.parallax.com/uploads/attachments/46831/74481.png" H 2500 6110 50  0001 C CNN
	1    2500 6300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E7F041B
P 1400 6750
F 0 "#PWR?" H 1400 6500 50  0001 C CNN
F 1 "GND" H 1405 6577 50  0000 C CNN
F 2 "" H 1400 6750 50  0001 C CNN
F 3 "" H 1400 6750 50  0001 C CNN
	1    1400 6750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5E7F08A4
P 1200 6300
F 0 "#PWR?" H 1200 6150 50  0001 C CNN
F 1 "+5V" V 1215 6428 50  0000 L CNN
F 2 "" H 1200 6300 50  0001 C CNN
F 3 "" H 1200 6300 50  0001 C CNN
	1    1200 6300
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C?
U 1 1 5E7F33BE
P 1400 6500
F 0 "C?" H 1515 6546 50  0000 L CNN
F 1 "0.1u" H 1515 6455 50  0000 L CNN
F 2 "" H 1438 6350 50  0001 C CNN
F 3 "~" H 1400 6500 50  0001 C CNN
	1    1400 6500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E7F36C3
P 1800 6500
F 0 "C?" H 1915 6546 50  0000 L CNN
F 1 "4.7u" H 1915 6455 50  0000 L CNN
F 2 "" H 1838 6350 50  0001 C CNN
F 3 "~" H 1800 6500 50  0001 C CNN
	1    1800 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 6300 1400 6350
Wire Wire Line
	1400 6300 1800 6300
Wire Wire Line
	1800 6300 1800 6350
Connection ~ 1400 6300
Wire Wire Line
	1200 6300 1400 6300
Wire Wire Line
	1400 6650 1400 6700
Wire Wire Line
	1400 6700 1800 6700
Wire Wire Line
	1800 6700 1800 6650
Connection ~ 1400 6700
Wire Wire Line
	1400 6700 1400 6750
Wire Wire Line
	2200 6300 1800 6300
Connection ~ 1800 6300
Wire Wire Line
	2200 6400 2200 6700
Wire Wire Line
	2200 6700 1800 6700
Connection ~ 1800 6700
Text HLabel 1800 6200 0    50   Input ~ 0
PWM_SERVO
Wire Wire Line
	2200 6200 1800 6200
Text Notes 1500 6050 0    50   ~ 0
Ok with 3.3v for PWM?
Wire Wire Line
	6250 5300 6150 5300
Text HLabel 6150 5300 0    50   Input ~ 0
PWM_TEC2
Connection ~ 6250 5300
$Comp
L Connector_Generic:Conn_01x02 J?
U 1 1 5EB40F91
P 10450 4550
F 0 "J?" H 10530 4542 50  0000 L CNN
F 1 "Peltier2" H 10530 4451 50  0000 L CNN
F 2 "" H 10450 4550 50  0001 C CNN
F 3 "~" H 10450 4550 50  0001 C CNN
	1    10450 4550
	1    0    0    -1  
$EndComp
$Comp
L Device:L L?
U 1 1 5EB40F97
P 9200 5050
F 0 "L?" V 9019 5050 50  0000 C CNN
F 1 "100u" V 9110 5050 50  0000 C CNN
F 2 "" H 9200 5050 50  0001 C CNN
F 3 "~" H 9200 5050 50  0001 C CNN
	1    9200 5050
	0    1    1    0   
$EndComp
$Comp
L Device:C C?
U 1 1 5EB40F9D
P 9600 4800
F 0 "C?" H 9715 4846 50  0000 L CNN
F 1 "4.7u" H 9715 4755 50  0000 L CNN
F 2 "" H 9638 4650 50  0001 C CNN
F 3 "~" H 9600 4800 50  0001 C CNN
	1    9600 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	10250 4650 10000 4650
Text Label 10100 4550 0    50   ~ 0
+
Text Label 10100 4650 0    50   ~ 0
-
Wire Wire Line
	10000 4650 10000 5050
Wire Wire Line
	10000 5050 9600 5050
Wire Wire Line
	9600 4950 9600 5050
Wire Wire Line
	9050 5050 8700 5050
$Comp
L Device:D D?
U 1 1 5EB40FAA
P 8700 4800
F 0 "D?" V 8654 4879 50  0000 L CNN
F 1 "D" V 8745 4879 50  0000 L CNN
F 2 "" H 8700 4800 50  0001 C CNN
F 3 "~" H 8700 4800 50  0001 C CNN
	1    8700 4800
	0    1    1    0   
$EndComp
Wire Wire Line
	8700 4550 8700 4650
Wire Wire Line
	9600 4650 9600 4550
Wire Wire Line
	9600 4550 10250 4550
Wire Wire Line
	8700 4950 8700 5050
Wire Wire Line
	9600 5050 9350 5050
Connection ~ 9600 5050
Wire Wire Line
	8700 4550 9600 4550
Connection ~ 9600 4550
$Comp
L Device:Q_NMOS_GDS Q?
U 1 1 5EB40FB8
P 8600 5400
F 0 "Q?" H 8804 5446 50  0000 L CNN
F 1 "Q_NMOS_GDS" H 8804 5355 50  0000 L CNN
F 2 "" H 8800 5500 50  0001 C CNN
F 3 "~" H 8600 5400 50  0001 C CNN
	1    8600 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	8700 5050 8700 5200
Connection ~ 8700 5050
Wire Wire Line
	8700 4550 8400 4550
Connection ~ 8700 4550
Text Label 8400 4550 0    50   ~ 0
TEC_SUPPLY2
Wire Wire Line
	6250 5800 8150 5800
Wire Wire Line
	8700 5600 8700 5800
Wire Wire Line
	8150 3950 8150 5800
Connection ~ 8150 5800
Wire Wire Line
	8150 5800 8700 5800
Wire Wire Line
	7300 5400 8400 5400
Wire Wire Line
	7650 5300 7650 3750
Wire Wire Line
	7650 3750 7850 3750
Wire Wire Line
	7300 5300 7650 5300
$EndSCHEMATC
