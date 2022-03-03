TOP=top
PIN_DEF=ice40hx1k-evb.pcf
DEVICE=hx1k
TARGET_FREQ_MHz=70
PRE_PACK_FILE=nextpnr_clock_constraints.py
PACKAGE=vq100
SIM_DIR=vcd
INC_DIR=include
MOD_DIR=module

MODULES = $(addprefix $(MOD_DIR)/, fifo.v ad9826_config.v mcp3008_interface.v tx_mux.v ccd_readout.v pwm.v ft245.v)
TESTBENCHES = $(wildcard testbench/*.v)

all: $(TOP).bin $(TOP).rpt

$(SIM_DIR)/$(TOP)_tb: testbench/$(TOP)_tb.v $(TOP).v | $(SIM_DIR)
	iverilog -I$(INC_DIR) -I$(MOD_DIR) -o $@ $^

$(TOP)_tb.vcd: $(SIM_DIR)/$(TOP)_tb $(MODULES) | $(SIM_DIR)
	vvp -N $< +vcd=$@
	mv -v $@ vcd

tx_tb.vcd: $(SIM_DIR)/tx_tb $(MODULES) | $(SIM_DIR)
	vvp -N $< +vcd=$@
	mv -v $@ vcd
$(SIM_DIR)/tx_tb: testbench/tx_tb.v $(TOP).v | $(SIM_DIR)
	iverilog -I$(INC_DIR) -I$(MOD_DIR) -o $@ $^

%.json: %.v $(MODULES)
	yosys $(TOP).ys

%.asc: %.json
	nextpnr-ice40 --package $(PACKAGE) --$(DEVICE) --json $^ --pcf $(PIN_DEF) --asc $@ --freq $(TARGET_FREQ_MHz) --timing-allow-fail --pre-pack $(PRE_PACK_FILE)

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

sim: $(TOP)_tb.vcd

$(SIM_DIR): 
	mkdir -p $(SIM_DIR)

$(SIM_DIR)/%_tb: testbench/%_tb.v $(MOD_DIR)/%.v | $(SIM_DIR)
	iverilog -I$(INC_DIR) -I$(MOD_DIR) -o $@ $^

%_tb.vcd: %_tb | $(SIM_DIR)
	vvp -N $< +vcd=$@
	mv -v $(notdir $@) $(SIM_DIR)

sim_modules: $(addprefix $(SIM_DIR)/, $(notdir $(MODULES:.v=_tb.vcd)))

clean:
	rm -rf $(SIM_DIR) *.json *.asc *.bin *.rpt

synthesize: $(TOP).json
place_and_route: $(TOP).asc
pack: $(TOP).bin
timing: $(TOP).rpt

.PHONY: all prog clean sim simclean sim_modules synthesize place_and_route pack timing

# prog: $(TOP).bin
# 	sudo iceprogduino $<

# sudo-prog: $(TOP).bin
# 	@echo 'Executing prog as root!!!'
# 	sudo iceprogduino $<

# Detailed timing estimate:
# yosys breadboard_tests.ys
# arachne-pnr -d 1k -P vq100 -o breadboard_tests.asc -p ice40hx1k-evb.pcf breadboard_tests.blif
# icetime -mt -p ice40hx1k-evb.pcf -P vq100 -d hx1k breadboard_tests.asc
