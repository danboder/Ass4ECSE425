LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sign_mux IS
	PORT(
		mode	: IN INTEGER;
		zero, sign	: IN STD_LOGIC_VECTOR(31 downto 0);
		imm		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END sign_mux;

ARCHITECTURE behavior OF sign_mux IS

BEGIN
	sign_process : PROCESS(mode, zero, sign) IS
	BEGIN
		case mode is
			when 15 =>
				imm <= sign;
			when 22 =>
				imm <= sign;
			when 24 =>
				imm <= sign;
			when 25 =>
				imm <= sign;
			when others =>
				imm <= zero;
		end case;
	END PROCESS;
END behavior;