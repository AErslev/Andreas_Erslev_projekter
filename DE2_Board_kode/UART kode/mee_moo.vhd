library ieee;
use ieee.std_logic_1164.all;

entity mee_moo is
port(
	--input
	inp 		: in std_logic_vector(1 downto 0);
	reset, clk
				: in std_logic;
	--output
	moo_out, mee_out
				: out std_logic
);
end;

architecture arch of mee_moo is 
type state is (idle, init, active1);
signal next_state, present_state
				: state;
begin
	state_reg: process(clk, reset)
	begin
		if reset = '0' then
			present_state <= idle;
		elsif rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process;
	
	nxt_state: process(present_state, inp)
	begin
	next_state <= present_state; --default
	case present_state is
		when idle => 
			if inp(1) = '1' then
				next_state <= init;
			end if;
		when init => 
			if inp = "01" then
				next_state <= active1;
			elsif inp = "00" then
				next_state <= idle;
			end if;
		when active1 =>
			next_state <= idle;
	end case;
	end process;
	
	moore_out: process(present_state)
	begin
	case present_state is
		when idle =>
			moo_out <= '0';
		when init | active1=>
			moo_out <= '1';
	end case;
	end process;
	
	mealy_out: process(present_state)
	begin
	case present_state is
		when idle =>
			mee_out <= '0';
		when init =>
			if inp = "11" then
				mee_out <= '1';
			else
				mee_out <= '0';
			end if;
		when active1 =>
			mee_out <= '0';
	end case;
	end process;	
end;
