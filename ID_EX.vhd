LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ID_EX IS
	PORT(
		clk				: IN STD_LOGIC;
		PC, s_data, t_data, imm		: IN STD_LOGIC_VECTOR(31 downto 0);
		op, funct			: IN STD_LOGIC_VECTOR(5 downto 0);
		shamt, d_addr			: IN STD_LOGIC_VECTOR(4 downto 0);
		jump_addr			: IN STD_LOGIC_VECTOR(25 downto 0);
		PC_out, s_out, t_out, imm_out	: OUT STD_LOGIC_VECTOR(31 downto 0);
		op_out, funct_out		: OUT STD_LOGIC_VECTOR(5 downto 0);
		shamt_out, d_addr_out		: OUT STD_LOGIC_VECTOR(4 downto 0);
		jump_addr_out			: OUT STD_LOGIC_VECTOR(25 downto 0)
	);
END ID_EX;

ARCHITECTURE behavior OF ID_EX IS
	signal PC_temp, s_temp, t_temp, imm_temp : STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000000";
	signal op_temp, funct_temp : STD_LOGIC_VECTOR(5 downto 0):="000000";
	signal shamt_temp, d_temp : STD_LOGIC_VECTOR(4 downto 0):="00000";
	signal jump_temp : STD_LOGIC_VECTOR(25 downto 0):="00000000000000000000000000";
BEGIN
	reg_process : PROCESS(clk, PC, s_data, t_data, imm, op, funct, shamt, d_addr, jump_addr) IS
		
	BEGIN
		if clk'event and clk = '1' then
			PC_out <= PC_temp;
			s_out <= s_temp;
			t_out <= t_temp;
			imm_out <= imm_temp;
			op_out <= op_temp;
			funct_out <= funct_temp;
			shamt_out <= shamt_temp;
			d_addr_out <= d_temp;
			jump_addr_out <= jump_temp;
			PC_temp <= PC;
			s_temp <= s_data;
			t_temp <= t_data;
			imm_temp <= imm;
			op_temp <= op;
			funct_temp <= funct;
			shamt_temp <= shamt;
			d_temp <= d_addr;
			jump_temp <= jump_addr;
		end if;
	END PROCESS;
END behavior;