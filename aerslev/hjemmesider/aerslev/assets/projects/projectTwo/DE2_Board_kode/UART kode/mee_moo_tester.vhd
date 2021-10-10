library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity mee_moo_tester is
port(
	--input
	KEY	: in std_logic_vector(1 downto 0);
	SW 	: in std_logic_vector(1 downto 0);
	--output
	LEDR	: out std_logic_vector(1 downto 0)
);
end;

architecture arch of mee_moo_tester is 
begin
	u1:entity mee_moo(arch) port map(
	clk => KEY(0), reset => KEY(1),
	inp(0) => SW(0), inp(1) => SW(1),
	moo_out => LEDR(0), mee_out => LEDR(1)
	);
end;
