set terminal postscript eps monochrome enhanced dashed
set output "thermistor_voltage.eps"
set nokey
set xtics font ",16"
set ytics font ",16"
set xlabel font ",16"
set ylabel font ",16"
set xlabel 'Temperature (C)'
set ylabel 'Voltage (V)'
set xrange [-50:40]
set grid

V0   = 3.3
R25  = 2000
beta = 3450
Rref = 2200
T25  = 298.15
T0  = 273.15

R(x) = R25*exp(beta*(1/x - 1/T25))
U(x) = V0*R(x + T0)/(Rref + R(x + T0))

plot U(x) title 'U_NTC(T)' with lines
