LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MEM_WB IS
	PORT(
		clk, wb_choose, wr_choose	: IN STD_LOGIC;
		DM_in, s_in	: IN STD_LOGIC_VECTOR(31 downto 0);
		write_addr_in	: IN STD_LOGIC_VECTOR(4 downto 0);
		wb_out, wr_out 		: OUT STD_LOGIC;
		DM_out, s_out	: OUT STD_LOGIC_VECTOR(31 downto 0);
		write_addr_out	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END MEM_WB;

ARCHITECTURE behavior OF MEM_WB IS
	SIGNAL wb_temp, wr_temp : STD_LOGIC;
	SIGNAL DM_temp, s_temp : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL write_addr_temp : STD_LOGIC_VECTOR(4 downto 0);
BEGIN
	reg_process : PROCESS(clk, wb_choose, DM_in, s_in, write_addr_in)
	BEGIN
		if(clk'event and clk = '1') then
			wr_out <= wr_temp;
			wb_out <= wb_temp;
			DM_out <= DM_temp;
			s_out <= s_temp;
			write_addr_out <= write_addr_temp;
			wr_temp <= wr_choose;
			wb_temp <= wb_choose;
			DM_temp <= DM_in;
			s_temp <= s_in;
			write_addr_temp <= write_addr_in;
			if wb_temp = '0' then
				--report "wb_result is" & integer'image(to_integer(unsigned(DM_temp)));
			end if;
		end if;
	END PROCESS;
END behavior;