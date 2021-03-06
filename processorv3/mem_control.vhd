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
	SIGNAL addr_temp : INTEGER := 0;
BEGIN
	process(write_mem, is_load, result, t_data) IS
	BEGIN
	addr_temp <= to_integer(SIGNED(result));
	--report "addr value is" & integer'image(to_integer(unsigned(result)));
		if write_mem = '1' then
			if is_load = '0' then
				write_data <= t_data;
				memwrite <= '1';
				memread <= '0';
			else
				write_data <= t_data;
				memread <= '1';
				memwrite <= '0';
			end if;
		elsif write_mem = '0' then
			
			memread <= '0';
			memwrite <= '0';
		end if;
	if addr_temp < 0 then
		addr_temp <= 0;
	elsif addr_temp > 8191 then
		addr_temp <= 8191;
	end if;
	END process;
	addr <= addr_temp;

END behavior;
