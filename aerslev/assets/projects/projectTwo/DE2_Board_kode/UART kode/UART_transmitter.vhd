library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_transmitter is
port(
	--input
	reset, txvalid, clk_baud	: in std_logic;
	--output
	txdata							: in std_logic_vector(7 downto 0);
	txd								: out std_logic
);
end;

architecture arch of UART_transmitter is

type state is (idle, send_start_bit, send_data, send_stop_bit);
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
			bit_cnt_present <= bit_cnt_next;
		end if;
	end process;
	
	nxt_state: process(present_state, txvalid, bit_cnt_present)
	begin
	next_state <= present_state; --default
	bit_cnt_next <= bit_cnt_present; --default
	case present_state is
		when idle => 
			if txvalid = '1' then
				bit_cnt_next <= 0;
				next_state <= send_start_bit;
			end if;
		when send_start_bit =>
			next_state <= send_data;
		when send_data =>
			if bit_cnt_present > 7 then
				next_state <= send_stop_bit;
			else
				bit_cnt_next <= bit_cnt_present + 1;
			end if;
		when send_stop_bit =>
			next_state <= idle;
		when others =>
			null;
	end case;
	end process;
	
	mealy_out: process(present_state, bit_cnt_present, txdata)
	begin
	case present_state is
		when send_start_bit =>
			txd <= '0';
		when send_data =>
			txd <= txdata(bit_cnt_present);
		when others =>
			txd <= '1';
	end case;
	end process;
end;
