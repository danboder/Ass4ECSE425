LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MEM IS
	PORT(
		clk, done	: IN STD_LOGIC;
		choose_b, choose_wb, choose_wr, choose_wm, is_load : IN STD_LOGIC;
		result, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
		dest_addr	: IN STD_LOGIC_VECTOR(4 downto 0);
		choose_b_out, choose_wb_out, choose_wr_out : OUT STD_LOGIC;
		b_addr, result_out, s_out		: OUT STD_LOGIC_VECTOR(31 downto 0);
		dest_addr_out	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END MEM;

ARCHITECTURE behavior OF MEM IS

COMPONENT memoryData IS
	GENERIC(
		ram_size : INTEGER := 8192;
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		done: IN STD_LOGIC;
		waitrequest: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mem_control IS
	PORT(
		write_mem, is_load	: IN STD_LOGIC;
		result, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
		addr : OUT INTEGER;
		write_data : OUT STD_LOGIC_VECTOR(31 downto 0);
		memwrite, memread : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL addr_temp : INTEGER := 0;
SIGNAL w_data_temp, r_data : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL w_temp, r_temp, w_r : STD_LOGIC;

BEGIN
	MC : mem_control PORT MAP (choose_wm, is_load, result, t_data);
	DM : memoryData PORT MAP (clk, w_data_temp, addr_temp, w_temp, r_temp, r_data, done, w_r);
	b_addr <= result;
	result_out <=  r_data;
	choose_b_out <= choose_b;
	choose_wb_out <= choose_wb;
	choose_wr_out <= choose_wr;
	s_out <= result;
	dest_addr_out <= dest_addr;
END behavior;