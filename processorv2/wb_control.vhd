LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY wb_control IS
	PORT(
	mode : IN INTEGER;
	choose : OUT STD_LOGIC
	);
END wb_control;

ARCHITECTURE behavior OF wb_control IS
SIGNAL choose_temp : STD_LOGIC := '1';
BEGIN
	choose_proc : PROCESS(mode) IS
	BEGIN
	case mode is 
		when 22 => --LW
			choose_temp <= '0';
		when others =>
			choose_temp <= '1';
	END CASE;
	END PROCESS;
	choose <= choose_temp;
END behavior;
