LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mem_control IS
	PORT(
		write_mem, is_load	: IN STD_LOGIC;
		result, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
		addr : OUT INTEGER;
		write_data : OUT STD_LOGIC_VECTOR(31 downto 0);
		memwrite, memread : OUT STD_LOGIC
	);
END mem_control;

ARCHITECTURE behavior OF mem_control IS

BEGIN
	process(write_mem, is_load, result, t_data) IS
	BEGIN
		if write_mem = '1' then
			if is_load = '0' then
				write_data <= t_data;
				addr <= to_integer(UNSIGNED(result));
				memwrite <= '1';
				memread <= '0';
			else
				write_data <= "00000000000000000000000000000000";
				addr <= to_integer(UNSIGNED(result));
				memread <= '1';
				memwrite <= '0';
			end if;
		else
			memread <= '0';
			memwrite <= '0';
		end if;
	END process;

END behavior;
