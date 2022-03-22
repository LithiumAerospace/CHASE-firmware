library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceWireCODECIPPackage.all;
use work.SpaceWireRouterIPPackage.all;

entity Tester is
  port (
  clock : in std_logic;
  transmitClock : in std_logic;
  receiveClock : in std_logic;
  reset : in std_logic
  );
end Tester;

architecture Behavioral of Tester is

  component SpaceWireCODECIP is

      port (
          -- Clock & Reset.
          clock                       : in  std_logic;
          transmitClock               : in  std_logic;
          receiveClock                : in  std_logic;
          reset                       : in  std_logic;
          -- SpaceWire Buffer Status/Control.
          transmitFIFOWriteEnable     : in  std_logic;
          transmitFIFODataIn          : in  std_logic_vector (8 downto 0);
          transmitFIFOFull            : out std_logic;
          transmitFIFODataCount       : out unsigned (5 downto 0);
          receiveFIFOReadEnable       : in  std_logic;
          receiveFIFODataOut          : out std_logic_vector (8 downto 0);
          receiveFIFOFull             : out std_logic;
          receiveFIFOEmpty            : out std_logic;
          receiveFIFODataCount        : out unsigned (5 downto 0);
          -- TimeCode.
          tickIn                      : in  std_logic;
          timeIn                      : in  std_logic_vector (5 downto 0);
          controlFlagsIn              : in  std_logic_vector (1 downto 0);
          tickOut                     : out std_logic;
          timeOut                     : out std_logic_vector (5 downto 0);
          controlFlagsOut             : out std_logic_vector (1 downto 0);
          -- Link Status/Control.
          linkStart                   : in  std_logic;
          linkDisable                 : in  std_logic;
          autoStart                   : in  std_logic;
          linkStatus                  : out std_logic_vector (15 downto 0);
          errorStatus                 : out std_logic_vector (7 downto 0);
          transmitClockDivideValue    : in  unsigned (5 downto 0);
          creditCount                 : out unsigned (5 downto 0);
          outstandingCount            : out unsigned (5 downto 0);
          -- LED.
          transmitActivity            : out std_logic;
          receiveActivity             : out std_logic;
          -- SpaceWire Data-Strobe.
          spaceWireDataOut            : out std_logic;
          spaceWireStrobeOut          : out std_logic;
          spaceWireDataIn             : in  std_logic;
          spaceWireStrobeIn           : in  std_logic;
          -- Statistics.
          statisticalInformationClear : in  std_logic;
          statisticalInformation      : out bit32X8Array
          );
  end component;

  component SpaceWireRouterIP is
      generic (
          gNumberOfInternalPort : integer := cNumberOfInternalPort
          );
      port (
          clock                       : in  std_logic;
          transmitClock               : in  std_logic;
          receiveClock                : in  std_logic;
          reset                       : in  std_logic;
          -- SpaceWire Signals.
          -- Port1.
          spaceWireDataIn1            : in  std_logic;
          spaceWireStrobeIn1          : in  std_logic;
          spaceWireDataOut1           : out std_logic;
          spaceWireStrobeOut1         : out std_logic;
          -- Port2.
          spaceWireDataIn2            : in  std_logic;
          spaceWireStrobeIn2          : in  std_logic;
          spaceWireDataOut2           : out std_logic;
          spaceWireStrobeOut2         : out std_logic;
          -- Port3.
          spaceWireDataIn3            : in  std_logic;
          spaceWireStrobeIn3          : in  std_logic;
          spaceWireDataOut3           : out std_logic;
          spaceWireStrobeOut3         : out std_logic;
          -- Port4.
          spaceWireDataIn4            : in  std_logic;
          spaceWireStrobeIn4          : in  std_logic;
          spaceWireDataOut4           : out std_logic;
          spaceWireStrobeOut4         : out std_logic;
          -- Port5.
          spaceWireDataIn5            : in  std_logic;
          spaceWireStrobeIn5          : in  std_logic;
          spaceWireDataOut5           : out std_logic;
          spaceWireStrobeOut5         : out std_logic;
          -- Port6.
          spaceWireDataIn6            : in  std_logic;
          spaceWireStrobeIn6          : in  std_logic;
          spaceWireDataOut6           : out std_logic;
          spaceWireStrobeOut6         : out std_logic;
          --
          statisticalInformationPort1 : out bit32X8Array;
          statisticalInformationPort2 : out bit32X8Array;
          statisticalInformationPort3 : out bit32X8Array;
          statisticalInformationPort4 : out bit32X8Array;
          statisticalInformationPort5 : out bit32X8Array;
          statisticalInformationPort6 : out bit32X8Array;
          --
          oneShotStatusPort1          : out std_logic_vector(7 downto 0);
          oneShotStatusPort2          : out std_logic_vector(7 downto 0);
          oneShotStatusPort3          : out std_logic_vector(7 downto 0);
          oneShotStatusPort4          : out std_logic_vector(7 downto 0);
          oneShotStatusPort5          : out std_logic_vector(7 downto 0);
          oneShotStatusPort6          : out std_logic_vector(7 downto 0);

          busMasterUserAddressIn      : in  std_logic_vector (31 downto 0);
          busMasterUserDataOut        : out std_logic_vector (31 downto 0);
          busMasterUserDataIn         : in  std_logic_vector (31 downto 0);
          busMasterUserWriteEnableIn  : in  std_logic;
          busMasterUserByteEnableIn   : in  std_logic_vector (3 downto 0);
          busMasterUserStrobeIn       : in  std_logic;
          busMasterUserRequestIn      : in  std_logic;
          busMasterUserAcknowledgeOut : out std_logic
          );
  end component;

  signal transmitFIFODataIn          : std_logic_vector (8 downto 0);

  signal tickIn                      : std_logic;
  signal timeIn                      : std_logic_vector (5 downto 0);
  signal controlFlagsIn              : std_logic_vector (1 downto 0);

  signal interfaceToRouterData1      : std_logic;
  signal interfaceToRouterStrobe1    : std_logic;
  signal routerToInterfaceData1      : std_logic;
  signal routerToInterfaceStrobe1    : std_logic;

  signal interfaceToRouterData2      : std_logic;
  signal interfaceToRouterStrobe2    : std_logic;
  signal routerToInterfaceData2      : std_logic;
  signal routerToInterfaceStrobe2    : std_logic;

  signal interfaceToRouterData3      : std_logic;
  signal interfaceToRouterStrobe3    : std_logic;
  signal routerToInterfaceData3      : std_logic;
  signal routerToInterfaceStrobe3    : std_logic;

  signal interfaceToRouterData4      : std_logic;
  signal interfaceToRouterStrobe4    : std_logic;
  signal routerToInterfaceData4      : std_logic;
  signal routerToInterfaceStrobe4    : std_logic;

  signal interfaceToRouterData5      : std_logic;
  signal interfaceToRouterStrobe5    : std_logic;
  signal routerToInterfaceData5      : std_logic;
  signal routerToInterfaceStrobe5    : std_logic;

  signal interfaceToRouterData6      : std_logic;
  signal interfaceToRouterStrobe6    : std_logic;
  signal routerToInterfaceData6      : std_logic;
  signal routerToInterfaceStrobe6    : std_logic;

  signal busMasterUserAddressIn      : std_logic_vector (31 downto 0);
  signal busMasterUserDataIn         : std_logic_vector (31 downto 0);
  signal busMasterUserWriteEnableIn  : std_logic;
  signal busMasterUserByteEnableIn   : std_logic_vector (3 downto 0);
  signal busMasterUserStrobeIn       : std_logic;
  signal busMasterUserRequestIn      : std_logic;

  signal linkStatus : std_logic_vector (15 downto 0);
  signal errorStatus : std_logic_vector (7 downto 0);

  signal transmitFIFOWriteEnable : std_logic;

  signal tx : std_logic;

begin

  tx <= linkStatus(8);

  interface : SpaceWireCODECIP
    port map (
      clock => clock,
      transmitClock => transmitClock,
      receiveClock => receiveClock,
      reset => reset,
      transmitFIFOWriteEnable => transmitFIFOWriteEnable,
      receiveFIFOReadEnable => '1',
      transmitFIFODataIn => transmitFIFODataIn,
      tickIn => tickIn,
      timeIn => timeIn,
      controlFlagsIn => controlFlagsIn,
      linkStart => '0',
      linkDisable => '0',
      autoStart => '1',
      transmitClockDivideValue => "001001",
      spaceWireDataIn    => routerToInterfaceData1,
      spaceWireStrobeIn  => routerToInterfaceStrobe1,
      spaceWireDataOut   => interfaceToRouterData1,
      spaceWireStrobeOut => interfaceToRouterStrobe1,
      statisticalInformationClear => '0',
      linkStatus => linkStatus,
      errorStatus => errorStatus
    );

  router : SpaceWireRouterIP
    port map (
      clock => clock,
      transmitClock => transmitClock,
      receiveClock => receiveClock,
      reset => reset,
      spaceWireDataIn1    =>  interfaceToRouterData1,
      spaceWireStrobeIn1  =>  interfaceToRouterStrobe1,
      spaceWireDataOut1   =>  routerToInterfaceData1,
      spaceWireStrobeOut1 =>  routerToInterfaceStrobe1,
      spaceWireDataIn2    =>  interfaceToRouterData2,
      spaceWireStrobeIn2  =>  interfaceToRouterStrobe2,
      spaceWireDataOut2   =>  routerToInterfaceData2,
      spaceWireStrobeOut2 =>  routerToInterfaceStrobe2,
      spaceWireDataIn3    =>  interfaceToRouterData3,
      spaceWireStrobeIn3  =>  interfaceToRouterStrobe3,
      spaceWireDataOut3   =>  routerToInterfaceData3,
      spaceWireStrobeOut3 =>  routerToInterfaceStrobe3,
      spaceWireDataIn4    =>  interfaceToRouterData4,
      spaceWireStrobeIn4  =>  interfaceToRouterStrobe4,
      spaceWireDataOut4   =>  routerToInterfaceData4,
      spaceWireStrobeOut4 =>  routerToInterfaceStrobe4,
      spaceWireDataIn5    =>  interfaceToRouterData5,
      spaceWireStrobeIn5  =>  interfaceToRouterStrobe5,
      spaceWireDataOut5   =>  routerToInterfaceData5,
      spaceWireStrobeOut5 =>  routerToInterfaceStrobe5,
      spaceWireDataIn6    =>  interfaceToRouterData6,
      spaceWireStrobeIn6  =>  interfaceToRouterStrobe6,
      spaceWireDataOut6   =>  routerToInterfaceData6,
      spaceWireStrobeOut6 =>  routerToInterfaceStrobe6,
      busMasterUserAddressIn => busMasterUserAddressIn,
      busMasterUserDataIn => busMasterUserDataIn,
      busMasterUserWriteEnableIn => busMasterUserWriteEnableIn,
      busMasterUserByteEnableIn => busMasterUserByteEnableIn,
      busMasterUserStrobeIn => busMasterUserStrobeIn,
      busMasterUserRequestIn => busMasterUserRequestIn
    );

end architecture;
