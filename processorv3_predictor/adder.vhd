LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY adder IS
	PORT(
		clk, en	: IN STD_LOGIC;
		count, addend 	: IN INTEGER;
		sum	: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END adder;

ARCHITECTURE behavior OF adder IS
	signal sum_int : INTEGER;
BEGIN
	add_process : PROCESS(clk, count) IS

	BEGIN
		if en = '1' then
			if clk'event and clk = '1' then
				sum_int <= (count + addend);
			end if;
		end if;
	end PROCESS;

	sum <= STD_LOGIC_VECTOR(to_signed(sum_int,32));
END behavior;
		