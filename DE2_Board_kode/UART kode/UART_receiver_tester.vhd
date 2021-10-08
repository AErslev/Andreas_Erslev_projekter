library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity UART_receiver_tester is
port(
	--input
	KEY	: in std_logic_vector(2 downto 0);
	--output
	LEDR	: out std_logic_vector(7 downto 0);
	LEDG	: out std_logic_vector(7 downto 7)
);
end;

architecture arch of UART_receiver_tester is 
begin
	u1:entity UART_receiver(arch) port map(
	rxd => KEY(0), reset => KEY(1), clk_baud => KEY(2),
	rxdata => LEDR, rxvalid => LEDG(7)
	);
end;
