LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY IF_ID IS
	PORT(
		clk				: IN STD_LOGIC;
		count_in, instruction_in : IN STD_LOGIC_VECTOR(31 downto 0);
		count_out, instruction_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END IF_ID;

ARCHITECTURE behavior OF IF_ID IS
	signal int1, int2 : STD_LOGIC_VECTOR(31 downto 0);
BEGIN

	reg_process : PROCESS(clk, count_in, instruction_in) IS
	BEGIN
		if clk'event and clk = '1' then
			int1 <= count_in;
			int2 <= instruction_in;
		end if;
	END PROCESS;
	
	count_out <= int1;
	instruction_out <= int2;
END behavior;
	