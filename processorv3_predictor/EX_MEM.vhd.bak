LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY EX_MEM IS
	PORT(
		clk, equal,choose_in	: IN STD_LOGIC;
		mode		: IN INTEGER;
		result, t_in	: IN STD_LOGIC_VECTOR(31 downto 0);
		d_addr		: IN STD_LOGIC_VECTOR(4 downto 0);
		choose_branch, choose_write_reg, write_mem, choose_wb, is_load	: OUT STD_LOGIC;
		r_data, t_out	: OUT STD_LOGIC_VECTOR(31 downto 0);
		d_addr_out	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END EX_MEM;
	
ARCHITECTURE behavior OF EX_MEM IS
	signal branch_temp, write_reg_temp, mem_temp, wb_temp, load_temp	: STD_LOGIC;
	signal addr_temp : STD_LOGIC_VECTOR(4 downto 0);
	signal data_temp, t_temp : STD_LOGIC_VECTOR(31 downto 0);
BEGIN
	reg_process : PROCESS(clk, equal, mode, result, d_addr, choose_in) IS
	
	BEGIN
		if clk'event and clk = '1' then
		d_addr_out <= addr_temp;
		r_data <= data_temp;
		t_out <= t_temp;
		choose_branch <= branch_temp;
		choose_write_reg <= write_reg_temp;
		write_mem <= mem_temp;
		choose_wb <= wb_temp;
		is_load <= load_temp;
		case mode is
			when 17 => --BEQ
				branch_temp <= '1';
				write_reg_temp <= '0';
				mem_temp <= '0';
				load_temp <= '0';
			when 18 => --BNE
				branch_temp <= '1';
				write_reg_temp <= '0';
				mem_temp <= '0';
				load_temp <= '0';
			when 22 => --LW
				branch_temp <= '0';
				write_reg_temp <= '0';
				mem_temp <= '1';
				load_temp <= '1';
			when 25 => --SW
				branch_temp <= '0';
				write_reg_temp <= '0';
				mem_temp <= '1';
				load_temp <= '0';
			when others =>
				branch_temp <= '0';
				write_reg_temp <= '1';
				mem_temp <= '0';
				load_temp <= '0';
		end case;
		t_temp <= t_in;
		data_temp <= result;
		addr_temp <= d_addr;
		wb_temp <= choose_in;
		end if;
	END PROCESS;
END behavior;