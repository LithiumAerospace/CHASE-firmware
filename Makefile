GHDL=ghdl
GHDLFLAGS=
MODULES=\
	SpaceWireCODEC/SpaceWireCODECIPReceiverSynchronize.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPTimeCodeControl.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPFIFO9x64.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPStateMachine.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPTimer.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPPackage.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPLinkInterface.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPStatisticalInformationCount.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPTransmitter.vhdl \
	SpaceWireCODEC/SpaceWireCODECIPSynchronizeOnePulse.vhdl \
	SpaceWireCODEC/SpaceWireCODECIP.vhdl \
	SpaceWireRouter/SpaceWireRouterIPLatchedPulse.vhdl \
	SpaceWireRouter/SpaceWireRouterIPStatistics.vhdl \
  SpaceWireRouter/SpaceWireRouterIPPackage.vhdl \
	SpaceWireRouter/SpaceWireRouterIPTableArbiter7.vhdl \
	SpaceWireRouter/SpaceWireRouterIPRMAPDecoder.vhdl \
	SpaceWireRouter/SpaceWireRouterIPTimeCodeControl6.vhdl \
	SpaceWireRouter/SpaceWireRouterIPArbiter7x7.vhdl \
	SpaceWireRouter/SpaceWireRouterIPRMAPPort.vhdl \
	SpaceWireRouter/SpaceWireRouterIPTimeOutCount.vhdl \
  SpaceWireRouter/SpaceWireRouterIPConfigurationPackage.vhdl \
	SpaceWireRouter/SpaceWireRouterIPRouterControlRegister.vhdl \
	SpaceWireRouter/SpaceWireRouterIPTimeOutEEP.vhdl \
  SpaceWireRouter/SpaceWireRouterIPCreditCount.vhdl \
	SpaceWireRouter/SpaceWireRouterIPRouterRoutingTable32x256.vhdl \
	SpaceWireRouter/SpaceWireRouterIP.vhdl \
  SpaceWireRouter/SpaceWireRouterIPLatchedPulse8.vhdl \
	SpaceWireRouter/SpaceWireRouterIPSpaceWirePort.vhdl
	#Altera \
	#Xilinx \

all: $(MODULES:.vhdl=.o)

%.o: %.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
