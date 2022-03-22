GHDL=ghdl
GHDLFLAGS=
include sources.mk

all: $(SOURCES:.vhdl=.o)

%.o: %.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
