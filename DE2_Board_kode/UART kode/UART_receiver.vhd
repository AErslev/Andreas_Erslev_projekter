library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_receiver is
port(
	--input
	reset, rxd, clk_baud	: in std_logic;
	--output
	rxdata					: out std_logic_vector(7 downto 0);
	rxvalid					: out std_logic
);
end;

architecture arch of UART_receiver is

type state is (idle, reading, stopping, latch_data);
signal next_state, present_state
				: state;
signal latch_present		: std_logic_vector(7 downto 0);
signal latch_next			: std_logic_vector(7 downto 0);
signal bit_cnt_present	: integer range 0 to 8 ;
signal bit_cnt_next		: integer range 0 to 8;

begin
	state_reg: process(clk_baud, reset)
	begin
		if reset = '0' then
			present_state <= idle;
		elsif rising_edge(clk_baud) then
			present_state <= next_state;
			latch_present <= latch_next;
			bit_cnt_present <= bit_cnt_next;
		end if;
	end process;
	
	nxt_state: process(present_state, rxd, bit_cnt_present, latch_present)
	begin
	latch_next <= latch_present; --default
	next_state <= present_state; --default
	bit_cnt_next <= bit_cnt_present; --default
	case present_state is
		when idle => 
			if rxd = '0' then
				bit_cnt_next <= 0;
				next_state <= reading;
			end if;
		when reading =>
			if bit_cnt_present > 7 then
				next_state <= stopping;
			else
				bit_cnt_next <= bit_cnt_present + 1;
				latch_next <= rxd & latch_present(7 downto 1);
			end if;
		when stopping =>
			if rxd = '1' then
				next_state <= latch_data;
			else
				next_state <= idle;
			end if;
		when latch_data =>
			next_state <= idle;
		when others =>
			null;
	end case;
	end process;
	
	moore_out: process(present_state, latch_present)
	begin
	case present_state is
		when latch_data =>
			rxdata <= latch_present;
			rxvalid <= '1';
		when others =>
			rxvalid <= '0';
	end case;
	end process;
end;
