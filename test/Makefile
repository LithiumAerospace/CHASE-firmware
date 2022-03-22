SIM ?= GHDL
TOPLEVEL_LANG ?=vhdl
SIM_ARGS ?= --vcd=results.vhd

include ../sources.mk

DIR = ../

VHDL_SOURCES += $(SOURCES) LinkTest.vhdl

TOPLEVEL = tester

MODULE = router_test

include $(shell cocotb-config --makefiles)/Makefile.sim
