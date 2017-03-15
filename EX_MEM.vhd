LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY EX_MEM IS
	PORT(
		equal	: IN STD_LOGIC;
		mode	: IN INTEGER;
		result, 	: IN STD_LOGIC_VECTOR(31 downto 0);
		d_addr	: IN STD_LOGIC_VECTOR(4 downto 0);
		branch	: OUT STD_LOGIC
		

	);
END EX_MEM;
	
ARCHITECTURE behavior OF EX_MEM IS

BEGIN
	
