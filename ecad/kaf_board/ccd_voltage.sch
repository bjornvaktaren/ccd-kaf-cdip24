EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 8
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
L Device:Opamp_Quad_Generic U?
U 1 1 5E6E0F9A
P 2000 1550
AR Path="/5E76D4CA/5E6E0AA8/5E6E0F9A" Ref="U?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E6E0F9A" Ref="U?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E6E0F9A" Ref="U?"  Part="1" 
F 0 "U?" H 2000 1917 50  0000 C CNN
F 1 "Opamp_Quad_Generic" H 2000 1826 50  0000 C CNN
F 2 "" H 2000 1550 50  0001 C CNN
F 3 "~" H 2000 1550 50  0001 C CNN
	1    2000 1550
	1    0    0    -1  
$EndComp
$Comp
L Device:Opamp_Quad_Generic U?
U 2 1 5E6E2241
P 2000 3200
AR Path="/5E76D4CA/5E6E0AA8/5E6E2241" Ref="U?"  Part="2" 
AR Path="/5E76D4CA/5E79BAC8/5E6E2241" Ref="U?"  Part="2" 
AR Path="/5E76D4CA/5E7A07AF/5E6E2241" Ref="U?"  Part="2" 
F 0 "U?" H 2000 3567 50  0000 C CNN
F 1 "Opamp_Quad_Generic" H 2000 3476 50  0000 C CNN
F 2 "" H 2000 3200 50  0001 C CNN
F 3 "~" H 2000 3200 50  0001 C CNN
	2    2000 3200
	1    0    0    -1  
$EndComp
$Comp
L Device:Opamp_Quad_Generic U?
U 3 1 5E6E4488
P 4450 1600
AR Path="/5E76D4CA/5E6E0AA8/5E6E4488" Ref="U?"  Part="3" 
AR Path="/5E76D4CA/5E79BAC8/5E6E4488" Ref="U?"  Part="3" 
AR Path="/5E76D4CA/5E7A07AF/5E6E4488" Ref="U?"  Part="3" 
F 0 "U?" H 4450 1967 50  0000 C CNN
F 1 "Opamp_Quad_Generic" H 4450 1876 50  0000 C CNN
F 2 "" H 4450 1600 50  0001 C CNN
F 3 "~" H 4450 1600 50  0001 C CNN
	3    4450 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:Opamp_Quad_Generic U?
U 4 1 5E6E4DF3
P 4450 3200
AR Path="/5E76D4CA/5E6E0AA8/5E6E4DF3" Ref="U?"  Part="4" 
AR Path="/5E76D4CA/5E79BAC8/5E6E4DF3" Ref="U?"  Part="4" 
AR Path="/5E76D4CA/5E7A07AF/5E6E4DF3" Ref="U?"  Part="4" 
F 0 "U?" H 4450 3567 50  0000 C CNN
F 1 "Opamp_Quad_Generic" H 4450 3476 50  0000 C CNN
F 2 "" H 4450 3200 50  0001 C CNN
F 3 "~" H 4450 3200 50  0001 C CNN
	4    4450 3200
	1    0    0    -1  
$EndComp
$Comp
L Device:Opamp_Quad_Generic U?
U 5 1 5E6E540D
P 2800 5750
AR Path="/5E76D4CA/5E6E0AA8/5E6E540D" Ref="U?"  Part="5" 
AR Path="/5E76D4CA/5E79BAC8/5E6E540D" Ref="U?"  Part="5" 
AR Path="/5E76D4CA/5E7A07AF/5E6E540D" Ref="U?"  Part="5" 
F 0 "U?" H 2758 5796 50  0000 L CNN
F 1 "Opamp_Quad_Generic" H 2758 5705 50  0000 L CNN
F 2 "" H 2800 5750 50  0001 C CNN
F 3 "~" H 2800 5750 50  0001 C CNN
	5    2800 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT RV?
U 1 1 5E6E6B3F
P 1300 1450
AR Path="/5E76D4CA/5E6E0AA8/5E6E6B3F" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E6E6B3F" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E6E6B3F" Ref="RV?"  Part="1" 
F 0 "RV?" H 1230 1496 50  0000 R CNN
F 1 "10k" H 1230 1405 50  0000 R CNN
F 2 "" H 1300 1450 50  0001 C CNN
F 3 "~" H 1300 1450 50  0001 C CNN
	1    1300 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 1450 1700 1450
Wire Wire Line
	1700 1650 1650 1650
Wire Wire Line
	1650 1650 1650 1850
Wire Wire Line
	2300 1550 2350 1550
Text HLabel 2650 1550 2    50   Output ~ 0
V1
Wire Wire Line
	1300 1250 1300 1300
Wire Wire Line
	1300 1600 1300 1650
$Comp
L Device:R_POT RV?
U 1 1 5E710EC3
P 1300 3100
AR Path="/5E76D4CA/5E6E0AA8/5E710EC3" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E710EC3" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E710EC3" Ref="RV?"  Part="1" 
F 0 "RV?" H 1230 3146 50  0000 R CNN
F 1 "10k" H 1230 3055 50  0000 R CNN
F 2 "" H 1300 3100 50  0001 C CNN
F 3 "~" H 1300 3100 50  0001 C CNN
	1    1300 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 3100 1700 3100
Wire Wire Line
	1700 3300 1650 3300
Wire Wire Line
	1650 3300 1650 3500
Wire Wire Line
	1300 2900 1300 2950
Wire Wire Line
	1300 3250 1300 3300
$Comp
L Device:R_POT RV?
U 1 1 5E711B73
P 3750 1500
AR Path="/5E76D4CA/5E6E0AA8/5E711B73" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E711B73" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E711B73" Ref="RV?"  Part="1" 
F 0 "RV?" H 3680 1546 50  0000 R CNN
F 1 "10k" H 3680 1455 50  0000 R CNN
F 2 "" H 3750 1500 50  0001 C CNN
F 3 "~" H 3750 1500 50  0001 C CNN
	1    3750 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 1500 4150 1500
Wire Wire Line
	4150 1700 4100 1700
Wire Wire Line
	4100 1700 4100 1900
$Comp
L power:-15V #PWR?
U 1 1 5E711B88
P 3300 6150
AR Path="/5E76D4CA/5E6E0AA8/5E711B88" Ref="#PWR?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E711B88" Ref="#PWR?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E711B88" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3300 6250 50  0001 C CNN
F 1 "-15V" V 3315 6278 50  0000 L CNN
F 2 "" H 3300 6150 50  0001 C CNN
F 3 "" H 3300 6150 50  0001 C CNN
	1    3300 6150
	0    1    1    0   
$EndComp
Wire Wire Line
	3750 1300 3750 1350
Wire Wire Line
	3750 1650 3750 1700
$Comp
L Device:R_POT RV?
U 1 1 5E712730
P 3750 3100
AR Path="/5E76D4CA/5E6E0AA8/5E712730" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E712730" Ref="RV?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E712730" Ref="RV?"  Part="1" 
F 0 "RV?" H 3680 3146 50  0000 R CNN
F 1 "10k" H 3680 3055 50  0000 R CNN
F 2 "" H 3750 3100 50  0001 C CNN
F 3 "~" H 3750 3100 50  0001 C CNN
	1    3750 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 3100 4150 3100
Wire Wire Line
	4150 3300 4100 3300
Wire Wire Line
	4100 3300 4100 3500
Wire Wire Line
	3750 2900 3750 2950
Wire Wire Line
	3750 3250 3750 3300
Wire Wire Line
	2300 3200 2350 3200
Text HLabel 2650 3200 2    50   Output ~ 0
V2
Wire Wire Line
	4750 1600 4800 1600
Text HLabel 5100 1600 2    50   Output ~ 0
V3
Wire Wire Line
	4750 3200 4800 3200
Text HLabel 5100 3200 2    50   Output ~ 0
V4
Text HLabel 1300 1250 1    50   Input ~ 0
+V_REF
Text HLabel 1300 1650 3    50   Input ~ 0
-V_REF
Text HLabel 1300 2900 1    50   Input ~ 0
+V_REF
Text HLabel 1300 3300 3    50   Input ~ 0
-V_REF
Text HLabel 3750 3300 3    50   Input ~ 0
-V_REF
Text HLabel 3750 1700 3    50   Input ~ 0
-V_REF
Text HLabel 3750 2900 1    50   Input ~ 0
+V_REF
Text HLabel 3750 1300 1    50   Input ~ 0
+V_REF
$Comp
L Device:C C?
U 1 1 5E7538AB
P 2700 5100
AR Path="/5E76D4CA/5E6E0AA8/5E7538AB" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E7538AB" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E7538AB" Ref="C?"  Part="1" 
F 0 "C?" H 2815 5146 50  0000 L CNN
F 1 "0.1u" H 2815 5055 50  0000 L CNN
F 2 "" H 2738 4950 50  0001 C CNN
F 3 "~" H 2700 5100 50  0001 C CNN
	1    2700 5100
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C?
U 1 1 5E753EC3
P 3100 5100
AR Path="/5E76D4CA/5E6E0AA8/5E753EC3" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E753EC3" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E753EC3" Ref="C?"  Part="1" 
F 0 "C?" H 2982 5054 50  0000 R CNN
F 1 "4.7u" H 2982 5145 50  0000 R CNN
F 2 "" H 3138 4950 50  0001 C CNN
F 3 "~" H 3100 5100 50  0001 C CNN
	1    3100 5100
	-1   0    0    1   
$EndComp
$Comp
L Device:C C?
U 1 1 5E768260
P 2700 6350
AR Path="/5E76D4CA/5E6E0AA8/5E768260" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E768260" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E768260" Ref="C?"  Part="1" 
F 0 "C?" H 2815 6396 50  0000 L CNN
F 1 "0.1u" H 2815 6305 50  0000 L CNN
F 2 "" H 2738 6200 50  0001 C CNN
F 3 "~" H 2700 6350 50  0001 C CNN
	1    2700 6350
	-1   0    0    1   
$EndComp
$Comp
L Device:CP C?
U 1 1 5E768266
P 3100 6350
AR Path="/5E76D4CA/5E6E0AA8/5E768266" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E768266" Ref="C?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E768266" Ref="C?"  Part="1" 
F 0 "C?" H 3218 6396 50  0000 L CNN
F 1 "4.7u" H 3218 6305 50  0000 L CNN
F 2 "" H 3138 6200 50  0001 C CNN
F 3 "~" H 3100 6350 50  0001 C CNN
	1    3100 6350
	-1   0    0    1   
$EndComp
Wire Wire Line
	2700 5450 2700 5300
Wire Wire Line
	3100 4950 3100 4900
Wire Wire Line
	3100 4900 2700 4900
Wire Wire Line
	2700 4900 2700 4950
Connection ~ 2700 4900
Wire Wire Line
	2700 4850 2700 4900
Wire Wire Line
	2700 6500 2700 6550
Wire Wire Line
	2700 6550 3100 6550
Wire Wire Line
	3100 6550 3100 6500
Connection ~ 2700 6550
Wire Wire Line
	2700 6550 2700 6600
Wire Wire Line
	3100 6200 3100 6150
Wire Wire Line
	3100 6150 2700 6150
Wire Wire Line
	2700 6150 2700 6200
Wire Wire Line
	2700 6150 2700 6050
Connection ~ 2700 6150
Wire Wire Line
	3100 6150 3300 6150
Connection ~ 3100 6150
$Comp
L power:+15V #PWR?
U 1 1 5E711B82
P 3300 5300
AR Path="/5E76D4CA/5E6E0AA8/5E711B82" Ref="#PWR?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E711B82" Ref="#PWR?"  Part="1" 
AR Path="/5E76D4CA/5E7A07AF/5E711B82" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3300 5150 50  0001 C CNN
F 1 "+15V" V 3315 5428 50  0000 L CNN
F 2 "" H 3300 5300 50  0001 C CNN
F 3 "" H 3300 5300 50  0001 C CNN
	1    3300 5300
	0    1    1    0   
$EndComp
Wire Wire Line
	2700 5300 3100 5300
Wire Wire Line
	2700 5250 2700 5300
Connection ~ 2700 5300
Wire Wire Line
	3100 5250 3100 5300
Connection ~ 3100 5300
Wire Wire Line
	3100 5300 3300 5300
Wire Wire Line
	1650 1850 2350 1850
Wire Wire Line
	2350 1850 2350 1550
Connection ~ 2350 1550
Wire Wire Line
	2350 1550 2650 1550
Wire Wire Line
	1650 3500 2350 3500
Wire Wire Line
	2350 3500 2350 3200
Connection ~ 2350 3200
Wire Wire Line
	2350 3200 2650 3200
Wire Wire Line
	4100 3500 4800 3500
Wire Wire Line
	4800 3500 4800 3200
Connection ~ 4800 3200
Wire Wire Line
	4800 3200 5100 3200
Wire Wire Line
	4100 1900 4800 1900
Wire Wire Line
	4800 1900 4800 1600
Connection ~ 4800 1600
Wire Wire Line
	4800 1600 5100 1600
$Comp
L power:GNDA #PWR?
U 1 1 5E63B571
P 2700 4850
AR Path="/5E76D4CA/5E7A07AF/5E63B571" Ref="#PWR?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E63B571" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2700 4600 50  0001 C CNN
F 1 "GNDA" H 2705 4677 50  0000 C CNN
F 2 "" H 2700 4850 50  0001 C CNN
F 3 "" H 2700 4850 50  0001 C CNN
	1    2700 4850
	-1   0    0    1   
$EndComp
$Comp
L power:GNDA #PWR?
U 1 1 5E63C676
P 2700 6600
AR Path="/5E76D4CA/5E7A07AF/5E63C676" Ref="#PWR?"  Part="1" 
AR Path="/5E76D4CA/5E79BAC8/5E63C676" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2700 6350 50  0001 C CNN
F 1 "GNDA" H 2705 6427 50  0000 C CNN
F 2 "" H 2700 6600 50  0001 C CNN
F 3 "" H 2700 6600 50  0001 C CNN
	1    2700 6600
	1    0    0    -1  
$EndComp
$EndSCHEMATC
