library ieee;
use ieee.std_logic_1164.all;

entity Baud_Rate_Generator is
generic(
	scale	: natural := 434;
	MIN_CLK_VAL	: natural := 0;
	MAX_CLK_VAL	: natural := 50000000;
	baud			: natural := 434 --BAUD-Rate paa ~115200 Hz
);
	port(
	reset, clk	: in std_logic;
	clk_baud		: out std_logic
);
end;

architecture arch of Baud_Rate_Generator is
begin
	counting : process(clk, reset)
	variable clk_counter : integer range MIN_CLK_VAL to MAX_CLK_VAL;
	variable clear			: std_logic;
	begin
		if reset = '0' or clear = '1' then
			clk_counter := 0;
		elsif rising_edge(clk) then
			clk_counter := clk_counter + 1;
		end if;
		
		if clk_counter = baud then
			clk_baud <= '1';
			clear := '1';
		else
			clk_baud <= '0';
			clear := '0';
		end if;
	end process counting;
end;