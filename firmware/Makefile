TOP = top
MODULES = $(addprefix module/, mcp3008_interface.v tx_mux.v ccd_readout.v pwm.v ft245.v fifo.v)
TESTBENCHES = $(wildcard testbench/*.v)
PIN_DEF = ice40hx1k-evb.pcf
DEVICE = hx1k

%_tb: testbench/%_tb.v %.v
	iverilog -Iinclude -Imodule -o $@ $^

%_tb.vcd: %_tb 	$(MODULES)
	vvp -N $< +vcd=$@

%.blif: %.v $(MODULES)
	yosys $(TOP).ys

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

all: $(TOP).rpt $(TOP).bin

sim: $(TOP)_tb.vcd

module/%_tb: testbench/%_tb.v module/%.v
	iverilog -Iinclude -Imodule -o $@ $^

module/%_tb.vcd: module/%_tb
	vvp -N $< +vcd=$@

sim_modules: $(MODULES:.v=_tb.vcd)

clean:
	rm -f *.blif *.asc *.bin *.rpt *_tb.vcd *_tb

.PHONY: all prog clean sim simclean sim_modules

# prog: $(TOP).bin
# 	sudo iceprogduino $<

# sudo-prog: $(TOP).bin
# 	@echo 'Executing prog as root!!!'
# 	sudo iceprogduino $<

# Detailed timing estimate:
# yosys breadboard_tests.ys
# arachne-pnr -d 1k -P vq100 -o breadboard_tests.asc -p ice40hx1k-evb.pcf breadboard_tests.blif
# icetime -mt -p ice40hx1k-evb.pcf -P vq100 -d hx1k breadboard_tests.asc
