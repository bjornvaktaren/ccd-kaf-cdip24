TOP = top
PIN_DEF = ice40hx1k-evb.pcf
DEVICE = hx1k
SIM_DIR=vcd
INC_DIR=include
MOD_DIR=module

MODULES = $(addprefix $(MOD_DIR)/, ad9826_config.v mcp3008_interface.v tx_mux.v ccd_readout.v pwm.v ft245.v fifo.v)
TESTBENCHES = $(wildcard testbench/*.v)

all: $(TOP).rpt $(TOP).bin

$(SIM_DIR)/$(TOP)_tb: testbench/$(TOP)_tb.v $(TOP).v | $(SIM_DIR)
	iverilog -I$(INC_DIR) -I$(MOD_DIR) -o $@ $^

$(TOP)_tb.vcd: $(SIM_DIR)/$(TOP)_tb $(MODULES) | $(SIM_DIR)
	vvp -N $< +vcd=$@
	mv -v $@ vcd

%.blif: %.v $(MODULES)
	yosys $(TOP).ys

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -r -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

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
	rm -rf $(SIM_DIR) *.blif *.asc *.bin *.rpt

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
