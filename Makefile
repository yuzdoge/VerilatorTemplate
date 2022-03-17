############################################################################
# Check for sanity to avoid later confusion

# $(words string) counts the number of the words in the string. $(CURDIR) is the path of the current directory
ifneq ($(words $(CURDIR)), 1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

############################################################################
# Set up variables
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT # pass the value of VERILATOR_ROOT to the sub-make
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

# Generate C++ in executable form
VERILATOR_FLAGS += --cc --exe
# Optimize
#VERILATOR_FLAGS += -Os -x-assign 0
# Warn about lint issues; may not want this on less solid designs
VERILATOR_FLAGS += -Wall
# Make waveforms
VERILATOR_FLAGS += --trace
# Run Verialtor in debug mode
#VERILATOR_FLAGS += --debug
# Add this trace to get a backtrace in gdb
#VERILATOR_FLAGS += --gdbbt
# Input files for Verilator
VERILATOR_INPUT = our.v sim_our.cpp 
VERILATED_BIN = Vour

ABOUT = My tracing Template
WAVEFORMS = vlt_dump.vcd

############################################################################
# COMMAND

default: run

run:
	@echo
	@echo "-- $(ABOUT)"

	@echo
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)

	@echo
	@echo "-- BUILD -------------------"
	$(MAKE) -j -C obj_dir -f ../Makefile_obj

	@echo
	@echo "-- RUN ---------------------"
	@rm -rf logs
	@mkdir -p logs
	obj_dir/$(VERILATED_BIN) +trace
	
	@echo
	@echo "-- DONE --------------------"
	@echo "To see waveforms, open $(WAVEFORMS) in a waveform viewer"
	@echo
############################################################################ #Other targets
.PHONY: clean
clean:	
	-rm -rf obj_dir logs
