library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity mee_moo is
port (inp: in std_logic_vector(1 downto 0);
		reset, clk: in std_logic;
		moo_out, mee_out: out std_logic);
end mee_moo;

architecture mee_moo_arch of mee_moo is
type state is(idle, init, a);
signal present_state, next_state: state;

begin
	state_reg: process(clk, reset)
	begin
		if reset = '0' then
			present_state <= idle;
			
		elsif rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process;
	
	next_state_pro: process(present_state, inp)
	begin
		next_state <= present_state;
		case present_state is
			when idle =>
				if inp(1) = '1' then
					next_state <= init;
				end if;
				
			when init =>
				if inp = "00" then 
					next_state <= idle;
				elsif inp = "01" then
					next_state <= a;
				end if;
				
			when others =>
				next_state <= idle;
		end case;
	end process;
	
	output_mee: process(present_state, inp)
	begin
		case present_state is
		
			when idle =>
				moo_out <= '0';
				mee_out <= '0';
				
			when init =>
				moo_out <= '1';
				
				if inp = "11" then
					mee_out <= '1';
				else
					mee_out <= '0';
				end if;
				
			when a =>
				moo_out <= '1';
				mee_out <= '0';
				
			end case;

	end process;
end mee_moo_arch; 