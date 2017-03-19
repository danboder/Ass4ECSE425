LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY comparator_32 IS
	PORT(
		A, B	: IN STD_LOGIC_VECTOR(31 downto 0);
		equal	: OUT STD_LOGIC
	);
END comparator_32;

ARCHITECTURE behavior OF comparator_32 IS

BEGIN
	compare_process : PROCESS(A,B) IS

	BEGIN
		if (A = B) then
			equal <= '1';
		else
			equal <= '0';
		end if;
	END PROCESS;
END behavior;
