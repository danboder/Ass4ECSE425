LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY if_load IS
	PORT(
		mode	: IN INTEGER;
		load	: OUT STD_LOGIC
	);
END if_load;

ARCHITECTURE behavior OF if_load IS
BEGIN
	load_process : PROCESS(mode) IS
	BEGIN
		if (mode = 22) then
			load <= '1';
		else
			load <= '0';
		end if;
	end process;

END behavior;