LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY program_counter IS
	PORT(
		clock, enable, reset	: IN STD_LOGIC;
		count			: IN STD_LOGIC_VECTOR(31 downto 0);
		instruction		: OUT INTEGER
	);
END program_counter;
	
ARCHITECTURE behavior OF program_counter IS
	SIGNAL instruc_internal		: INTEGER;
BEGIN
	count_process: PROCESS (reset, enable, clock)
	BEGIN
		if reset = '1' then
			instruc_internal <= 0;
		elsif enable = '1' then
			if (clock'event and clock = '1') then
				instruc_internal <= to_integer(unsigned(count));
			end if;
		end if;
	END process;
	instruction <= instruc_internal;
END behavior;