SIM ?= GHDL
TOPLEVEL_LANG ?=vhdl
SIM_ARGS ?= --wave=results.ghw
COMPILE_ARGS = --std=08 -frelaxed

include ../sources.mk

DIR = ../

VHDL_SOURCES += $(SOURCES) LinkTest.vhdl

TOPLEVEL = tester

MODULE = router_test

include $(shell cocotb-config --makefiles)/Makefile.sim
