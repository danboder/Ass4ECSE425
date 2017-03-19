LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY addr_mux IS
	PORT(
		mode	: IN INTEGER;
		t_addr, d_addr	: IN STD_LOGIC_VECTOR(4 downto 0);
		addr		: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END addr_mux;

ARCHITECTURE behavior OF addr_mux IS

BEGIN
	addr_process : PROCESS(mode, t_addr, d_addr) IS
	BEGIN
		if (mode < 15) then
			addr <= d_addr;
		else
			addr <= t_addr;
		end if;
	END PROCESS;
END behavior;
