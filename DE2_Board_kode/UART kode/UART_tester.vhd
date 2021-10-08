library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity UART_tester is
port(
	--input
	GPIO_1	: in std_logic_vector(0 downto 0);
	GPIO_0	: out std_logic_vector(1 downto 0);
	KEY		: in std_logic_vector(1 downto 0);
	SW			: in std_logic_vector(7 downto 0);
	CLOCK_50	: in std_logic;
	--output
	LEDR		: out std_logic_vector(8 downto 0)
);
end;

architecture arch of UART_tester is 
begin
	u1: entity UART(arch) port map (
	reset => KEY(0), rxd => GPIO_1(0), txvalid => not KEY(1),
	txdata => SW,
	clk => CLOCK_50,
	rxdata => LEDR(7 downto 0), rxvalid => LEDR(8), txd => GPIO_0(0)
	);
	
	GPIO_0(1) <= '0'; 
end;
