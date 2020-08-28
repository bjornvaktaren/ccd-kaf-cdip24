EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 9
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
L Regulator_Linear:LD1117S12TR_SOT223 U?
U 1 1 5E943A66
P 4100 1450
AR Path="/5E5DF889/5E943A66" Ref="U?"  Part="1" 
AR Path="/5E643BF7/5E943A66" Ref="U13"  Part="1" 
F 0 "U13" H 4100 1692 50  0000 C CNN
F 1 "LD1117S12CTR_SOT223" H 4100 1601 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-223-3_TabPin2" H 4100 1650 50  0001 C CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/CD00000544.pdf" H 4200 1200 50  0001 C CNN
	1    4100 1450
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E943A6C
P 4800 1750
AR Path="/5E5DF889/5E943A6C" Ref="C?"  Part="1" 
AR Path="/5E643BF7/5E943A6C" Ref="C61"  Part="1" 
F 0 "C61" H 4915 1796 50  0000 L CNN
F 1 "10u" H 4915 1705 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 4838 1600 50  0001 C CNN
F 3 "~" H 4800 1750 50  0001 C CNN
	1    4800 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E943A72
P 3650 1750
AR Path="/5E5DF889/5E943A72" Ref="C?"  Part="1" 
AR Path="/5E643BF7/5E943A72" Ref="C57"  Part="1" 
F 0 "C57" H 3765 1796 50  0000 L CNN
F 1 "0.1u" H 3765 1705 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3688 1600 50  0001 C CNN
F 3 "~" H 3650 1750 50  0001 C CNN
	1    3650 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5E943A78
P 4500 1750
AR Path="/5E5DF889/5E943A78" Ref="R?"  Part="1" 
AR Path="/5E643BF7/5E943A78" Ref="R44"  Part="1" 
F 0 "R44" V 4400 1750 50  0000 C CNN
F 1 "120" V 4600 1750 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4430 1750 50  0001 C CNN
F 3 "~" H 4500 1750 50  0001 C CNN
	1    4500 1750
	-1   0    0    1   
$EndComp
$Comp
L power:+1V2 #PWR?
U 1 1 5E943A7E
P 4950 1450
AR Path="/5E5DF889/5E943A7E" Ref="#PWR?"  Part="1" 
AR Path="/5E643BF7/5E943A7E" Ref="#PWR0201"  Part="1" 
F 0 "#PWR0201" H 4950 1300 50  0001 C CNN
F 1 "+1V2" V 4965 1578 50  0000 L CNN
F 2 "" H 4950 1450 50  0001 C CNN
F 3 "" H 4950 1450 50  0001 C CNN
	1    4950 1450
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E943A84
P 3650 2000
AR Path="/5E5DF889/5E943A84" Ref="#PWR?"  Part="1" 
AR Path="/5E643BF7/5E943A84" Ref="#PWR0202"  Part="1" 
F 0 "#PWR0202" H 3650 1750 50  0001 C CNN
F 1 "GND" H 3655 1827 50  0000 C CNN
F 2 "" H 3650 2000 50  0001 C CNN
F 3 "" H 3650 2000 50  0001 C CNN
	1    3650 2000
	-1   0    0    -1  
$EndComp
Wire Wire Line
	3650 1600 3650 1450
Connection ~ 3650 1450
Wire Wire Line
	3650 1450 3800 1450
Wire Wire Line
	3650 1900 3650 1950
Wire Wire Line
	3650 1950 4100 1950
Wire Wire Line
	4100 1950 4100 1750
Connection ~ 3650 1950
Wire Wire Line
	3650 1950 3650 2000
Wire Wire Line
	4100 1950 4500 1950
Wire Wire Line
	4500 1950 4500 1900
Connection ~ 4100 1950
Wire Wire Line
	4400 1450 4500 1450
Wire Wire Line
	4500 1450 4500 1600
Wire Wire Line
	4500 1450 4800 1450
Wire Wire Line
	4800 1450 4800 1600
Connection ~ 4500 1450
Connection ~ 4800 1450
Wire Wire Line
	4800 1900 4800 1950
Wire Wire Line
	4800 1950 4500 1950
Connection ~ 4500 1950
$Comp
L Device:C C?
U 1 1 5E96250C
P 4550 2950
AR Path="/5E5DF889/5E96250C" Ref="C?"  Part="1" 
AR Path="/5E643BF7/5E96250C" Ref="C60"  Part="1" 
F 0 "C60" H 4665 2996 50  0000 L CNN
F 1 "10u" H 4665 2905 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 4588 2800 50  0001 C CNN
F 3 "~" H 4550 2950 50  0001 C CNN
	1    4550 2950
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5E962512
P 3650 2950
AR Path="/5E5DF889/5E962512" Ref="C?"  Part="1" 
AR Path="/5E643BF7/5E962512" Ref="C58"  Part="1" 
F 0 "C58" H 3765 2996 50  0000 L CNN
F 1 "0.1u" H 3765 2905 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3688 2800 50  0001 C CNN
F 3 "~" H 3650 2950 50  0001 C CNN
	1    3650 2950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E962524
P 3650 3200
AR Path="/5E5DF889/5E962524" Ref="#PWR?"  Part="1" 
AR Path="/5E643BF7/5E962524" Ref="#PWR0204"  Part="1" 
F 0 "#PWR0204" H 3650 2950 50  0001 C CNN
F 1 "GND" H 3655 3027 50  0000 C CNN
F 2 "" H 3650 3200 50  0001 C CNN
F 3 "" H 3650 3200 50  0001 C CNN
	1    3650 3200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	3650 2800 3650 2650
Connection ~ 3650 2650
Wire Wire Line
	3650 2650 3800 2650
Wire Wire Line
	3650 3100 3650 3150
Wire Wire Line
	3650 3150 4100 3150
Wire Wire Line
	4100 3150 4100 2950
Connection ~ 3650 3150
Wire Wire Line
	3650 3150 3650 3200
Wire Wire Line
	4550 2650 4550 2800
Connection ~ 4550 2650
Wire Wire Line
	4550 3100 4550 3150
$Comp
L Regulator_Linear:LD1117S33TR_SOT223 U14
U 1 1 5E965774
P 4100 2650
F 0 "U14" H 4100 2892 50  0000 C CNN
F 1 "LD1117S33CTR_SOT223" H 4100 2801 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-223-3_TabPin2" H 4100 2850 50  0001 C CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/CD00000544.pdf" H 4200 2400 50  0001 C CNN
	1    4100 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 2650 4550 2650
Wire Wire Line
	4100 3150 4550 3150
Connection ~ 4100 3150
$Comp
L power:+3.3V #PWR0206
U 1 1 5E9A3F03
P 4700 2650
F 0 "#PWR0206" H 4700 2500 50  0001 C CNN
F 1 "+3.3V" V 4700 2800 50  0000 L CNN
F 2 "" H 4700 2650 50  0001 C CNN
F 3 "" H 4700 2650 50  0001 C CNN
	1    4700 2650
	0    1    1    0   
$EndComp
Wire Wire Line
	3400 1450 3650 1450
Wire Wire Line
	3400 2650 3650 2650
Wire Wire Line
	4550 2650 4700 2650
$Comp
L Device:C C68
U 1 1 5EEEB9C5
P 2350 1950
AR Path="/5E643BF7/5EEEB9C5" Ref="C68"  Part="1" 
AR Path="/5EEEB9C5" Ref="C?"  Part="1" 
F 0 "C68" H 2465 1996 50  0000 L CNN
F 1 "0.1u" H 2465 1905 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 2388 1800 50  0001 C CNN
F 3 "~" H 2350 1950 50  0001 C CNN
	1    2350 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:CP C69
U 1 1 5EEEB9CB
P 2750 1950
AR Path="/5E643BF7/5EEEB9CB" Ref="C69"  Part="1" 
AR Path="/5EEEB9CB" Ref="C?"  Part="1" 
F 0 "C69" H 2868 1996 50  0000 L CNN
F 1 "47u" H 2868 1905 50  0000 L CNN
F 2 "Capacitors_THT:CP_Radial_D5.0mm_P2.00mm" H 2788 1800 50  0001 C CNN
F 3 "~" H 2750 1950 50  0001 C CNN
	1    2750 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 1750 2350 1800
Wire Wire Line
	2350 1750 2750 1750
Wire Wire Line
	2750 1750 2750 1800
Wire Wire Line
	2350 2150 2350 2100
Wire Wire Line
	2350 2150 2550 2150
Wire Wire Line
	2750 2150 2750 2100
Wire Wire Line
	2750 1750 2750 1600
Connection ~ 2750 1750
$Comp
L power:GND #PWR0168
U 1 1 5EEEB9EE
P 2550 2200
AR Path="/5E643BF7/5EEEB9EE" Ref="#PWR0168"  Part="1" 
AR Path="/5EEEB9EE" Ref="#PWR?"  Part="1" 
F 0 "#PWR0168" H 2550 1950 50  0001 C CNN
F 1 "GND" H 2555 2027 50  0000 C CNN
F 2 "" H 2550 2200 50  0001 C CNN
F 3 "" H 2550 2200 50  0001 C CNN
	1    2550 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 2150 2550 2200
Connection ~ 2550 2150
Wire Wire Line
	2550 2150 2750 2150
Wire Wire Line
	2100 2150 2100 1850
Wire Wire Line
	2100 1850 2050 1850
$Comp
L power:GND #PWR014
U 1 1 5EEE86A1
P 2300 3200
F 0 "#PWR014" H 2300 2950 50  0001 C CNN
F 1 "GND" H 2305 3027 50  0000 C CNN
F 2 "" H 2300 3200 50  0001 C CNN
F 3 "" H 2300 3200 50  0001 C CNN
	1    2300 3200
	1    0    0    -1  
$EndComp
$Comp
L power:GNDA #PWR015
U 1 1 5EEE8FDF
P 2650 3200
F 0 "#PWR015" H 2650 2950 50  0001 C CNN
F 1 "GNDA" H 2655 3027 50  0000 C CNN
F 2 "" H 2650 3200 50  0001 C CNN
F 3 "" H 2650 3200 50  0001 C CNN
	1    2650 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 3200 2300 3150
Wire Wire Line
	2300 3150 2500 3150
Wire Wire Line
	2650 3150 2650 3200
$Comp
L ccd_camera:Peltier J1
U 1 1 5EEDF492
P 1800 1800
F 0 "J1" H 1717 2075 50  0000 C CNN
F 1 "PWR" H 1717 1984 50  0000 C CNN
F 2 "Connectors:PINHEAD1-2" H 1650 1700 50  0001 C CNN
F 3 "" H 1650 1700 50  0001 C CNN
	1    1800 1800
	-1   0    0    -1  
$EndComp
Connection ~ 2350 1750
Connection ~ 2350 2150
$Comp
L power:+6V #PWR0173
U 1 1 5EFE1EE9
P 3400 2650
F 0 "#PWR0173" H 3400 2500 50  0001 C CNN
F 1 "+6V" V 3415 2778 50  0000 L CNN
F 2 "" H 3400 2650 50  0001 C CNN
F 3 "" H 3400 2650 50  0001 C CNN
	1    3400 2650
	0    -1   -1   0   
$EndComp
$Comp
L power:+6V #PWR0174
U 1 1 5EFE2DB3
P 2750 1600
F 0 "#PWR0174" H 2750 1450 50  0001 C CNN
F 1 "+6V" H 2765 1773 50  0000 C CNN
F 2 "" H 2750 1600 50  0001 C CNN
F 3 "" H 2750 1600 50  0001 C CNN
	1    2750 1600
	1    0    0    -1  
$EndComp
$Comp
L power:+6V #PWR0177
U 1 1 5EFE68CD
P 3400 1450
F 0 "#PWR0177" H 3400 1300 50  0001 C CNN
F 1 "+6V" V 3415 1578 50  0000 L CNN
F 2 "" H 3400 1450 50  0001 C CNN
F 3 "" H 3400 1450 50  0001 C CNN
	1    3400 1450
	0    -1   -1   0   
$EndComp
$Comp
L power:PWR_FLAG #FLG0104
U 1 1 5F00E477
P 5950 4550
F 0 "#FLG0104" H 5950 4625 50  0001 C CNN
F 1 "PWR_FLAG" H 5950 4723 50  0000 C CNN
F 2 "" H 5950 4550 50  0001 C CNN
F 3 "~" H 5950 4550 50  0001 C CNN
	1    5950 4550
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0105
U 1 1 5F00E860
P 6000 6350
F 0 "#FLG0105" H 6000 6425 50  0001 C CNN
F 1 "PWR_FLAG" H 6000 6523 50  0000 C CNN
F 2 "" H 6000 6350 50  0001 C CNN
F 3 "~" H 6000 6350 50  0001 C CNN
	1    6000 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 1450 4950 1450
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5F0B5B4D
P 10350 1400
AR Path="/5E6A6B3B/5F0B5B4D" Ref="#FLG?"  Part="1" 
AR Path="/5E643BF7/5F0B5B4D" Ref="#FLG0101"  Part="1" 
F 0 "#FLG0101" H 10350 1475 50  0001 C CNN
F 1 "PWR_FLAG" H 10150 1550 50  0000 L CNN
F 2 "" H 10350 1400 50  0001 C CNN
F 3 "~" H 10350 1400 50  0001 C CNN
	1    10350 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	10350 1400 10350 1550
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5F0B5B55
P 9900 1400
AR Path="/5E6A6B3B/5F0B5B55" Ref="#FLG?"  Part="1" 
AR Path="/5E643BF7/5F0B5B55" Ref="#FLG0102"  Part="1" 
F 0 "#FLG0102" H 9900 1475 50  0001 C CNN
F 1 "PWR_FLAG" H 9700 1550 50  0000 L CNN
F 2 "" H 9900 1400 50  0001 C CNN
F 3 "~" H 9900 1400 50  0001 C CNN
	1    9900 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 1400 9900 1550
Text Notes 9700 1150 0    50   ~ 0
Flags to appease ERC
Wire Wire Line
	2100 2150 2350 2150
Wire Wire Line
	2050 1750 2350 1750
$Comp
L power:GND #PWR0165
U 1 1 5F0CA95A
P 10350 1550
AR Path="/5E643BF7/5F0CA95A" Ref="#PWR0165"  Part="1" 
AR Path="/5F0CA95A" Ref="#PWR?"  Part="1" 
F 0 "#PWR0165" H 10350 1300 50  0001 C CNN
F 1 "GND" H 10355 1377 50  0000 C CNN
F 2 "" H 10350 1550 50  0001 C CNN
F 3 "" H 10350 1550 50  0001 C CNN
	1    10350 1550
	1    0    0    -1  
$EndComp
$Comp
L power:+6V #PWR0180
U 1 1 5F0CD3C3
P 9900 1550
F 0 "#PWR0180" H 9900 1400 50  0001 C CNN
F 1 "+6V" H 9915 1723 50  0000 C CNN
F 2 "" H 9900 1550 50  0001 C CNN
F 3 "" H 9900 1550 50  0001 C CNN
	1    9900 1550
	-1   0    0    1   
$EndComp
$Comp
L Connector:TestPoint_Probe TP1
U 1 1 5EFD4B3A
P 2500 2900
F 0 "TP1" H 2652 3001 50  0000 L CNN
F 1 "GND" H 2652 2910 50  0000 L CNN
F 2 "Measurement_Points:Test_Point_Keystone_5005-5009_Compact" H 2700 2900 50  0001 C CNN
F 3 "https://www.keyelco.com/userAssets/file/M65p56.pdf" H 2700 2900 50  0001 C CNN
	1    2500 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 2900 2500 3150
Connection ~ 2500 3150
Wire Wire Line
	2500 3150 2650 3150
$Comp
L ccd_camera:TPS7A39 U5
U 1 1 5F587E4D
P 8100 5000
F 0 "U5" H 8100 5800 50  0000 C CNN
F 1 "TPS7A39" H 8100 5700 50  0000 C CNN
F 2 "kaf_board:TI_WSON-10-1TP_3x3mm_P0.5mm_HandSolder" H 8150 4450 50  0001 C CNN
F 3 "" H 8150 4450 50  0001 C CNN
	1    8100 5000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C21
U 1 1 5F594B64
P 7300 4400
F 0 "C21" V 7048 4400 50  0000 C CNN
F 1 "10u" V 7139 4400 50  0000 C CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 7338 4250 50  0001 C CNN
F 3 "~" H 7300 4400 50  0001 C CNN
	1    7300 4400
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C67
U 1 1 5F595DD9
P 7300 5700
F 0 "C67" V 7048 5700 50  0000 C CNN
F 1 "10u" V 7139 5700 50  0000 C CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 7338 5550 50  0001 C CNN
F 3 "~" H 7300 5700 50  0001 C CNN
	1    7300 5700
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C115
U 1 1 5F59660F
P 9550 5900
F 0 "C115" V 9298 5900 50  0000 C CNN
F 1 "10u" V 9389 5900 50  0000 C CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 9588 5750 50  0001 C CNN
F 3 "~" H 9550 5900 50  0001 C CNN
	1    9550 5900
	-1   0    0    1   
$EndComp
$Comp
L Device:C C71
U 1 1 5F596F4B
P 9100 4600
F 0 "C71" V 8848 4600 50  0000 C CNN
F 1 "10n" V 8939 4600 50  0000 C CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 9138 4450 50  0001 C CNN
F 3 "~" H 9100 4600 50  0001 C CNN
	1    9100 4600
	-1   0    0    1   
$EndComp
$Comp
L Device:R R6
U 1 1 5F599130
P 8750 5500
F 0 "R6" H 8600 5550 50  0000 L CNN
F 1 "147k 0.1%" V 8850 5300 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 8680 5500 50  0001 C CNN
F 3 "~" H 8750 5500 50  0001 C CNN
	1    8750 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5F59A22F
P 8750 4600
F 0 "R4" H 8600 4600 50  0000 L CNN
F 1 "169k 0.1%" V 8850 4400 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 8680 4600 50  0001 C CNN
F 3 "~" H 8750 4600 50  0001 C CNN
	1    8750 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R9
U 1 1 5F59A72E
P 9400 5100
F 0 "R9" H 9470 5146 50  0000 L CNN
F 1 "15k 0.1%" H 9470 5055 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 9330 5100 50  0001 C CNN
F 3 "~" H 9400 5100 50  0001 C CNN
	1    9400 5100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C24
U 1 1 5F59B081
P 7350 5100
F 0 "C24" V 7098 5100 50  0000 C CNN
F 1 "0.1u" V 7189 5100 50  0000 C CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 7388 4950 50  0001 C CNN
F 3 "~" H 7350 5100 50  0001 C CNN
	1    7350 5100
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C113
U 1 1 5F5A14E9
P 9100 5500
F 0 "C113" V 8848 5500 50  0000 C CNN
F 1 "10n" V 8939 5500 50  0000 C CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 9138 5350 50  0001 C CNN
F 3 "~" H 9100 5500 50  0001 C CNN
	1    9100 5500
	-1   0    0    1   
$EndComp
$Comp
L Device:C C114
U 1 1 5F5A17AD
P 9500 4600
F 0 "C114" V 9248 4600 50  0000 C CNN
F 1 "10u" V 9339 4600 50  0000 C CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 9538 4450 50  0001 C CNN
F 3 "~" H 9500 4600 50  0001 C CNN
	1    9500 4600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR028
U 1 1 5F5B6016
P 8100 6050
F 0 "#PWR028" H 8100 5800 50  0001 C CNN
F 1 "GND" H 7950 6000 50  0000 C CNN
F 2 "" H 8100 6050 50  0001 C CNN
F 3 "" H 8100 6050 50  0001 C CNN
	1    8100 6050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR027
U 1 1 5F5B6F28
P 7100 5800
F 0 "#PWR027" H 7100 5550 50  0001 C CNN
F 1 "GND" H 6950 5750 50  0000 C CNN
F 2 "" H 7100 5800 50  0001 C CNN
F 3 "" H 7100 5800 50  0001 C CNN
	1    7100 5800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR030
U 1 1 5F5B730C
P 9550 6150
F 0 "#PWR030" H 9550 5900 50  0001 C CNN
F 1 "GND" H 9400 6100 50  0000 C CNN
F 2 "" H 9550 6150 50  0001 C CNN
F 3 "" H 9550 6150 50  0001 C CNN
	1    9550 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 4400 7100 4400
Wire Wire Line
	7100 4400 7100 5100
Wire Wire Line
	7150 5700 7100 5700
Connection ~ 7100 5700
Wire Wire Line
	7100 5700 7100 5800
Wire Wire Line
	7200 5100 7100 5100
Connection ~ 7100 5100
Wire Wire Line
	7100 5100 7100 5700
Wire Wire Line
	7450 4400 7500 4400
Wire Wire Line
	7550 5100 7500 5100
Wire Wire Line
	8650 4400 8750 4400
Wire Wire Line
	8750 4400 8750 4450
Wire Wire Line
	8750 4750 8750 4800
Wire Wire Line
	8750 4800 8650 4800
Wire Wire Line
	8750 4800 9100 4800
Wire Wire Line
	9400 4800 9400 4950
Connection ~ 8750 4800
Wire Wire Line
	9400 5250 9400 6100
Wire Wire Line
	9400 6100 9550 6100
Wire Wire Line
	9550 6100 9550 6150
Wire Wire Line
	9550 6050 9550 6100
Connection ~ 9550 6100
Wire Wire Line
	9100 4800 9100 4750
Connection ~ 9100 4800
Wire Wire Line
	9100 4800 9400 4800
Wire Wire Line
	9100 4450 9100 4400
Wire Wire Line
	9100 4400 8750 4400
Connection ~ 8750 4400
Wire Wire Line
	9100 4400 9500 4400
Wire Wire Line
	9500 4400 9500 4450
Connection ~ 9100 4400
Connection ~ 9500 4400
$Comp
L power:GND #PWR029
U 1 1 5F63940A
P 9500 4800
F 0 "#PWR029" H 9500 4550 50  0001 C CNN
F 1 "GND" H 9650 4750 50  0000 C CNN
F 2 "" H 9500 4800 50  0001 C CNN
F 3 "" H 9500 4800 50  0001 C CNN
	1    9500 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9500 4750 9500 4800
Wire Wire Line
	8650 5300 8750 5300
Wire Wire Line
	8750 5300 8750 5350
Wire Wire Line
	8750 5650 8750 5700
Wire Wire Line
	8750 5700 8650 5700
Wire Wire Line
	8750 5300 9100 5300
Wire Wire Line
	9100 5300 9100 5350
Connection ~ 8750 5300
Wire Wire Line
	9100 5650 9100 5700
Wire Wire Line
	9100 5700 8750 5700
Connection ~ 8750 5700
Wire Wire Line
	9100 5700 9550 5700
Wire Wire Line
	9550 5700 9550 5750
Connection ~ 9100 5700
Wire Wire Line
	8750 5250 8750 5300
Wire Wire Line
	8650 4900 8750 4900
Wire Wire Line
	8750 4900 8750 4950
Connection ~ 9550 5700
Wire Wire Line
	6000 6350 7500 6350
Wire Wire Line
	5950 4550 7500 4550
Wire Wire Line
	9500 4400 9900 4400
Wire Wire Line
	9550 5700 9900 5700
Text Label 6300 4550 0    50   ~ 0
+15V
Text Label 6300 6350 0    50   ~ 0
-15V
$Comp
L ccd_camera:+14.5V #PWR031
U 1 1 5EFFCFA4
P 9900 4400
F 0 "#PWR031" H 9900 4250 50  0001 C CNN
F 1 "+14.5V" V 9915 4528 50  0000 L CNN
F 2 "" H 9900 4400 50  0001 C CNN
F 3 "" H 9900 4400 50  0001 C CNN
	1    9900 4400
	0    1    1    0   
$EndComp
$Comp
L ccd_camera:-14.5V #PWR032
U 1 1 5EFFD968
P 9900 5700
F 0 "#PWR032" H 9900 5550 50  0001 C CNN
F 1 "-14.5V" V 9915 5828 50  0000 L CNN
F 2 "" H 9900 5700 50  0001 C CNN
F 3 "" H 9900 5700 50  0001 C CNN
	1    9900 5700
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 5F599E7B
P 8750 5100
F 0 "R5" H 8820 5146 50  0000 L CNN
F 1 "12k 0.1%" H 8820 5055 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 8680 5100 50  0001 C CNN
F 3 "~" H 8750 5100 50  0001 C CNN
	1    8750 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	7450 5700 7500 5700
Wire Wire Line
	7500 5700 7500 6350
Connection ~ 7500 5700
Wire Wire Line
	7500 5700 7550 5700
Wire Wire Line
	7500 4550 7500 4400
Connection ~ 7500 4400
Wire Wire Line
	7500 4400 7550 4400
Wire Wire Line
	7500 4550 7500 4600
Wire Wire Line
	7500 4600 7550 4600
Connection ~ 7500 4550
Wire Wire Line
	8050 5950 8050 6000
Wire Wire Line
	8050 6000 8100 6000
Wire Wire Line
	8100 6000 8100 6050
Wire Wire Line
	8100 6000 8150 6000
Wire Wire Line
	8150 6000 8150 5950
Connection ~ 8100 6000
$Comp
L ccd_camera:TPS6513x U6
U 1 1 5F08C589
P 3300 5850
F 0 "U6" H 3300 5900 50  0000 C CNN
F 1 "TPS6513x" H 3300 5800 50  0000 C CNN
F 2 "kaf_board:TI_WQFN-24-1EP_4x4mm_P0.5mm_HandSolder" H 2000 6500 50  0001 C CNN
F 3 "" H 2000 6500 50  0001 C CNN
	1    3300 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:C C54
U 1 1 5F08DC4E
P 2000 4750
F 0 "C54" H 2115 4796 50  0000 L CNN
F 1 "4.7u" H 2115 4705 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 2038 4600 50  0001 C CNN
F 3 "~" H 2000 4750 50  0001 C CNN
F 4 "6.3V, X5R" H 2000 4750 50  0001 C CNN "Type"
	1    2000 4750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C53
U 1 1 5F08E62F
P 1800 6200
F 0 "C53" H 1915 6246 50  0000 L CNN
F 1 "4.7u" H 1915 6155 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 1838 6050 50  0001 C CNN
F 3 "~" H 1800 6200 50  0001 C CNN
F 4 "6.3V, X5R" H 1800 6200 50  0001 C CNN "Type"
	1    1800 6200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C55
U 1 1 5F08F07A
P 2200 6200
F 0 "C55" H 2315 6246 50  0000 L CNN
F 1 "0.1u" H 2315 6155 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 2238 6050 50  0001 C CNN
F 3 "~" H 2200 6200 50  0001 C CNN
F 4 "10V, X5R" H 2200 6200 50  0001 C CNN "Type"
	1    2200 6200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C56
U 1 1 5F08F881
P 4250 7000
F 0 "C56" H 4365 7046 50  0000 L CNN
F 1 "10n" H 4365 6955 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 4288 6850 50  0001 C CNN
F 3 "~" H 4250 7000 50  0001 C CNN
F 4 "16V, X7R" H 4250 7000 50  0001 C CNN "Type"
	1    4250 7000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C62
U 1 1 5F090065
P 4650 7000
F 0 "C62" H 4765 7046 50  0000 L CNN
F 1 "4.7n" H 4765 6955 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 4688 6850 50  0001 C CNN
F 3 "~" H 4650 7000 50  0001 C CNN
F 4 "50V, C0G" H 4650 7000 50  0001 C CNN "Type"
	1    4650 7000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C65
U 1 1 5F090630
P 5500 7000
F 0 "C65" H 5615 7046 50  0000 L CNN
F 1 "22u" H 5615 6955 50  0000 L CNN
F 2 "Capacitors_SMD:C_1210_HandSoldering" H 5538 6850 50  0001 C CNN
F 3 "~" H 5500 7000 50  0001 C CNN
F 4 "25V, X7R" H 5500 7000 50  0001 C CNN "Type"
	1    5500 7000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C59
U 1 1 5F090D69
P 4500 6150
F 0 "C59" H 4615 6196 50  0000 L CNN
F 1 "6.8u" H 4615 6105 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 4538 6000 50  0001 C CNN
F 3 "~" H 4500 6150 50  0001 C CNN
F 4 "25V, X7R" H 4500 6150 50  0001 C CNN "Type"
	1    4500 6150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C63
U 1 1 5F091A9C
P 4700 5750
F 0 "C63" H 4815 5796 50  0000 L CNN
F 1 "220n" H 4815 5705 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 4738 5600 50  0001 C CNN
F 3 "~" H 4700 5750 50  0001 C CNN
F 4 "6.3V, X5R" H 4700 5750 50  0001 C CNN "Type"
	1    4700 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:C C64
U 1 1 5F092089
P 5250 4800
F 0 "C64" H 5365 4846 50  0000 L CNN
F 1 "6.8u" H 5365 4755 50  0000 L CNN
F 2 "Capacitors_SMD:C_1206_HandSoldering" H 5288 4650 50  0001 C CNN
F 3 "~" H 5250 4800 50  0001 C CNN
F 4 "25V, X7R" H 5250 4800 50  0001 C CNN "Type"
	1    5250 4800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C66
U 1 1 5F092663
P 5650 4800
F 0 "C66" H 5765 4846 50  0000 L CNN
F 1 "22u" H 5765 4755 50  0000 L CNN
F 2 "Capacitors_SMD:C_1210_HandSoldering" H 5688 4650 50  0001 C CNN
F 3 "~" H 5650 4800 50  0001 C CNN
F 4 "25V, X7R" H 5650 4800 50  0001 C CNN "Type"
	1    5650 4800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R10
U 1 1 5F0A9BAA
P 2000 5950
F 0 "R10" V 1793 5950 50  0000 C CNN
F 1 "100" V 1884 5950 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 1930 5950 50  0001 C CNN
F 3 "~" H 2000 5950 50  0001 C CNN
	1    2000 5950
	0    1    1    0   
$EndComp
$Comp
L Device:R R11
U 1 1 5F0AA91F
P 4150 5750
F 0 "R11" H 4080 5704 50  0000 R CNN
F 1 "104.8k" H 4080 5795 50  0000 R CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4080 5750 50  0001 C CNN
F 3 "~" H 4150 5750 50  0001 C CNN
	1    4150 5750
	-1   0    0    1   
$EndComp
$Comp
L Device:R R45
U 1 1 5F0AB1F0
P 4150 6150
F 0 "R45" H 4080 6104 50  0000 R CNN
F 1 "1.3M" H 4080 6195 50  0000 R CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4080 6150 50  0001 C CNN
F 3 "~" H 4150 6150 50  0001 C CNN
	1    4150 6150
	-1   0    0    1   
$EndComp
$Comp
L Device:R R46
U 1 1 5F0AB609
P 4850 4800
F 0 "R46" H 4780 4754 50  0000 R CNN
F 1 "975k" H 4780 4845 50  0000 R CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4780 4800 50  0001 C CNN
F 3 "~" H 4850 4800 50  0001 C CNN
	1    4850 4800
	-1   0    0    1   
$EndComp
$Comp
L Device:R R47
U 1 1 5F0ABE50
P 4850 5250
F 0 "R47" H 4780 5204 50  0000 R CNN
F 1 "85.8k" H 4780 5295 50  0000 R CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4780 5250 50  0001 C CNN
F 3 "~" H 4850 5250 50  0001 C CNN
	1    4850 5250
	-1   0    0    1   
$EndComp
$Comp
L Device:D_Schottky D6
U 1 1 5F0AE2F7
P 3250 4550
F 0 "D6" H 3250 4333 50  0000 C CNN
F 1 "MBRM120" H 3250 4424 50  0000 C CNN
F 2 "Diodes_SMD:D_Powermite_AK" H 3250 4550 50  0001 C CNN
F 3 "~" H 3250 4550 50  0001 C CNN
	1    3250 4550
	-1   0    0    1   
$EndComp
$Comp
L Device:L L5
U 1 1 5F0AFFFA
P 2350 4550
F 0 "L5" V 2169 4550 50  0000 C CNN
F 1 "4.7u" V 2260 4550 50  0000 C CNN
F 2 "kaf_board:L_SMT_B82462G4" H 2350 4550 50  0001 C CNN
F 3 "~" H 2350 4550 50  0001 C CNN
F 4 "B82462-G4472" V 2350 4550 50  0001 C CNN "Type"
	1    2350 4550
	0    1    1    0   
$EndComp
$Comp
L power:+6V #PWR033
U 1 1 5F0B73FE
P 1050 4550
F 0 "#PWR033" H 1050 4400 50  0001 C CNN
F 1 "+6V" H 1065 4723 50  0000 C CNN
F 2 "" H 1050 4550 50  0001 C CNN
F 3 "" H 1050 4550 50  0001 C CNN
	1    1050 4550
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR036
U 1 1 5F0E1BA4
P 3300 7150
F 0 "#PWR036" H 3300 6900 50  0001 C CNN
F 1 "GND" H 3150 7100 50  0000 C CNN
F 2 "" H 3300 7150 50  0001 C CNN
F 3 "" H 3300 7150 50  0001 C CNN
	1    3300 7150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR037
U 1 1 5F0E7B36
P 4250 7300
F 0 "#PWR037" H 4250 7050 50  0001 C CNN
F 1 "GND" H 4100 7250 50  0000 C CNN
F 2 "" H 4250 7300 50  0001 C CNN
F 3 "" H 4250 7300 50  0001 C CNN
	1    4250 7300
	1    0    0    -1  
$EndComp
$Comp
L Device:L L10
U 1 1 5F0EF50B
P 5000 7000
F 0 "L10" H 4957 6954 50  0000 R CNN
F 1 "4.7u" H 4957 7045 50  0000 R CNN
F 2 "kaf_board:L_SMT_B82462G4" H 5000 7000 50  0001 C CNN
F 3 "~" H 5000 7000 50  0001 C CNN
F 4 "B82462-G4472" H 5000 7000 50  0001 C CNN "Type"
	1    5000 7000
	-1   0    0    1   
$EndComp
$Comp
L Device:D_Schottky D7
U 1 1 5F0F0712
P 5250 6600
F 0 "D7" H 5250 6817 50  0000 C CNN
F 1 "MBRM120" H 5250 6726 50  0000 C CNN
F 2 "Diodes_SMD:D_Powermite_AK" H 5250 6600 50  0001 C CNN
F 3 "~" H 5250 6600 50  0001 C CNN
	1    5250 6600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR034
U 1 1 5F10D65A
P 1800 6450
F 0 "#PWR034" H 1800 6200 50  0001 C CNN
F 1 "GND" H 1650 6400 50  0000 C CNN
F 2 "" H 1800 6450 50  0001 C CNN
F 3 "" H 1800 6450 50  0001 C CNN
	1    1800 6450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR035
U 1 1 5F10DEF1
P 2000 4950
F 0 "#PWR035" H 2000 4700 50  0001 C CNN
F 1 "GND" H 1850 4900 50  0000 C CNN
F 2 "" H 2000 4950 50  0001 C CNN
F 3 "" H 2000 4950 50  0001 C CNN
	1    2000 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1300 4550 1250 4550
Wire Wire Line
	2000 4900 2000 4950
Wire Wire Line
	1700 4550 2000 4550
Wire Wire Line
	2000 4550 2000 4600
Wire Wire Line
	2000 4550 2200 4550
Connection ~ 2000 4550
Wire Wire Line
	2500 4550 2550 4550
Wire Wire Line
	2600 5050 2550 5050
Wire Wire Line
	2550 5050 2550 4550
Connection ~ 2550 4550
Wire Wire Line
	2550 4550 3100 4550
Wire Wire Line
	3400 4550 4050 4550
Wire Wire Line
	4050 4550 4050 5050
Wire Wire Line
	4050 5050 4000 5050
Wire Wire Line
	1250 4550 1250 5700
Wire Wire Line
	1250 5700 2550 5700
Connection ~ 1250 4550
Wire Wire Line
	1250 4550 1050 4550
Wire Wire Line
	2600 5800 2550 5800
Wire Wire Line
	2550 5800 2550 5700
Connection ~ 2550 5700
Wire Wire Line
	2550 5700 2600 5700
Wire Wire Line
	2600 5250 1500 5250
Wire Wire Line
	1500 4850 1500 5250
Wire Wire Line
	2600 5150 2550 5150
Wire Wire Line
	2550 5150 2550 5050
Connection ~ 2550 5050
Wire Wire Line
	2600 5950 2550 5950
Wire Wire Line
	1850 5950 1800 5950
Wire Wire Line
	1250 5950 1250 5700
Connection ~ 1250 5700
Wire Wire Line
	1800 6050 1800 5950
Connection ~ 1800 5950
Wire Wire Line
	1800 5950 1250 5950
Wire Wire Line
	2200 6050 2200 5950
Connection ~ 2200 5950
Wire Wire Line
	2200 5950 2150 5950
Wire Wire Line
	1800 6350 1800 6400
Wire Wire Line
	1800 6400 2200 6400
Wire Wire Line
	2200 6400 2200 6350
Wire Wire Line
	1800 6400 1800 6450
Connection ~ 1800 6400
Wire Wire Line
	2600 6750 2550 6750
Wire Wire Line
	2550 6750 2550 6650
Connection ~ 2550 5950
Wire Wire Line
	2550 5950 2200 5950
Wire Wire Line
	2600 6450 2550 6450
Connection ~ 2550 6450
Wire Wire Line
	2550 6450 2550 5950
Wire Wire Line
	2550 6550 2600 6550
Connection ~ 2550 6550
Wire Wire Line
	2550 6550 2550 6450
Wire Wire Line
	2600 6650 2550 6650
Connection ~ 2550 6650
Wire Wire Line
	2550 6650 2550 6550
Wire Wire Line
	3150 7100 3300 7100
Wire Wire Line
	3300 7100 3300 7050
Wire Wire Line
	3150 7050 3150 7100
Wire Wire Line
	3400 7050 3400 7100
Wire Wire Line
	3400 7100 3300 7100
Connection ~ 3300 7100
Wire Wire Line
	3300 7100 3300 7150
Wire Wire Line
	4850 5100 4850 5050
Wire Wire Line
	4850 5050 5250 5050
Wire Wire Line
	5250 5050 5250 4950
Connection ~ 4850 5050
Wire Wire Line
	4850 5050 4850 4950
Wire Wire Line
	4050 4550 4850 4550
Wire Wire Line
	5250 4550 5250 4650
Connection ~ 4050 4550
Wire Wire Line
	4850 4550 4850 4650
Connection ~ 4850 4550
Wire Wire Line
	4850 4550 5250 4550
Wire Wire Line
	5250 4550 5650 4550
Wire Wire Line
	5650 4550 5650 4650
Connection ~ 5250 4550
$Comp
L power:GND #PWR040
U 1 1 5F274FA1
P 5650 5000
F 0 "#PWR040" H 5650 4750 50  0001 C CNN
F 1 "GND" H 5500 4950 50  0000 C CNN
F 2 "" H 5650 5000 50  0001 C CNN
F 3 "" H 5650 5000 50  0001 C CNN
	1    5650 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4950 5650 5000
Wire Wire Line
	5650 4550 5950 4550
Connection ~ 5650 4550
Wire Wire Line
	4000 5550 4150 5550
Wire Wire Line
	4150 5550 4150 5600
Wire Wire Line
	4150 5550 4700 5550
Wire Wire Line
	4700 5550 4700 5600
Connection ~ 4150 5550
$Comp
L power:GND #PWR038
U 1 1 5F2A73C8
P 4700 5950
F 0 "#PWR038" H 4700 5700 50  0001 C CNN
F 1 "GND" H 4850 5900 50  0000 C CNN
F 2 "" H 4700 5950 50  0001 C CNN
F 3 "" H 4700 5950 50  0001 C CNN
	1    4700 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 5900 4700 5950
$Comp
L power:GND #PWR039
U 1 1 5F2B4216
P 4850 5500
F 0 "#PWR039" H 4850 5250 50  0001 C CNN
F 1 "GND" H 5000 5450 50  0000 C CNN
F 2 "" H 4850 5500 50  0001 C CNN
F 3 "" H 4850 5500 50  0001 C CNN
	1    4850 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 5950 4150 5950
Wire Wire Line
	4150 5950 4150 5900
Wire Wire Line
	4150 5950 4150 6000
Connection ~ 4150 5950
Wire Wire Line
	4000 6350 4150 6350
Wire Wire Line
	4150 6350 4150 6300
Wire Wire Line
	4150 6350 4500 6350
Wire Wire Line
	4500 6350 4500 6300
Connection ~ 4150 6350
Wire Wire Line
	4150 5950 4500 5950
Wire Wire Line
	4500 5950 4500 6000
Wire Wire Line
	4500 6350 5500 6350
Connection ~ 4500 6350
Wire Wire Line
	4000 6450 4050 6450
Wire Wire Line
	5000 6450 5000 6600
Wire Wire Line
	5000 6600 5100 6600
Wire Wire Line
	5000 6600 5000 6850
Connection ~ 5000 6600
Wire Wire Line
	5400 6600 5500 6600
Wire Wire Line
	5500 6600 5500 6350
Connection ~ 5500 6350
Wire Wire Line
	5500 6350 6000 6350
Wire Wire Line
	5500 6850 5500 6600
Connection ~ 5500 6600
Wire Wire Line
	4000 6750 4250 6750
Wire Wire Line
	4250 6750 4250 6850
Wire Wire Line
	4250 7150 4250 7200
Wire Wire Line
	4250 7200 4650 7200
Wire Wire Line
	4650 7200 4650 7150
Connection ~ 4250 7200
Wire Wire Line
	4250 7200 4250 7300
Wire Wire Line
	4650 7200 5000 7200
Wire Wire Line
	5000 7200 5000 7150
Connection ~ 4650 7200
Wire Wire Line
	5000 7200 5500 7200
Wire Wire Line
	5500 7200 5500 7150
Connection ~ 5000 7200
Wire Wire Line
	4000 6550 4050 6550
Wire Wire Line
	4050 6550 4050 6450
Connection ~ 4050 6450
Wire Wire Line
	4050 6450 5000 6450
Wire Wire Line
	4000 6650 4650 6650
Wire Wire Line
	4650 6650 4650 6850
Connection ~ 5950 4550
Connection ~ 6000 6350
Wire Wire Line
	3400 7100 3500 7100
Wire Wire Line
	3500 7100 3500 7050
Connection ~ 3400 7100
Wire Wire Line
	4850 5400 4850 5500
Wire Wire Line
	4000 5450 4600 5450
Wire Wire Line
	4600 5450 4600 5050
Wire Wire Line
	4600 5050 4850 5050
$Comp
L Device:Q_PMOS_GSD Q4
U 1 1 5F0B3430
P 1500 4650
F 0 "Q4" V 1842 4650 50  0000 C CNN
F 1 "Si2323DS" V 1751 4650 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 1700 4750 50  0001 C CNN
F 3 "~" H 1500 4650 50  0001 C CNN
	1    1500 4650
	0    1    -1   0   
$EndComp
$EndSCHEMATC
