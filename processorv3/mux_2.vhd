LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux_2 IS
	PORT(
		choose		: IN STD_LOGIC;
		A,B		: IN STD_LOGIC_VECTOR(31 downto 0);
		C		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END mux_2;

ARCHITECTURE behavior of mux_2 IS
--	signal next_output : STD_LOGIC_VECTOR(31 downto 0);
BEGIN

choose_process : PROCESS(choose, A, B)

BEGIN
	if choose = '0' then
		C <= A;
	elsif choose = '1' then
		C <= B;
	end if;
END process;
--C <= next_output;
END behavior;
		