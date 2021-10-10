library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity mee_moo_test is
port (SW: in std_logic_vector (1 downto 0);
		KEY: in std_logic_vector (1 downto 0);
		LEDR: out std_logic_vector(1 downto 0));
end mee_moo_test;

architecture mee_moo_test_arch of mee_moo_test is

begin

	i1: entity mee_moo port map 
	(
		inp => SW,
		reset => KEY(0),
		clk => KEY(1),
		moo_out => LEDR(0),
		mee_out => LEDR(1)
	);

end mee_moo_test_arch;