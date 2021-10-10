library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity UART is
port(
	--input
	rxd, reset, clk, txvalid	: in std_logic;
	txdata				: in std_logic_vector(7 downto 0);
	--output
	rxdata					: out std_logic_vector(7 downto 0);
	rxvalid, txd					: out std_logic
);
end;

architecture arch of UART is
signal clk_baud_signal	: std_logic;
begin
	u1: Baud_Rate_Generator(arch) port map(
	clk_baud => clk_baud_signal,
	reset 	=> reset,
	clk 		=> clk
	);
	
	u2: UART_receiver(arch) port map(
	reset		=> reset,
	rxd		=> rxd,
	rxdata	=> rxdata,
	rxvalid	=> rxvalid,
	clk_baud	=> clk_baud_signal
	);
	
	u3: UART_transmitter(arch) port map(
	reset		=> reset,
	txvalid	=> txvalid,
	txdata	=> txdata,
	txd		=> txd,
	clk_baud	=> clk_baud_signal
	);	
end;
