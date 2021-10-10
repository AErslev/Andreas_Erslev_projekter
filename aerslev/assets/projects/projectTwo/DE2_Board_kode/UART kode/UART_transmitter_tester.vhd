library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity UART_transmitter_tester is
port(
	--input
	KEY	: in std_logic_vector(2 downto 0);
	SW 	: in std_logic_vector(7 downto 0);
	--output
	LEDR	: out std_logic_vector(0 downto 0)
);
end;

architecture arch of UART_transmitter_tester is 
begin
	u1:entity UART_transmitter(arch) port map(
	clk_baud => KEY(0), reset => KEY(1), txvalid => KEY(2),
	txdata => SW,
	txd => LEDR(0)
	);
end;
